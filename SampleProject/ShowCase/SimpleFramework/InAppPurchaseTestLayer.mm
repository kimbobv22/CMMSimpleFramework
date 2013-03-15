//  Created by JGroup(kimbobv22@gmail.com)

#import "InAppPurchaseTestLayer.h"
#import "HelloWorldLayer.h"

@implementation InAppMenuItem
@synthesize productName,productID,isPurchased;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	labelProductName = [CMMFontUtil labelWithString:@" " fontSize:10];
	[self addChild:labelProductName];
	isPurchased = NO;
	
	return self;
}

-(void)setProductName:(NSString *)productName_{
	[labelProductName setString:productName_];
	[self updateDisplay];
}
-(NSString *)productName{
	return [labelProductName string];
}

-(void)setIsPurchased:(BOOL)isPurchased_{
	isPurchased = isPurchased_;
	if(isPurchased){
		[self setTitle:@"Purchased"];
	}
}

-(void)updateDisplay{
	[super updateDisplay];
	[labelProductName setPosition:ccp([labelProductName contentSize].width/2.0f + 10.0f,_contentSize.height-([labelProductName contentSize].height/2.0f + 10.0f))];
}

-(void)dealloc{
	[productID release];
	[super dealloc];
}

@end

@implementation InAppPurchaseTestLayerIndicator
@synthesize state,isOnShow;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	labelState = [CMMFontUtil labelWithString:@" "];
	[self addChild:labelState];
	
	[self setOpacity:120];
	
	return self;
}

-(void)setState:(NSString *)state_{
	[labelState setString:state_];
	[labelState setPosition:cmmFunc_positionIPN(self, labelState)];
}
-(NSString *)state{
	return [labelState string];
}

-(BOOL)isOnShow{
	return [self parent] != nil;
}

@end

@interface InAppPurchaseTestLayer(Indicator)

-(void)switchIndicatorTo:(BOOL)doShow_ withState:(NSString *)state_;

@end

@implementation InAppPurchaseTestLayer(Indicator)

-(void)switchIndicatorTo:(BOOL)doShow_ withState:(NSString *)state_{
	[indicatorLayer removeFromParentAndCleanup:NO];
	if(doShow_){
		[self addChild:indicatorLayer];
		[indicatorLayer setState:state_];
	}
}

@end

@implementation InAppPurchaseTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	inAppList = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(_contentSize.width*0.6f, _contentSize.height*0.6f)];
	[inAppList setCallback_whenTapAtIndex:^(int index_) {
		InAppMenuItem *inAppItem_ = (InAppMenuItem *)[inAppList itemAtIndex:index_];
		if([inAppItem_ isPurchased]) return;
		[[CMMInAppPurchasesManager sharedManager] purchaseProductAtProductID:[inAppItem_ productID]];
		[self switchIndicatorTo:YES withState:@"Purchasing..."];
	}];
	[inAppList setPosition:ccpAdd(cmmFunc_positionIPN(self, inAppList), ccp(0,20.0f))];
	[self addChild:inAppList];
	
	restorBtn = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[restorBtn setTitle:@"RESTORE"];
	restorBtn.position = ccp(_contentSize.width-restorBtn.contentSize.width/2,restorBtn.contentSize.height/2);
	restorBtn.callback_pushup = ^(id sender_){
		[[CMMInAppPurchasesManager sharedManager] restorePurchases];
		[self switchIndicatorTo:YES withState:@"Restoring..."];
	};
	[self addChild:restorBtn];
	
	indicatorLayer = [[InAppPurchaseTestLayerIndicator alloc] init];
	
	CMMMenuItemL *menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"BACK"];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerForKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBtn_];
	
	CCLabelTTF *labelNotice_ = [CMMFontUtil labelWithString:@"test account : cmmsimpleframework@test.com / Testuser1" fontSize:12];
	[labelNotice_ setPosition:ccp(inAppList.position.x+labelNotice_.contentSize.width/2.0f,inAppList.position.y-labelNotice_.contentSize.height/2.0f-5.0f)];
	[self addChild:labelNotice_];
	
	CMMInAppPurchasesManager *inAppManager_ = [CMMInAppPurchasesManager sharedManager];
	[inAppManager_ setDelegate:self];
	[inAppManager_ loadProductsWithProductIDs:[NSSet setWithObjects:@"com.jgroup.cmmsimpleframework.00001",@"com.jgroup.cmmsimpleframework.00002", nil]];
	[self switchIndicatorTo:YES withState:@"Loading..."];
	
	return self;
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return ![indicatorLayer isOnShow];
}

-(void)inAppPurchasesManagerDidReceiveProducts:(CMMInAppPurchasesManager *)manager_{
	CCLOG(@"received products count : %d",[manager_ productsCount]);
	[inAppList removeAllItems];
	CGSize itemSize_ = CGSizeMake(inAppList.contentSize.width, 40);
	CCArray *productList_ = [manager_ products];
	for(SKProduct *product_ in productList_){
		InAppMenuItem *item_ = [InAppMenuItem menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:itemSize_];
		[item_ setTitleAlign:kCCTextAlignmentRight];
		[item_ setProductID:[product_ productIdentifier]];
		[item_ setProductName:[product_ localizedTitle]];
		[item_ setTitle:[[product_ price] descriptionWithLocale:[product_ priceLocale]]];
		[inAppList addItem:item_];
	}
	[self switchIndicatorTo:NO withState:nil];
}
-(void)inAppPurchasesManager:(CMMInAppPurchasesManager *)manager_ paymentTransaction:(SKPaymentTransaction *)paymentTransaction_ didUpdateState:(SKPaymentTransactionState)state_{
	switch(state_){
		case SKPaymentTransactionStatePurchased:
			[self switchIndicatorTo:YES withState:@"Completed Purchase !"];
			[self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:1.0f] two:[CCCallBlock actionWithBlock:^{
				[self switchIndicatorTo:NO withState:nil];
			}]]];
			break;
		case SKPaymentTransactionStateRestored:
			for(InAppMenuItem *inAppItem_ in inAppList){
				if([[inAppItem_ productID] isEqualToString:[[paymentTransaction_ payment] productIdentifier]]){
					[inAppItem_ setIsPurchased:YES];
					break;
				}
			}
			
			[self switchIndicatorTo:NO withState:nil];
			break;
		case SKPaymentTransactionStateFailed:
			[self switchIndicatorTo:NO withState:nil];
			break;
		case SKPaymentTransactionStatePurchasing:
		default: break;
	}
}
-(void)inAppPurchasesManager:(CMMInAppPurchasesManager *)manager_ didFailedRestoreWithError:(NSError *)error_{
	[self switchIndicatorTo:YES withState:@"Failed restore!"];
	[self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:1.0f] two:[CCCallBlock actionWithBlock:^{
		[self switchIndicatorTo:NO withState:nil];
	}]]];
}

-(void)cleanup{
	[[CMMInAppPurchasesManager sharedManager] setDelegate:nil];
	[super cleanup];
}

-(void)dealloc{
	[indicatorLayer release];
	[super dealloc];
}

@end
