//  Created by JGroup(kimbobv22@gmail.com)

#import "CameraTestLayer.h"
#import "HelloWorldLayer.h"

@implementation CameraTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemL *menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"BACK"];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBtn_];
	
	menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"CAMERA"];
	menuItemBtn_.position = ccp(_contentSize.width-menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMCaremaManager sharedManager] openCameraWithSourceType:(TARGET_IPHONE_SIMULATOR ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera)];
	};
	[self addChild:menuItemBtn_];
	
	if(TARGET_IPHONE_SIMULATOR){
		CCLabelTTF *noticeLabel_ = [CMMFontUtil labelWithString:@"Simulator not supported camera. support photo library only"];
		[noticeLabel_ setPosition:cmmFuncCommon_positionInParent(self, noticeLabel_)];
		[self addChild:noticeLabel_];
	}
	
	[[CMMCaremaManager sharedManager] setDelegate:self];
	[[CMMCaremaManager sharedManager] setImageLimitSize:CGSizeMake(100.0f, 100.0f)];
	
	CGSize stageSize_ = CGSizeSub(_contentSize, CGSizeMake(0, 50.0f));
	stage = [CMMStage stageWithStageDef:CMMStageDefMake(stageSize_, stageSize_, CGPointZero)];
	[stage setPosition:ccp(0,50.0f)];
	[self addChild:stage];
	
	[[CMMMotionDispatcher sharedDispatcher] addMotionBlockForTarget:self block:^(CMMMotionState motionState_) {
		[[stage spec] setGravity:ccp(motionState_.pitch*5.0f,motionState_.roll*5.0f)];
	}];
	
	[self scheduleUpdate];
	
	return self;
}

-(void)update:(ccTime)dt_{
	[stage update:dt_];
}

-(void)cameraManager:(CMMCaremaManager *)cameraManger_ whenReturnedImageTexture:(CCTexture2D *)imageTexture_{
	CMMSObject *object_ = [CMMSObject spriteWithTexture:imageTexture_];
	[object_ setPosition:[stage convertToStageWorldSpace:ccp(_contentSize.width/2.0f,_contentSize.height/2.0f)]];
	[[stage world] addObject:object_];
}
-(void)cameraManager_whenCancelled:(CMMCaremaManager *)cameraManger_{
	CCLOG(@"cameraManager_whenCancelled");
}
-(void)cleanup{
	[[CMMMotionDispatcher sharedDispatcher] removeMotionBlockForTarget:self];
	[[CMMCaremaManager sharedManager] setDelegate:nil];
	[super cleanup];
}

-(void)dealloc{
	[super dealloc];
}

@end
