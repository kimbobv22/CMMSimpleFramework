//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenu.h"

@interface CMMScrollMenuHItem : CMMMenuItem

@end

@interface CMMScrollMenuH : CMMScrollMenu{
	BOOL snapAtItem;
	float targetScrollSpeedToPass;
}

@property (nonatomic, readwrite, getter = isSnapAtItem) BOOL snapAtItem;
@property (nonatomic, readwrite) float targetScrollSpeedToPass;

@end