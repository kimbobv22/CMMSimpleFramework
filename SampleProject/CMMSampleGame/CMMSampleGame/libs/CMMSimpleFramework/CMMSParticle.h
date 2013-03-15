//  Created by JGroup(kimbobv22@gmail.com)

#import "CCParticleSystemQuad.h"
#import "CMMSObject.h"

@interface CMMSParticle : CCParticleSystemQuad{
	NSString *particleName;
	CMMSObject *target;
}

+(id)particleWithParticleName:(NSString *)particleName_;
-(id)initWithParticleName:(NSString *)particleName_;

@property (nonatomic, readonly) NSString *particleName;
@property (nonatomic, retain) CMMSObject *target;

@end