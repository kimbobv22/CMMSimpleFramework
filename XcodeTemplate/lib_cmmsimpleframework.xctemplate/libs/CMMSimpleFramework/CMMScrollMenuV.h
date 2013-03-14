//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenu.h"

@interface CMMScrollMenuVItemDragView : CCSprite{
	int targetIndex;
}

-(void)setTextureWithMenuItem:(CMMMenuItem *)menuItem_;

@property (nonatomic, readwrite) int targetIndex;

@end

typedef CGPoint(^CMMScrollMenuVItemDragViewOffsetFilter)(CGPoint orginalPoint_, CGPoint targetPoint_,ccTime dt_);
typedef void(^CMMScrollMenuVItemDragViewCallback)(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_, void(^callback_)(void) );

@interface CMMScrollMenuV : CMMScrollMenu{	
	float dragStartDelayTime,dragStartDistance;
	
	BOOL (^filter_canDragItem)(CMMMenuItem *item_);
	CMMScrollMenuVItemDragViewOffsetFilter filter_itemDragViewOffset;
	CMMScrollMenuVItemDragViewCallback callback_itemDragViewAppeared;
	CMMScrollMenuVItemDragViewCallback callback_itemDragViewDisappeared;
}

@property (nonatomic, readwrite) float dragStartDelayTime,dragStartDistance;
@property (nonatomic, readonly) CMMScrollMenuVItemDragView *itemDragView;
@property (nonatomic, copy) BOOL (^filter_canDragItem)(CMMMenuItem *item_);
@property (nonatomic, copy) CMMScrollMenuVItemDragViewOffsetFilter filter_itemDragViewOffset;
@property (nonatomic, copy) CMMScrollMenuVItemDragViewCallback callback_itemDragViewAppeared;
@property (nonatomic, copy) CMMScrollMenuVItemDragViewCallback callback_itemDragViewDisappeared;

-(void)setFilter_canDragItem:(BOOL (^)(CMMMenuItem *item_))block_;
-(void)setFilter_itemDragViewOffset:(CMMScrollMenuVItemDragViewOffsetFilter)block_;
-(void)setCallback_itemDragViewAppeared:(CMMScrollMenuVItemDragViewCallback)block_;
-(void)setCallback_itemDragViewDisappeared:(CMMScrollMenuVItemDragViewCallback)block_;

+(void)setDefaultFilter_itemDragViewOffset:(CMMScrollMenuVItemDragViewOffsetFilter)block_;
+(void)setDefaultCallback_itemDragViewAppeared:(CMMScrollMenuVItemDragViewCallback)block_;
+(void)setDefaultCallback_itemDragViewDisappeared:(CMMScrollMenuVItemDragViewCallback)block_;

@end