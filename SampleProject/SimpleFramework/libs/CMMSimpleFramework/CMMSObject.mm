//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSObject.h"
#import "CMMStage.h"
#import "CMMStringUtil.h"

@implementation CMMSObjectBatchNode
@synthesize obatchNodeTag,stage,objectClass,fileName,isInDocument,count;

+(id)batchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [[[self alloc] initWithFileName:fileName_ isInDocument:isInDocument_] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)tex capacity:(NSUInteger)capacity{
	if(!(self = [super initWithTexture:tex capacity:capacity])) return self;
	
	obatchNodeTag = -1;
	objectClass = [CMMSObject class];
	fileName = nil;
	isInDocument = NO;
	
	_cachedObjects = [[CMMSimpleCache alloc] init];
	
	return self;
}
-(id)initWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	CCTexture2D *tex_ = [[CCTextureCache sharedTextureCache] addImage:[CMMStringUtil stringPathWithFileName:fileName_ isInDocument:isInDocument_]];
	if(!(self = [self initWithTexture:tex_ capacity:cmmVarCMMSObjectBatchNode_defaultCapacity])) return self;
	
	fileName = [fileName_ copy];
	isInDocument = isInDocument_;
	
	return self;
}

-(void)removeChild:(CMMSObject *)object_ cleanup:(BOOL)cleanup_{
	[self cacheObject:object_];
	[super removeChild:object_ cleanup:cleanup_];
}

-(int)count{
	if(!_children) return 0;
	return [_children count];
}

-(CMMSObject *)createObjectWithRect:(CGRect)rect_{
	CMMSObject *object_ = [self cachedObject];
	if(!object_){
		object_ = [objectClass spriteWithObatchNode:self rect:rect_];
	}else{
		[object_ setTextureRect:rect_];
	}
	
	return object_;
}
-(CMMSObject *)createObjectWithSpriteFrame:(CCSpriteFrame *)spriteFrame_{
	CCTexture2D *targetTexture_ = [spriteFrame_ texture];
	if([self texture] != targetTexture_){
		return nil;
	}
	return [self createObjectWithRect:[spriteFrame_ rect]];
}
-(CMMSObject *)createObject{
	CGRect rect_ = CGRectZero;
	rect_.size = [[_textureAtlas texture] contentSize];
	return [self createObjectWithRect:rect_];
}

-(void)dealloc{
	[_cachedObjects release];
	[fileName release];
	[super dealloc];
}

@end

@implementation CMMSObjectBatchNode(Cache)

-(CMMSObject *)cachedObject{
	return [_cachedObjects cachedObject];
}
-(void)cacheObject:(CMMSObject *)object_{
	[object_ resetObject];
	[_cachedObjects addObject:object_];
}

@end


@implementation CMMSObject
@synthesize objectTag,spec,state,body,b2CMask,stage,obatchNode,addToBatchNode,callback_whenAddedToStage,callback_whenRemovedToStage;

+(id)spriteWithObatchNode:(CMMSObjectBatchNode *)obatchNode_ rect:(CGRect)rect_{
	return [[[self alloc] initWithObatchNode:obatchNode_ rect:rect_] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	spec = nil;
	state = nil;
	body = NULL;
	objectTag = -1;
	b2CMask = CMMb2ContactMaskMake(0x1001,-1,-1,1);

	[self buildupObject];
	[self resetObject];
	
	addToBatchNode = NO;
	callback_whenAddedToStage = nil;
	callback_whenRemovedToStage = nil;
	
	return self;
}

-(id)initWithObatchNode:(CMMSObjectBatchNode *)obatchNode_ rect:(CGRect)tRect_{
	obatchNode = obatchNode_;
	return [self initWithTexture:[obatchNode_ texture] rect:tRect_ rotated:NO];
}

-(void)setObjectTag:(int)objectTag_{
	objectTag = objectTag_;
	b2CMask.maskBit1 = objectTag_;
}

//#issue
-(void)setB2CMask:(CMMb2ContactMask)b2CMask_{
	b2CMask.fixtureType = b2CMask_.fixtureType;
	b2CMask.maskBit1 = b2CMask_.maskBit1;
	b2CMask.maskBit2 = b2CMask_.maskBit2;
	b2CMask.checkBit = b2CMask_.checkBit;
}

-(void)buildupObject{
	//override this.
	[self setSpec:[CMMSSpecObject specWithTarget:self]];
	[self setState:[CMMSStateObject stateWithTarget:self]];
}
-(void)resetObject{
	[self setObjectTag:-1];
	if(state) [state resetStateWithSpecObject:spec];
}

-(void)update:(ccTime)dt_{
	[self setPosition:ccpFromb2Vec2_PTM_RATIO(body->GetPosition())];
	[self setRotation:-CC_RADIANS_TO_DEGREES(body->GetAngle())];
	
	[state update:dt_];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{}

-(void)whenContactBeganWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{}
-(void)whenContactEndedWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{}
-(void)doContactWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_ interval:(ccTime)interval_{}

-(void)cleanup{
	[self setCallback_whenAddedToStage:nil];
	[self setCallback_whenRemovedToStage:nil];
	[super cleanup];
}

-(void)dealloc{
	[callback_whenAddedToStage release];
	[callback_whenRemovedToStage release];
	[state release];
	[spec release];
	[super dealloc];
}

@end

@implementation CMMSObject(Box2d)

-(void)buildupBody{
	body = [[stage world] createBody:b2_dynamicBody point:_position angle:_rotationX];
	body->SetUserData(self);
	
	b2Vec2 targetSize_ = b2Vec2Div(b2Vec2FromSize_PTM_RATIO(_contentSize), 2.0f);
	b2PolygonShape bodyBox_;
	bodyBox_.SetAsBox(targetSize_.x,targetSize_.y);
	b2FixtureDef fixtureDef_;
	fixtureDef_.shape = &bodyBox_;
	fixtureDef_.density = 0.7f;
	
	body->CreateFixture(&fixtureDef_)->SetUserData(&b2CMask);
}

-(void)updateBodyPosition:(CGPoint)point_ rotation:(float)tRotation_{
	if(body == NULL) return;
	body->SetTransform(b2Vec2Fromccp_PTM_RATIO(point_), -CC_DEGREES_TO_RADIANS(tRotation_));
}
-(void)updateBodyPosition:(CGPoint)point_{
	[self updateBodyPosition:point_ rotation:_rotationX];
}

-(void)updateBodyLinearVelocity:(b2Vec2)linearVelocity angularVelocity:(float)angularVelocity_{
	if(body == NULL) return;
	body->SetLinearVelocity(linearVelocity);
	body->SetAngularVelocity(angularVelocity_);
}
-(void)updateBodyLinearVelocity:(b2Vec2)linearVelocity{
	if(body == NULL) return;
	[self updateBodyLinearVelocity:linearVelocity angularVelocity:body->GetAngularVelocity()];
}

@end

@implementation CMMSObject(Stage)

-(void)whenAddedToStage{
	[self buildupBody];
	if(obatchNode && addToBatchNode){
		[self setBatchNode:obatchNode];
		[obatchNode addChild:self];
	}else{
		[[stage world] addChild:self];
	}
	
	if(callback_whenAddedToStage){
		callback_whenAddedToStage(self, stage);
	}
}
-(void)whenRemovedToStage{
	if(callback_whenRemovedToStage){
		callback_whenRemovedToStage(self, stage);
	}
	[[stage world] world]->DestroyBody(body);
	body = NULL;
	[_parent removeChild:self cleanup:YES];
}

@end