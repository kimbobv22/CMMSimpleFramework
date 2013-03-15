//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMacro.h"
#import "CMMSimpleCache.h"
#import "CMMTouchDispatcher.h"
#import "CMMLayer.h"

@interface CMMPopupLayer : CMMLayer{
	BOOL lazyCleanup;
	void (^callback_didOpen)(CMMPopupLayer *popup_),(^callback_didClose)(CMMPopupLayer *popup_);
	void (^callback_becomeHeadPopup)(CMMPopupLayer *popup_),(^callback_resignHeadPopup)(CMMPopupLayer *popup_);
}

-(void)close;

@property (nonatomic, readwrite, getter = isLazyCleanup) BOOL lazyCleanup;
@property (nonatomic, copy) void (^callback_didOpen)(CMMPopupLayer *popup_),(^callback_didClose)(CMMPopupLayer *popup_);
@property (nonatomic, copy) void (^callback_becomeHeadPopup)(CMMPopupLayer *popup_),(^callback_resignHeadPopup)(CMMPopupLayer *popup_);

-(void)setCallback_didOpen:(void (^)(CMMPopupLayer *popup_))block_;
-(void)setCallback_didClose:(void (^)(CMMPopupLayer *popup_))block_;
-(void)setCallback_becomeHeadPopup:(void (^)(CMMPopupLayer *popup_))block_;
-(void)setCallback_resignHeadPopup:(void (^)(CMMPopupLayer *popup_))block_;

@end

@interface CMMPopupView : CMMLayer{
	CCArray *popupList;
	CCNode<CCRGBAProtocol> *backgroundNode;
	BOOL showOnlyOne;
	
	CMMPopupLayer *headPopup;
	void (^callback_whenHeadPopupChanged)(CMMPopupLayer *headPopup_,CMMPopupLayer *beforeHeadPopup_);
}

+(id)popupView;

-(void)addPopup:(CMMPopupLayer *)popup_ atIndex:(uint)index_;
-(void)addPopup:(CMMPopupLayer *)popup_;

-(void)removePopup:(CMMPopupLayer *)popup_;
-(void)removePopupAtIndex:(uint)index_;

-(void)switchPopup:(CMMPopupLayer *)popup_ toIndex:(uint)toIndex_;
-(void)switchPopupAtIndex:(uint)atIndex_ toIndex:(uint)toIndex_;

-(CMMPopupLayer *)popupAtIndex:(uint)index_;
-(uint)indexOfPopup:(CMMPopupLayer *)popup_;

@property (nonatomic, readonly) CCArray *popupList;
@property (nonatomic, readonly) uint count;
@property (nonatomic, readonly) CMMPopupLayer *headPopup;
@property (nonatomic, retain, setter = addBackgroundNode:) CCNode<CCRGBAProtocol> *backgroundNode;
@property (nonatomic, readwrite, getter = isShowOnlyOne) BOOL showOnlyOne;
@property (nonatomic, copy) void (^callback_whenHeadPopupChanged)(CMMPopupLayer *headPopup_,CMMPopupLayer *beforeHeadPopup_);

-(void)setCallback_whenHeadPopupChanged:(void (^)(CMMPopupLayer *headPopup_,CMMPopupLayer *beforeHeadPopup_))block_;

@end
