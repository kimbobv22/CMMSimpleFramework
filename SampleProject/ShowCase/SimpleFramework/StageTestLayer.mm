//  Created by JGroup(kimbobv22@gmail.com)

#import "StageTestLayer.h"
#import "HelloWorldLayer.h"

@implementation StageTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	stageSelector = [CMMMenuItemSet menuItemSetWithMenuSize:CGSizeMake(_contentSize.width*0.8f, _contentSize.height*0.6f)];
	[stageSelector setLineVAlignType:CMMMenuItemSetLineVAlignType_center];
	[stageSelector setUnitPerLine:2];
	[stageSelector setPosition:cmmFunc_positionIPN(self, stageSelector)];
	[self addChild:stageSelector];
	
	CMMMenuItemL *menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"basic stage"];
	[menuItem_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayerBasic node]];
	}];
	
	[stageSelector addMenuItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"pixel stage"];
	[menuItem_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayerPixel node]];
	}];
	
	[stageSelector addMenuItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"tile stage"];
	[menuItem_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayerTile node]];
	}];
	
	[stageSelector addMenuItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"dynamic block stage"];
	[menuItem_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayerDynamicBlock node]];
	}];
	
	[stageSelector addMenuItem:menuItem_];
		
	[stageSelector updateDisplay];
	
	CMMMenuItemL *menuItemBack_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	[menuItemBack_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushStaticLayerForKey:_HelloWorldLayer_key_];
	}];
	[self addChild:menuItemBack_];
	
	return self;
}

@end

@interface CCLayerGradientTest : CCLayerGradient<CMMStageBackgroundProtocol>

@end

@implementation CCLayerGradientTest

-(void)setWorldPoint:(CGPoint)worldPoint_{
	[self setPosition:worldPoint_];
}
-(CGPoint)worldPoint{
	return [self position];
}

-(void)update:(ccTime)dt_{}

-(void)draw{
	[super draw];
	
	glLineWidth(1.0f);
	ccDrawColor4F(1.0f, 1.0f, 1.0f, 0.4f);
	ccDrawLine(ccp(_contentSize.width/2,0), ccp(_contentSize.width/2,_contentSize.height));
	ccDrawLine(ccp(0,_contentSize.height/2), ccp(_contentSize.width,_contentSize.height/2));
}

@end

@implementation StageTestLayerMaster

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	//// add control menu
	controlMenu = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(80.0f, _contentSize.height*0.8f)];
	[controlMenu setFilter_canChangeIndex:^BOOL(int index_) {
		return YES;
	}];
	[controlMenu setPosition:ccp(_contentSize.width-controlMenu.contentSize.width,_contentSize.height/2.0f-controlMenu.contentSize.height/2.0f)];
	[self addChild:controlMenu];
	
	//add control menu item
	CGSize tempMenuItemSize_ = CGSizeMake(controlMenu.contentSize.width, 30);
	
	CMMMenuItemL *tempMenuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"add box"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_addBox;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	tempMenuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"add ball"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_addBall;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	////gravity control
	labelGravity = [CMMFontUtil labelWithString:@" "];
	[self addChild:labelGravity];
	
	gravitySlider = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	[gravitySlider setCallback_whenItemValueChanged:^(float itemValue_, float beforeItemValue_) {
		CGPoint gravity_ = stage.spec.gravity;
		gravity_.y = itemValue_;
		[stage.spec setGravity:gravity_];
		[labelGravity setString:[NSString stringWithFormat:@"gravity : %1.1f",gravity_.y]];
		labelGravity.position = ccp(_contentSize.width-labelGravity.contentSize.width/2-5,labelGravity.contentSize.height/2+5);
	}];
	
	[gravitySlider setItemValueRange:CMMFloatRange(-10.0f,10.0)];
	gravitySlider.unitValue = 0.5f;
	gravitySlider.itemValue = 0.0f;
	CGPoint targetPoint_ = cmmFunc_positionIPN(self, gravitySlider);
	targetPoint_.x += 40.0f;
	targetPoint_.y = 5.0f;
	gravitySlider.position = targetPoint_;
	[self addChild:gravitySlider];
	
	backBtn = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[backBtn setTitle:@"BACK"];
	backBtn.position = ccp(backBtn.contentSize.width/2,backBtn.contentSize.height/2);
	[backBtn setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayer node]];
	}];
	[self addChild:backBtn];
	
	[self buildupStage];
	
	[stage setCallback_whenObjectAdded:^(CMMSObject *object_) {
		CCLOG(@"object added to stage : %d",[object_ objectTag]);
	}];
	[stage setCallback_whenObjectRemoved:^(CMMSObject *object_) {
		CCLOG(@"object removed to stage : %d",[object_ objectTag]);
		if(_curTouchObject == object_){
			_curTouchObject = nil;
			_isTouchObject = NO;
		}
	}];
	[stage setCallback_whenTouchBegan:^(UITouch *touch, CMMSObject *object_) {
		if(object_){
			_isTouchObject = YES;
			_curTouchObject = object_;
		}
	}];
	
	[self scheduleUpdate];
	
	return self;
}

-(void)buildupStage{/*overide me*/}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	_isOnTouch = YES;
	_curTouchObject = nil;
	_isTouchObject = NO;
	_curTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	_curTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtIndex:0];
	if(!_isTouchObject && !_isOnDrag && touchItem_ && [touchItem_ node] == stage){
		switch(stageControlType){
			case StageControlType_addBox:
				[self addBox:[stage convertToStageWorldSpace:_curTouchPoint]];
				break;
			case StageControlType_addBall:
				[self addBall:[stage convertToStageWorldSpace:_curTouchPoint]];
				break;
			default: break;
		}
	}
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	_isOnTouch = _isTouchObject = NO;
	_curTouchObject = nil;
	
	if([touchDispatcher touchCount] == 0){
		_isOnDrag = NO;
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	
	_isOnTouch = _isTouchObject = NO;
	_curTouchObject = nil;
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchBegan:(CMMPinchState)pinchState_{
	_isOnDrag = YES;
	_curTouchObject = nil;
	_isTouchObject = NO;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchMoved:(CMMPinchState)pinchState_{
//	float curWorldScale_ = [stage worldScale];
//	[stage setWorldScale:curWorldScale_ - (curWorldScale_ * (pinchState_.lastScale - pinchState_.scale))];
	UITouch *touch1_ = pinchState_.touch1;
	UITouch *touch2_ = pinchState_.touch2;
	CGPoint touch1DiffPoint_ = ccpSub([CMMTouchUtil pointFromTouch:touch1_], [CMMTouchUtil prepointFromTouch:touch1_]);
	CGPoint touch2DiffPoint_ = ccpSub([CMMTouchUtil pointFromTouch:touch2_], [CMMTouchUtil prepointFromTouch:touch2_]);
	[stage setWorldPoint:ccpSub([stage worldPoint], ccpDiv(ccpAdd(touch1DiffPoint_, touch2DiffPoint_), 2.0f))];
	
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchEnded:(CMMPinchState)pinchState_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchCancelled:(CMMPinchState)pinchState_{}

-(void)update:(ccTime)dt_{
	if(_isTouchObject){
		b2Vec2 beforeVector_ = _curTouchObject.body->GetTransform().p;
		[_curTouchObject updateBodyPosition:[stage convertToStageWorldSpace:_curTouchPoint]];
		b2Vec2 curVector_ = _curTouchObject.body->GetTransform().p;
		b2Vec2 velocity_ = curVector_-beforeVector_;
		velocity_*=10.0f;
		[_curTouchObject updateBodyLinearVelocity:velocity_];
		CGPoint diffPoint_ = ccpSub(ccp(self.contentSize.width/2,self.contentSize.height/2),_curTouchPoint);
		stage.worldPoint = ccpSub(stage.worldPoint, ccpMult(diffPoint_, dt_*2.0f));
	}
	
	[stage update:dt_];
}

-(CMMSObject *)addBox:(CGPoint)point_{
	CMMSObject *object_ = [CMMSObject spriteWithFile:@"Icon.png"];
	object_.position = point_;
	[[stage world] addObject:object_];
	
	CMMStageLightItem *lightItem_ = [[stage light] addLightItemAtPoint:CGPointZero brightness:1.0f radius:100.0f];
	[lightItem_ setTarget:object_];
	
	return object_;
}
-(CMMSBall *)addBall:(CGPoint)point_{
	CMMSBall *ball_ = [CMMSBall spriteWithFile:@"IMG_STG_ball.png"];
	[ball_ setCallback_whenAddedToStage:^(CMMSObject *target_, CMMStage *stage_) {
		[[stage_ stateView] addStateView:[CMMSBallStateView stateViewWithTarget:target_]];
	}];
	ball_.position = point_;
	[[stage world] addObject:ball_];
	
	CMMStageLightItem *lightItem_ = [[stage light] addLightItemAtPoint:CGPointZero brightness:1.0f radius:100.0f];
	[lightItem_ setBlendColor:YES];
	[lightItem_ setColor:ccc3(255, 0, 0)];
	[lightItem_ setTarget:ball_];
	
	return ball_;
}

@end

@implementation StageTestLayerBasic

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	stageControlType = StageControlType_addBox;
	
	[gravitySlider setItemValue:-9.8f];
	
	//add light control item
	CGSize tempMenuItemSize_ = CGSizeMake(controlMenu.contentSize.width, 30);
	CMMMenuItemL *tempMenuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"add Light"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_addLight;
	}];
	[controlMenu addItem:tempMenuItem_];

	return self;
}

-(void)buildupStage{
	//// add stage
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageDef stageDef_;
	stageDef_.stageSize = stageDef_.worldSize = CGSizeMake(targetSize_.width-80.0f, targetSize_.height-50.0f);
	stageDef_.gravity = CGPointZero;
	stageDef_.friction = 0.3f;
	stageDef_.restitution = 0.3f;
	stageDef_.brightness = 0.4f;
	
	stage = [CMMStage stageWithStageDef:stageDef_];
	stage.sound.soundDistance = 300.0f;
	stage.position = ccp(0,_contentSize.height-stage.contentSize.height);
	
	stage.touchEnabled = YES;
	[stage initializeLightSystem]; // lazy initialization
	
	[self addChild:stage z:0];
	
	//add background
	CCLayerGradientTest *backgroundLayer_ = [CCLayerGradientTest layerWithColor:ccc4(180, 0, 0, 255) fadingTo:ccc4(0, 180, 0, 255) alongVector:ccp(0.1,0.4)];
	[backgroundLayer_ setContentSize:stageDef_.worldSize];
	[stage addBackgroundNode:backgroundLayer_];
	
	////add object batchNode
	//CMMSObjectBatchNode *batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"Icon.png" isInDocument:NO];
//	[stage.world addObatchNode:batchNode_];
	
//	batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"IMG_STG_ball.png" isInDocument:NO];
//	batchNode_.objectClass = [CMMSBall class];
//	[stage.world addObatchNode:batchNode_];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	
	switch(stageControlType){
		case StageControlType_addLight:{
			CGPoint targetPoint_ = [stage convertToStageWorldSpace:[CMMTouchUtil pointFromTouch:touch_]];
			CMMStageLightItemFadeInOut *lightItem_ = (CMMStageLightItemFadeInOut *)[[stage light] addLightItemAtPoint:targetPoint_ brightness:1.0f radius:100.0f duration:1.0f lightItemClass:[CMMStageLightItemFadeInOut class]];
			[lightItem_ setFadeTime:0.2f];
			[lightItem_ setBlendColor:YES];
			[lightItem_ setColor:ccc3(arc4random()%255, arc4random()%255, arc4random()%255)];
			break;
		}
		default: break;
	}
}

@end

@implementation StageTestLayerPixel

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	//add control menu item
	CGSize tempMenuItemSize_ = CGSizeMake(controlMenu.contentSize.width, 30);
	
	CMMMenuItemL *tempMenuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"paint pixel"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_paintMap;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	tempMenuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"erase pixel"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_eraseMap;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	[gravitySlider setItemValue:-9.8f];
		
	return self;
}

-(void)buildupStage{
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageDef stageDef_;
	stageDef_.stageSize = CGSizeMake(targetSize_.width-80.0f, targetSize_.height-50.0f);
	stageDef_.gravity = CGPointZero;
	stageDef_.friction = 0.3f;
	stageDef_.restitution = 0.3f;
	stageDef_.brightness = 0.2f;
	
	stage = [CMMStagePXL stageWithStageDef:stageDef_ fileName:@"IMG_STG_TEST_001.png" isInDocument:NO];
	stage.sound.soundDistance = 300.0f;
	stage.position = ccp(0,self.contentSize.height-stage.contentSize.height);
	stage.touchEnabled = YES;
	[stage initializeLightSystem]; // lazy initialization
	
	[self addChild:stage z:0];
	
	//add background
	CCLayerGradientTest *backgroundLayer_ = [CCLayerGradientTest layerWithColor:ccc4(130, 130, 130, 255) fadingTo:ccc4(130, 130, 130, 255) alongVector:ccp(0.1,0.4)];
	[backgroundLayer_ setContentSize:[stage worldSize]];
	[stage addBackgroundNode:backgroundLayer_];
	
	////add object batchNode
//	CMMSObjectBatchNode *batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"Icon.png" isInDocument:NO];
//	[stage.world addObatchNode:batchNode_];
	
//	batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"IMG_STG_ball.png" isInDocument:NO];
//	batchNode_.objectClass = [CMMSBall class];
//	[stage.world addObatchNode:batchNode_];
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	
	if(_isOnTouch && !_isTouchObject && !_isOnDrag){
		CMMStagePXL *stage_ = (CMMStagePXL *)stage;
		float pointDistance_ = ccpDistance(_curTouchPoint, _beforeTouchPoint);
		int targetCount_ = MAX((int)(pointDistance_/2.0f),2);
		float targetRadians_ = ccpToAngle(_beforeTouchPoint,_curTouchPoint);
		_beforeTouchPoint = _curTouchPoint;
		switch(stageControlType){
			case StageControlType_paintMap:{
				for(uint index_=0;index_<targetCount_;++index_){
					CGPoint targetPoint_ = ccpOffset(_curTouchPoint, targetRadians_, pointDistance_*((float)index_/(float)targetCount_));
					[stage_.pixel paintMapAtPoint:[stage convertToStageWorldSpace:targetPoint_] color:ccc4(0, 0, 0, 255) radius:20.0f];
				}
				break;
			}
			case StageControlType_eraseMap:{
				for(uint index_=0;index_<targetCount_;++index_){
					CGPoint targetPoint_ = ccpOffset(_curTouchPoint, targetRadians_, pointDistance_*((float)index_/(float)targetCount_));
					[stage_.pixel createCraterAtPoint:[stage convertToStageWorldSpace:targetPoint_] radius:20.0f];
				}
				break;
			}
			default: break;
		}
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	_beforeTouchPoint = _curTouchPoint;
}

@end

@implementation StageTestLayerTile

-(void)buildupStage{
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageDef stageDef_ = CMMStageDefMake(CGSizeMake(targetSize_.width-80.0f, targetSize_.height-50.0f),CGSizeZero,ccp(0,0));
	
	stage = [CMMStageTMX stageWithStageDef:stageDef_ tmxFileName:@"TMX_SAMPLE_000.tmx" isInDocument:NO];
	[stage light];
	stage.position = ccp(0,_contentSize.height-stage.contentSize.height);
	stage.touchEnabled = YES;
	[stage initializeLightSystem]; // lazy initialization
	
	[((CMMStageTMX *)stage) setFilter_isSingleTile:^BOOL(CCTMXLayer *tmxLayer_, CCSprite *tile_, float xIndex_, float yIndex_) {
		return NO;
	}];
	[((CMMStageTMX *)stage) setCallback_tileBuiltup:^(CCTMXLayer *tmxLayer_, float fromXIndex_, float toXIndex_, float yIndex_, b2Fixture *tileFixture_) {
		CCLOG(@"tile built up! [ X : %d -> %d , Y: %d ]",(int)fromXIndex_,(int)toXIndex_,(int)yIndex_);
	}];
	
	[self addChild:stage];
	
	////add object batchNode
//	CMMSObjectBatchNode *batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"Icon-Small.png" isInDocument:NO];
//	[stage.world addObatchNode:batchNode_];

//	batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"IMG_STG_ball.png" isInDocument:NO];
//	batchNode_.objectClass = [CMMSBall class];
//	[stage.world addObatchNode:batchNode_];
	
	[gravitySlider setItemValue:-9.8f];
}

-(void)sceneDidEndTransition:(CMMScene *)scene_{
	[self unscheduleUpdate];
	[backBtn setEnable:NO];
	
	CMMStageTMX *stage_ = (CMMStageTMX *)stage;
	[stage_ addGroundTMXLayerAtLayerName:@"ground"];
	[stage_ buildupTilemapWithBlock:^{
		[self scheduleUpdate];
		[backBtn setEnable:YES];
	}];
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return [((CMMStageTMX *)stage) isTilemapBuiltup];
}

-(CMMSObject *)addBox:(CGPoint)point_{
	CMMSObject *object_ = [CMMSObject spriteWithFile:@"Icon-Small.png"];
	object_.position = point_;
	[[stage world] addObject:object_];
	
	CMMStageLightItem *lightItem_ = [[stage light] addLightItemAtPoint:CGPointZero brightness:1.0f radius:100.0f];
	[lightItem_ setTarget:object_];
	
	return object_;
}

@end

@implementation TestHero
@synthesize velocity;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	b2CMask_leg = CMMb2ContactMaskMake(0x1002,-1,-1,1);
	_canJump = NO;
	
	return self;
}

-(void)jump{
	if(!_canJump || !body) return;
	body->ApplyForceToCenter(b2Vec2(0,120.0f));
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	
	//handling move
	b2Vec2 convertedVelocity_ = b2Vec2Fromccp(velocity);
	convertedVelocity_.y = 0.0f;
	if(body && convertedVelocity_.Length() > 0){
		if(ABS(body->GetLinearVelocity().x) < 8.0f){
			if(!_canJump) convertedVelocity_.x *= 0.6f;
			body->ApplyLinearImpulse(b2Vec2Mult(convertedVelocity_, 10.0f*dt_), body->GetPosition());
		}
	}
}

@end

@implementation TestHero(Box2d)

-(void)buildupBodyWithWorld:(CMMStageWorld *)world_{
	[super buildupBodyWithWorld:world_];
	
	b2Vec2 targetSize_ = b2Vec2FromSize_PTM_RATIO(CGSizeMake(_contentSize.width*0.3f, _contentSize.height*0.3f));
	b2PolygonShape bodyBox_;
	bodyBox_.SetAsBox(targetSize_.x, targetSize_.y, b2Vec2(0.0f,-(_contentSize.height/2.0f)/PTM_RATIO), 0.0f);
	b2FixtureDef fixtureDef_;
	fixtureDef_.shape = &bodyBox_;
	fixtureDef_.isSensor = YES;
	
	body->CreateFixture(&fixtureDef_)->SetUserData(&b2CMask_leg);
	body->SetFixedRotation(YES);
}

-(void)whenContactBeganWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{
	if(fixtureType_ == b2CMask_leg.fixtureType){
		_canJump = YES;
	}
}
-(void)whenContactEndedWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{
	if(fixtureType_ == b2CMask_leg.fixtureType){
		_canJump = NO;
	}
}

@end

@implementation StageTestLayerDynamicBlock

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemL *backBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[backBtn_ setTitle:@"BACK"];
	backBtn_.position = ccp(backBtn_.contentSize.width/2,_contentSize.height-backBtn_.contentSize.height/2);
	[backBtn_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayer node]];
	}];
	[self addChild:backBtn_];
	
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageDef stageDef_ = CMMStageDefMake(CGSizeMake(targetSize_.width, targetSize_.height-50.0f), CGSizeZero, ccp(0.0f, -9.8f));
	stageDef_.brightness = 0.4f;
	stage = [CMMStageDNB stageWithStageDef:stageDef_];
	[stage setMarginPerBlock:CMMFloatRange(50.0f, 80.0f)];
	[stage setBlockHeightRange:CMMFloatRange(0.0f, 120.0f)];
	[stage setMaxHeightDifferencePerBlock:30.0f];
	[[stage block] setBlockRandomizeRatio:1.0f];
	[self addChild:stage];
	
	[stage setCallback_whenContactBeganWithObject:^(CMMSObject *object_, CMMStageDNBDirection direction_) {
		if(direction_ == CMMStageDNBDirection_top) return;
		
		if(object_ == targetObject){
			[self _regenTargetObject];
		}
	}];
	
	//[stage initializeLightSystem];
	
	CCTexture2D *backPattern_ =[[CCTextureCache sharedTextureCache] addImage:@"IMG_STG_BLOCK_PATTERN.png"];
	
	//add block item
	CMMStageBlockItem *blockItem_ = [CMMStageBlockItem blockItem];
	[blockItem_ setBlockType:CMMBlockType_filledDown];
	[blockItem_ setDrawEdge:YES];
	[blockItem_ addGroundBlockWithFile:@"IMG_STG_BLOCK000.plist" spriteFrameFormatter:@"IMG_STG_BLOCK000_GROUND%02d.png"];
	[blockItem_ addBackBlockWithFile:@"IMG_STG_BLOCK000.plist" spriteFrameFormatter:@"IMG_STG_BLOCK000_BACK%02d.png"];
	[blockItem_ setLayoutPatternTexture:backPattern_];
	[[stage block] addBlockItem:blockItem_]; //first record being default block.
	
	CMMStageBlockItem *linkBlockItem_ = [CMMStageBlockItem blockItem];
	[linkBlockItem_ setBlockType:CMMBlockType_filledDown];
	[linkBlockItem_ setDrawEdge:YES];
	[linkBlockItem_ addGroundBlockWithFile:@"IMG_STG_BLOCK000.plist" spriteFrameFormatter:@"IMG_STG_BLOCK000_GROUND%02d.png"];
	[linkBlockItem_ addBackBlockWithFile:@"IMG_STG_BLOCK000.plist" spriteFrameFormatter:@"IMG_STG_BLOCK000_BACK%02d.png"];
	[linkBlockItem_ setLayoutPatternTexture:backPattern_];
	[blockItem_ addLinkBlockItem:linkBlockItem_];
	
	blockItem_ = [CMMStageBlockItem blockItem];
	[blockItem_ setBlockType:CMMBlockType_filledDown];
	[blockItem_ setDrawEdge:YES];
	[blockItem_ setPickupRatio:0.7f]; // you can change pickup ratio of block item
	[blockItem_ addGroundBlockWithFile:@"IMG_STG_BLOCK001.plist" spriteFrameFormatter:@"IMG_STG_BLOCK001_GROUND%02d.png"];
	[blockItem_ addBackBlockWithFile:@"IMG_STG_BLOCK001.plist" spriteFrameFormatter:@"IMG_STG_BLOCK001_BACK%02d.png"];
	[blockItem_ setLayoutPatternTexture:backPattern_];
	[[stage block] addBlockItem:blockItem_];
	
	blockItem_ = [CMMStageBlockItem blockItem];
	[blockItem_ setBlockType:CMMBlockType_filledUp];
	[blockItem_ setDrawEdge:YES];
	[blockItem_ setBlockB2BodyType:CMMSBlockObjectB2BodyType_bar];
	[blockItem_ setPickupRatio:0.6f];
	[blockItem_ addGroundBlockWithFile:@"IMG_STG_BLOCK002.plist" spriteFrameFormatter:@"IMG_STG_BLOCK002_GROUND%02d.png"];
	[blockItem_ addBackBlockWithFile:@"IMG_STG_BLOCK002.plist" spriteFrameFormatter:@"IMG_STG_BLOCK002_BACK%02d.png"];
	[blockItem_ setLayoutPatternTexture:backPattern_];
	[[stage block] addBlockItem:blockItem_];
	
	blockItem_ = [CMMStageBlockItem blockItem];
	[blockItem_ setBlockType:CMMBlockType_normal];
	[blockItem_ setDrawEdge:YES];
	[blockItem_ setBlockB2BodyType:CMMSBlockObjectB2BodyType_bar];
	[blockItem_ setPickupRatio:0.5f];
	[blockItem_ setBlockPhysicalSpec:CMMSBlockObjectPhysicalSpec(0.3f, 0.8f, 1.0f)]; // you can setting physical spec per block item.
	[blockItem_ addGroundBlockWithFile:@"IMG_STG_BLOCK002.plist" spriteFrameFormatter:@"IMG_STG_BLOCK002_GROUND%02d.png"];
	[blockItem_ setLayoutPatternTexture:backPattern_];
	[[stage block] addBlockItem:blockItem_];
	
	blockItem_ = [CMMStageBlockItem blockItem];
	[blockItem_ setBlockType:CMMBlockType_filledUpAndCeiling];
	[blockItem_ setDrawEdge:YES];
	[blockItem_ setBlockB2BodyType:CMMSBlockObjectB2BodyType_bar];
	[blockItem_ setPickupRatio:0.3f];
	[blockItem_ setBlockCountRange:NSRangeMake(2, 4)];
	[blockItem_ setBlockPhysicalSpec:CMMSBlockObjectPhysicalSpec(0.3f, 0.8f, 1.0f)];
	[blockItem_ addGroundBlockWithFile:@"IMG_STG_BLOCK002.plist" spriteFrameFormatter:@"IMG_STG_BLOCK002_GROUND%02d.png"];
	[blockItem_ setLayoutPatternTexture:backPattern_];
	[[stage block] addBlockItem:blockItem_];
	
	//add ui
	NSString *joypadSpriteFrameFileName_ = @"IMG_JOYPAD_000.plist";
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:joypadSpriteFrameFileName_];
	ui = [CMMCustomUIJoypad joypadWithSpriteFrameFileName:joypadSpriteFrameFileName_];
	[ui setOpacity:120.0f];
	[[ui stick] setCallback_whenStickVectorChanged:^(CGPoint vector_) {
		if(targetObject) [targetObject setVelocity:vector_];
	}];
	
	[[ui buttonB] setCallback_pushdown:^(id sender_){
		if(!targetObject) return;
		[targetObject jump];
	}];
	
	[[ui buttonB] setPushDelayTime:0.4f];
	[self addChild:ui z:1];
	
	worldVelocityLabel = [CMMFontUtil labelWithString:@" "];
	[worldVelocityLabel setPosition:ccp(_contentSize.width/2.0f, _contentSize.height/2.0f+50.0f)];
	[self addChild:worldVelocityLabel z:9];
	
	[self _setWorldVelocity:100.0f];
	
	[self _regenTargetObject];
	[self scheduleUpdate];
	
	return self;
}

-(void)_regenTargetObject{
	if(targetObject && [targetObject stage] == stage){
		[[stage world] removeObject:targetObject];
	}
	
	targetObject = [TestHero spriteWithFile:@"Icon-Small.png"];
	[targetObject setPosition:[stage convertToStageWorldSpace:ccp(_contentSize.width/2.0f,_contentSize.height/2.0f)]];
	[[stage world] addObject:targetObject];
	CMMStageLightItem *lightItem_ = [[stage light] addLightItemAtPoint:[targetObject position]];
	[lightItem_ setTarget:targetObject];
}

-(void)_setWorldVelocity:(float)velocity_{
	if(velocity_ == [stage worldVelocityX]) return;
	
	[stage setWorldVelocityX:velocity_];
	[worldVelocityLabel setString:[NSString stringWithFormat:@"world velocity : %d",(uint)velocity_]];
	
	[worldVelocityLabel stopAllActions];
	[worldVelocityLabel setScale:1.0f];
	[worldVelocityLabel runAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:0.1f scale:1.2] two:[CCScaleTo actionWithDuration:0.1f scale:1.0]]];
}

-(void)update:(ccTime)dt_{
	[ui update:dt_];
	[stage update:dt_];
	
	_curStackTime += dt_;
	if(_curStackTime >= 10.0f){
		_curStackTime = 0.0f;
		[self _setWorldVelocity:MIN([stage worldVelocityX]+20.0f,240.f)];
	}
}

@end
