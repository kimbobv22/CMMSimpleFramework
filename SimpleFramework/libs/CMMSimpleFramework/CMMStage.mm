//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMStage.h"

void CMMStageContactListener::BeginContact(b2Contact* contact){
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
void CMMStageContactListener::EndContact(b2Contact *contact){
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

bool CMMStageContactFilter::ShouldCollide(b2Fixture *fixtureA, b2Fixture *fixtureB){
	CMMb2ContactMask *b2CMaskA_ = (CMMb2ContactMask *)fixtureA->GetUserData();
	CMMb2ContactMask *b2CMaskB_ = (CMMb2ContactMask *)fixtureB->GetUserData();
	return cmmFuncCMMb2ContactMask_IsContact(b2CMaskA_,b2CMaskB_);
	
	//filter supported by Box2d - N/U
	//return b2ContactFilter::ShouldCollide(fixtureA, fixtureB);
}

@implementation CMMStageWorld
@synthesize stage,world,worldBody,obatchNode_list,object_list,count,countOfObatchNode,countOfObject;

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
	
	b2Mask1 = b2CMaskMake(0x3001,-1,-1,1);
	b2Mask2 = b2CMaskMake(0x3003,-1,-1,1);
	b2Mask3 = b2CMaskMake(0x3005,-1,-1,1);
	b2Mask4 = b2CMaskMake(0x3007,-1,-1,1);
	
	worldBody = [self createBody:b2_staticBody point:CGPointZero angle:0];
	worldBody->SetUserData(stage);
	
	b2EdgeShape groundBox;
	groundBox.Set(b2Vec2(0,0), b2Vec2_PTM_RATIO(contentSize_.width,0));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2Mask1);
	
	groundBox.Set(b2Vec2_PTM_RATIO(0,contentSize_.height), b2Vec2_PTM_RATIO(contentSize_.width,contentSize_.height));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2Mask2);
	
	groundBox.Set(b2Vec2_PTM_RATIO(0,contentSize_.height), b2Vec2_PTM_RATIO(0,0));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2Mask3);
	
	groundBox.Set(b2Vec2_PTM_RATIO(contentSize_.width,contentSize_.height), b2Vec2_PTM_RATIO(contentSize_.width,0));
	worldBody->CreateFixture(&groundBox,0)->SetUserData(&b2Mask4);
	
	_touchedObjects = nil;
	
	_OBATCHNODETAG_ = _OBJECTTAG_ = 0;
	
	return self;
}

#if COCOS2D_DEBUG >= 1
-(void)visit{
	[super visit];
	
	kmGLPushMatrix();
	[self transform];
	
	ccDrawColor4F(1.0, 1.0, 1.0, 1.0);
	glLineWidth(1.0f);
	world->DrawDebugData();
	
	kmGLPopMatrix();
}
#endif

-(int)count{
	return [self countOfObject];
}

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
	
	//destory object
	data_ = object_destroyList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSObject *object_ = data_->arr[index_];
		[object_list removeObject:object_];
		[object_ whenRemovedToStage];
		
		//remove touch
		[touchDispatcher cancelTouchAtNode:object_];
		
		//stage delegate
		[stage stageWorld:self whenRemovedObject:object_];
	}
	
	if(count_>0 && cmmFuncCommon_respondsToSelector(stage.delegate,@selector(stage:whenRemovedObjects:)))
		[stage.delegate stage:stage whenRemovedObjects:object_destroyList];
	[object_destroyList removeAllObjects];
	
	//add object
	data_ = object_createList->data;
	count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSObject *object_ = data_->arr[index_];
		[object_list addObject:object_];
		[object_ whenAddedToStage];
		[stage stageWorld:self whenAddedObject:object_];
	}
	
	if(count_>0 && cmmFuncCommon_respondsToSelector(stage.delegate,@selector(stage:whenAddedObjects:)))
		[stage.delegate stage:stage whenAddedObjects:object_createList];
	[object_createList removeAllObjects];
	
	world->Step(dt_, 8, 3);
	
	CMMSSpecStage *specStage_ = stage.spec;
	b2Vec2 gravity_ = b2Vec2Fromccp([specStage_ gravity]);
	
	//object update
	data_ = object_list->data;
	count_ = data_->num;
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

-(void)dealloc{
	[_touchedObjects release];
	[object_createList release];
	[object_destroyList release];
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
	[object_ setStage:stage];
	[object_ setObjectTag:[self _nextObjectTag]];
	[object_createList addObject:object_];
}

-(void)removeObject:(CMMSObject *)object_{
	if([object_destroyList indexOfObject:object_] != NSNotFound) return;
	[object_destroyList addObject:object_];
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
	bodyDef.position = b2Vec2Fromccp_PTM_RATIO(point_);
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
	for(uint index_=0;index_<count_;++index_){
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
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMSParticle *particle_ = data_->arr[index_];
		if(particle_.particleType == ParticleType_follow
		   && ((CMMSParticleFollow *)particle_).target == target_)
			[self removeParticle:particle_];
	}
}

@end

@implementation CMMStageLight
@synthesize stage,lightList;

+(id)lightWithStage:(CMMStage *)stage_{
	return [[[self alloc] initWithStage:stage_] autorelease];
}
-(id)initWithStage:(CMMStage *)stage_{
	if(!(self = [super init])) return self;
	[self setContentSize:[stage_ worldSize]];
	[self setIgnoreAnchorPointForPosition:NO];
	[self setAnchorPoint:CGPointZero];
	
	stage = stage_;
	lightList = [[CCArray alloc] init];
	
	return self;
}

-(void)update:(ccTime)dt_{
	
}

-(void)dealloc{
	[lightList release];
	[super dealloc];
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
@synthesize spec,delegate,world,particle,stateView,backGround,sound,worldSize,worldPoint,isAllowTouch;

+(id)stageWithStageSpecDef:(CMMStageSpecDef)stageSpecDef_{
	return [[[self alloc] initWithStageSpecDef:stageSpecDef_] autorelease];
}
-(id)initWithStageSpecDef:(CMMStageSpecDef)stageSpecDef_{
	if(!(self = [super init])) return self;
	[self setContentSize:stageSpecDef_.stageSize];
	
	spec = [[CMMSSpecStage alloc] initWithTarget:self];
	
	world = [CMMStageWorld worldWithStage:self worldSize:stageSpecDef_.worldSize];
	particle = [CMMStageParticle particleWithStage:self];
	stateView = [CMMStageObjectSView stateViewWithStage:self];
	
	[self addChild:world z:2];
	[self addChild:particle z:3];
	[self addChild:stateView z:4];
	
	backGround = [[CMMStageBackGround alloc] initWithStage:self distanceRate:0.0f];
	sound = [[CMMSoundHandler alloc] initSoundHandler:CGPointZero soundDistance:700.0f];
	
	[spec applyWithStageSpecDef:stageSpecDef_];
	
	isAllowTouch = NO;
	
	return self;
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
	[backGround updatePosition];
	
	//update sound center position
	CGPoint soundPoint_ = [self convertToStageWorldSpace:ccp(stageSize_.width/2,stageSize_.height/2)];
	sound.centerPoint = soundPoint_;
}
-(CGPoint)worldPoint{
	return ccpMult([world position], -1.0f);
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

-(void)update:(ccTime)dt_{
	[world update:dt_];
	[particle update:dt_];
	[sound update:dt_];
	[stateView update:dt_];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	if(!isAllowTouch) return;
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
}

-(void)stageWorld:(CMMStageWorld *)world_ whenAddedObject:(CMMSObject *)object_{}
-(void)stageWorld:(CMMStageWorld *)world_ whenRemovedObject:(CMMSObject *)object_{}

-(void)whenContactBeganWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{}
-(void)whenContactEndedWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{}
-(void)doContactWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_ interval:(ccTime)interval_{}

-(void)dealloc{
	[delegate release];
	[sound release];
	[spec release];
	[backGround release];
	[super dealloc];
}

@end

@implementation CMMStage(Point)

-(CGPoint)convertToStageWorldSpace:(CGPoint)worldPoint_{
	return [world convertToNodeSpace:worldPoint_];
}

@end