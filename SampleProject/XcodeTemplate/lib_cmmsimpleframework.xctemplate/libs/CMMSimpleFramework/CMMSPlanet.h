//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSObject.h"

@interface CMMSPlanet : CMMSObject{
	float gravity,gravityRadius,_curDrawRadius;
}

+(id)planetWithGravity:(float)gravity_ gravityRadius:(float)gravityRadius_;
-(id)initPlanetWithGravity:(float)gravity_ gravityRadius:(float)gravityRadius_;

@property (nonatomic, readwrite) float gravity,gravityRadius;

@end