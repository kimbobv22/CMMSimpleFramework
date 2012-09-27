//  Created by JGroup(kimbobv22@gmail.com)

#import "StageTestLayer.h"
#import "HelloWorldLayer.h"

@interface CCLayerGradientTest : CCLayerGradient

@end

@implementation CCLayerGradientTest

-(void)draw{
	[super draw];
	
	glLineWidth(1.0f);
	ccDrawColor4F(1.0f, 1.0f, 1.0f, 0.4f);
	ccDrawLine(ccp(self.contentSize.width/2,0), ccp(self.contentSize.width/2,self.contentSize.height));
	ccDrawLine(ccp(0,self.contentSize.height/2), ccp(self.contentSize.width,self.contentSize.height/2));
}

@end

@interface StageTestLayer(Private)

//for test of dynamical gravity
-(void)updateGravityUp:(ccTime)dt_;
-(void)updateGravityDown:(ccTime)dt_;

//for test of adding object
-(CMMSObject *)_addBox:(CGPoint)point_;
-(CMMSBall *)_addBall:(CGPoint)point_;

//for test of gravity planet
-(CMMSPlanet *)_addPlanet:(CGPoint)point_ gravity:(float)gravity_ gravityRadius:(float)gravityRadius_;

@end

@implementation StageTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CGSize targetSize_ = [[CCDirector sharedDirector] winSize];
	CMMStageSpecDef stageSpec_;
	stageSpec_.stageSize = CGSizeMake(targetSize_.width-60.0f, targetSize_.height-50.0f);
	stageSpec_.worldSize = CGSizeMake(targetSize_.width+200.0f, targetSize_.height+200.0f);
	stageSpec_.gravity = CGPointZero;
	stageSpec_.friction = 0.3f;
	stageSpec_.restitution = 0.3f;

	stage = [CMMStagePXL stageWithStageSpecDef:stageSpec_ fileName:@"IMG_STG_TEST_001.png" isInDocument:NO];
	stage.sound.soundDistance = 300.0f;
	stage.position = ccp(0,self.contentSize.height-stage.contentSize.height);
	stage.delegate = self;
	stage.isAllowTouch = YES;
	[self addChild:stage z:0];
	
	//backGround image for test
	//CCLayerGradient *backLayer_ = [CCLayerGradientTest layerWithColor:ccc4(120, 0, 0, 180) fadingTo:ccc4(0, 0, 120, 180) alongVector:ccp(0.3,0.7)];
	CCLayerGradient *backLayer_ = [CCLayerGradientTest layerWithColor:ccc4(200, 200, 200, 255) fadingTo:ccc4(180, 180, 180, 255) alongVector:ccp(0.3,0.7)];
	backLayer_.contentSize = stage.worldSize;
	stage.backGround.backGroundNode = backLayer_;
	stage.backGround.distanceRate = 1.0f; //for Parallax
	
	//[self _addPlanet:ccp(stage.worldSize.width/2,0) gravity:-7 gravityRadius:350];
	[self _addPlanet:ccp(stage.worldSize.width/2,stage.worldSize.height) gravity:-7 gravityRadius:500.0f];
	
	/// set object batch node
	CMMSObjectBatchNode *batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"Icon.png" isInDocument:NO];
	[stage.world addObatchNode:batchNode_];
	
	batchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:@"IMG_STG_ball.png" isInDocument:NO];
	batchNode_.objectClass = [CMMSBall class];
	[stage.world addObatchNode:batchNode_];
	
	labelGravity = [CMMFontUtil labelWithstring:@" "];
	[self addChild:labelGravity];
	
	CMMControlItemSlider *gravitySlider_ = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	gravitySlider_.callback_whenChangedItemVale = ^(id sender_, float itemValue_, float beforeItemValue_){
		CGPoint gravity_ = stage.spec.gravity;
		gravity_.y = itemValue_;
		[stage.spec setGravity:gravity_];
	};
	gravitySlider_.minValue = -10.0f;
	gravitySlider_.maxValue = 10.0f;
	gravitySlider_.unitValue = 0.5f;
	gravitySlider_.itemValue = 0.0f;
	CGPoint targetPoint_ = cmmFuncCommon_position_center(self, gravitySlider_);
	targetPoint_.x += 40.0f;
	targetPoint_.y = 5.0f;
	gravitySlider_.position = targetPoint_;
	[self addChild:gravitySlider_];
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	menuItemBack_.delegate = self;
	[self addChild:menuItemBack_];
	
	controlBtn = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(50, 50)];
	[controlBtn setTitle:@" "];
	controlBtn.position = ccp(contentSize_.width-controlBtn.contentSize.width/2.0f,contentSize_.height/2);
	controlBtn.callback_pushup = ^(id sender_){
		int tempType_ = stageControlType+1;
		
		if(tempType_>=StageControlType_maxCount)
			tempType_ = StageControlType_addBox;
		
		[self setStageControlType:(StageControlType)tempType_];
	};
	[self addChild:controlBtn];
	
	[self setStageControlType:StageControlType_addBox];
	
	[self scheduleUpdate];
	//[self schedule:@selector(updateGravityUp:)];
	
	return self;
}

-(void)setStageControlType:(StageControlType)controlType_{
	switch(controlType_){
		case StageControlType_addBox:{
			[controlBtn setTitle:@"BOX"];
			break;
		}
		case StageControlType_addBall:{
			[controlBtn setTitle:@"BALL"];
			break;
		}
		case StageControlType_paintMap:{
			[controlBtn setTitle:@"PAINT"];
			break;
		}
		case StageControlType_eraseMap:{
			[controlBtn setTitle:@"ERASE"];
			break;
		}
		case StageControlType_dragMap:{
			[controlBtn setTitle:@"DRAG"];
			break;
		}
		default: break;
	}
	
	stageControlType = controlType_;
}

-(void)update:(ccTime)dt_{
	if(_isOnTouch){
		float pointDistance_ = ccpDistance(_curTouchPoint, _beforeTouchPoint);
		int targetCount_ = MAX((int)(pointDistance_/2.0f),2);
		float targetRadians_ = ccpToAngle(_beforeTouchPoint,_curTouchPoint);
		_beforeTouchPoint = _curTouchPoint;
		switch(stageControlType){
			case StageControlType_paintMap:{
				for(uint index_=0;index_<targetCount_;++index_){
					CGPoint targetPoint_ = ccpOffset(_curTouchPoint, targetRadians_, pointDistance_*((float)index_/(float)targetCount_));
					[stage.pixel paintMapAtPoint:[stage convertToStageWorldSpace:targetPoint_] color:ccc4(0, 0, 0, 255) radius:20.0f];
				}
				break;
			}
			case StageControlType_eraseMap:{
				for(uint index_=0;index_<targetCount_;++index_){
					CGPoint targetPoint_ = ccpOffset(_curTouchPoint, targetRadians_, pointDistance_*((float)index_/(float)targetCount_));
					[stage.pixel createCraterAtPoint:[stage convertToStageWorldSpace:targetPoint_] radius:20.0f];
				}
				break;
			}
			case StageControlType_dragMap:{
				if(_isOnTouchObject){
					b2Vec2 beforeVector_ = _dragObject.body->GetTransform().p;
					[_dragObject updateBodyWithPosition:[stage convertToStageWorldSpace:_curTouchPoint]];
					b2Vec2 curVector_ = _dragObject.body->GetTransform().p;
					b2Vec2 velocity_ = curVector_-beforeVector_;
					velocity_*=10.0f;
					_dragObject.body->SetLinearVelocity(velocity_);
					CGPoint diffPoint_ = ccpSub(ccp(self.contentSize.width/2,self.contentSize.height/2),_curTouchPoint);
					stage.worldPoint = ccpSub(stage.worldPoint, ccpMult(diffPoint_, dt_*2.0f));
				}
				break;
			}
			default: break;
		}
	}
	
	[stage update:dt_];
	
	CGPoint gravity_ = stage.spec.gravity;
	[labelGravity setString:[NSString stringWithFormat:@"gravity : %1.1f",gravity_.y]];
	labelGravity.position = ccp(self.contentSize.width-labelGravity.contentSize.width/2-5,labelGravity.contentSize.height/2+5);
}

-(void)stage:(CMMStage *)stage_ whenTouchBegan:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	_curTouchPoint = _beforeTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
	_isOnTouch = YES;
	_isOnTouchObject = NO;
	
	if(stageControlType == StageControlType_dragMap && object_){
		_dragObject = object_;
		_isOnTouchObject = YES;
	}
}
-(void)stage:(CMMStage *)stage_ whenTouchMoved:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	_curTouchPoint = [CMMTouchUtil pointFromTouch:touch_];

	switch(stageControlType){
		
		case StageControlType_dragMap:{
			if(!_isOnTouchObject){
				CGPoint diffPoint_ = ccpSub(_curTouchPoint,[CMMTouchUtil prepointFromTouch:touch_]);
				stage.worldPoint = ccpSub(stage.worldPoint, diffPoint_);
			}
			break;
		}
		default: break;
	}
}
-(void)stage:(CMMStage *)stage_ whenTouchEnded:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	CGPoint touchPoint_ = [stage_ convertToStageWorldSpace:_curTouchPoint];
	
	switch(stageControlType){
		case StageControlType_addBall:{
			[self _addBall:touchPoint_];
			break;
		}
		case StageControlType_addBox:{
			[self _addBox:touchPoint_];
			break;
		}
		default: break;
	}
	
	_isOnTouch = NO;
	_isOnTouchObject = NO;
	_dragObject = nil;
}
-(void)stage:(CMMStage *)stage_ whenTouchCancelled:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	
	_isOnTouch = NO;
	_isOnTouchObject = NO;
	_dragObject = nil;
}

//stage delegate method
-(void)stage:(CMMStage *)stage_ whenAddedObjects:(CCArray *)objects_{
	CCLOG(@"added objects. count : %d",objects_.count);
}
-(void)stage:(CMMStage *)stage_ whenRemovedObjects:(CCArray *)objects_{
	CCLOG(@"removed objects. count : %d",objects_.count);
	
	ccArray *data_ = objects_->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;index_++){
		CMMSObject *object_ = data_->arr[index_];
		if(_dragObject == object_){
			_dragObject = nil;
			_isOnTouchObject = NO;
		}
	}
}

-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_{
	[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
}

@end

@implementation StageTestLayer(Private)

-(void)updateGravityUp:(ccTime)dt_{
	CGPoint gravity_ = stage.spec.gravity;
	gravity_.y += 5.0f*dt_;
	stage.spec.gravity = gravity_;
	
	if(gravity_.y>10){
		[self unschedule:@selector(updateGravityUp:)];
		[self schedule:@selector(updateGravityDown:)];
	}
}
-(void)updateGravityDown:(ccTime)dt_{
	CGPoint gravity_ = stage.spec.gravity;
	gravity_.y -= 5.0f*dt_;
	stage.spec.gravity = gravity_;
	
	if(gravity_.y<-10){
		[self unschedule:@selector(updateGravityDown:)];
		[self schedule:@selector(updateGravityUp:)];
	}
}
-(CMMSObject *)_addBox:(CGPoint)point_{
	CMMSObjectBatchNode *batchNode_ = [stage.world obatchNodeAtFileName:@"Icon.png" isInDocument:NO];
	CMMSObject *object_ = [batchNode_ createObject];
	object_.position = point_;
	[stage.world addObject:object_];
	return object_;
}
-(CMMSBall *)_addBall:(CGPoint)point_{
	CMMSObjectBatchNode *batchNode_ = [stage.world obatchNodeAtFileName:@"IMG_STG_ball.png" isInDocument:NO];
	CMMSBall *ball_ = (CMMSBall *)[batchNode_ createObject];
	ball_.position = point_;
	[stage.world addObject:ball_];
	return ball_;
}
-(CMMSPlanet *)_addPlanet:(CGPoint)point_ gravity:(float)gravity_ gravityRadius:(float)gravityRadius_{
	CMMSPlanet *planet_ = [CMMSPlanet planetWithGravity:gravity_ gravityRadius:gravityRadius_];
	planet_.position = point_;
	[stage.world addObject:planet_];
	return planet_;
}


@end
