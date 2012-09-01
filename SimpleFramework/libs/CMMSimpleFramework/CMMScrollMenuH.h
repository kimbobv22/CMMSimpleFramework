//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenu.h"

@protocol CMMScrollMenuVDelegate <CMMScrollMenuDelegate>

@optional

@end

@interface CMMScrollMenuVItem : CMMLayer{
	float touchCancelDistance;
	CGPoint _firstTouchPoint;
}

@property (nonatomic, readwrite) float touchCancelDistance;

@end

@interface CMMScrollMenuV : CMMScrollMenu{
	float fouceItemScale,nonefouceItemScale,minScrollAccelToSnap;
	BOOL isSnapAtItem;
}

@property (nonatomic, readwrite) float fouceItemScale,nonefouceItemScale,minScrollAccelToSnap;
@property (nonatomic, readwrite) BOOL isSnapAtItem;

@end