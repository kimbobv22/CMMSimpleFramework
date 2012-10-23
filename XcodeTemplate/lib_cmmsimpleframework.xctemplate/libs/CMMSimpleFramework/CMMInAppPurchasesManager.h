//  Created by JGroup(kimbobv22@gmail.com)

#import <StoreKit/StoreKit.h>
#import "CMMMacro.h"

@class CMMInAppPurchasesManager;

@protocol CMMInAppPurchasesManagerDelegate <NSObject>

-(void)inAppPurchasesManager:(CMMInAppPurchasesManager *)manager_ paymentTransaction:(SKPaymentTransaction *)paymentTransaction_ didUpdateState:(SKPaymentTransactionState)state_;

@optional
-(void)inAppPurchasesManagerDidReceiveProducts:(CMMInAppPurchasesManager *)manager_;
-(void)inAppPurchasesManager:(CMMInAppPurchasesManager *)manager_ didFailedReceivingProductsWithError:(NSError *)error_;
-(void)inAppPurchasesManager:(CMMInAppPurchasesManager *)manager_ didFailedRestoreWithError:(NSError *)error_;

@end

typedef enum{
	CMMInAppPurchasesManagerState_onAvailable,
	CMMInAppPurchasesManagerState_noConnection,
	CMMInAppPurchasesManagerState_notSupported,
} CMMInAppPurchasesManagerState;

@interface CMMInAppPurchasesManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>{
	id<CMMInAppPurchasesManagerDelegate> delegate;
	CCArray *products;
}

+(CMMInAppPurchasesManager *)sharedManager;

-(void)loadProductsWithProductIDs:(NSSet *)productIDs_;
-(void)restorePurchases;

@property (nonatomic, assign) id<CMMInAppPurchasesManagerDelegate> delegate;
@property (nonatomic, retain) CCArray *products;
@property (nonatomic, readonly) uint productsCount;
@property (nonatomic, readonly) CMMInAppPurchasesManagerState state;

@end

@interface CMMInAppPurchasesManager(ProductManager)

-(void)purchaseProduct:(SKProduct *)product_;
-(void)purchaseProductAtIndex:(uint)index_;
-(void)purchaseProductAtProductID:(NSString *)productID_;

-(SKProduct *)productAtIndex:(uint)index_;
-(SKProduct *)productAtProductID:(NSString *)productID_;

-(uint)indexOfProductID:(NSString *)productID_;

@end
