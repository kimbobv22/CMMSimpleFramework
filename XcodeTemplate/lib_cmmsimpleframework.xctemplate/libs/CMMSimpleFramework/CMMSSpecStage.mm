//  Created by Kim Jazz on 12. 8. 8..

#import "CMMSSpecStage.h"
#import "CMMStage.h"

#define cmmFuncCMMSSpecStage_LoopFixtureOfWorldBody(_varFixture_,_worldBody_) for((_varFixture_) = (_worldBody_)->GetFixtureList();(_varFixture_);(_varFixture_) = (_varFixture_)->GetNext())

@implementation CMMSSpecStage
@synthesize gravity,friction,restitution,density,brightness;

+(id)specWithTarget:(id)target_ withStageDef:(CMMStageDef)stageDef_{
	return [[[self alloc] initWithTarget:target_ withStageDef:stageDef_] autorelease];
}

-(id)initWithTarget:(id)target_{
	if(!(self = [super initWithTarget:target_])) return self;
	
	specType = 0x3001;
	friction = 0.5f;
	restitution = 0.3f;
	density = 0.7f;
	brightness = 1.0f;
	
	return self;
}

-(id)initWithTarget:(id)target_ withStageDef:(CMMStageDef)stageDef_{
	if(!(self = [self initWithTarget:target_])) return self;
	
	[self applyWithStageDef:stageDef_];
	
	return self;
}

-(void)setFriction:(float)friction_{
	friction = friction_;
	
	CMMStage *stage_ = target;
	CMMStageWorld *world_ = [stage_ world];
	if(!stage_ || !world_) return;
	
	b2Fixture *fixture_;
	cmmFuncCMMSSpecStage_LoopFixtureOfWorldBody(fixture_,world_.worldBody){
		fixture_->SetFriction(friction);
	}
}
-(void)setRestitution:(float)restitution_{
	restitution = restitution_;
	
	CMMStage *stage_ = target;
	CMMStageWorld *world_ = [stage_ world];
	if(!stage_ || !world_) return;
	
	b2Fixture *fixture_;
	cmmFuncCMMSSpecStage_LoopFixtureOfWorldBody(fixture_,world_.worldBody){
		fixture_->SetRestitution(restitution);
	}
}

-(void)setDensity:(float)density_{
	density = density_;
	
	CMMStage *stage_ = target;
	CMMStageWorld *world_ = [stage_ world];
	if(!stage_ || !world_) return;
	
	b2Fixture *fixture_;
	cmmFuncCMMSSpecStage_LoopFixtureOfWorldBody(fixture_,world_.worldBody){
		fixture_->SetDensity(density);
	}
}

-(void)applyWithStageDef:(CMMStageDef)stageDef_{
	[self setGravity:stageDef_.gravity];
	[self setFriction:stageDef_.friction];
	[self setRestitution:stageDef_.restitution];
	[self setDensity:stageDef_.density];
	[self setBrightness:stageDef_.brightness];
}

-(id)initWithCoder:(NSCoder *)decoder_{
	if(!(self = [self initWithCoder:decoder_])) return self;
	
	gravity = [decoder_ decodeCGPointForKey:cmmVarCMMSSpecStage_gravity];
	friction = [decoder_ decodeFloatForKey:cmmVarCMMSSpecStage_friction];
	restitution = [decoder_ decodeFloatForKey:cmmVarCMMSSpecStage_restitution];
	density = [decoder_ decodeFloatForKey:cmmVarCMMSSpecStage_density];
	brightness = [decoder_ decodeFloatForKey:cmmVarCMMSSpecStage_brightness];
	
	return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder_{
	[super encodeWithCoder:encoder_];
	[encoder_ encodeCGPoint:gravity forKey:cmmVarCMMSSpecStage_gravity];
	[encoder_ encodeFloat:friction forKey:cmmVarCMMSSpecStage_gravity];
	[encoder_ encodeFloat:restitution forKey:cmmVarCMMSSpecStage_gravity];
	[encoder_ encodeFloat:restitution forKey:cmmVarCMMSSpecStage_density];
	[encoder_ encodeFloat:brightness forKey:cmmVarCMMSSpecStage_brightness];
}

-(id)copyWithZone:(NSZone *)zone_{
	CMMSSpecStage *copy_ = [super copyWithZone:zone_];
	[copy_ setGravity:gravity];
	[copy_ setFriction:friction];
	[copy_ setRestitution:restitution];
	[copy_ setDensity:density];
	[copy_ setBrightness:brightness];
	
	return copy_;
}

@end
