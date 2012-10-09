//  Created by JGroup(kimbobv22@gmail.com)

#import "CameraTestLayer.h"
#import "HelloWorldLayer.h"

@implementation CameraTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemLabelTTF *menuItemBtn_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"BACK"];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBtn_];
	
	menuItemBtn_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"CAMERA"];
	menuItemBtn_.position = ccp(contentSize_.width-menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMCaremaManager sharedManager] openCameraWithSourceType:(TARGET_IPHONE_SIMULATOR ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera)];
	};
	[self addChild:menuItemBtn_];
	
	if(TARGET_IPHONE_SIMULATOR){
		CCLabelTTF *noticeLabel_ = [CMMFontUtil labelWithstring:@"Simulator not supported camera. support photo library only"];
		[noticeLabel_ setPosition:cmmFuncCommon_position_center(self, noticeLabel_)];
		[self addChild:noticeLabel_];
	}
	
	[[CMMCaremaManager sharedManager] setDelegate:self];
	[[CMMCaremaManager sharedManager] setImageLimitSize:CGSizeMake(200.0f, 200.0f)];
	
	return self;
}

-(void)cameraManager:(CMMCaremaManager *)cameraManger_ whenReturnedImageTexture:(CCTexture2D *)imageTexture_{
	if(cameraSprite){
		[cameraSprite removeFromParentAndCleanup:YES];
	}
	
	cameraSprite = [CCSprite spriteWithTexture:imageTexture_];
	[cameraSprite setPosition:cmmFuncCommon_position_center(self, cameraSprite)];
	[self addChild:cameraSprite];
	
	CGSize spriteSize_ = [cameraSprite contentSize];
	CCLOG(@"ReturnedImageTexture size : %1.1f x %1.1f",spriteSize_.width,spriteSize_.height);
}
-(void)cameraManager_whenCancelled:(CMMCaremaManager *)cameraManger_{
	CCLOG(@"cameraManager_whenCancelled");
}

-(void)onExit{
	[super onExit];
	[[CMMCaremaManager sharedManager] setDelegate:nil];
}

-(void)dealloc{
	[super dealloc];
}

@end
