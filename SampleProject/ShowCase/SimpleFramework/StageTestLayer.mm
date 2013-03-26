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
		[[CMMScene sharedScene] pushLayer:[ViewStageTestBasic stage]];
	}];
	
	[stageSelector addMenuItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"pixel stage"];
	[menuItem_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[ViewStageTestPixel stage]];
	}];
	
	[stageSelector addMenuItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"tile stage"];
	[menuItem_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[ViewStageTestTile stage]];
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

@implementation ViewStageTest{
	CCLabelTTF *_labelGravity;
	CMMGestureDispatcher *_gestureDispatcher;
	CGPoint _lastPoint;
}
@synthesize controlMenu;

+(id)stage{return nil;}
+(id)layerWithStage:(CMMStage *)stage_{
	return [[[self alloc] initWithStage:stage_] autorelease];
}
-(id)initWithStage:(CMMStage *)stage_{
	CGSize winSize_ = [[CCDirector sharedDirector] winSize];
	if(!(self = [super initWithColor:ccc4(0, 0, 0, 0) width:winSize_.width height:winSize_.height])) return self;
	[touchDispatcher setMaxMultiTouchCount:1];
	
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
		_stageControlType = StageControlType_addBox;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	tempMenuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"add ball"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		_stageControlType = StageControlType_addBall;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	////gravity control
	_labelGravity = [CMMFontUtil labelWithString:@" "];
	[self addChild:_labelGravity];
	
	_gravitySlider = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	[_gravitySlider setCallback_whenItemValueChanged:^(float itemValue_, float beforeItemValue_) {
		CGPoint gravity_ = stage.spec.gravity;
		gravity_.y = itemValue_;
		[stage.spec setGravity:gravity_];
		[_labelGravity setString:[NSString stringWithFormat:@"gravity : %1.1f",gravity_.y]];
		_labelGravity.position = ccp(_contentSize.width-_labelGravity.contentSize.width/2-5,_labelGravity.contentSize.height/2+5);
	}];
	
	[_gravitySlider setItemValueRange:CMMFloatRange(-10.0f,10.0)];
	[_gravitySlider setSnappable:YES];
	_gravitySlider.unitValue = 0.5f;
	_gravitySlider.itemValue = 0.0f;
	CGPoint targetPoint_ = cmmFunc_positionIPN(self, _gravitySlider);
	targetPoint_.x += 40.0f;
	targetPoint_.y = 5.0f;
	_gravitySlider.position = targetPoint_;
	[self addChild:_gravitySlider];
	
	//add stage
	stage = stage_;
	[stage setTouchEnabled:YES];
	
	
	//////////// CALLBACK TEST///////////
	/////////////////////////////////////
	[stage addObjectCallbackWithType:CMMStageObjectCallbackType_added callback:^(CMMSObject *object_) {
		CCLOG(@"add callback1");
	}];
	[stage addObjectCallbackWithType:CMMStageObjectCallbackType_added callback:^(CMMSObject *object_) {
		CCLOG(@"add callback2");
	}];
	[stage addObjectCallbackWithType:CMMStageObjectCallbackType_removed callback:^(CMMSObject *object_) {
		CCLOG(@"remove callback1");
	}];
	[stage addObjectCallbackWithType:CMMStageObjectCallbackType_removed callback:^(CMMSObject *object_) {
		CCLOG(@"remove callback2");
	}];
	/////////////////////////////////////
	/////////////////////////////////////
	
	
	[stage setCallback_whenTouchEnded:^(UITouch *touch_, CMMSObject *object_) {
		if(object_) return;
		
		CGPoint targetPoint_ = [stage convertToStageWorldSpace:[CMMTouchUtil pointFromTouch:touch_]];
		switch(_stageControlType){
			case StageControlType_addBox:{
				[self addBoxAtPoint:targetPoint_];
				break;
			}
			case StageControlType_addBall:{
				[self addBallAtPoint:targetPoint_];
				break;
			}
			case StageControlType_addLight:{
				[self addLightAtPoint:targetPoint_];
				break;
			}
			default: break;
		}
	}];
	[stage setPosition:ccp(0,_contentSize.height-[stage contentSize].height)];
	[self addChild:stage z:0];
	
	CMMMenuItemL *backBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[backBtn_ setTitle:@"BACK"];
	backBtn_.position = ccp(backBtn_.contentSize.width/2,backBtn_.contentSize.height/2);
	[backBtn_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayer node]];
	}];
	[self addChild:backBtn_];
	
	//add gesture
	_gestureDispatcher = [[CMMGestureDispatcher alloc] initWithDelegate:self];
	[_gestureDispatcher initializePanRecognizer];
	[[_gestureDispatcher panRecognizer] setMinimumNumberOfTouches:2];
	[[_gestureDispatcher panRecognizer] setCancelsTouchesInView:YES];
	
	_stageControlType = StageControlType_addBox;
	
	return self;
}
-(void)sceneDidEndTransition:(CMMScene *)scene_{
	[self addBoxAtPoint:ccpMult(ccpFromSize([stage worldSize]), 0.5f)];
	[self scheduleUpdate];
}

-(void)update:(ccTime)dt_{
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtIndex:0];
	if(touchItem_){
		CMMSObject *object_ = [[stage world] objectAtTouch:[touchItem_ touch]];
		if(object_){
			b2Body *objectBody_ = [object_ body];
			CGPoint touchPoint_ = [CMMTouchUtil pointFromTouch:[touchItem_ touch]];
			CGPoint convertedPoint_ = [stage convertToStageWorldSpace:touchPoint_];
			
			b2Vec2 beforeVector_ = objectBody_->GetTransform().p;
			[object_ updateBodyPosition:convertedPoint_];
			b2Vec2 curVector_ = objectBody_->GetTransform().p;
			b2Vec2 velocity_ = curVector_-beforeVector_;
			velocity_*=10.0f;
			[object_ updateBodyLinearVelocity:velocity_];
			CGPoint diffPoint_ = ccpSub(ccp(_contentSize.width/2,_contentSize.height/2),touchPoint_);
			[stage setWorldPoint:ccpSub([stage worldPoint], ccpMult(diffPoint_, dt_*2.0f))];
		}
	}
	
	[stage update:dt_];
}

-(CMMSObject *)addBoxAtPoint:(CGPoint)point_{
	CMMSObject *object_ = [CMMSObject spriteWithFile:@"Icon.png"];
	object_.position = point_;
	[[stage world] addObject:object_];
	
	CMMStageLightItem *lightItem_ = [[stage light] addLightItemAtPoint:CGPointZero brightness:1.0f radius:100.0f];
	[lightItem_ setTarget:object_];
	
	return object_;
}
-(CMMSBall *)addBallAtPoint:(CGPoint)point_{
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
-(void)addLightAtPoint:(CGPoint)point_{
	CMMStageLightItemFadeInOut *lightItem_ = (CMMStageLightItemFadeInOut *)[[stage light] addLightItemAtPoint:point_ brightness:1.0f radius:100.0f duration:1.0f lightItemClass:[CMMStageLightItemFadeInOut class]];
	[lightItem_ setFadeTime:0.2f];
	[lightItem_ setBlendColor:YES];
	[lightItem_ setColor:ccc3(arc4random()%255, arc4random()%255, arc4random()%255)];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	
	if([touchDispatcher touchCount] >= 2){
		[touchDispatcher cancelAllTouches];
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
}

-(void)gestureDispatcher:(CMMGestureDispatcher *)gestureDispatcher_ whenPanEvent:(UIPanGestureRecognizer *)gestureRecognizer_{
	switch([gestureRecognizer_ state]){
		case UIGestureRecognizerStateBegan:{
			_lastPoint = CGPointZero;
			break;
		}
		case UIGestureRecognizerStateChanged:{
			CGPoint targetPoint_ = [gestureRecognizer_ translationInView:[gestureRecognizer_ view]];
			CGPoint diffPoint_ = ccpSub(targetPoint_, _lastPoint);
			[stage setWorldPoint:ccpSub([stage worldPoint], ccp(diffPoint_.x,-diffPoint_.y))];
			
			_lastPoint = targetPoint_;
			break;
		}
	}
}

-(void)cleanup{
	[_gestureDispatcher setDelegate:nil];
	[super cleanup];
}
-(void)dealloc{
	[_gestureDispatcher release];
	[super dealloc];
}

@end

@implementation ViewStageTestBasic

+(id)stage{
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageDef stageDef_;
	stageDef_.stageSize = stageDef_.worldSize = CGSizeMake(targetSize_.width-80.0f, targetSize_.height-50.0f);
	stageDef_.gravity = CGPointZero;
	stageDef_.friction = 0.3f;
	stageDef_.restitution = 0.3f;
	stageDef_.brightness = 0.4f;
	
	CMMStage *stage_ = [CMMStage stageWithStageDef:stageDef_];
	stage_.sound.soundDistance = 300.0f;
	[stage_ initializeLightSystem]; // lazy initialization
	
	//add background
	CCLayerGradientTest *backgroundLayer_ = [CCLayerGradientTest layerWithColor:ccc4(180, 0, 0, 255) fadingTo:ccc4(0, 180, 0, 255) alongVector:ccp(0.1,0.4)];
	[backgroundLayer_ setContentSize:stageDef_.worldSize];
	[stage_ addBackgroundNode:backgroundLayer_];
	
	return [self layerWithStage:stage_];
}

@end

@implementation ViewStageTestPixel{
	CGPoint _curDrawPoint,_beforeDrawPoint;
}

+(id)stage{
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageDef stageDef_;
	stageDef_.stageSize = CGSizeMake(targetSize_.width-80.0f, targetSize_.height-50.0f);
	stageDef_.gravity = CGPointZero;
	stageDef_.friction = 0.3f;
	stageDef_.restitution = 0.3f;
	stageDef_.brightness = 0.4f;
	
	CMMStagePXL *stage_ = [CMMStagePXL stageWithStageDef:stageDef_ fileName:@"IMG_STG_TEST_001.png" isInDocument:NO];
	stage_.sound.soundDistance = 300.0f;
	stage_.touchEnabled = YES;
	[stage_ initializeLightSystem]; // lazy initialization
	
	//add background
	CCLayerGradientTest *backgroundLayer_ = [CCLayerGradientTest layerWithColor:ccc4(130, 130, 130, 255) fadingTo:ccc4(130, 130, 130, 255) alongVector:ccp(0.1,0.4)];
	[backgroundLayer_ setContentSize:[stage_ worldSize]];
	[stage_ addBackgroundNode:backgroundLayer_];

	return [self layerWithStage:stage_];
}
-(id)initWithStage:(CMMStage *)stage_{
	if(!(self = [super initWithStage:stage_])) return self;
	
	CGSize tempMenuItemSize_ = CGSizeMake(controlMenu.contentSize.width, 30);
	
	CMMMenuItemL *tempMenuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"paint pixel"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		_stageControlType = StageControlType_paintMap;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	tempMenuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"erase pixel"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		_stageControlType = StageControlType_eraseMap;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	[_gravitySlider setItemValue:-9.8f];
	
	return self;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];

	if([[stage touchDispatcher] touchCount] > 0 && ![[stage world] touchedObject]){
		CMMStagePXL *stage_ = (CMMStagePXL *)stage;
		float pointDistance_ = ccpDistance(_curDrawPoint, _beforeDrawPoint);
		int targetCount_ = MAX((int)(pointDistance_/2.0f),2);
		float targetRadians_ = ccpToAngle(_beforeDrawPoint,_curDrawPoint);
		_beforeDrawPoint = _curDrawPoint;
		
		switch(_stageControlType){
			case StageControlType_paintMap:{
				for(uint index_=0;index_<targetCount_;++index_){
					CGPoint targetPoint_ = ccpOffset(_curDrawPoint, targetRadians_, pointDistance_*((float)index_/(float)targetCount_));
					[[stage_ pixel] paintMapAtPoint:[stage convertToStageWorldSpace:targetPoint_] color:ccc4(0, 0, 0, 255) radius:20.0f];
				}
				break;
			}
			case StageControlType_eraseMap:{
				for(uint index_=0;index_<targetCount_;++index_){
					CGPoint targetPoint_ = ccpOffset(_curDrawPoint, targetRadians_, pointDistance_*((float)index_/(float)targetCount_));
					[[stage_ pixel] createCraterAtPoint:[stage convertToStageWorldSpace:targetPoint_] radius:20.0f];
				}
				break;
			}
			default: break;
		}
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	_curDrawPoint = _beforeDrawPoint = [CMMTouchUtil pointFromTouch:touch_];
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	_curDrawPoint = [CMMTouchUtil pointFromTouch:touch_];
}

@end

@implementation ViewStageTestTile

+(id)stage{
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageDef stageDef_ = CMMStageDefMake(CGSizeMake(targetSize_.width-80.0f, targetSize_.height-50.0f),CGSizeZero,ccp(0,0));
	
	CMMStageTMX *stage_ = [CMMStageTMX stageWithStageDef:stageDef_ tmxFileName:@"TMX_SAMPLE_000.tmx" isInDocument:NO];
	stage_.touchEnabled = YES;
	[stage_ initializeLightSystem]; // lazy initialization
	
	[stage_ setFilter_isSingleTile:^BOOL(CCTMXLayer *tmxLayer_, CCSprite *tile_, float xIndex_, float yIndex_) {
		return NO;
	}];
	[stage_ setCallback_tileBuiltup:^(CCTMXLayer *tmxLayer_, float fromXIndex_, float toXIndex_, float yIndex_, b2Fixture *tileFixture_) {
		CCLOG(@"tile built up! [ X : %d -> %d , Y: %d ]",(int)fromXIndex_,(int)toXIndex_,(int)yIndex_);
	}];

	return [self layerWithStage:stage_];
}

-(id)initWithStage:(CMMStage *)stage_{
	if(!(self = [super initWithStage:stage_])) return self;

	[_gravitySlider setItemValue:-9.8f];
	
	return self;
}

-(void)sceneDidEndTransition:(CMMScene *)scene_{
	[self unscheduleUpdate];
	[self setTouchEnabled:NO];
	
	CMMStageTMX *stage_ = (CMMStageTMX *)stage;
	[stage_ addGroundTMXLayerAtLayerName:@"ground"];
	[stage_ buildupTilemapWithBlock:^{
		[self scheduleUpdate];
		[self setTouchEnabled:YES];
	}];
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
