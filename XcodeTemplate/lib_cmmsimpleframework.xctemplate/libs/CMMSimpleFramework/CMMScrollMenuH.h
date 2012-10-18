//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenu.h"

@protocol CMMScrollMenuHDelegate <CMMScrollMenuDelegate>

@optional

@end

@interface CMMScrollMenuHItem : CMMMenuItem{
	CGPoint _firstTouchPoint;
}

@property (nonatomic, readwrite) float touchCancelDistance;

@end

@interface CMMScrollMenuH : CMMScrollMenu{
	float fouceItemScale,nonefouceItemScale,minScrollAccelToSnap;
	BOOL isSnapAtItem,_isOnSnap;
}

@property (nonatomic, readwrite) float fouceItemScale,nonefouceItemScale,minScrollAccelToSnap;
@property (nonatomic, readwrite) BOOL isSnapAtItem;

@end