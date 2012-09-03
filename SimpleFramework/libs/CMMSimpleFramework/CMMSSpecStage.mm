//  Created by Kim Jazz on 12. 8. 8..

#import "CMMSSpecStage.h"
#import "CMMStage.h"

#define cmmFuncCMMSSpecStage_LoopFixtureOfWorldBody(_varFixture_,_worldBody_) for((_varFixture_) = (_worldBody_)->GetFixtureList();(_varFixture_);(_varFixture_) = (_varFixture_)->GetNext())

@implementation CMMSSpecStage
@synthesize gravity,friction,restitution;

-(id)initWithTarget:(id)target_{
	if(!(self = [super initWithTarget:target_])) return self;
	
	specType = 0x3001;
	
	return self;
}

-(void)setFriction:(float)friction_{
	friction = friction_;
	if(!target) return;
	
	CMMStageWorld *world_ = ((CMMStage *)target).world;
	b2Fixture *fixture_;
	cmmFuncCMMSSpecStage_LoopFixtureOfWorldBody(fixture_,world_.worldBody){
		fixture_->SetFriction(friction);
	}
}
-(void)setRestitution:(float)restitution_{
	restitution = restitution_;
	if(!target) return;
	
	CMMStageWorld *world_ = ((CMMStage *)target).world;
	b2Fixture *fixture_;
	cmmFuncCMMSSpecStage_LoopFixtureOfWorldBody(fixture_,world_.worldBody){
		fixture_->SetRestitution(restitution);
	}
}

-(id)initWithCoder:(NSCoder *)decoder_{
	if(!(self = [self initWithCoder:decoder_])) return self;
	
	gravity = [decoder_ decodeCGPointForKey:cmmVarCMMSSpecStage_gravity];
	friction = [decoder_ decodeFloatForKey:cmmVarCMMSSpecStage_friction];
	restitution = [decoder_ decodeFloatForKey:cmmVarCMMSSpecStage_restitution];
	
	return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder_{
	[super encodeWithCoder:encoder_];
	[encoder_ encodeCGPoint:gravity forKey:cmmVarCMMSSpecStage_gravity];
	[encoder_ encodeFloat:friction forKey:cmmVarCMMSSpecStage_gravity];
	[encoder_ encodeFloat:restitution forKey:cmmVarCMMSSpecStage_gravity];
}

-(id)copyWithZone:(NSZone *)zone_{
	CMMSSpecStage *copy_ = [super copyWithZone:zone_];
	copy_.gravity = gravity;
	copy_.friction = friction;
	copy_.restitution = restitution;
	
	return copy_;
}

@end
