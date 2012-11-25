//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSSpec.h"

#define cmmVarCMMSSpecStage_gravity @"s0"
#define cmmVarCMMSSpecStage_friction @"s1"
#define cmmVarCMMSSpecStage_restitution @"s2"
#define cmmVarCMMSSpecStage_density @"s2"
#define cmmVarCMMSSpecStage_brightness @"s3"

@interface CMMSSpecStage : CMMSSpec{
	CGPoint gravity;
	float friction,restitution,density,brightness;
}

+(id)specWithTarget:(id)target_ withStageDef:(CMMStageDef)stageDef_;
-(id)initWithTarget:(id)target_ withStageDef:(CMMStageDef)stageDef_;

-(void)applyWithStageDef:(CMMStageDef)stageDef_;

@property (nonatomic, readwrite) CGPoint gravity;
@property (nonatomic, readwrite) float friction,restitution,density,brightness;

@end
