//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSSpec.h"

#define cmmVarCMMSSpecStage_gravity @"s0"
#define cmmVarCMMSSpecStage_friction @"s1"
#define cmmVarCMMSSpecStage_restitution @"s2"
#define cmmVarCMMSSpecStage_density @"s2"

@interface CMMSSpecStage : CMMSSpec{
	CGPoint gravity;
	float friction,restitution,density;
}

+(id)specWithTarget:(id)target_ withStageSpecDef:(CMMStageSpecDef)stageSpecDef_;
-(id)initWithTarget:(id)target_ withStageSpecDef:(CMMStageSpecDef)stageSpecDef_;

-(void)applyWithStageSpecDef:(CMMStageSpecDef)stageSpecDef_;

@property (nonatomic, readwrite) CGPoint gravity;
@property (nonatomic, readwrite) float friction,restitution,density;

@end
