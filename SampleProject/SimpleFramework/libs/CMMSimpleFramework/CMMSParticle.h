//  Created by JGroup(kimbobv22@gmail.com)

#import "CCParticleSystemQuad.h"

typedef enum{
	ParticleType_default,
	ParticleType_follow,
} ParticleType;

@interface CMMSParticle : CCParticleSystemQuad{
	NSString *particleName;
	ParticleType particleType;
}

+(id)particleWithParticleName:(NSString *)particleName_;
-(id)initWithParticleName:(NSString *)particleName_;

@property (nonatomic, readonly) NSString *particleName;
@property (nonatomic, readonly) ParticleType particleType;

@end

@interface CMMSParticleFollow : CMMSParticle{
	CCNode *target;
}

@property (nonatomic, retain) CCNode *target;

@end