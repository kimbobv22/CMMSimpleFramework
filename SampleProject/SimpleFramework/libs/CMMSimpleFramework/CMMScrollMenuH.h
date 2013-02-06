//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenu.h"

@interface CMMScrollMenuHItem : CMMMenuItem{
	CGPoint _firstTouchPoint;
}

@property (nonatomic, readwrite) float touchCancelDistance;

@end

@interface CMMScrollMenuH : CMMScrollMenu{
	float fouceItemScale,nonefouceItemScale,minScrollAccelToSnap;
	BOOL snapAtItem,_OnSnap;
}

@property (nonatomic, readwrite) float fouceItemScale,nonefouceItemScale,minScrollAccelToSnap;
@property (nonatomic, readwrite, getter = isSnapAtItem) BOOL snapAtItem;

@end