//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSObject.h"
#import "CMMSoundEngine.h"

/**
 objects for test
 **/

#define cmmVarCMMSSpecBall_HP @"ball00"
#define cmmVarCMMSSpecBall_AP @"ball01"
#define cmmVarCMMSSpecBall_bounceCount @"ball02"

@interface CMMSSpecBall : CMMSSpecObject{
	float HP,AP;
	int bounceCount;
}

@property (nonatomic, readwrite) float HP,AP;
@property (nonatomic, readwrite) int bounceCount;

@end

@interface CMMSStateBall : CMMSStateObject{
	float HP;
	int bounceCount;
}

@property (nonatomic, readwrite) float HP;
@property (nonatomic, readwrite) int bounceCount;

@end

@interface CMMSBall : CMMSObject

+(id)ball;
-(id)initBall;

@end