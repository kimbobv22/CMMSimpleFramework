//
//  SequenceMakerTestLayer.mm
//  SimpleFramework
//
//  Created by Kim Jazz on 12. 10. 19..
//
//

#import "SequenceMakerTestLayer.h"
#import "HelloWorldLayer.h"

@implementation SequenceMakerTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	sequencer = [[CMMSequenceMaker alloc] init];
	[sequencer setDelegate:self];
	[sequencer setSequenceMethodFormatter:@"seq%02d"];
	
	testSprite = [CCSprite spriteWithFile:@"Icon.png"];
	[testSprite setPosition:cmmFuncCommon_positionInParent(self, testSprite)];
	[self addChild:testSprite];
	
	CGSize buttonSize_ = CGSizeMake(90, 35);
	
	startBtn = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:buttonSize_];
	[startBtn setTitle:@"START"];
	[startBtn setCallback_pushup:^(id){
		[sequencer start];
	}];
	[self addChild:startBtn];
	
	nextBtn = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:buttonSize_];
	[nextBtn setAnchorPoint:CGPointZero];
	[nextBtn setTitle:@"NEXT"];
	[nextBtn setCallback_pushup:^(id){
		[sequencer stepSequence];
	}];
	[self addChild:nextBtn];
	
	prevBtn = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:buttonSize_];
	[prevBtn setTitle:@"PREV"];
	[prevBtn setCallback_pushup:^(id){
		[sequencer stepSequenceTo:[sequencer curSequence]-1];
	}];
	[self addChild:prevBtn];
	
	[startBtn setPosition:cmmFuncCommon_positionFromOtherNode(testSprite, startBtn,ccp(0, -1.0f),ccp(0,-contentSize_.height*0.08f))];
	[nextBtn setPosition:cmmFuncCommon_positionFromOtherNode(startBtn, nextBtn,ccp(1.0f, 0),ccp(10,0))];
	[prevBtn setPosition:cmmFuncCommon_positionFromOtherNode(startBtn, prevBtn,ccp(-1.0f, 0),ccp(-10,0))];
	
	CMMMenuItemL *backBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[backBtn_ setTitle:@"BACK"];
	backBtn_.position = ccp(backBtn_.contentSize.width/2,backBtn_.contentSize.height/2);
	backBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:backBtn_];
	
	[self sequenceMaker:sequencer didChangeState:[sequencer sequenceState]];
	
	return self;
}

-(void)sequenceMaker:(CMMSequenceMaker *)sequenceMaker_ didChangeState:(CMMSequenceMakerState)state_{
	NSString *stateStr_ = @"onSequence";
	switch(state_){
		case CMMSequenceMakerState_stop:
			nextBtn.enable = prevBtn.enable = NO;
			startBtn.enable = YES;
			stateStr_ = @"stop";
			break;
		case CMMSequenceMakerState_waitingNextSequence:
			nextBtn.enable = prevBtn.enable = YES;
			startBtn.enable = NO;
			stateStr_ = @"waitingNextSequence";
			break;
		case CMMSequenceMakerState_pause:
			stateStr_ = @"pause";
			break;
		case CMMSequenceMakerState_onSequence:
			nextBtn.enable = prevBtn.enable = YES;
			startBtn.enable = NO;
			break;
	}
	
	CCLOG(@"sequencer state : %@",stateStr_);
}

-(void)sequenceMakerDidStart:(CMMSequenceMaker *)sequenceMaker_{
	[self resetSprite];
}

-(void)resetSprite{
	[testSprite stopAllActions];
	[testSprite setPosition:cmmFuncCommon_positionInParent(self, testSprite)];
	[testSprite setColor:ccc3(255, 255, 255)];
	[testSprite setOpacity:255];
	[testSprite setScale:1.0f];
	[testSprite setRotation:0.0f];
}

-(void)seq00{
	[self resetSprite];
	[testSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCTintTo actionWithDuration:1.0f red:255 green:0 blue:0] two:[CCTintTo actionWithDuration:1.0f red:255 green:255 blue:255]]]];
}
-(void)seq01{
	[self resetSprite];
	[testSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:1.0f opacity:50] two:[CCFadeTo actionWithDuration:1.0f opacity:255]]]];
}
-(void)seq02{
	[self resetSprite];
	[testSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:1.0f scale:1.3f] two:[CCScaleTo actionWithDuration:1.0f scale:1.0f]]]];
}
-(void)seq03{
	[self resetSprite];
	CGPoint targetPoint_ = [testSprite position];
	[testSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCMoveTo actionWithDuration:0.1f position:ccpAdd(targetPoint_,ccp(0,20.0f))] two:[CCMoveTo actionWithDuration:0.1f position:targetPoint_]]]];
}

-(void)sequenceMakerDidEnd:(CMMSequenceMaker *)sequenceMaker_{
	[self resetSprite];
}

-(void)dealloc{
	[sequencer release];
	[super dealloc];
}

@end
