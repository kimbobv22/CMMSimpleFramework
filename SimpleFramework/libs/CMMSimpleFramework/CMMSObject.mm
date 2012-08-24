//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSObject.h"
#import "CMMStage.h"

@implementation CMMSObject
@synthesize objectTag,spec,state,body,b2CMask,stage;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	spec = nil;
	state = nil;
	body = NULL;
	objectTag = -1;
	b2CMask = CMMb2ContactMask(CMMb2FixtureType_object,-1,-1,1);

	[self buildupObject];
	[state resetStateWithSpecObject:spec];
	
	return self;
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
	spec = [[CMMSSpecObject alloc] initWithTarget:self];
	state = [[CMMSStateObject alloc] initWithTarget:self];
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

-(void)dealloc{
	[state release];
	[spec release];
	[super dealloc];
}

@end

@implementation CMMSObject(Box2d)

-(void)buildupBody{
	body = [stage.world createBody:b2_dynamicBody point:self.position angle:self.rotation];
	body->SetUserData(self);
	
	b2Vec2 targetSize_ = b2Vec2Fromccp(self.contentSize.width*0.5,self.contentSize.height*0.5);
	b2PolygonShape bodyBox_;
	bodyBox_.SetAsBox(targetSize_.x,targetSize_.y);
	b2FixtureDef fixtureDef_;
	fixtureDef_.shape = &bodyBox_;
	fixtureDef_.density = 0.7f;
	
	body->CreateFixture(&fixtureDef_)->SetUserData(&b2CMask);
	body->SetFixedRotation(false);
}

-(void)whenCollisionWithObject:(CMMb2FixtureType)fixtureType_ otherObject:(CMMSObject *)otherObject_  otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{}
-(void)whenCollisionWithStage:(CMMb2FixtureType)fixtureType_ stageFixtureType:(CMMb2FixtureType)stageFixtureType_ contactPoint:(CGPoint)contactPoint_{}

-(void)doContactingWithObject:(CMMb2FixtureType)fixtureType_ otherObject:(CMMSObject *)otherObject_  otherFixtureType:(CMMb2FixtureType)otherFixtureType contactPoint:(CGPoint)contactPoint_ dt:(ccTime)dt_{}
-(void)doContactingWithStage:(CMMb2FixtureType)fixtureType_ stageFixtureType:(CMMb2FixtureType)stageFixtureType_ contactPoint:(CGPoint)contactPoint_ dt:(ccTime)dt_{}

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
	[stage.world addChild:self];
}
-(void)whenRemovedToStage{
	stage.world.world->DestroyBody(body);
	body = NULL;
	[self removeFromParentAndCleanup:YES];
}

@end