//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMInAppPurchasesManager.h"
#import "CMMConnectionMonitor.h"

static CMMInAppPurchasesManager *_sharedCMMInAppPurchasesManager_ = nil;

@implementation CMMInAppPurchasesManager
@synthesize delegate,products,productsCount,state;

+(CMMInAppPurchasesManager *)sharedManager{
	if(!_sharedCMMInAppPurchasesManager_){
		_sharedCMMInAppPurchasesManager_ = [[CMMInAppPurchasesManager alloc] init];
	}
	
	return _sharedCMMInAppPurchasesManager_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	products = [[CCArray alloc] init];
	
	if([self state] != CMMInAppPurchasesManagerState_notSupported){
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	
	return self;
}

-(uint)productsCount{
	return [products count];
}

-(CMMInAppPurchasesManagerState)state{
	CMMInAppPurchasesManagerState state_ = CMMInAppPurchasesManagerState_onAvailable;
	if([[CMMConnectionMonitor sharedMonitor] connectionStatus] == CMMConnectionStatus_noConnection){
		state_ = CMMInAppPurchasesManagerState_noConnection;
	}
	
	if(![SKPaymentQueue canMakePayments]){
		state_ = CMMInAppPurchasesManagerState_notSupported;
	}
	
	return state_;
}

-(void)loadProductsWithProductIDs:(NSSet *)productIDs_{
	if([self state] != CMMInAppPurchasesManagerState_onAvailable) return;
	
	SKProductsRequest *request_ = [[[SKProductsRequest alloc] initWithProductIdentifiers:productIDs_] autorelease];
	[request_ setDelegate:self];
	[request_ start];
}

-(void)restorePurchases{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
	//adding products
	[products removeAllObjects];
	NSArray *products_ = [response products];
	for(SKProduct *product_ in products_){
		[products addObject:product_];
	}
	
	if(cmmFunc_respondsToSelector(delegate, @selector(inAppPurchasesManagerDidReceiveProducts:))){
		[delegate inAppPurchasesManagerDidReceiveProducts:self];
	}
}
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
	if(cmmFunc_respondsToSelector(delegate, @selector(inAppPurchasesManager:didFailedReceivingProductsWithError:))){
		[delegate inAppPurchasesManager:self didFailedReceivingProductsWithError:error];
	}
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
	for(SKPaymentTransaction *transaction_ in transactions){
		SKPaymentTransactionState state_ = [transaction_ transactionState];
		if(cmmFunc_respondsToSelector(delegate, @selector(inAppPurchasesManager:paymentTransaction:didUpdateState:))){
			[delegate inAppPurchasesManager:self paymentTransaction:transaction_ didUpdateState:state_];
		}
		
		switch(state_){
			case SKPaymentTransactionStatePurchased :
			case SKPaymentTransactionStateFailed :
			case SKPaymentTransactionStateRestored :
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction_];
				break;
			default: break;
		}
	}
}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
	if(cmmFunc_respondsToSelector(delegate, @selector(inAppPurchasesManager:didFailedRestoreWithError:))){
		[delegate inAppPurchasesManager:self didFailedRestoreWithError:error];
	}
}

-(void)dealloc{
	[products release];
	[super dealloc];
}

@end

@implementation CMMInAppPurchasesManager(ProductManager)

-(void)purchaseProduct:(SKProduct *)product_{
	if([self state] != CMMInAppPurchasesManagerState_onAvailable || !product_) return;
	
	SKPaymentQueue *defaultQueue_ = [SKPaymentQueue defaultQueue];
	[defaultQueue_ addPayment:[SKPayment paymentWithProduct:product_]];
}
-(void)purchaseProductAtIndex:(uint)index_{
	[self purchaseProduct:[self productAtIndex:index_]];
}
-(void)purchaseProductAtProductID:(NSString *)productID_{
	[self purchaseProduct:[self productAtProductID:productID_]];
}

-(SKProduct *)productAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [products objectAtIndex:index_];
}
-(SKProduct *)productAtProductID:(NSString *)productID_{
	return [self productAtIndex:[self indexOfProductID:productID_]];
}

-(uint)indexOfProductID:(NSString *)productID_{
	ccArray *data_ = products->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		SKProduct *product_ = data_->arr[index_];
		if([[product_ productIdentifier] isEqualToString:productID_])
			return index_;
	}
	
	return NSNotFound;
}

@end