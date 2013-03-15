//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSObject_Test.h"
#import "CMMStage.h"

@implementation CMMSSpecBall
@synthesize HP,AP,bounceCount;

-(id)initWithTarget:(id)target_{
	if(!(self = [super initWithTarget:target_])) return self;
	
	HP = 100.0f;
	AP = 40.0f;
	bounceCount = 10;
	
	return self;
}

-(id)initWithCoder:(NSCoder *)decoder_{
	if(!(self = [self initWithCoder:decoder_])) return self;
	
	HP = [decoder_ decodeFloatForKey:cmmVarCMMSSpecBall_HP];
	AP = [decoder_ decodeFloatForKey:cmmVarCMMSSpecBall_AP];
	bounceCount = [decoder_ decodeIntForKey:cmmVarCMMSSpecBall_bounceCount];
	
	return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder_{
	[super encodeWithCoder:encoder_];
	[encoder_ encodeFloat:HP forKey:cmmVarCMMSSpecBall_HP];
	[encoder_ encodeFloat:AP forKey:cmmVarCMMSSpecBall_AP];
	[encoder_ encodeInt:bounceCount forKey:cmmVarCMMSSpecBall_bounceCount];
}
-(id)copyWithZone:(NSZone *)zone_{
	CMMSSpecBall *copy_ = [self copyWithZone:zone_];
	copy_.HP = HP;
	copy_.AP = AP;
	copy_.bounceCount = bounceCount;
	
	return copy_;
}

@end

@implementation CMMSStateBall
@synthesize HP,bounceCount;

-(void)setHP:(float)HP_{
	HP = MAX(HP_,0);
	if(HP<=0)
		[((CMMSBall *)target).stage.world removeObject:target];
}

-(void)resetStateWithSpecObject:(CMMSSpecBall *)spec_{
	HP = spec_.HP;
	bounceCount = 0;
}

@end

@implementation CMMSBallStateView

-(void)draw{
	[super draw];
	
	if(!target) return;
	
	CGSize targetSize_ = [target contentSize];
	CGPoint fromPoint_ = ccp(-targetSize_.width/2.0f,targetSize_.height/2.0f + 10.0f);
	CGPoint toPoint_ = ccpAdd(fromPoint_, ccp(targetSize_.width,0.0f));
	
	glLineWidth(5.0f*CC_CONTENT_SCALE_FACTOR());
	ccDrawColor4F(1.0f, 1.0f, 1.0f, 0.5f);
	ccDrawLine(fromPoint_, toPoint_);

	toPoint_ = ccpAdd(fromPoint_, ccp(targetSize_.width * ([((CMMSStateBall *)target.state) HP]/[((CMMSSpecBall *)target.spec) HP]),0.0f));
	
	glLineWidth(3.0f*CC_CONTENT_SCALE_FACTOR());
	ccDrawColor4F(1.0f, 0.0f, 0.0f, 0.5f);
	ccDrawLine(fromPoint_, toPoint_);
}

@end

@implementation CMMSBall

+(id)ball{
	return [[[self alloc] initBall] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	b2CMask = CMMb2ContactMaskMake(0x1005,-1,-1,1);
	
	return self;
}
-(id)initBall{
	return [self initWithFile:@"IMG_STG_ball.png"];
}

-(void)buildupObject{
	[self setSpec:[CMMSSpecBall specWithTarget:self]];
	[self setState:[CMMSStateBall stateWithTarget:self]];
}

-(void)whenContactBeganWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{
	CMMSSpecBall *spec_ = (CMMSSpecBall *)spec;
	CMMSStateBall *state_ = (CMMSStateBall *)state;
	
	state_.HP -= (float)(arc4random()%40 + 10);
	state_.bounceCount++;
	if(state_.bounceCount>=spec_.bounceCount)
		[stage.world removeObject:self];
	[stage.particle addParticleWithName:@"PAR_EFT_0001" point:contactPoint_];
	CMMSoundHandlerItem *soundItem_ = [stage.sound addSoundItemWithSoundPath:@"SND_EFT_00003.caf" soundPoint:contactPoint_];
	soundItem_.deregWhenStop = YES;
	[soundItem_ play];
}

@end

@implementation CMMSBall(Box2d)

-(void)buildupBodyWithWorld:(CMMStageWorld *)world_{
	body = [world_ createBody:b2_dynamicBody point:self.position angle:self.rotation];
	body->SetUserData(self);
	
	b2CircleShape bodyBox_;
	bodyBox_.m_radius = self.contentSize.width/2.0f/PTM_RATIO;
	b2FixtureDef fixtureDef_;
	fixtureDef_.density = 0.5f;
	fixtureDef_.friction = 0.5f;
	fixtureDef_.restitution = 1.0f;
	fixtureDef_.shape = &bodyBox_;
	
	body->CreateFixture(&fixtureDef_)->SetUserData(&b2CMask);
	body->SetFixedRotation(false);
}

@end

/*
 planet
*/

@implementation CMMSPlanet
@synthesize gravity,gravityRadius;

+(id)planetWithGravity:(float)gravity_ gravityRadius:(float)gravityRadius_{
	return [[[self alloc] initPlanetWithGravity:gravity_ gravityRadius:gravityRadius_] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	gravity = -9.8f;
	gravityRadius = 80.0f;
	_curDrawRadius = 0;
	b2CMask = CMMb2ContactMaskMake(0x1003,-1,-1,1);
	
	return self;
}
-(id)initPlanetWithGravity:(float)gravity_ gravityRadius:(float)gravityRadius_{
	if(!(self = [self initWithFile:@"IMG_STG_planet.png"])) return self;
	
	gravity = gravity_;
	gravityRadius = gravityRadius_;
	_curDrawRadius = 0;
	
	return self;
}

-(void)visit{
	[super visit];
	
	_curDrawRadius += gravity>=0?1:-1;
	if(_curDrawRadius>gravityRadius)
		_curDrawRadius = 0;
	else if(_curDrawRadius<0)
		_curDrawRadius = gravityRadius;
	
	glLineWidth(2.0f);
	ccDrawColor4F(0.0f, 0.6f, 0.5f, 0.1f);
	ccDrawCircle(self.position, gravityRadius, 0, 20, NO);
	
	glLineWidth(1.0f);
	ccDrawColor4F(0.0f, 0.3f, 1.0f, 0.05f);
	ccDrawCircle(self.position, _curDrawRadius, 0, 20, NO);
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	ccArray *objectData_ = stage.world.object_list->data;
	int count_ = objectData_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSObject *object_ = objectData_->arr[index_];
		CGPoint diffPoint_ = ccpSub(object_.position, self.position);
		float ditance_ = ccpLength(diffPoint_);
		if(object_ == self || ccpLength(diffPoint_)> gravityRadius) continue;
		
		CGPoint objectDiffPoint_ = ccpMult(ccpForAngle(ccpToAngle(diffPoint_)), gravity*(ditance_/gravityRadius));
		b2Body *objectBody_ = object_.body;
		objectBody_->ApplyForceToCenter(objectBody_->GetMass()*b2Vec2(objectDiffPoint_.x,objectDiffPoint_.y));
	}
}

@end

@implementation CMMSPlanet(Box2d)

-(void)buildupBodyWithWorld:(CMMStageWorld *)world_{
	body = [world_ createBody:b2_staticBody point:_position angle:_rotationX];
	body->SetUserData(self);
	
	b2CircleShape bodyBox_;
	bodyBox_.m_radius = (_contentSize.width/2.0f)/PTM_RATIO;
	b2FixtureDef fixtureDef_;
	fixtureDef_.density = 0.5f;
	fixtureDef_.restitution = 0.1f;
	fixtureDef_.shape = &bodyBox_;
	
	body->CreateFixture(&fixtureDef_)->SetUserData(&b2CMask);
	body->SetFixedRotation(true);
}

@end