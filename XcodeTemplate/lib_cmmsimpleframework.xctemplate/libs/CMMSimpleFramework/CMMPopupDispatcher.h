//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMacro.h"
#import "CMMSimpleCache.h"
#import "CMMTouchDispatcher.h"
#import "CMMLayer.h"

#define cmmVarCMMPopupDispather_defaultCacheCount 20
#define cmmVarCMMPopupDispatcher_defaultPopupZOrder NSIntegerMax

@class CMMPopupLayer;
@class CMMPopupDispatcher;
@class CMMPopupDispatcherItem;

@protocol CMMPopupLayerDelegate <NSObject>

-(void)popup:(CMMPopupLayer *)popup_ didCloseWithReceivedData:(id)data_;

@end

@interface CMMPopupLayer : CMMLayer{
	CMMPopupDispatcherItem *popupDispatcherItem;
	BOOL lazyCleanup;
}

-(void)closeWithSendData:(id)data_;
-(void)close;

@property (nonatomic, assign) CMMPopupDispatcherItem *popupDispatcherItem;
@property (nonatomic, readwrite, getter = isLazyCleanup) BOOL lazyCleanup;

@end

@protocol CMMPopupDispatcherDelegate<NSObject>

@optional
-(void)popupDispatcher:(CMMPopupDispatcher *)popupDispatcher_ didOpenPopup:(CMMPopupLayer *)popup_;
-(void)popupDispatcher:(CMMPopupDispatcher *)popupDispatcher_ didClosePopup:(CMMPopupLayer *)popup_ withReceivedData:(id)data_;

-(void)popupDispatcher:(CMMPopupDispatcherItem *)popupItem_ whenClosedWithReceivedData:(id)data_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMPopupDispatcherItem : NSObject<CMMPopupLayerDelegate>{
	CMMPopupDispatcher *popupDispatcher;
	CMMPopupLayer *popup;
	id<CMMPopupDispatcherDelegate> delegate;
}

+(id)popupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_;
-(id)initWithPopup:(CMMPopupLayer *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_;

@property (nonatomic, assign) CMMPopupDispatcher *popupDispatcher;
@property (nonatomic, retain) CMMPopupLayer *popup;
@property (nonatomic, assign) id<CMMPopupDispatcherDelegate> delegate;

@end

@interface CMMPopupMasterView : CMMLayer{
	CMMPopupDispatcher *popupDispatcher;
	CCNode<CCRGBAProtocol> *backgroundNode;
	BOOL showOnlyOne;
}

+(id)viewWithPopupDispatcher:(CMMPopupDispatcher *)popupDispatcher_;
-(id)initWithPopupDispatcher:(CMMPopupDispatcher *)popupDispatcher_;

@property (nonatomic, retain, setter = addBackgroundNode:) CCNode<CCRGBAProtocol> *backgroundNode;
@property (nonatomic, readwrite, getter = isShowOnlyOne) BOOL showOnlyOne;

@end

@interface CMMPopupDispatcher : NSObject{
	CCNode *target;
	CCArray *popupList;
	
	CMMPopupMasterView *masterView;
}

+(id)popupDispatcherWithTarget:(CCNode *)target_;
-(id)initWithTarget:(CCNode *)target_;

@property (nonatomic, assign) CCNode *target;
@property (nonatomic, readonly) CCArray *popupList;
@property (nonatomic, readonly) int popupCount;
@property (nonatomic, readonly) CMMPopupLayer *headPopup;
@property (nonatomic, readonly) CMMPopupMasterView *masterView;

@end

@interface CMMPopupDispatcher(Common)

-(void)addPopupItem:(CMMPopupDispatcherItem *)popupItem_ atIndex:(int)index_;
-(CMMPopupDispatcherItem *)addPopupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_ atIndex:(int)index_;
-(CMMPopupDispatcherItem *)addPopupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_;

-(void)removePopupItem:(CMMPopupDispatcherItem *)popupItem_ withData:(id)data_;
-(void)removePopupItem:(CMMPopupDispatcherItem *)popupItem_;
-(void)removePopupItemAtIndex:(int)index_ withData:(id)data_;
-(void)removePopupItemAtIndex:(int)index_;
-(void)removePopupItemAtPopup:(CMMPopupLayer *)popup_ withData:(id)data_;
-(void)removePopupItemAtPopup:(CMMPopupLayer *)popup_;

-(CMMPopupDispatcherItem *)popupItemAtIndex:(int)index_;

-(int)indexOfPopupItem:(CMMPopupDispatcherItem *)popupItem_;
-(int)indexOfPopup:(CMMPopupLayer *)popup_;

@end