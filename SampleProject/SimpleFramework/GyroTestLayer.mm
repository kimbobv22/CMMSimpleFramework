//  Created by JGroup(kimbobv22@gmail.com)

#import "GyroTestLayer.h"
#import "HelloWorldLayer.h"

@implementation GyroTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageDef stageDef_;
	stageDef_.stageSize = CGSizeMake(targetSize_.width, targetSize_.height-50.0f);
	stageDef_.worldSize = stageDef_.stageSize;
	stageDef_.gravity = CGPointZero;
	stageDef_.friction = 0.3f;
	stageDef_.restitution = 0.3f;
	
	stage = [CMMStage stageWithStageDef:stageDef_];
	stage.sound.soundDistance = 300.0f;
	stage.position = ccp(0,self.contentSize.height-stage.contentSize.height);
	[self addChild:stage z:0];
	
	CMMMenuItemL *menuItemBack_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	[menuItemBack_ setCallback_pushup:^(id item_) {
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	}];
	[self addChild:menuItemBack_];
	
	for(uint index_=0;index_<10;index_++){
		CMMSObject *object_;
		if(arc4random()%5 == 0){
			object_ = [CMMSBall ball];
		}else object_ = [CMMSObject spriteWithFile:@"Icon-Small-50.png"];
		
		object_.position = ccp((arc4random()%(int)stage.contentSize.width-100)+50,(arc4random()%(int)stage.contentSize.height-100)+50);
		[stage.world addObject:object_];
	}
	
	displayLabel = [CMMFontUtil labelWithString:@" "];
	[self addChild:displayLabel];
	
	if(TARGET_IPHONE_SIMULATOR){
		CCLabelTTF *noticeLabel_ = [CMMFontUtil labelWithString:@"Simulator not supported gyro sensor."];
		[noticeLabel_ setPosition:cmmFuncCommon_positionInParent(self, noticeLabel_)];
		[self addChild:noticeLabel_ z:9];
	}
	
	[self schedule:@selector(update:)];
	
	//register to gyro sensor
	[[CMMMotionDispatcher sharedDispatcher] addMotionBlockForTarget:self block:^(CMMMotionState motionState_) {
		[displayLabel setString:[NSString stringWithFormat:@"%1.1f / %1.1f / %1.1f",motionState_.roll,motionState_.pitch,motionState_.yaw]];
		displayLabel.position = ccp(self.contentSize.width-displayLabel.contentSize.width/2-10,displayLabel.contentSize.height+10);
		[stage.spec setGravity:ccp(motionState_.pitch*5.0f,motionState_.roll*5.0f)];
	}];
	
	return self;
}

-(void)update:(ccTime)dt_{
	[stage update:dt_];
}

-(void)cleanup{
	//must remove from CMMMotionDispatcher in cleanup method
	[[CMMMotionDispatcher sharedDispatcher] removeMotionBlockForTarget:self];
	[super cleanup];
}

@end
