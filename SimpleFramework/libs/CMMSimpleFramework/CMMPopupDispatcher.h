//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMacro.h"

@class CMMScene;
@class CMMLayerPopup;

#define cmmVarCMMPopupDispather_defaultCacheCount 20
#define cmmVarCMMPopupDispatcher_defaultPopupZOrder 999

@class CMMPopupDispatcherItem;

@protocol CMMPopupDispatcherDelegate<NSObject>

@optional
-(void)popupDispatcher:(CMMPopupDispatcherItem *)popupItem_ whenClosedWithReceivedData:(id)data_;

@end

@interface CMMPopupDispatcherItem : NSObject{
	CMMLayerPopup *popup;
	id<CMMPopupDispatcherDelegate> delegate;
}

+(id)popupItemWithPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_;
-(id)initWithPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_;

@property (nonatomic, retain) CMMLayerPopup *popup;
@property (nonatomic, retain) id<CMMPopupDispatcherDelegate> delegate;

@end

@interface CMMPopupDispatcher : NSObject{
	CMMScene *scene;
	CCArray *popupList;
	CMMLayerPopup *curPopup;
}

+(id)popupDispatcherWithScene:(CMMScene *)scene_;
-(id)initWithScene:(CMMScene *)scene_;

@property (nonatomic, assign) CMMScene *scene;
@property (nonatomic, readonly) CCArray *popupList;
@property (nonatomic, readonly) int popupCount;
@property (nonatomic, readonly) CMMLayerPopup *curPopup;

@end

@interface CMMPopupDispatcher(Common)

-(void)addPopupItem:(CMMPopupDispatcherItem *)popupItem_ atIndex:(int)index_;
-(CMMPopupDispatcherItem *)addPopupItemWithPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_ atIndex:(int)index_;
-(CMMPopupDispatcherItem *)addPopupItemWithPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_;

-(void)removePopupItem:(CMMPopupDispatcherItem *)popupItem_ withData:(id)data_;
-(void)removePopupItem:(CMMPopupDispatcherItem *)popupItem_;
-(void)removePopupItemAtIndex:(int)index_ withData:(id)data_;
-(void)removePopupItemAtIndex:(int)index_;
-(void)removePopupItemAtPopup:(CMMLayerPopup *)popup_ withData:(id)data_;
-(void)removePopupItemAtPopup:(CMMLayerPopup *)popup_;

-(CMMPopupDispatcherItem *)popupItemAtIndex:(int)index_;

-(int)indexOfPopupItem:(CMMPopupDispatcherItem *)popupItem_;
-(int)indexOfPopup:(CMMLayerPopup *)popup_;

@end