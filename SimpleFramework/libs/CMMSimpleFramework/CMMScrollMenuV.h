//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenu.h"

@class CMMScrollMenuV;

@protocol CMMScrollMenuVDelegate <CMMScrollMenuDelegate>

@optional
-(BOOL)scrollMenu:(CMMScrollMenuV *)scrollMenu_ isCanDragItem:(CCNode<CMMTouchDispatcherDelegate> *)item_;

@end

@interface CMMScrollMenuDragItem : CCSprite{
	int targetIndex;
}

@property (nonatomic, readwrite) int targetIndex;

@end

@interface CMMScrollMenuV : CMMScrollMenu{
	CMMScrollMenuDragItem *_dragItemView;
	ccTime _curDragStartDelayTime;
	CGPoint _firstTouchPoint;
	
	float dragStartDelayTime,dragStartDistance;
}

@property (nonatomic, readwrite) float dragStartDelayTime,dragStartDistance;

@end
