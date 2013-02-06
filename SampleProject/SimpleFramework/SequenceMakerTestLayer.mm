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
	
	testSprite = [CCSprite spriteWithFile:@"Icon.png"];
	[testSprite setPosition:cmmFuncCommon_positionInParent(self, testSprite)];
	[self addChild:testSprite];
	
	CCLabelTTF *labelNotice_ = [CMMFontUtil labelWithString:@" "];
	[labelNotice_ setPosition:cmmFuncCommon_positionFromOtherNode(testSprite, labelNotice_, ccp(0.0f,1.0f),ccp(0.0f,20.0f))];
	[self addChild:labelNotice_];
	
	sequencer = [[CMMSequencer alloc] init];
	
	[sequencer addSequenceForMainQueue:^{
		[testSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCTintTo actionWithDuration:1.0f red:255 green:0 blue:0] two:[CCTintTo actionWithDuration:1.0f red:255 green:255 blue:255]]]];
	}];
	
	[sequencer addSequenceForMainQueue:^{
		[testSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:1.0f scale:1.3f] two:[CCScaleTo actionWithDuration:1.0f scale:1.0f]]]];
	}];
	
	[sequencer addSequenceForMainQueue:^{
		[testSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:1.0f opacity:50] two:[CCFadeTo actionWithDuration:1.0f opacity:255]]]];
	}];
	
	[sequencer addSequenceForMainQueue:^{
		CGPoint targetPoint_ = [testSprite position];
		[testSprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCMoveTo actionWithDuration:0.1f position:ccpAdd(targetPoint_,ccp(0,20.0f))] two:[CCMoveTo actionWithDuration:0.1f position:targetPoint_]]]];
	}];
	
	[sequencer setCallback_whenSequenceIndexChanged:^(int currentIndex_, int beforeIndex_) {
		CCLOG(@"SequenceIndexChanged : %d -> %d",beforeIndex_,currentIndex_);
		[labelNotice_ setString:[NSString stringWithFormat:@"current Sequence : %d",currentIndex_]];
		[self resetSprite];
	}];
	[sequencer setCallback_whenStateChanged:^{
		[self _updateDisplayUI];
	}];
	
	CGSize buttonSize_ = CGSizeMake(90, 35);
	
	nextBtn = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:buttonSize_];
	[nextBtn setAnchorPoint:CGPointZero];
	[nextBtn setTitle:@"NEXT"];
	[nextBtn setCallback_pushup:^(id){
		[sequencer callSequence];
	}];
	[self addChild:nextBtn];
	
	prevBtn = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:buttonSize_];
	[prevBtn setTitle:@"PREV"];
	[prevBtn setCallback_pushup:^(id){
		[sequencer callSequenceAtIndex:MAX(((int)[sequencer sequenceIndex])-1,0)];
	}];
	[self addChild:prevBtn];
	
	[nextBtn setPosition:cmmFuncCommon_positionFromOtherNode(testSprite, nextBtn,ccp(0, -1.0f),ccp(buttonSize_.width/2.0f+5.0f,-_contentSize.height*0.08f))];
	[prevBtn setPosition:cmmFuncCommon_positionFromOtherNode(nextBtn, prevBtn,ccp(-1.0f, 0),ccp(-10,0))];
	
	CMMMenuItemL *backBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[backBtn_ setTitle:@"BACK"];
	backBtn_.position = ccp(backBtn_.contentSize.width/2,backBtn_.contentSize.height/2);
	backBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:backBtn_];
	
	[self _updateDisplayUI];
	
	return self;
}

-(void)_updateDisplayUI{
	CMMSequencerState state_ = [sequencer state];
	
	switch(state_){
		case CMMSequencerState_stop:
		case CMMSequencerState_waitingNextSequence:
			nextBtn.enable = prevBtn.enable = YES;
			break;
		case CMMSequencerState_onSequence:
			nextBtn.enable = prevBtn.enable = NO;
			break;
	}
}

-(void)resetSprite{
	[testSprite stopAllActions];
	[testSprite setPosition:cmmFuncCommon_positionInParent(self, testSprite)];
	[testSprite setColor:ccc3(255, 255, 255)];
	[testSprite setOpacity:255];
	[testSprite setScale:1.0f];
	[testSprite setRotation:0.0f];
}

-(void)cleanup{
	[sequencer cleanup];
	[super cleanup];
}
-(void)dealloc{
	[sequencer release];
	[super dealloc];
}

@end
