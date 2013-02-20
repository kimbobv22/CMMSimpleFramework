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

@interface CMMSBallStateView : CMMSObjectSView

@end

@interface CMMSBall : CMMSObject

+(id)ball;
-(id)initBall;

@end

/*
 planet
*/

@interface CMMSPlanet : CMMSObject{
	float gravity,gravityRadius,_curDrawRadius;
}

+(id)planetWithGravity:(float)gravity_ gravityRadius:(float)gravityRadius_;
-(id)initPlanetWithGravity:(float)gravity_ gravityRadius:(float)gravityRadius_;

@property (nonatomic, readwrite) float gravity,gravityRadius;

@end