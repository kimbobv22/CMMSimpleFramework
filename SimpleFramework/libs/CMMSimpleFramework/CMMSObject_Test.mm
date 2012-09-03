//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSObject_Test.h"
#import "CMMStage.h"

@implementation CMMSSpecBall
@synthesize HP,AP,bounceCount;

-(id)initWithTarget:(id)target_{
	if(!(self = [super initWithTarget:target_])) return self;
	
	HP = 100.0f;
	AP = 40.0f;
	bounceCount = arc4random()%7;
	
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

@implementation CMMSBall

+(id)ball{
	return [[[self alloc] initBall] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	b2CMask = CMMb2ContactMask(0x1005,-1,-1,1);
	
	return self;
}
-(id)initBall{
	return [self initWithFile:@"IMG_STG_ball.png"];
}

-(void)buildupObject{
	spec = [[CMMSSpecBall alloc] initWithTarget:self];
	state = [[CMMSStateBall alloc] initWithTarget:self];
}

-(void)whenContractWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{
	if(fixtureType_ == otherFixtureType_)
		((CMMSStateBall *)state).HP -= ((CMMSSpecBall *)spec).AP;
	
	[self doCollisionEvent:contactPoint_];
}

@end

@implementation CMMSBall(Box2d)

-(void)buildupBody{
	body = [stage.world createBody:b2_dynamicBody point:self.position angle:self.rotation];
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

-(void)doCollisionEvent:(CGPoint)contactPoint_{
	CMMSSpecBall *spec_ = (CMMSSpecBall *)spec;
	CMMSStateBall *state_ = (CMMSStateBall *)state;
	
	state_.bounceCount++;
	if(state_.bounceCount>=spec_.bounceCount)
		[stage.world removeObject:self];
	[stage.particle addParticleWithName:@"PAR_EFT_0001" point:contactPoint_];
	CMMSoundHandlerItem *soundItem_ = [stage.sound addSoundItem:@"SND_EFT_00003.caf" soundPoint:contactPoint_];
	soundItem_.deregWhenStop = YES;
	[soundItem_ play];
}

@end