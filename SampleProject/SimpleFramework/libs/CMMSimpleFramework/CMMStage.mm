//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMStage.h"

void CMMStageWorldContactListener::BeginContact(b2Contact* contact){
	b2Fixture *fixtureA_ = contact->GetFixtureA();
	b2Fixture *fixtureB_ = contact->GetFixtureB();
	
	CMMb2ContactMask *b2CMaskA_ = (CMMb2ContactMask *)fixtureA_->GetUserData();
	CMMb2ContactMask *b2CMaskB_ = (CMMb2ContactMask *)fixtureB_->GetUserData();;
	
	id<CMMSContactProtocol> objectA_ = (id<CMMSContactProtocol>)fixtureA_->GetBody()->GetUserData();
	id<CMMSContactProtocol> objectB_ = (id<CMMSContactProtocol>)fixtureB_->GetBody()->GetUserData();
	
	CGPoint contactPoint_ = cmmFuncCMMStage_GetContactPoint(contact);
	
	[objectA_ whenContactBeganWithFixtureType:b2CMaskA_->fixtureType otherObject:objectB_ otherFixtureType:b2CMaskB_->fixtureType contactPoint:contactPoint_];
	[objectB_ whenContactBeganWithFixtureType:b2CMaskB_->fixtureType otherObject:objectA_ otherFixtureType:b2CMaskA_->fixtureType contactPoint:contactPoint_];
}
void CMMStageWorldContactListener::EndContact(b2Contact *contact){
	b2Fixture *fixtureA_ = contact->GetFixtureA();
	b2Fixture *fixtureB_ = contact->GetFixtureB();
	
	CMMb2ContactMask *b2CMaskA_ = (CMMb2ContactMask *)fixtureA_->GetUserData();
	CMMb2ContactMask *b2CMaskB_ = (CMMb2ContactMask *)fixtureB_->GetUserData();;
	
	id<CMMSContactProtocol> objectA_ = (id<CMMSContactProtocol>)fixtureA_->GetBody()->GetUserData();
	id<CMMSContactProtocol> objectB_ = (id<CMMSContactProtocol>)fixtureB_->GetBody()->GetUserData();

	CGPoint contactPoint_ = cmmFuncCMMStage_GetContactPoint(contact);
	
	[objectA_ whenContactEndedWithFixtureType:b2CMaskA_->fixtureType otherObject:objectB_ otherFixtureType:b2CMaskB_->fixtureType contactPoint:contactPoint_];
	[objectB_ whenContactEndedWithFixtureType:b2CMaskB_->fixtureType otherObject:objectA_ otherFixtureType:b2CMaskA_->fixtureType contactPoint:contactPoint_];
}

bool CMMStageWorldContactFilter::ShouldCollide(b2Fixture *fixtureA, b2Fixture *fixtureB){
	CMMb2ContactMask *b2CMaskA_ = (CMMb2ContactMask *)fixtureA->GetUserData();
	CMMb2ContactMask *b2CMaskB_ = (CMMb2ContactMask *)fixtureB->GetUserData();
	return cmmFuncCMMb2ContactMask_IsContact(b2CMaskA_,b2CMaskB_);
}

@implementation CMMStageWorld
@synthesize stage,world,worldBody,obatchNode_list,object_list,b2CMask_bottom,b2CMask_top,b2CMask_left,b2CMask_right,velocityIterations,positionIterations,countOfObatchNode,countOfObject;

+(id)worldWithStage:(CMMStage *)stage_ worldSize:(CGSize)worldSize_{
	return [[[self alloc] initWithStage:stage_ worldSize:worldSize_] autorelease];
}
-(id)initWithStage:(CMMStage *)stage_ worldSize:(CGSize)worldSize_{
	if(!(self = [super init])) return self;
	self.anchorPoint = CGPointZero;
	self.contentSize = worldSize_;
	stage = stage_;
	
	obatchNode_list = [[CCArray alloc] init];
	obatchNode_destroyList = [[CCArray alloc] init];
	
	object_list = [[CMMTimeIntervalArray alloc] init];
	
	//add filter & callback
	[object_list setFilter_whenRemovedObject:^(id object_){
		[object_ whenRemovedToStage];
		
		//remove touch
		[touchDispatcher cancelTouchAtNode:object_];
		
		//remove state view
		[[stage stateView] removeStateViewAtTarget:object_];
		
		CMMStageLight *light_ = [stage light];
		//remve light
		if(light_){
			[light_ removeLightItemsAtTarget:object_];
		}
		
		//stage delegate
		[stage stageWorld:self whenRemovedObject:object_];
	}];
	[object_list setCallback_whenRemovedObject:^(CCArray *objects_){
		if([objects_ count]>0 && cmmFuncCommon_respondsToSelector(stage.delegate,@selector(stage:whenRemovedObjects:)))
			[[stage delegate] stage:stage whenRemovedObjects:objects_];
	}];
	
	[object_list setFilter_whenAddedObject:^(id object_){
		[object_ whenAddedToStage];
		[stage stageWorld:self whenAddedObject:object_];
	}];
	[object_list setCallback_whenAddedObject:^(CCArray * objects_){
		if([objects_ count]>0 && cmmFuncCommon_respondsToSelector(stage.delegate,@selector(stage:whenAddedObjects:)))
			[[stage delegate] stage:stage whenAddedObjects:objects_];
	}];
	
	_contactLintener = new CMMStageWorldContactListener;
	_contactFilter = new CMMStageWorldContactFilter;
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
	
	b2CMask_bottom = CMMb2ContactMaskMake(0x3001,-1,-1,1); // bottom
	b2CMask_top = CMMb2ContactMaskMake(0x3003,-1,-1,1); // top
	b2CMask_left = CMMb2ContactMaskMake(0x3005,-1,-1,1); // left
	b2CMask_right = CMMb2ContactMaskMake(0x3007,-1,-1,1); // right
	
	worldBody = [self createBody:b2_staticBody point:CGPointZero angle:0];
	worldBody->SetUserData(stage);
	
	b2EdgeShape groundBox;
	groundBox.Set(b2Vec2(0,0), b2Vec2_PTM_RATIO(contentSize_.width,0));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2CMask_bottom);
	
	groundBox.Set(b2Vec2_PTM_RATIO(0,contentSize_.height), b2Vec2_PTM_RATIO(contentSize_.width,contentSize_.height));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2CMask_top);
	
	groundBox.Set(b2Vec2_PTM_RATIO(0,contentSize_.height), b2Vec2_PTM_RATIO(0,0));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2CMask_left);
	
	groundBox.Set(b2Vec2_PTM_RATIO(contentSize_.width,contentSize_.height), b2Vec2_PTM_RATIO(contentSize_.width,0));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2CMask_right);
		
	velocityIterations = 8;
	positionIterations = 3;
	
	_touchedObjects = nil;
	
	_OBATCHNODETAG_ = _OBJECTTAG_ = 0;
	
	return self;
}

#if COCOS2D_DEBUG >= 1
-(void)draw{
	[super draw];
	
	ccDrawColor4F(1.0, 1.0, 1.0, 1.0);
	glLineWidth(1.0f);
	world->DrawDebugData();
}
#endif

-(int)countOfObatchNode{
	return [obatchNode_list count];
}
-(int)countOfObject{
	return [object_list count];
}

-(void)update:(ccTime)dt_{
	//destroy object batch node
	ccArray *data_ = obatchNode_destroyList->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMSObjectBatchNode *obatchNode_ = data_->arr[index_];
		if([obatchNode_ count]>0){
			[self removeObjectAtObatchNode:obatchNode_];
			continue;
		}
		[obatchNode_list removeObject:obatchNode_];
		[obatchNode_destroyList removeObjectAtIndex:index_];
		[obatchNode_ removeFromParentAndCleanup:YES];
	}
	
	[object_list step];
	
	world->Step(dt_, velocityIterations, positionIterations);
	
	CMMSSpecStage *specStage_ = stage.spec;
	b2Vec2 gravity_ = b2Vec2Fromccp([specStage_ gravity]);
	
	//object update
	data_ = object_list->data;
	uint count_ = data_->num;
	for(int index_=0;index_<count_;++index_){
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
		
		CMMb2ContactMask *b2CMaskA_ = (CMMb2ContactMask *)fixtureA_->GetUserData();
		CMMb2ContactMask *b2CMaskB_ = (CMMb2ContactMask *)fixtureB_->GetUserData();
		
		id<CMMSContactProtocol> objectA_ = (id<CMMSContactProtocol>)fixtureA_->GetBody()->GetUserData();
		id<CMMSContactProtocol> objectB_ = (id<CMMSContactProtocol>)fixtureB_->GetBody()->GetUserData();
		
		CGPoint contactPoint_ = cmmFuncCMMStage_GetContactPoint(contact_);
		
		[objectA_ doContactWithFixtureType:b2CMaskA_->fixtureType otherObject:objectB_ otherFixtureType:b2CMaskB_->fixtureType contactPoint:contactPoint_ interval:dt_];
		[objectB_ doContactWithFixtureType:b2CMaskB_->fixtureType otherObject:objectA_ otherFixtureType:b2CMaskA_->fixtureType contactPoint:contactPoint_ interval:dt_];
	}
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return [super touchDispatcher:touchDispatcher_ shouldAllowTouch:touch_ event:event_] && [CMMTouchUtil nodeCountInTouch:object_list touch:touch_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMSObject *touchedObject_ = nil;
	ccArray *data_ = object_list->data;
	NSUInteger count_ = data_->num;
	for(NSUInteger index_=0;index_<count_;++index_){
		CMMSObject *object_ = data_->arr[index_];
		if([CMMTouchUtil isNodeInTouch:object_ touch:touch_]){
			[touchDispatcher addTouchItemWithTouch:touch_ node:object_];
			[object_ touchDispatcher:touchDispatcher whenTouchBegan:touch_ event:event_];
			touchedObject_ = object_;
			break;
		}
	}
	
	id<CMMStageTouchDelegate> delegate_ = (id<CMMStageTouchDelegate>)stage.delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_,@selector(stage:whenTouchBegan:withObject:))){
		[delegate_ stage:stage whenTouchBegan:touch_ withObject:touchedObject_];
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

-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len{
	return [object_list countByEnumeratingWithState:state objects:buffer count:len];
}

-(void)dealloc{
	[_touchedObjects release];
	[object_list release];
	
	[obatchNode_destroyList release];
	[obatchNode_list release];
	
	delete world;
	delete _contactLintener;
	delete _contactFilter;
	delete _debugDraw;
	[super dealloc];
}

@end

@implementation CMMStageWorld(ObjectBatchNode)

-(int)_nextObatchNodeTag{
	return ++_OBATCHNODETAG_;
}

-(void)addObatchNode:(CMMSObjectBatchNode *)obatchNode_{
	if([self indexOfObatchNodeFileName:obatchNode_.fileName isInDocument:obatchNode_.isInDocument] != NSNotFound) return;
	obatchNode_.obatchNodeTag = [self _nextObatchNodeTag];
	[obatchNode_list addObject:obatchNode_];
	[self addChild:obatchNode_];
}
-(CMMSObjectBatchNode *)addObatchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	CMMSObjectBatchNode *obatchNode_ = [CMMSObjectBatchNode batchNodeWithFileName:fileName_ isInDocument:isInDocument_];
	[self addObatchNode:obatchNode_];
	return obatchNode_;
}

-(void)removeObatchNode:(CMMSObjectBatchNode *)obatchNode_{
	if([self indexOfObatchNode:obatchNode_] == NSNotFound) return;
	[obatchNode_destroyList addObject:obatchNode_];
}
-(void)removeObatchNodeAtIndex:(int)index_{
	[self removeObatchNode:[self obatchNodeAtIndex:index_]];
}
-(void)removeObatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	[self removeObatchNodeAtIndex:[self indexOfObatchNodeFileName:fileName_ isInDocument:isInDocument_]];
}

-(CMMSObjectBatchNode *)obatchNodeAtIndex:(int)index_{
	if(index_ == NSNotFound || index_ >= [self countOfObatchNode]) return nil;
	return [obatchNode_list objectAtIndex:index_];
}
-(CMMSObjectBatchNode *)obatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self obatchNodeAtIndex:[self indexOfObatchNodeFileName:fileName_ isInDocument:isInDocument_]];
}

-(int)indexOfObatchNode:(CMMSObjectBatchNode *)obatchNode_{
	return [obatchNode_list indexOfObject:obatchNode_];
}
-(int)indexOfObatchNodeFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	ccArray *data_ = obatchNode_list->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSObjectBatchNode *obatchNode_ = data_->arr[index_];
		if([obatchNode_.fileName isEqualToString:fileName_]
		   && obatchNode_.isInDocument == isInDocument_)
			return index_;
	}
	
	return NSNotFound;
}

@end

@implementation CMMStageWorld(Common)

-(int)_nextObjectTag{
	return ++_OBJECTTAG_;
}
	
-(void)addObject:(CMMSObject *)object_{
	if([[object_list createList] indexOfObject:object_] != NSNotFound) return;
	[object_ setStage:stage];
	[object_ setObjectTag:[self _nextObjectTag]];
	[object_list addObject:object_];
}

-(void)removeObject:(CMMSObject *)object_{
	if([[object_list destroyList] indexOfObject:object_] != NSNotFound) return;
	[object_list removeObject:object_];
}
-(void)removeObjectAtIndex:(int)index_{
	return [self removeObject:[self objectAtIndex:index_]];
}
-(void)removeObjectAtObjectTag:(int)objectTag_{
	[self removeObjectAtIndex:[self indexOfObjectTag:objectTag_]];
}
-(void)removeObjectAtObatchNode:(CMMSObjectBatchNode *)obatchNode_{
	ccArray *data_ = object_list->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMSObject *object_ = data_->arr[index_];
		if(object_.obatchNode == obatchNode_)
			[self removeObject:object_];
	}
}

-(CMMSObject *)objectAtIndex:(int)index_{
	if(index_ == NSNotFound || index_ >= [self countOfObject]) return nil;
	return [object_list objectAtIndex:index_];
}
-(CMMSObject *)objectAtObjectTag:(int)objectTag_{
	return [self objectAtIndex:[self indexOfObjectTag:objectTag_]];
}

-(CMMSObject *)objectAtTouch:(UITouch *)touch_{
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtTouch:touch_];
	if(!touchItem_ || ![touchItem_.node isKindOfClass:[CMMSObject class]]) return nil;
	else return (CMMSObject *)touchItem_.node;
}

-(int)indexOfObject:(CMMSObject *)object_{
	return [object_list indexOfObject:object_];
}
-(int)indexOfObjectTag:(int)objectTag_{
	ccArray *data_ = object_list->data;
	int count_ = data_->num;
	for(int index_=0;index_<count_;++index_){
		CMMSObject *object_ = data_->arr[index_];
		if(object_.objectTag == objectTag_)
			return index_;
	}
	
	return NSNotFound;
}

-(CCArray *)objectsInTouches{
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
	bodyDef.position = b2Vec2Fromccp_PTM_RATIO(point_);
	bodyDef.angle = -CC_DEGREES_TO_RADIANS(angle_);
	return world->CreateBody(&bodyDef);
}

@end

@interface CMMStageParticle(Cache)

-(void)cacheParticle:(CMMSParticle *)particle_;
-(CMMSParticle *)cachedParticleAtClass:(Class)tClass_;

@end

@implementation CMMStageParticle(Cache)

-(void)cacheParticle:(CMMSParticle *)particle_{
	[_cachedParticles addObject:particle_];
}
-(CMMSParticle *)cachedParticleAtClass:(Class)tClass_{
	ccArray *data_ = _cachedParticles->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSParticle *particle_ = data_->arr[index_];
		if([particle_ class] == tClass_){
			return [_cachedParticles cachedObjectAtIndex:index_];
		}
	}
	return nil;
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
	
	[self setContentSize:[stage worldSize]];
	[self setIgnoreAnchorPointForPosition:NO];
	[self setAnchorPoint:CGPointZero];
	
	particleList = [[CMMTimeIntervalArray alloc] init];
	
	//add filter
	[particleList setFilter_whenAddedObject:^(id particle_){
		[self addChild:particle_];
	}];
	[particleList setFilter_whenRemovedObject:^(id particle_){
		[particle_ resetSystem];
		[self cacheParticle:particle_];
	}];
	
	_cachedParticles = [[CMMSimpleCache alloc] init];
	
	return self;
}

-(void)update:(ccTime)dt_{
	[particleList step];
	
	ccArray *data_ = particleList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
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

@implementation CMMStageParticle(Particle)

-(void)addParticle:(CMMSParticle *)particle_{
	[particleList addObject:particle_];
}

-(CMMSParticle *)addParticleWithName:(NSString *)particleName_ point:(CGPoint)point_ particleClass:(Class)particleClass_{
	NSAssert([CMMSParticle isSubclassOfClass:particleClass_], @"CMMStageParticle : target class is not sub class of CMMSParticle");
	
	CMMSParticle *particle_ = [self cachedParticleAtClass:particleClass_];
	if(!particle_){
		particle_ = [CMMSParticle particleWithParticleName:particleName_];
	}
	
	[particle_ setPosition:point_];
	[self addParticle:particle_];
	return particle_;
}
-(CMMSParticle *)addParticleWithName:(NSString *)particleName_ point:(CGPoint)point_{
	return [self addParticleWithName:particleName_ point:point_ particleClass:[CMMSParticle class]];
}

-(void)removeChild:(CMMSParticle *)particle_ cleanup:(BOOL)cleanup{
	[super removeChild:particle_ cleanup:cleanup];
	[particleList removeObject:particle_];
}
-(void)removeParticle:(CMMSParticle *)particle_{
	if([self indexOfParticle:particle_] != NSNotFound) return;
	[self removeChild:particle_ cleanup:YES];
}
-(void)removeParticleAtIndex:(int)index_{
	return [self removeParticle:[self particleAtIndex:index_]];
}
-(void)removeParticleOfTarget:(CMMSObject *)target_{
	ccArray *data_ = particleList->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMSParticle *particle_ = data_->arr[index_];
		if([particle_ target] == target_){
			[self removeParticle:particle_];
		}
	}
}

-(CMMSParticle *)particleAtIndex:(int)index_{
	if(index_ == NSNotFound) return nil;
	return [particleList objectAtIndex:index_];
}

-(int)indexOfParticle:(CMMSParticle *)particle_{
	return [particleList indexOfObject:particle_];
}

@end

@implementation CMMStageLightItem
@synthesize stageLight,point,brightness,radius,duration,color,isBlendColor,target;

+(id)lightItemWithStageLight:(CMMStageLight *)stageLight_ point:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_ duration:(ccTime)duration_{
	return [[[self alloc] initWithStageLight:stageLight_ point:point_ brightness:brightness_ radius:radius_ duration:duration_] autorelease];
}
-(id)initWithStageLight:(CMMStageLight *)stageLight_ point:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_ duration:(ccTime)duration_{
	if(!(self = [super init])) return self;
	
	stageLight = [stageLight_ retain];
	point = point_;
	brightness = brightness_;
	radius = radius_;
	duration = duration_;
	[self reset];
	
	return self;
}

-(void)update:(ccTime)dt_{
	_curDuration += dt_;
	
	if(_curDuration >= duration && duration > 0.0f){
		[stageLight removeLightItem:self];
		return;
	}
	
	if(target){
		point = [target position];
	}
}

-(void)reset{
	_curDuration = 0.0f;
	[self setTarget:nil];
}

-(void)dealloc{
	[target release];
	[stageLight release];
	[super dealloc];
}

@end

@implementation CMMStageLightItemFadeInOut
@synthesize fadeTime;

-(id)initWithStageLight:(CMMStageLight *)stageLight_ point:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_ duration:(ccTime)duration_{
	if(!(self = [super initWithStageLight:stageLight_ point:point_ brightness:brightness_ radius:radius_ duration:duration_])) return self;
	
	_orginalBrightness = brightness_;
	_orginalRadius = radius_;
	_fadeInOutState = CMMStageLightItemFadeInOutState_fadeIn;
	
	return self;
}

-(void)setBrightness:(float)brightness_{
	_orginalBrightness = brightness_;
}
-(void)setRadius:(float)radius_{
	_orginalRadius = radius_;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	
	switch(_fadeInOutState){
		case CMMStageLightItemFadeInOutState_none:
			if(duration - _curDuration <= fadeTime){
				_fadeInOutState = CMMStageLightItemFadeInOutState_fadeOut;
			}
			break;
		case CMMStageLightItemFadeInOutState_fadeIn:{
			_curFadeTime += dt_;
			float ratio_ = _curFadeTime/MAX(fadeTime,_curFadeTime);
			brightness = _orginalBrightness * ratio_;
			radius = _orginalRadius * ratio_;
			
			if(_curFadeTime >= fadeTime){
				_fadeInOutState = CMMStageLightItemFadeInOutState_none;
				_curFadeTime = 0.0f;
			}
			
			break;
		}
		case CMMStageLightItemFadeInOutState_fadeOut:{
			_curFadeTime += dt_;
			float ratio_ = _curFadeTime/MAX(fadeTime,_curFadeTime);
			brightness = _orginalBrightness - _orginalBrightness * ratio_;
			radius = _orginalRadius - _orginalRadius * ratio_;
			
			if(_curFadeTime >= fadeTime){
				_fadeInOutState = CMMStageLightItemFadeInOutState_endedFade;
				_curFadeTime = 0.0f;
			}
			
			break;
		}
		case CMMStageLightItemFadeInOutState_endedFade:
		default:
			break;
	}
}

-(void)reset{
	[super reset];
	radius = 0.0f;
	brightness = 0.0f;
	_curFadeTime = 0.0f;
	[self setFadeTime:0.0f];
	_fadeInOutState = CMMStageLightItemFadeInOutState_fadeIn;
}

@end

@interface CMMStageLight(Cache)

-(void)cacheLightItem:(CMMStageLightItem *)lightItem_;
-(CMMStageLightItem *)cachedLightItemAtClass:(Class)tClass_;

@end

@implementation CMMStageLight(Cache)

-(void)cacheLightItem:(CMMStageLightItem *)lightItem_{
	[_cachedlightItems addObject:lightItem_];
}
-(CMMStageLightItem *)cachedLightItemAtClass:(Class)tClass_{
	ccArray *data_ = _cachedlightItems->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMStageLightItem *lightItem_ = data_->arr[index_];
		if([lightItem_ class] == tClass_){
			return [_cachedlightItems cachedObjectAtIndex:index_];
		}
	}
	return nil;
}

@end

@implementation CMMStageLight
@synthesize stage,lightList,count,useLights,useCulling,segmentOfLights,lightBlendFunc;

+(id)lightWithStage:(CMMStage *)stage_{
	return [[[self alloc] initWithStage:stage_] autorelease];
}
-(id)initWithStage:(CMMStage *)stage_{
	if(!(self = [super init])) return self;
	[self setContentSize:[stage_ contentSize]];
	[self setIgnoreAnchorPointForPosition:NO];
	[self setAnchorPoint:CGPointZero];
	
	stage = stage_;
	lightList = [[CMMTimeIntervalArray alloc] init];
	
	//register filter
	[lightList setFilter_whenRemovedObject:^(id lightItem_){
		[lightItem_ reset];
		[self cacheLightItem:lightItem_];
	}];
	
	useLights = useCulling = YES;
	segmentOfLights = 15;
	
	_lightRender = [CCRenderTexture renderTextureWithWidth:contentSize_.width height:contentSize_.height];
	[_lightRender setShaderProgram:[[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor]];
	[_lightRender setPosition:ccp(contentSize_.width*0.5f,contentSize_.height*0.5f)];
	[self setLightBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA}];
	[self addChild:_lightRender];
	
	_cachedlightItems = [[CMMSimpleCache alloc] init];
	
	return self;
}

-(uint)count{
	return [lightList count];
}

-(void)setLightBlendFunc:(ccBlendFunc)lightBlendFunc_{
	[[_lightRender sprite] setBlendFunc:lightBlendFunc_];
}
-(ccBlendFunc)lightBlendFunc{
	return [[_lightRender sprite] blendFunc];
}

-(void)update:(ccTime)dt_{
	[lightList step];
	
	CMMSSpecStage *stageSpec_ = [stage spec];
	CMMStageWorld *world_ = [stage world];
	float worldScale_ = [world_ scale];
	CGRect lightRect_ = CGRectZero;
	lightRect_.size = contentSize_;
	
	[_lightRender begin];
	
	GLfloat	clearColor_[4];
	glGetFloatv(GL_COLOR_CLEAR_VALUE,clearColor_);
	
	glClearColor(0.0f, 0.0f, 0.0f, (1.0f-[stageSpec_ brightness]));
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glClearColor(clearColor_[0], clearColor_[1], clearColor_[2], clearColor_[3]);
	glColorMask(0, 0, 0, 1);
	
	if(useLights){
		CCGLProgram *lightShader_ = [_lightRender shaderProgram];
		
		[lightShader_ use];
		[lightShader_ setUniformsForBuiltins];
		
		ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position | kCCVertexAttribFlag_Color);
		
		float coef_ = 2.0f * (float)M_PI/(segmentOfLights-2);
		GLfloat *lightVertices_ = (GLfloat *)malloc(sizeof(GLfloat)*2*(segmentOfLights));
		ccColor4B *lightColors_ = (ccColor4B *)malloc(sizeof(ccColor4B)*(segmentOfLights));
		
		ccArray *data_ = lightList->data;
		uint count_ = data_->num;
		for(uint index_=0;index_<count_;++index_){
			CMMStageLightItem *lightItem_ = data_->arr[index_];
			[lightItem_ update:dt_];
			CGPoint targetPoint_ = [lightItem_ point];
			float targetBrightness_ = [lightItem_ brightness];
			float radius_ = [lightItem_ radius]*worldScale_;
			ccColor3B targetColor_ = [lightItem_ color];
			
			CGPoint convertedPoint_ = [self convertToNodeSpace:[world_ convertToWorldSpace:targetPoint_]];
			if(useCulling){
				CGRect targetRect_ = CGRectMake(convertedPoint_.x-radius_, convertedPoint_.y-radius_,radius_*2.0f, radius_*2.0f);
				if(!CGRectIntersectsRect(lightRect_, targetRect_)){
					continue;
				}
			}
			
			ccColor4B tcolor_ = ccc4(targetColor_.r, targetColor_.g, targetColor_.b, 255.0f * targetBrightness_);
			
			lightColors_[0] = tcolor_;
			memset(lightVertices_,0,sizeof(GLfloat)*2*(segmentOfLights));
			
			lightVertices_[0] = convertedPoint_.x;
			lightVertices_[1] = convertedPoint_.y;
			
			for(uint lightSegIndex_=1;lightSegIndex_<=segmentOfLights;++lightSegIndex_){
				float targetRadians_ = lightSegIndex_*coef_;
				CGPoint vertPoint_ = ccpOffset(convertedPoint_, targetRadians_, radius_);
				
				lightVertices_[lightSegIndex_*2] = vertPoint_.x;
				lightVertices_[lightSegIndex_*2+1] = vertPoint_.y;
				lightColors_[lightSegIndex_] = ccc4(targetColor_.r,targetColor_.g,targetColor_.b,0);
			}
			
			ccGLBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_ALPHA);
			
			glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, lightVertices_);
			glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, lightColors_);
			glDrawArrays(GL_TRIANGLE_FAN, 0, segmentOfLights);
			
			if([lightItem_ isBlendColor]){
				glColorMask(1, 1, 1, 1);
				
				ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE);
				glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, lightVertices_);
				glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, lightColors_);
				glDrawArrays(GL_TRIANGLE_FAN, 0, segmentOfLights);
				
				glColorMask(0, 0, 0, 1);
			}
		}
		
		free(lightVertices_);
		free(lightColors_);
	}
	
	glColorMask(1, 1, 1, 1);
	
	[_lightRender end];
}

-(void)dealloc{
	[_cachedlightItems release];
	[lightList release];
	[super dealloc];
}

@end

@implementation CMMStageLight(Common)

-(void)addLightItem:(CMMStageLightItem *)lightItem_{
	uint index_= [self indexOfLightItem:lightItem_];
	if(index_ != NSNotFound) return;
	[lightList addObject:lightItem_];
}
-(CMMStageLightItem *)addLightItemAtPoint:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_ duration:(ccTime)duration_ lightItemClass:(Class)lightItemClass_{
	
	NSAssert([lightItemClass_ isSubclassOfClass:[CMMStageLightItem class]], @"CMMStageLight : target class is not sub class of CMMStageLightItem");
	CMMStageLightItem *lightItem_ = [self cachedLightItemAtClass:lightItemClass_];
	if(!lightItem_){
		lightItem_ = [lightItemClass_ lightItemWithStageLight:nil point:CGPointZero brightness:0.0f radius:0.0f duration:0.0f];
	}
	
	//reset option
	[lightItem_ setColor:ccc3(0, 0, 0)];
	[lightItem_ setIsBlendColor:NO];
	
	[lightItem_ setPoint:point_];
	[lightItem_ setBrightness:brightness_];
	[lightItem_ setRadius:radius_];
	[lightItem_ setDuration:duration_];
	[lightItem_ setStageLight:self];
	
	[self addLightItem:lightItem_];
	return lightItem_;
}
-(CMMStageLightItem *)addLightItemAtPoint:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_ duration:(ccTime)duration_{
	return [self addLightItemAtPoint:point_ brightness:brightness_ radius:radius_ duration:duration_ lightItemClass:[CMMStageLightItem class]];
}
-(CMMStageLightItem *)addLightItemAtPoint:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_{
	return [self addLightItemAtPoint:point_ brightness:brightness_ radius:radius_ duration:-1.0f];
}
-(CMMStageLightItem *)addLightItemAtPoint:(CGPoint)point_ brightness:(float)brightness_{
	return [self addLightItemAtPoint:point_ brightness:brightness_ radius:100.0f];
}
-(CMMStageLightItem *)addLightItemAtPoint:(CGPoint)point_{
	return [self addLightItemAtPoint:point_ brightness:1.0f];
}

-(void)removeLightItem:(CMMStageLightItem *)lightItem_{
	uint index_= [self indexOfLightItem:lightItem_];
	if(index_ == NSNotFound) return;
	
	[lightList removeObjectAtIndex:index_];
}
-(void)removeLightItemAtIndex:(uint)index_{
	[self removeLightItem:[self lightItemAtIndex:index_]];
}
-(void)removeLightItemsAtTarget:(CMMSObject *)target_{
	ccArray *data_ = lightList->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMStageLightItem *lightItem_ = data_->arr[index_];
		if([lightItem_ target] == target_){
			[self removeLightItem:lightItem_];
		}
	}
}

-(CMMStageLightItem *)lightItemAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [lightList objectAtIndex:index_];
}

-(uint)indexOfLightItem:(CMMStageLightItem *)lightItem_{
	return [lightList indexOfObject:lightItem_];
}

@end

@implementation CMMStageObjectSView
@synthesize stage,stateViewList,count;

+(id)stateViewWithStage:(CMMStage *)stage_{
	return [[[self alloc] initWithStage:stage_] autorelease];
}
-(id)initWithStage:(CMMStage *)stage_{
	if(!(self = [super init])) return self;
	
	stage = stage_;
	stateViewList = [[CCArray alloc] init];
	
	return self;
}

-(int)count{
	return [stateViewList count];
}

-(void)update:(ccTime)dt_{
	ccArray *data_ = stateViewList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSObjectSView *stateView_ = data_->arr[index_];
		[stateView_ update:dt_];
	}
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return [super touchDispatcher:touchDispatcher_ shouldAllowTouch:touch_ event:event_] && [CMMTouchUtil nodeCountInTouch:stateViewList touch:touch_];
}

-(void)dealloc{
	[stateViewList release];
	[super dealloc];
}

@end

@implementation CMMStageObjectSView(Common)

-(void)addStateView:(CMMSObjectSView *)stateView_{
	if([self indexOfStateView:stateView_] != NSNotFound) return;
	[stateViewList addObject:stateView_];
	[self addChild:stateView_];
}

-(void)removeStateView:(CMMSObjectSView *)stateView_{
	int targetIndex_ = [self indexOfStateView:stateView_];
	if(targetIndex_ == NSNotFound) return;
	[self removeChild:stateView_ cleanup:YES];
	[stateViewList removeObjectAtIndex:targetIndex_];
}
-(void)removeStateViewAtIndex:(int)index_{
	[self removeStateView:[self stateViewAtIndex:index_]];
}
-(void)removeStateViewAtTarget:(CMMSObject *)target_{
	ccArray *data_ = stateViewList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSObjectSView *stateView_ = data_->arr[index_];
		if(stateView_.target == target_)
			[self removeStateView:stateView_];
	}
}
-(void)removeAllStateView{
	ccArray *data_ = stateViewList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSObjectSView *stateView_ = data_->arr[index_];
		[self removeStateView:stateView_];
	}
}

-(CMMSObjectSView *)stateViewAtIndex:(int)index_{
	if(index_ == NSNotFound || [self count] <= index_) return nil;
	return [stateViewList objectAtIndex:index_];
}
-(CCArray *)stateViewListAtTarget:(CMMSObject *)target_;{
	CCArray *array_ = [CCArray array];

	ccArray *data_ = stateViewList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSObjectSView *stateView_ = data_->arr[index_];
		if(stateView_.target == target_)
			[array_ addObject:stateView_];
	}
	
	return array_;
}

-(int)indexOfStateView:(CMMSObjectSView *)stateView_{
	return [stateViewList indexOfObject:stateView_];
}

@end

@implementation CMMStage
@synthesize spec,delegate,world,particle,stateView,light,sound,backgroundNode,worldSize,worldPoint,worldScale,timeInterval,maxTimeIntervalProcessCount;

+(id)stageWithStageDef:(CMMStageDef)stageDef_{
	return [[[self alloc] initWithStageDef:stageDef_] autorelease];
}
-(id)initWithStageDef:(CMMStageDef)stageDef_{
	if(!(self = [super init])) return self;
	[self setContentSize:stageDef_.stageSize];
	[self setIsTouchEnabled:NO];
	
	spec = [[CMMSSpecStage alloc] initWithTarget:self];
	
	world = [CMMStageWorld worldWithStage:self worldSize:stageDef_.worldSize];
	particle = [CMMStageParticle particleWithStage:self];
	stateView = [CMMStageObjectSView stateViewWithStage:self];
	light = nil; //lazy alloc
	
	[self addChild:world z:2];
	[self addChild:particle z:3];
	[self addChild:stateView z:5];

	sound = [[CMMSoundHandler alloc] initSoundHandler:CGPointZero soundDistance:700.0f];
	
	[spec applyWithStageDef:stageDef_];
	
	timeInterval = 1.0f/30.0f;
	maxTimeIntervalProcessCount = 10;
	_stackTime = 0.0f;
	
	[self setWorldPoint:CGPointZero];
	
	return self;
}

-(void)addBackgroundNode:(CCNode<CMMStageChildProtocol> *)backgroundNode_{
	if(backgroundNode){
		[self removeChild:backgroundNode_ cleanup:YES];
		backgroundNode = nil;
	}
	
	backgroundNode = backgroundNode_;
	[self addChild:backgroundNode];
}

-(CGSize)worldSize{
	return [world contentSize];
}

-(void)setWorldPoint:(CGPoint)worldPoint_{
	CGSize stageSize_ = [self contentSize];
	CGPoint resultPoint_ = worldPoint_;
	
	resultPoint_ = ccpMult(resultPoint_, -1.0f);
	[world setPosition:resultPoint_];
	[particle setPosition:resultPoint_];
	[stateView setPosition:resultPoint_];
	if(backgroundNode) [backgroundNode setPosition:resultPoint_];
	
	//update sound center position
	CGPoint soundPoint_ = [self convertToStageWorldSpace:ccp(stageSize_.width/2.0f,stageSize_.height/2.0f)];
	[sound setCenterPoint:soundPoint_];
}
-(CGPoint)worldPoint{
	return ccpMult([world position], -1.0f);
}

-(void)setWorldScale:(float)worldScale_{
	[world setScale:worldScale_];
	[particle setScale:worldScale_];
	[stateView setScale:worldScale_];
	if(backgroundNode) [backgroundNode setScale:worldScale_];
}
-(float)worldScale{
	return [world scale];
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

-(void)step:(ccTime)dt_{
	[world update:dt_];
	[particle update:dt_];
	[sound update:dt_];
	[stateView update:dt_];
	if(backgroundNode) [backgroundNode update:dt_];
}
-(void)afterStep:(ccTime)dt_{
	if(light) [light update:dt_];
}
-(void)update:(ccTime)dt_{
	ccTime targetDt_ = dt_ + _stackTime;
	while(targetDt_ >= timeInterval){
		[self step:timeInterval];
		[self afterStep:timeInterval];
		targetDt_ = targetDt_ - timeInterval;
	}
	_stackTime = targetDt_;
}

-(void)initializeLightSystem{
	if(light) return;
	light = [CMMStageLight lightWithStage:self];
	[self addChild:light z:4];
}

-(void)stageWorld:(CMMStageWorld *)world_ whenAddedObject:(CMMSObject *)object_{}
-(void)stageWorld:(CMMStageWorld *)world_ whenRemovedObject:(CMMSObject *)object_{}

-(void)whenContactBeganWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{}
-(void)whenContactEndedWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{}
-(void)doContactWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_ interval:(ccTime)interval_{}

-(void)cleanup{
	delegate = nil;
	[super cleanup];
}

-(void)dealloc{
	[sound release];
	[spec release];
	[super dealloc];
}

@end

@implementation CMMStage(Point)

-(CGPoint)convertToStageWorldSpace:(CGPoint)worldPoint_{
	return [world convertToNodeSpace:worldPoint_];
}

@end