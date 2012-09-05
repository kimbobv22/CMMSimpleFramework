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
	
	_cachedObjects = [[CCArray alloc] init];
	
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
	if(!children_) return 0;
	return [children_ count];
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
-(CMMSObject *)createObject{
	CGRect rect_ = CGRectZero;
	rect_.size = [[textureAtlas_ texture] contentSize];
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
	CMMSObject *object_ = nil;
	if(_cachedObjects.count>0){
		object_ = [[[_cachedObjects objectAtIndex:0] retain] autorelease];
		[_cachedObjects removeObjectAtIndex:0];
	}
	return object_;
}
-(void)cacheObject:(CMMSObject *)object_{
	[object_ resetObject];
	[_cachedObjects addObject:object_];
}

@end


@implementation CMMSObject
@synthesize objectTag,spec,state,body,b2CMask,stage,obatchNode;

+(id)spriteWithObatchNode:(CMMSObjectBatchNode *)obatchNode_ rect:(CGRect)rect_{
	return [[[self alloc] initWithObatchNode:obatchNode_ rect:rect_] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	spec = nil;
	state = nil;
	body = NULL;
	objectTag = -1;
	b2CMask = CMMb2ContactMask(0x1001,-1,-1,1);

	[self buildupObject];
	[self resetObject];
	
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
	if(state) [state resetStateWithSpecObject:spec];
}

-(void)update:(ccTime)dt_{
	self.position = ccpFromb2Vec2(body->GetPosition());
	self.rotation = -CC_RADIANS_TO_DEGREES(body->GetAngle());
	
	[state update:dt_];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{}

-(void)whenContactBeganWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{}
-(void)whenContactEndedWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{}
-(void)doContactWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_ interval:(ccTime)interval_{}

-(void)dealloc{
	[state release];
	[spec release];
	[super dealloc];
}

@end

@implementation CMMSObject(Box2d)

-(void)buildupBody{
	body = [stage.world createBody:b2_dynamicBody point:position_ angle:rotation_];
	body->SetUserData(self);
	
	b2Vec2 targetSize_ = b2Vec2Fromccp(contentSize_.width*0.5,contentSize_.height*0.5);
	b2PolygonShape bodyBox_;
	bodyBox_.SetAsBox(targetSize_.x,targetSize_.y);
	b2FixtureDef fixtureDef_;
	fixtureDef_.shape = &bodyBox_;
	fixtureDef_.density = 0.7f;
	
	body->CreateFixture(&fixtureDef_)->SetUserData(&b2CMask);
	body->SetFixedRotation(false);
}

-(void)updateBodyWithPosition:(CGPoint)point_ andRotation:(float)tRotation_{
	if(body == NULL) return;
	body->SetTransform(b2Vec2Fromccp(point_), -CC_DEGREES_TO_RADIANS(tRotation_));
}
-(void)updateBodyWithPosition:(CGPoint)point_{
	[self updateBodyWithPosition:point_ andRotation:self.rotation];
}

@end

@implementation CMMSObject(Stage)

-(void)whenAddedToStage{
	[self buildupBody];
	if(obatchNode){
		[self setBatchNode:obatchNode];
		[obatchNode addChild:self];
	}else{
		[stage.world addChild:self];
	}
}
-(void)whenRemovedToStage{
	stage.world.world->DestroyBody(body);
	body = NULL;
	[stage.stateView removeStateViewAtTarget:self];
	[parent_ removeChild:self cleanup:YES];
}

@end