//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMStage.h"

static CGPoint getContactPoint(b2Contact* contact){
	b2WorldManifold worldManifold;
	contact->GetWorldManifold(&worldManifold);
	return ccpFromb2Vec2(worldManifold.points[0]);
}

static BOOL isObjectBody(CMMb2FixtureType fixtureType_){
	switch(fixtureType_){
		case CMMb2FixtureType_object:
		case CMMb2FixtureType_ball:
		case CMMb2FixtureType_nail:
		case CMMb2FixtureType_planet:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

void CMMStageContactListener::proccessCollision(b2Contact* contact_, b2Fixture *targetFixture_, b2Fixture *otherFixture_){
	CMMb2ContactMask *targetB2CMask = (CMMb2ContactMask *)targetFixture_->GetUserData();
	CMMb2ContactMask *otherB2CMask = (CMMb2ContactMask *)otherFixture_->GetUserData();
	
	if(isObjectBody(targetB2CMask->fixtureType)){
		CGPoint contactPoint_ = getContactPoint(contact_);
		CMMSObject *targetObject_ = (CMMSObject *)targetFixture_->GetBody()->GetUserData();
		
		if(isObjectBody(otherB2CMask->fixtureType)){
			CMMSObject *otherObject_ = (CMMSObject *)otherFixture_->GetBody()->GetUserData();
			[targetObject_ whenCollisionWithObject:targetB2CMask->fixtureType otherObject:otherObject_ otherFixtureType:otherB2CMask->fixtureType contactPoint:contactPoint_];
		}else{
			[targetObject_ whenCollisionWithStage:targetB2CMask->fixtureType stageFixtureType:otherB2CMask->fixtureType contactPoint:contactPoint_];
		}
	}
}

void CMMStageContactListener::BeginContact(b2Contact* contact){
	proccessCollision(contact, contact->GetFixtureA(), contact->GetFixtureB());
	proccessCollision(contact, contact->GetFixtureB(), contact->GetFixtureA());
}


bool CMMStageContactFilter::ShouldCollide(b2Fixture *fixtureA, b2Fixture *fixtureB){
	//다른 충돌 조건을 넣고 싶다면 여기에 작성해주세요
	
	//아래는 제가 제작한 충돌필터입니다.
	CMMb2ContactMask *b2CMaskA_ = (CMMb2ContactMask *)fixtureA->GetUserData();
	CMMb2ContactMask *b2CMaskB_ = (CMMb2ContactMask *)fixtureB->GetUserData();
	return b2CMaskA_->IsContact(b2CMaskB_);
	
	//아래는 Box2d에서 제공하는 기본 충돌필터입니다.
	//return b2ContactFilter::ShouldCollide(fixtureA, fixtureB);
}

@implementation CMMStageWorld
@synthesize stage,world,worldBody,object_list;

+(id)worldWithStage:(CMMStage *)stage_ worldSize:(CGSize)worldSize_{
	return [[[self alloc] initWithStage:stage_ worldSize:worldSize_] autorelease];
}
-(id)initWithStage:(CMMStage *)stage_ worldSize:(CGSize)worldSize_{
	if(!(self = [super init])) return self;
	self.anchorPoint = CGPointZero;
	self.contentSize = worldSize_;
	stage = stage_;
	
	object_list = [[CCArray alloc] init];
	object_destroyList = [[CCArray alloc] init];
	object_createList = [[CCArray alloc] init];
	
	_contactLintener = new CMMStageContactListener;
	_contactFilter = new CMMStageContactFilter;
	_contactLintener->stage = stage;
	_contactFilter->stage = stage;
	
	world = new b2World(b2Vec2_zero);
	world->SetContinuousPhysics(true);
	world->SetContactListener(_contactLintener);
	world->SetContactFilter(_contactFilter);
	
#if COCOS2D_DEBUG >= 1
	/*** Debug Draw functions ***/
	_debugDraw = new GLESDebugDraw(PTM_RATIO);
	world->SetDebugDraw(_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	flags += b2Draw::e_jointBit;
	flags += b2Draw::e_centerOfMassBit;
	_debugDraw->SetFlags(flags);
#endif
	
	b2Mask1 = CMMb2ContactMask(CMMb2FixtureType_stageBottom,-1,-1,1);
	b2Mask2 = CMMb2ContactMask(CMMb2FixtureType_stageTop,-1,-1,1);
	b2Mask3 = CMMb2ContactMask(CMMb2FixtureType_stageLeft,-1,-1,1);
	b2Mask4 = CMMb2ContactMask(CMMb2FixtureType_stageRight,-1,-1,1);
	
	worldBody = [self createBody:b2_staticBody point:CGPointZero angle:0];
	worldBody->SetUserData(self);
	
	b2EdgeShape groundBox;
	groundBox.Set(b2Vec2Fromccp(0,0), b2Vec2Fromccp(self.contentSize.width,0));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2Mask1);
	
	groundBox.Set(b2Vec2Fromccp(0,self.contentSize.height), b2Vec2Fromccp(self.contentSize.width,self.contentSize.height));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2Mask2);
	
	groundBox.Set(b2Vec2Fromccp(0,self.contentSize.height), b2Vec2Fromccp(0,0));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2Mask3);
	
	groundBox.Set(b2Vec2Fromccp(self.contentSize.width,self.contentSize.height), b2Vec2Fromccp(self.contentSize.width,0));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2Mask4);
	
	_touchedObjects = nil;
	
	_OBJECTTAG_ = 0;
	
	return self;
}

#if COCOS2D_DEBUG >= 1
-(void)draw{
	ccDrawColor4F(1.0, 1.0, 1.0, 1.0);
	glLineWidth(1.0f);
	world->DrawDebugData();
}
#endif

-(void)update:(ccTime)dt_{
	//destory object
	ccArray *data_ = object_destroyList->data;
	int count_ = data_->num;
	for(int index_=0;index_<count_;index_++){
		CMMSObject *object_ = data_->arr[index_];
		[object_list removeObject:object_];
		[object_ whenRemovedToStage];
		
		//remove touch
		[touchDispatcher cancelTouchAtNode:object_];
	}
	
	if(count_>0 && cmmFuncCommon_respondsToSelector(stage.delegate,@selector(stage:whenRemovedObjects:)))
		[stage.delegate stage:stage whenRemovedObjects:object_destroyList];
	[object_destroyList removeAllObjects];
	
	//add object
	data_ = object_createList->data;
	count_ = data_->num;
	for(int index_=0;index_<count_;index_++){
		CMMSObject *object_ = data_->arr[index_];
		[object_list addObject:object_];
		[object_ whenAddedToStage];
	}
	
	if(count_>0 && cmmFuncCommon_respondsToSelector(stage.delegate,@selector(stage:whenAddedObjects:)))
		[stage.delegate stage:stage whenAddedObjects:object_createList];
	[object_createList removeAllObjects];
	
	world->Step(dt_, 8, 3);
	
	CMMSSpecStage *specStage_ = stage.spec;
	b2Vec2 gravity_ = b2Vec2Fromccp(specStage_.gravity, 1.0f);
	
	//object update
	data_ = object_list->data;
	count_ = data_->num;
	for(int index_=0;index_<count_;index_++){
		CMMSObject *object_ = data_->arr[index_];
		b2Body *objectBody_ = object_.body;
		
		objectBody_->ApplyForceToCenter(objectBody_->GetMass()*gravity_);
		[object_ update:dt_];
	}
	
	//update contacting
	for(b2Contact *contact_ = world->GetContactList();contact_;contact_=contact_->GetNext()){
		if(!contact_->IsTouching()) continue;
		b2Fixture *fixtureA_ = contact_->GetFixtureA();
		b2Fixture *fixtureB_ = contact_->GetFixtureB();
		
		CGPoint contactPoint_ = getContactPoint(contact_);
		[self _doContacting:fixtureA_ otherFixture:fixtureB_ contactPoint:contactPoint_ dt:dt_];
		[self _doContacting:fixtureB_ otherFixture:fixtureA_ contactPoint:contactPoint_ dt:dt_];
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	
	id<CMMStageTouchDelegate> delegate_ = (id<CMMStageTouchDelegate>)stage.delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_,@selector(stage:whenTouchBegan:withObject:))){
		[delegate_ stage:stage whenTouchBegan:touch_ withObject:[self objectAtTouch:touch_]];
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	id<CMMStageTouchDelegate> delegate_ = (id<CMMStageTouchDelegate>)stage.delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_,@selector(stage:whenTouchMoved:withObject:))){
		[delegate_ stage:stage whenTouchMoved:touch_ withObject:[self objectAtTouch:touch_]];
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	id<CMMStageTouchDelegate> delegate_ = (id<CMMStageTouchDelegate>)stage.delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_,@selector(stage:whenTouchEnded:withObject:))){
		[delegate_ stage:stage whenTouchEnded:touch_ withObject:[self objectAtTouch:touch_]];
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	id<CMMStageTouchDelegate> delegate_ = (id<CMMStageTouchDelegate>)stage.delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_,@selector(stage:whenTouchCancelled:withObject:))){
		[delegate_ stage:stage whenTouchCancelled:touch_ withObject:[self objectAtTouch:touch_]];
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
}

-(void)dealloc{
	[_touchedObjects release];
	[object_createList release];
	[object_destroyList release];
	[object_list release];
	
	delete world;
	delete _contactLintener;
	delete _contactFilter;
	delete _debugDraw;
	[super dealloc];
}

@end

@implementation CMMStageWorld(Common)

-(int)_nextObjectTag{
	return _OBJECTTAG_++;
}

-(void)_doContacting:(b2Fixture *)targetFixture_ otherFixture:(b2Fixture *)otherFixture_ contactPoint:(CGPoint)contactPoint_ dt:(ccTime)dt_{
	CMMb2ContactMask *targetB2CMask = (CMMb2ContactMask *)targetFixture_->GetUserData();
	CMMb2ContactMask *otherB2CMask = (CMMb2ContactMask *)otherFixture_->GetUserData();
	
	if(isObjectBody(targetB2CMask->fixtureType)){
		CMMSObject *targetObject_ = (CMMSObject *)targetFixture_->GetBody()->GetUserData();
		if(isObjectBody(otherB2CMask->fixtureType)){
			CMMSObject *otherObject_ = (CMMSObject *)otherFixture_->GetBody()->GetUserData();
			[targetObject_ doContactingWithObject:targetB2CMask->fixtureType otherObject:otherObject_ otherFixtureType:otherB2CMask->fixtureType contactPoint:contactPoint_ dt:dt_];
		}else{
			[targetObject_ doContactingWithStage:targetB2CMask->fixtureType stageFixtureType:otherB2CMask->fixtureType contactPoint:contactPoint_ dt:dt_];
		}
	}
}

-(void)addObject:(CMMSObject *)object_{
	object_.stage = stage;
	object_.objectTag = [self _nextObjectTag];
	[object_createList addObject:object_];
}

-(void)removeObject:(CMMSObject *)object_{
	if([object_destroyList indexOfObject:object_] != NSNotFound) return;
	[object_destroyList addObject:object_];
}
-(void)removeObjectAtObjectTag:(int)objectTag_{
	[self removeObject:[self objectAtObjectTag:objectTag_]];
}

-(CMMSObject *)objectAtObjectTag:(int)objectTag_{
	ccArray *data_ = object_list->data;
	int count_ = data_->num;
	for(int index_=0;index_<count_;index_++){
		CMMSObject *object_ = data_->arr[index_];
		if(object_.objectTag == objectTag_)
			return object_;
	}
	
	return nil;
}

-(CMMSObject *)objectAtTouch:(UITouch *)touch_{
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtTouch:touch_];
	if(!touchItem_ || ![touchItem_.node isKindOfClass:[CMMSObject class]]) return nil;
	else return (CMMSObject *)touchItem_.node;
}

-(CCArray *)objectsInTouched{
	if(!_touchedObjects)
		_touchedObjects = [[CCArray alloc] init];
	
	[_touchedObjects removeAllObjects];
	ccArray *data_ = touchDispatcher.touchList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;index_++){
		CMMTouchDispatcherItem *touchItem_ = data_->arr[index_];
		if([touchItem_.node isKindOfClass:[CMMSObject class]])
			[_touchedObjects addObject:touchItem_.node];
	}
	
	return _touchedObjects;
}

@end

@implementation CMMStageWorld(Box2d)

-(b2Body *)createBody:(b2BodyType)bodyType_ point:(CGPoint)point_ angle:(float)angle_{
	b2BodyDef bodyDef;
	bodyDef.type = bodyType_;
	bodyDef.position = b2Vec2Fromccp(point_);
	bodyDef.angle = -CC_DEGREES_TO_RADIANS(angle_);
	return world->CreateBody(&bodyDef);
}

@end

@interface CMMStageParticle(Cache)

-(CMMSParticle *)cachedParticleOfParticleType:(ParticleType)particleType_ particleName:(NSString *)particleName_;
-(void)cacheParticle:(CMMSParticle *)particle_;

@end

@implementation CMMStageParticle(Cache)

-(CMMSParticle *)cachedParticleOfParticleType:(ParticleType)particleType_ particleName:(NSString *)particleName_{
	ccArray *data_ = _cachedParticles->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;index_++){
		CMMSParticle *particle_ = data_->arr[index_];
		if(particle_.particleType == particleType_
		   && [particle_.particleName isEqualToString:particleName_]){
			particle_ = [[particle_ retain] autorelease];
			[_cachedParticles removeObject:particle_];
			return particle_;
		}
	}
	return nil;
}
-(void)cacheParticle:(CMMSParticle *)particle_{
	[particle_ resetSystem];
	[_cachedParticles addObject:particle_];
}

@end

@implementation CMMStageParticle
@synthesize stage,particleList,particleCount;

+(id)particleWithStage:(CMMStage *)stage_{
	return [[[self alloc] initWithStage:stage_] autorelease];
}
-(id)initWithStage:(CMMStage *)stage_{
	if(!(self = [super init])) return self;
	
	stage = stage_;
	self.contentSize = stage.worldSize;
	
	particleList = [[CCArray alloc] init];
	_cachedParticles = [[CCArray alloc] init];
	
	return self;
}

-(void)addParticle:(CMMSParticle *)particle_{
	if([self indexOfParticle:particle_] != NSNotFound)
		 return;
	
	[particleList addObject:particle_];
	[self addChild:particle_];
}

-(void)removeChild:(CMMSParticle *)particle_ cleanup:(BOOL)cleanup{
	[super removeChild:particle_ cleanup:cleanup];
	[self cacheParticle:particle_];
	[particleList removeObject:particle_];
}
-(void)removeParticle:(CMMSParticle *)particle_{
	if([self indexOfParticle:particle_] != NSNotFound) return;
	[self removeChild:particle_ cleanup:YES];
}
-(void)removeParticleAtIndex:(int)index_{
	return [self removeParticle:[self particleAtIndex:index_]];
}

-(CMMSParticle *)particleAtIndex:(int)index_{
	if(index_ == NSNotFound) return nil;
	return [particleList objectAtIndex:index_];
}

-(int)indexOfParticle:(CMMSParticle *)particle_{
	return [particleList indexOfObject:particle_];
}

-(void)update:(ccTime)dt_{
	ccArray *data_ = particleList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;index_++){
		CMMSParticle *particle_ = data_->arr[index_];
		[particle_ update:dt_];
	}
}

-(void)dealloc{
	[particleList release];
	[_cachedParticles release];
	[super dealloc];
}

@end

@implementation CMMStageParticle(ParticleDefault)

-(CMMSParticle *)addParticleWithName:(NSString *)particleName_ point:(CGPoint)point_{
	CMMSParticle *particle_ = [self cachedParticleOfParticleType:ParticleType_default particleName:particleName_];
	if(!particle_){
		particle_ = [CMMSParticle particleWithParticleName:particleName_];
	}
	
	particle_.position = point_;
	[self addParticle:particle_];
	return particle_;
}

@end

@implementation CMMStageParticle(ParticleFollow)

-(CMMSParticleFollow *)addParticleFollowWithName:(NSString *)particleName_ target:(CMMSObject *)target_{
	CMMSParticleFollow *particle_ = (CMMSParticleFollow *)[self cachedParticleOfParticleType:ParticleType_follow particleName:particleName_];
	if(!particle_)
		particle_ = [CMMSParticleFollow particleWithParticleName:particleName_];
	
	particle_.target = target_;
	[self addParticle:particle_];
	return particle_;
}
-(void)removeParticleFollowOfTarget:(CMMSObject *)target_{
	ccArray *data_ = particleList->data;
	for(int index_=data_->num-1;index_>=0;index_--){
		CMMSParticle *particle_ = data_->arr[index_];
		if(particle_.particleType == ParticleType_follow
		   && ((CMMSParticleFollow *)particle_).target == target_)
			[self removeParticle:particle_];
	}
}

@end

@implementation CMMStageBackGround
@synthesize stage,backGroundNode,distanceRate;

+(id)backGroundWithStage:(CMMStage *)stage_ distanceRate:(float)distanceRate_{
	return [[[self alloc] initWithStage:stage_ distanceRate:distanceRate_] autorelease];
}
-(id)initWithStage:(CMMStage *)stage_ distanceRate:(float)distanceRate_{
	if(!(self = [super init])) return self;
	
	stage = stage_;
	distanceRate = distanceRate_;
	backGroundNode = nil;
	
	return self;
}

-(void)setBackGroundNode:(CCNode *)backGroundNode_{
	if(backGroundNode == backGroundNode_) return;
	[backGroundNode removeFromParentAndCleanup:YES];
	backGroundNode = backGroundNode_;
	
	if(backGroundNode){
		[self updatePosition];
		[stage addChild:backGroundNode z:1];
	}
}
-(void)setDistanceRate:(float)distanceRate_{
	distanceRate = distanceRate_;
	[self updatePosition];
}

-(void)updatePosition{
	if(!backGroundNode) return;

	CGPoint worldPoint_ = stage.worldPoint;
	CGPoint targetPoint_ = ccpMult(worldPoint_, distanceRate);
	
	backGroundNode.position = ccpMult(targetPoint_, -1.0f);
}

@end

@implementation CMMStage
@synthesize spec,delegate,world,particle,backGround,sound,worldSize,worldPoint,isAllowTouch;

+(id)stageWithCMMStageSpecDef:(CMMStageSpecDef)stageSpecDef_{
	return [[[self alloc] initWithCMMStageSpecDef:stageSpecDef_] autorelease];
}
-(id)initWithCMMStageSpecDef:(CMMStageSpecDef)stageSpecDef_{
	if(!(self = [super init])) return self;
	
	self.contentSize = stageSpecDef_.stageSize;
	
	spec = [[CMMSSpecStage alloc] init];
	
	world = [CMMStageWorld worldWithStage:self worldSize:stageSpecDef_.worldSize];
	particle = [CMMStageParticle particleWithStage:self];
	[self addChild:world z:2];
	[self addChild:particle z:3];
	
	backGround = [[CMMStageBackGround alloc] initWithStage:self distanceRate:0.0f];
	sound = [[CMMSoundHandler alloc] initSoundHandler:CGPointZero soundDistance:700.0f];
	
	spec.gravity = stageSpecDef_.gravity;
	spec.friction = stageSpecDef_.friction;
	spec.restitution = stageSpecDef_.restitution;
	
	isAllowTouch = NO;
	
	return self;
}

-(CGSize)worldSize{
	return world.contentSize;
}

-(void)setWorldPoint:(CGPoint)worldPoint_{
	CGSize worldSize_ = self.worldSize;
	CGSize stageSize_ = self.contentSize;
	CGPoint resultPoint_ = worldPoint_;
	
	if(worldPoint_.x < 0)
		resultPoint_.x -= worldPoint_.x;
	else if(worldPoint_.x >worldSize_.width-stageSize_.width)
		resultPoint_.x -= worldPoint_.x-(worldSize_.width-stageSize_.width);
	
	if(worldPoint_.y < 0)
		resultPoint_.y -= worldPoint_.y;
	else if(worldPoint_.y >worldSize_.height-stageSize_.height)
		resultPoint_.y -= worldPoint_.y-(worldSize_.height-stageSize_.height);
	
	resultPoint_ = ccpMult(resultPoint_, -1.0f);
	[world setPosition:resultPoint_];
	[particle setPosition:resultPoint_];
	[backGround updatePosition];
	
	//update sound center position
	CGPoint soundPoint_ = [self convertToStageWorldSpace:ccp(stageSize_.width/2,stageSize_.height/2)];
	sound.centerPoint = soundPoint_;
}
-(CGPoint)worldPoint{
	return ccpMult(world.position, -1.0f);
}

-(void)visit{
	glEnable(GL_SCISSOR_TEST);
	CGRect screenRect_;
	screenRect_.origin = ccp(0,0);
	screenRect_.size = self.contentSize;
	screenRect_ = CGRectApplyAffineTransform(screenRect_,[self nodeToWorldTransform]);
	
	glScissor(screenRect_.origin.x*CC_CONTENT_SCALE_FACTOR(), screenRect_.origin.y*CC_CONTENT_SCALE_FACTOR(), screenRect_.size.width*CC_CONTENT_SCALE_FACTOR(), screenRect_.size.height*CC_CONTENT_SCALE_FACTOR());
	
	[super visit];
	
	glDisable(GL_SCISSOR_TEST);
}

-(CGPoint)convertToStageWorldSpace:(CGPoint)worldPoint_{
	return [world convertToNodeSpace:worldPoint_];
}

-(void)update:(ccTime)dt_{
	[world update:dt_];
	[particle update:dt_];
	[sound update:dt_];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	if(!isAllowTouch) return;
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
}

-(void)dealloc{
	[sound release];
	[spec release];
	[backGround release];
	[super dealloc];
}

@end