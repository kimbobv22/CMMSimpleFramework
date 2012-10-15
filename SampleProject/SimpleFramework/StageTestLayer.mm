//  Created by JGroup(kimbobv22@gmail.com)

#import "StageTestLayer.h"
#import "HelloWorldLayer.h"

@implementation StageTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	stageSelector = [CMMMenuItemSet menuItemSetWithMenuSize:CGSizeMake(contentSize_.width*0.8f, contentSize_.height*0.6f)];
	[stageSelector setLineVAlignType:CMMMenuItemSetLineVAlignType_center];
	[stageSelector setUnitPerLine:2];
	[stageSelector setPosition:cmmFuncCommon_position_center(self, stageSelector)];
	[self addChild:stageSelector];
	
	CMMMenuItemLabelTTF *menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"basic stage"];
	[menuItem_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayerBasic node]];
	}];
	
	[stageSelector addMenuItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"pixel stage"];
	[menuItem_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayerPixel node]];
	}];
	
	[stageSelector addMenuItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"tile stage"];
	[menuItem_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayerTile node]];
	}];
	
	[stageSelector addMenuItem:menuItem_];
		
	[stageSelector updateDisplay];
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	[menuItemBack_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	}];
	[self addChild:menuItemBack_];
	
	return self;
}

@end

@interface CCLayerGradientTest : CCLayerGradient

@end

@implementation CCLayerGradientTest

-(void)draw{
	[super draw];
	
	glLineWidth(1.0f);
	ccDrawColor4F(1.0f, 1.0f, 1.0f, 0.4f);
	ccDrawLine(ccp(contentSize_.width/2,0), ccp(contentSize_.width/2,contentSize_.height));
	ccDrawLine(ccp(0,contentSize_.height/2), ccp(contentSize_.width,contentSize_.height/2));
}

@end

@implementation StageTestLayerMaster

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	//// add control menu
	controlMenu = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(80.0f, contentSize_.height*0.8f)];
	[controlMenu setDelegate:self];
	[controlMenu setPosition:ccp(contentSize_.width-controlMenu.contentSize.width,contentSize_.height/2.0f-controlMenu.contentSize.height/2.0f)];
	[self addChild:controlMenu];
	
	//add control menu item
	CGSize tempMenuItemSize_ = CGSizeMake(controlMenu.contentSize.width, 30);
	
	CMMMenuItemLabelTTF *tempMenuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"add box"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_addBox;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	tempMenuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"add ball"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_addBall;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	tempMenuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"drag mode"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_dragMode;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	////gravity control
	labelGravity = [CMMFontUtil labelWithstring:@" "];
	[self addChild:labelGravity];
	
	gravitySlider = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	gravitySlider.callback_whenChangedItemVale = ^(id sender_, float itemValue_, float beforeItemValue_){
		CGPoint gravity_ = stage.spec.gravity;
		gravity_.y = itemValue_;
		[stage.spec setGravity:gravity_];
		[labelGravity setString:[NSString stringWithFormat:@"gravity : %1.1f",gravity_.y]];
		labelGravity.position = ccp(contentSize_.width-labelGravity.contentSize.width/2-5,labelGravity.contentSize.height/2+5);
	};
	gravitySlider.minValue = -10.0f;
	gravitySlider.maxValue = 10.0f;
	gravitySlider.unitValue = 0.5f;
	gravitySlider.itemValue = 0.0f;
	CGPoint targetPoint_ = cmmFuncCommon_position_center(self, gravitySlider);
	targetPoint_.x += 40.0f;
	targetPoint_.y = 5.0f;
	gravitySlider.position = targetPoint_;
	[self addChild:gravitySlider];
	
	backBtn = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[backBtn setTitle:@"BACK"];
	backBtn.position = ccp(backBtn.contentSize.width/2,backBtn.contentSize.height/2);
	[backBtn setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[StageTestLayer node]];
	}];
	[self addChild:backBtn];
	
	[self scheduleUpdate];
	
	return self;
}

//stage basic delegate method
-(void)stage:(CMMStage *)stage_ whenAddedObjects:(CCArray *)objects_{
	CCLOG(@"added objects. count : %d",objects_.count);
}
-(void)stage:(CMMStage *)stage_ whenRemovedObjects:(CCArray *)objects_{
	CCLOG(@"removed objects. count : %d",objects_.count);
	
	ccArray *data_ = objects_->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;index_++){
		CMMSObject *object_ = data_->arr[index_];
		if(_curTouchObject == object_){
			_curTouchObject = nil;
			_isTouchObject = NO;
		}
	}
}

//stage touch delegate method
-(void)stage:(CMMStage *)stage_ whenTouchBegan:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	_isOnTouch = YES;
	_curTouchObject = nil;
	_curTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
	switch(stageControlType){
		case StageControlType_dragMode:
			if(!object_) return;
			_isTouchObject = YES;
			_curTouchObject = object_;
			break;
		default: break;
	}
}
-(void)stage:(CMMStage *)stage_ whenTouchMoved:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	_curTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
	
	switch(stageControlType){
		case StageControlType_dragMode:{
			if(!_isTouchObject){
				CGPoint diffPoint_ = ccpSub(_curTouchPoint,[CMMTouchUtil prepointFromTouch:touch_]);
				stage.worldPoint = ccpSub(stage.worldPoint, diffPoint_);
			}
			break;
		}
		default: break;
	}
}
-(void)stage:(CMMStage *)stage_ whenTouchEnded:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	switch(stageControlType){
		case StageControlType_addBox:
			[self addBox:[stage convertToStageWorldSpace:_curTouchPoint]];
			break;
		case StageControlType_addBall:
			[self addBall:[stage convertToStageWorldSpace:_curTouchPoint]];
			break;
		default: break;
	}
	
	_isOnTouch = _isTouchObject = NO;
	_curTouchObject = nil;
}
-(void)stage:(CMMStage *)stage_ whenTouchCancelled:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	_isOnTouch = _isTouchObject = NO;
	_curTouchObject = nil;
}

-(void)update:(ccTime)dt_{
	switch(stageControlType){
		case StageControlType_dragMode:{
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
			break;
		}
		default: break;
	}
	
	if(stage){
		[stage update:dt_];
	}
}

-(CMMSObject *)addBox:(CGPoint)point_{
	CMMSObjectBatchNode *batchNode_ = [stage.world obatchNodeAtFileName:@"Icon.png" isInDocument:NO];
	CMMSObject *object_ = [batchNode_ createObject];
	object_.position = point_;
	[stage.world addObject:object_];
	
	CMMStageLightItem *lightItem_ = [[stage light] addLightItemAtPoint:CGPointZero brightness:1.0f radius:100.0f];
	[lightItem_ setTarget:object_];
	
	return object_;
}
-(CMMSBall *)addBall:(CGPoint)point_{
	CMMSObjectBatchNode *batchNode_ = [stage.world obatchNodeAtFileName:@"IMG_STG_ball.png" isInDocument:NO];
	CMMSBall *ball_ = (CMMSBall *)[batchNode_ createObject];
	ball_.position = point_;
	[stage.world addObject:ball_];
	
	CMMStageLightItem *lightItem_ = [[stage light] addLightItemAtPoint:CGPointZero brightness:1.0f radius:100.0f];
	[lightItem_ setIsBlendColor:YES];
	[lightItem_ setColor:ccc3(255, 0, 0)];
	[lightItem_ setTarget:ball_];
	
	return ball_;
}

@end

@implementation StageTestLayerBasic

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	//// add stage
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageSpecDef stageSpec_;
	stageSpec_.stageSize = CGSizeMake(targetSize_.width-80.0f, targetSize_.height-50.0f);
	stageSpec_.worldSize = stageSpec_.stageSize;
	stageSpec_.gravity = CGPointZero;
	stageSpec_.friction = 0.3f;
	stageSpec_.restitution = 0.3f;
	stageSpec_.brightness = 0.1f;
	
	stage = [CMMStage stageWithStageSpecDef:stageSpec_];
	stage.sound.soundDistance = 300.0f;
	stage.position = ccp(0,contentSize_.height-stage.contentSize.height);
	stage.delegate = self;
	stage.isAllowTouch = YES;
	[stage initializeLightSystem]; // lazy initialization
	
	[self addChild:stage z:0];
	
	////add object batchNode
	CMMSObjectBatchNode *batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"Icon.png" isInDocument:NO];
	[stage.world addObatchNode:batchNode_];
	
	batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"IMG_STG_ball.png" isInDocument:NO];
	batchNode_.objectClass = [CMMSBall class];
	[stage.world addObatchNode:batchNode_];
	
	////add stage back ground
	CCLayerGradient *backLayer_ = [CCLayerGradientTest layerWithColor:ccc4(120, 0, 0, 230) fadingTo:ccc4(0, 0, 120, 230) alongVector:ccp(0.3,0.7)];
	backLayer_.contentSize = stage.worldSize;
	stage.backGround.backGroundNode = backLayer_;
	
	stageControlType = StageControlType_addBox;
	
	[gravitySlider setItemValue:-9.8f];
	
	//add light control item
	CGSize tempMenuItemSize_ = CGSizeMake(controlMenu.contentSize.width, 30);
	CMMMenuItemLabelTTF *tempMenuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"add Light"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_addLight;
	}];
	[controlMenu addItem:tempMenuItem_];

	return self;
}

-(void)stage:(CMMStage *)stage_ whenTouchEnded:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	[super stage:stage_ whenTouchEnded:touch_ withObject:object_];
	
	switch(stageControlType){
		case StageControlType_addLight:{
			CGPoint targetPoint_ = [stage_ convertToStageWorldSpace:[CMMTouchUtil pointFromTouch:touch_]];
			CMMStageLightItemFadeInOut *lightItem_ = (CMMStageLightItemFadeInOut *)[[stage_ light] addLightItemAtPoint:targetPoint_ brightness:1.0f radius:100.0f duration:1.0f lightItemClass:[CMMStageLightItemFadeInOut class]];
			[lightItem_ setFadeTime:0.2f];
			[lightItem_ setIsBlendColor:YES];
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
	
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageSpecDef stageSpec_;
	stageSpec_.stageSize = CGSizeMake(targetSize_.width-80.0f, targetSize_.height-50.0f);
	stageSpec_.worldSize = CGSizeMake(targetSize_.width+200.0f, targetSize_.height+200.0f);
	stageSpec_.gravity = CGPointZero;
	stageSpec_.friction = 0.3f;
	stageSpec_.restitution = 0.3f;
	stageSpec_.brightness = 0.2f;

	stage = [CMMStagePXL stageWithStageSpecDef:stageSpec_ fileName:@"IMG_STG_TEST_001.png" isInDocument:NO];
	stage.sound.soundDistance = 300.0f;
	stage.position = ccp(0,self.contentSize.height-stage.contentSize.height);
	stage.delegate = self;
	stage.isAllowTouch = YES;
	[stage initializeLightSystem]; // lazy initialization
	
	[self addChild:stage z:0];
	
	//backGround image for test
	CCLayerGradient *backLayer_ = [CCLayerGradientTest layerWithColor:ccc4(200, 200, 200, 255) fadingTo:ccc4(180, 180, 180, 255) alongVector:ccp(0.3,0.7)];
	backLayer_.contentSize = stage.worldSize;
	stage.backGround.backGroundNode = backLayer_;
	stage.backGround.distanceRate = 1.0f; //for Parallax
	
	////add object batchNode
	CMMSObjectBatchNode *batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"Icon.png" isInDocument:NO];
	[stage.world addObatchNode:batchNode_];
	
	batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"IMG_STG_ball.png" isInDocument:NO];
	batchNode_.objectClass = [CMMSBall class];
	[stage.world addObatchNode:batchNode_];
	
	//add control menu item
	CGSize tempMenuItemSize_ = CGSizeMake(controlMenu.contentSize.width, 30);
	
	CMMMenuItemLabelTTF *tempMenuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"paint pixel"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_paintMap;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	tempMenuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:tempMenuItemSize_];
	[tempMenuItem_ setTitle:@"erase pixel"];
	[tempMenuItem_ setCallback_pushup:^(id) {
		stageControlType = StageControlType_eraseMap;
	}];
	[controlMenu addItem:tempMenuItem_];
	
	[gravitySlider setItemValue:-9.8f];
		
	return self;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	
	if(_isOnTouch){
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

-(void)stage:(CMMStage *)stage_ whenTouchBegan:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	[super stage:stage_ whenTouchBegan:touch_ withObject:object_];
	_beforeTouchPoint = _curTouchPoint;
}

@end

@implementation StageTestLayerTile

-(void)loadingProcess000{
	[self unscheduleUpdate];
	[backBtn setIsEnable:NO];
	
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageSpecDef stageSpecDef_ = CMMStageSpecDefMake(CGSizeMake(targetSize_.width-80.0f, targetSize_.height-50.0f),CGSizeZero,ccp(0,0));
	stageSpecDef_.brightness = 1.0f;
	
	stage = [CMMStageTMX stageWithStageSpecDef:stageSpecDef_ tmxFileName:@"TMX_SAMPLE_000.tmx" isInDocument:NO];
	[stage light];
	stage.position = ccp(0,contentSize_.height-stage.contentSize.height);
	stage.delegate = self;
	stage.isAllowTouch = YES;
	[stage initializeLightSystem]; // lazy initialization
	
	[self addChild:stage];
	
	////add object batchNode
	CMMSObjectBatchNode *batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"Icon-Small.png" isInDocument:NO];
	[stage.world addObatchNode:batchNode_];
	
	batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"IMG_STG_ball.png" isInDocument:NO];
	batchNode_.objectClass = [CMMSBall class];
	[stage.world addObatchNode:batchNode_];
	
	[gravitySlider setItemValue:-9.8f];
}
-(void)loadingProcess001{
	CMMStageTMX *stage_ = (CMMStageTMX *)stage;
	[stage_ addGroundTMXLayerAtLayerName:@"ground"];
	[stage_ buildupTilemap];
}
-(void)whenLoadingEnded{
	[self scheduleUpdate];
	[backBtn setIsEnable:YES];
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return [backBtn isEnable];
}

-(void)tilemapStage:(CMMStageTMX *)stage_ whenTileBuiltupAtTMXLayer:(CCTMXLayer *)tmxLayer_ fromXIndex:(float)fromXIndex_ toXIndex:(float)toXIndex_ yIndex:(float)yIndex_ tileFixture:(b2Fixture *)tileFixture_{
	CCLOG(@"tile built up! [ X : %d -> %d , Y: %d ]",(int)fromXIndex_,(int)toXIndex_,(int)yIndex_);
}
-(BOOL)tilemapStage:(CMMStageTMX *)stage_ isSingleTileAtTMXLayer:(CCTMXLayer *)tmxLayer_ tile:(CCSprite *)tile_ xIndex:(float)xIndex_ yIndex:(float)yIndex_{
	return NO; // if return value is 'yes', the tile will be built up as a single tile;
}

-(CMMSObject *)addBox:(CGPoint)point_{
	CMMSObjectBatchNode *batchNode_ = [stage.world obatchNodeAtFileName:@"Icon-Small.png" isInDocument:NO];
	CMMSObject *object_ = [batchNode_ createObject];
	object_.position = point_;
	[[stage world] addObject:object_];
	
	CMMStageLightItem *lightItem_ = [[stage light] addLightItemAtPoint:CGPointZero brightness:1.0f radius:100.0f];
	[lightItem_ setTarget:object_];
	
	return object_;
}

@end
