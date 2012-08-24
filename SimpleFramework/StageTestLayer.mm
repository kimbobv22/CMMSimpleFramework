//  Created by JGroup(kimbobv22@gmail.com)

#import "StageTestLayer.h"
#import "HelloWorldLayer.h"

@interface CCLayerGradientTest : CCLayerGradient

@end

@implementation CCLayerGradientTest

-(void)draw{
	[super draw];
	
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
	
	CMMStageSpecDef stageSpec_;
	stageSpec_.stageSize = CGSizeMake(480, 270);
	stageSpec_.worldSize = CGSizeMake(600, 500);
	stageSpec_.gravity = CGPointZero;
	stageSpec_.friction = 0.3f;
	stageSpec_.restitution = 0.3f;
	
	stage = [CMMStage stageWithCMMStageSpecDef:stageSpec_];
	stage.sound.soundDistance = 300.0f;
	stage.position = ccp(0,self.contentSize.height-stage.contentSize.height);
	stage.delegate = self;
	stage.isAllowTouch = YES;
	[self addChild:stage z:0];
	
	//backGround image for test
	CCLayerGradient *backLayer_ = [CCLayerGradientTest layerWithColor:ccc4(120, 0, 0, 180) fadingTo:ccc4(0, 0, 120, 180) alongVector:ccp(0.3,0.7)];
	backLayer_.contentSize = stage.worldSize;
	stage.backGround.backGroundNode = backLayer_;
	stage.backGround.distanceRate = 0.1f; //for Parallax
	
	//[self _addPlanet:ccp(stage.worldSize.width/2,0) gravity:-7 gravityRadius:350];
	[self _addPlanet:ccp(stage.worldSize.width/2,stage.worldSize.height) gravity:-7 gravityRadius:500.0f];
	
	labelGravity = [CMMFontUtil labelWithstring:@" "];
	[self addChild:labelGravity];
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	menuItemBack_.delegate = self;
	[self addChild:menuItemBack_];
	
	[self scheduleUpdate];
	[self schedule:@selector(updateGravityUp:)];
	
	return self;
}

-(void)update:(ccTime)dt_{
	//drag object
	if(_isOnDragObject){
		b2Vec2 beforeVector_ = _dragObject.body->GetTransform().p;
		[_dragObject updateBodyWithPosition:[stage convertToStageWorldSpace:_curTouchPoint]];
		b2Vec2 curVector_ = _dragObject.body->GetTransform().p;
		b2Vec2 velocity_ = curVector_-beforeVector_;
		velocity_*=10.0f;
		_dragObject.body->SetLinearVelocity(velocity_);
		CGPoint diffPoint_ = ccpSub(ccp(self.contentSize.width/2,self.contentSize.height/2),_curTouchPoint);
		stage.worldPoint = ccpSub(stage.worldPoint, ccpMult(diffPoint_, dt_*2.0f));
	}
	
	[stage update:dt_];
	
	CGPoint gravity_ = stage.spec.gravity;
	[labelGravity setString:[NSString stringWithFormat:@"gravity : %1.1f/%1.1f",gravity_.x,gravity_.y]];
	labelGravity.position = ccp(self.contentSize.width-labelGravity.contentSize.width/2-5,labelGravity.contentSize.height/2+5);
}

-(void)stage:(CMMStage *)stage_ whenTouchBegan:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	if(object_){
		_dragObject = object_;
		_isOnDragObject = YES;
		_curTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
	}
}
-(void)stage:(CMMStage *)stage_ whenTouchMoved:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	if(!_isOnDragObject && !_isOnDrag && !object_)
		_isOnDrag = YES;
	
	if(_isOnDrag){
		CGPoint curPoint_ = [CMMTouchUtil pointFromTouch:touch_];
		CGPoint diffPoint_ = ccpSub(curPoint_,[CMMTouchUtil prepointFromTouch:touch_]);
		stage.worldPoint = ccpSub(stage.worldPoint, diffPoint_);
	}else if(_isOnDragObject){
		_curTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
	}
}
-(void)stage:(CMMStage *)stage_ whenTouchEnded:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	if(!_isOnDrag && !_isOnDragObject){
		CGPoint addPoint_ = [stage convertToStageWorldSpace:[CMMTouchUtil pointFromTouch:touch_]];
		if(arc4random()%2 == 0)
			[self _addBall:addPoint_];
		else [self _addBox:addPoint_];
	}
	
	_isOnDrag = NO;
	_isOnDragObject = NO;
	_dragObject = nil;
}
-(void)stage:(CMMStage *)stage_ whenTouchCancelled:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	
	_isOnDrag = NO;
	_isOnDragObject = NO;
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
			_isOnDragObject = NO;
		}
	}
}

-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_{
	[[CMMScene sharedScene] pushLayer:[HelloWorldLayer node]];
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
	CMMSObject *object_ = [CMMSObject spriteWithFile:@"Icon.png"];
	object_.position = point_;
	[stage.world addObject:object_];
	return object_;
}
-(CMMSBall *)_addBall:(CGPoint)point_{
	CMMSBall *ball_ = [CMMSBall ball];
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
