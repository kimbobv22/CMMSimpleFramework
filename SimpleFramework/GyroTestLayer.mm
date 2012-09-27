//  Created by JGroup(kimbobv22@gmail.com)

#import "GyroTestLayer.h"
#import "HelloWorldLayer.h"

@implementation GyroTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	self.isAvailableMotion = YES;
	
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageSpecDef stageSpec_;
	stageSpec_.stageSize = CGSizeMake(targetSize_.width, targetSize_.height-50.0f);
	stageSpec_.worldSize = stageSpec_.stageSize;
	stageSpec_.gravity = CGPointZero;
	stageSpec_.friction = 0.3f;
	stageSpec_.restitution = 0.3f;
	
	stage = [CMMStage stageWithStageSpecDef:stageSpec_];
	stage.sound.soundDistance = 300.0f;
	stage.position = ccp(0,self.contentSize.height-stage.contentSize.height);
	[self addChild:stage z:0];
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	menuItemBack_.delegate = self;
	[self addChild:menuItemBack_];
	
	for(uint index_=0;index_<10;index_++){
		CMMSObject *object_;
		if(arc4random()%5 == 0){
			object_ = [CMMSBall ball];
		}else object_ = [CMMSObject spriteWithFile:@"Icon-Small-50.png"];
		
		object_.position = ccp((arc4random()%(int)stage.contentSize.width-100)+50,(arc4random()%(int)stage.contentSize.height-100)+50);
		[stage.world addObject:object_];
	}
	
	displayLabel = [CMMFontUtil labelWithstring:@" "];
	[self addChild:displayLabel];
	
	[self schedule:@selector(update:)];
	
	return self;
}

-(void)motionDispatcher:(CMMMotionDispatcher *)motionDispatcher_ updateMotion:(CMMMotionState)state_{
	[displayLabel setString:[NSString stringWithFormat:@"%1.1f / %1.1f / %1.1f",state_.roll,state_.pitch,state_.yaw]];
	displayLabel.position = ccp(self.contentSize.width-displayLabel.contentSize.width/2-10,displayLabel.contentSize.height+10);
	[stage.spec setGravity:ccp(state_.pitch*5.0f,state_.roll*5.0f)];
}

-(void)update:(ccTime)dt_{
	[stage update:dt_];
}

-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_{
	[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
}

@end
