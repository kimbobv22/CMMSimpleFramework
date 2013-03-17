//
//  SampleGameLayer.mm
//  CMMSampleGame
//
//  Created by Kim Jazz on 13. 3. 15..
//  Copyright (c) 2013년 Kim Jazz. All rights reserved.
//

#import "SampleGameLayer.h"
#import "HelloWorldLayer.h"

#define varTestCMMSObjectMaskBit_player 0x1001
#define varTestCMMSObjectMaskBit_enemy 0x1002
#define varTestCMMSObjectMaskBit_goal 0x1003

@implementation TestPlayer
@synthesize accelVector,speed;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	b2CMask = CMMb2ContactMaskMake(varTestCMMSObjectMaskBit_player,-1,-1,1);
	speed = 0.0f;
	[self setZOrder:2];
	
	return self;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	
	b2Vec2 targetVector_ = accelVector;
	targetVector_ *= speed;
	body->ApplyForceToCenter(targetVector_);
}

@end

@implementation TestPlayer(Box2d)

-(void)whenContactBeganWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{
	if(otherFixtureType_ == varTestCMMSObjectMaskBit_enemy){
		[[SampleGameLayer gameLayer] doGameOver];
	}else if(otherFixtureType_ == varTestCMMSObjectMaskBit_goal){
		[[SampleGameLayer gameLayer] doNextGoal];
	}
}

@end

@implementation TestEnemy{
	ccTime _curTurnningTime;
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	b2CMask = CMMb2ContactMaskMake(varTestCMMSObjectMaskBit_enemy,-1,-1,1);
	speed = 5.0f;
	_curTurnningTime = 0.0f;
	[self _refreshAccelVector];
	[self setZOrder:2];
	
	return self;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	_curTurnningTime += dt_;
	if(_curTurnningTime > 5.0f){
		_curTurnningTime = 0.0f;
		[self _refreshAccelVector];
	}
}

-(void)_refreshAccelVector{
	[self setAccelVector:b2Vec2Fromccp(ccpForAngle(CC_DEGREES_TO_RADIANS((float)(arc4random()%360))))];
}

@end

@implementation TestEnemy(Box2d)

-(void)whenContactBeganWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{
	[self _refreshAccelVector];
}

@end

@implementation TestGoal

+(id)goal{
	return [[[self alloc] init] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	b2CMask = CMMb2ContactMaskMake(varTestCMMSObjectMaskBit_goal,-1,-1,1);
	[self setColor:ccc3(100, 100, 100)];
	[self setZOrder:1];
	
	return self;
}
-(id)init{
	return [self initWithFile:@"blocks.png"];
}

@end

@implementation TestGoal(Box2d)

-(void)buildupBodyWithWorld:(CMMStageWorld *)world_{
	body = [world_ createBody:b2_staticBody point:[self position] angle:[self rotation]];
	body->SetUserData(self);
	
	b2CircleShape bodyBox_;
	bodyBox_.m_radius = self.contentSize.width/2.0f/PTM_RATIO;
	b2FixtureDef fixtureDef_;
	fixtureDef_.isSensor = true;
	fixtureDef_.shape = &bodyBox_;
	
	body->CreateFixture(&fixtureDef_)->SetUserData(&b2CMask);
}

@end

@implementation TestGoalSView

-(id)initWithTarget:(CMMSObject *)target_{
	if(!(self = [super initWithTarget:target_])) return self;
	
	CCLabelTTF *label_ = [CMMFontUtil labelWithString:@"GOAL"];
	[self addChild:label_];
	
	return self;
}

@end

static SampleGameLayer *_sharedSampleGameLayer_ = nil;

@implementation SampleGameLayer{
	CMMSequencer *_loadingSequencer;
	TestGoal *_goal;
	uint _goalCount;
}

+(id)gameLayer{
	if(!_sharedSampleGameLayer_){
		_sharedSampleGameLayer_ = [[SampleGameLayer alloc] init];
	}
	
	return _sharedSampleGameLayer_;
}

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	SamplePopupLoading *loadingLayer_ = [SamplePopupLoading node];
	[[CMMScene sharedScene] openPopupAtFirst:loadingLayer_];
	
	_loadingSequencer = [[CMMSequencer alloc] init];
	
	[_loadingSequencer addSequenceForMainQueue:^{
		stage = [CMMStage stageWithStageDef:CMMStageDefMake(_contentSize, _contentSize, CGPointZero)];
		[stage setTouchEnabled:YES];
		[self addChild:stage];
	} callback:^{
		[_loadingSequencer callSequence];
	}];
	
	[_loadingSequencer addSequenceForMainQueue:^{
		//add enemy
		for(uint index_=0;index_<3;++index_){
			TestEnemy *enemy_ = [TestEnemy spriteWithFile:@"Icon-Small-50.png"];
			[enemy_ setColor:ccc3(255, 0, 0)];
			[enemy_ setPosition:ccp(_contentSize.width*0.5f,_contentSize.height*0.5f)];
			[[stage world] addObject:enemy_];
		}
		
		//add player
		player = [TestPlayer spriteWithFile:@"Icon-Small.png"];
		CGSize playerSize_ = [player contentSize];
		[player setPosition:ccp(playerSize_.width*0.5f,playerSize_.height*0.5f)];
		[[stage world] addObject:player];
		
		[self _createGoal];
		
		[self scheduleUpdate];
	} callback:^{
		[loadingLayer_ close];
	}];
	
	stageState = TestStageState_play;
	_goalCount = 0;
	
	return self;
}
-(void)sceneDidEndTransition:(CMMScene *)scene_{
	[_loadingSequencer callSequence];
}

-(void)update:(ccTime)dt_{
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtIndex:0];
	if(touchItem_){
		[player setSpeed:2.0f];
		CGPoint diffPoint_ = ccpSub([self convertToNodeSpace:[CMMTouchUtil pointFromTouch:[touchItem_ touch]]],[player position]);
		[player setAccelVector:b2Vec2Fromccp(ccpForAngle(ccpToAngle(diffPoint_)))];
	}else{
		[player setSpeed:0.0f];
	}
	
	if(stageState == TestStageState_play){
		[stage update:dt_];
	}
}

//handle game
-(void)doGameOver{
	stageState = TestStageState_pause;
	
	SamplePopupNotice *notice_ = [SamplePopupNotice noticeWithNotice:@"GAME OVER!"];
	[notice_ setCallback_didClose:^(CMMPopupLayer *popup_) {
		[[CMMScene sharedScene] pushStaticLayerForKey:varSampleStaticMenu_staticKey];
	}];
	[[CMMScene sharedScene] openPopupAtFirst:notice_];
}
-(void)doGameComplete{
	stageState = TestStageState_pause;
	
	SamplePopupNotice *notice_ = [SamplePopupNotice noticeWithNotice:@"GOAL!"];
	[notice_ setCallback_didClose:^(CMMPopupLayer *popup_) {
		[[CMMScene sharedScene] pushStaticLayerForKey:varSampleStaticMenu_staticKey];
	}];
	[[CMMScene sharedScene] openPopupAtFirst:notice_];
}

-(void)doNextGoal{
	++_goalCount;
	
	if(_goalCount >= 3){
		[self doGameComplete];
	}else{
		[self _createGoal];
	}
}
-(void)_createGoal{
	if(_goal){
		[[stage world] removeObject:_goal];
	}
	
	_goal = [TestGoal goal];
	CGPoint regenPoint_ = CGPointZero;
	
	regenPoint_.x = (float)(25+arc4random()%((int)(_contentSize.width-50.0f)));
	regenPoint_.y = (float)(25+arc4random()%((int)(_contentSize.height-50.0f)));
	[_goal setPosition:regenPoint_];
	[[stage world] addObject:_goal];
	[[stage stateView] addStateView:[TestGoalSView stateViewWithTarget:_goal]];
}

/*
 //handle touch 
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
}
*/

-(void)cleanup{
	[_sharedSampleGameLayer_ release];
	[super cleanup];
}
-(void)dealloc{
	[_loadingSequencer release];
	[_sharedSampleGameLayer_ release];
	_sharedSampleGameLayer_ = nil;
	[super dealloc];
}

@end
