//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSSpec.h"

#define cmmVarCMMSSpecStage_gravity @"s0"
#define cmmVarCMMSSpecStage_friction @"s1"
#define cmmVarCMMSSpecStage_restitution @"s2"

@interface CMMSSpecStage : CMMSSpec{
	CGPoint gravity;
	float friction,restitution;
}

@property (nonatomic, readwrite) CGPoint gravity;
@property (nonatomic, readwrite) float friction;
@property (nonatomic, readwrite) float restitution;

@end
