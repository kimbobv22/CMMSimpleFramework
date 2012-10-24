//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface InAppMenuItem : CMMMenuItemLabelTTF{
	CCLabelTTF *labelProductName;
	NSString *productID;
	BOOL isPurchased;
}

@property (nonatomic, assign) NSString *productName;
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, readwrite) BOOL isPurchased;

@end

@interface InAppPurchaseTestLayerIndicator : CMMLayer{
	CCLabelTTF *labelState;
}

@property (nonatomic, assign) NSString *state;
@property (nonatomic, readonly) BOOL isOnShow;

@end

@interface InAppPurchaseTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMInAppPurchasesManagerDelegate,CMMScrollMenuVDelegate>{
	CMMScrollMenuV *inAppList;
	CMMMenuItemLabelTTF *restorBtn;
	InAppPurchaseTestLayerIndicator *indicatorLayer;
}

@end
