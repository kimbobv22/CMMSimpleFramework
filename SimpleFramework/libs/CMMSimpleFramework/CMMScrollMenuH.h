//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenu.h"

@class CMMScrollMenuH;

@protocol CMMScrollMenuHDelegate <CMMScrollMenuDelegate>

@optional
-(BOOL)scrollMenu:(CMMScrollMenuH *)scrollMenu_ isCanDragItem:(CCNode<CMMTouchDispatcherDelegate> *)item_;

@end

@interface CMMScrollMenuDragItem : CCSprite{
	int targetIndex;
}

@property (nonatomic, readwrite) int targetIndex;

@end

@interface CMMScrollMenuH : CMMScrollMenu{
	CMMScrollMenuDragItem *_dragItemView;
	ccTime _curDragStartDelayTime;
	CGPoint _firstTouchPoint;
	
	float dragStartDelayTime,dragStartDistance;
}

@property (nonatomic, readwrite) float dragStartDelayTime,dragStartDistance;

@end
