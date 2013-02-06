//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenu.h"

@interface CMMScrollMenuVItemDragView : CCSprite{
	int targetIndex;
}

@property (nonatomic, readwrite) int targetIndex;

@end

@interface CMMScrollMenuV : CMMScrollMenu{
	CMMScrollMenuVItemDragView *_itemDragView;
	ccTime _curDragStartDelayTime;
	CGPoint _firstTouchPoint;
	
	float dragStartDelayTime,dragStartDistance;
	
	BOOL (^filter_canDragItem)(CMMMenuItem *item_);
	CGPoint (^filter_offsetOfDraggedItem)(CGPoint orginalPoint_, CGPoint targetPoint_,ccTime dt_);
	CCFiniteTimeAction *(^action_itemDragViewCancelled)(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_);
}

@property (nonatomic, readwrite) float dragStartDelayTime,dragStartDistance;
@property (nonatomic, copy) BOOL (^filter_canDragItem)(CMMMenuItem *item_);
@property (nonatomic, copy) CGPoint (^filter_offsetOfDraggedItem)(CGPoint orginalPoint_, CGPoint targetPoint_,ccTime dt_);
@property (nonatomic, copy) CCFiniteTimeAction * (^action_itemDragViewCancelled)(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_);

-(void)setFilter_canDragItem:(BOOL (^)(CMMMenuItem *item_))block_;
-(void)setFilter_offsetOfDraggedItem:(CGPoint (^)(CGPoint orginalPoint_, CGPoint targetPoint_,ccTime dt_))block_;
-(void)setAction_itemDragViewCancelled:(CCFiniteTimeAction *(^)(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_))block_;

@end