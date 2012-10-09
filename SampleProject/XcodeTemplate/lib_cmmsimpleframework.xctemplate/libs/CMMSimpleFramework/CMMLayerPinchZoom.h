//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"

typedef enum{
	CMMPinchState_none,
	CMMPinchState_OnTouchChild,
	CMMPinchState_onPinch,
} CMMPinchState;

@interface CMMLayerPinchZoom : CMMLayer{
	CMMPinchState pinchState;
	float _touchDistance,_touchAngle;
	float pinchRateMax,pinchRateMin;
}

@property (nonatomic, readwrite) CMMPinchState pinchState;
@property (nonatomic, readwrite) float pinchRateMax,pinchRateMin;

@end
