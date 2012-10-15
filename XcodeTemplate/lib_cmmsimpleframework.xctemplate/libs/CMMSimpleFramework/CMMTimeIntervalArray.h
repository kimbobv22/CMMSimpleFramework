//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

@interface CMMTimeIntervalArray : CCArray{
	CCArray *createList,*destroyList;
	void (^filter_whenAddedObject)(id object_),(^filter_whenRemovedObject)(id object_),
	(^callback_whenAddedObject)(CCArray *objects_),(^callback_whenRemovedObject)(CCArray *objects_);
}

-(void)step;

@property (nonatomic, readonly) CCArray *createList,*destroyList;
@property (nonatomic, copy) void (^filter_whenAddedObject)(id object_),(^filter_whenRemovedObject)(id object_),(^callback_whenAddedObject)(CCArray *objects_),(^callback_whenRemovedObject)(CCArray *objects_);

@end