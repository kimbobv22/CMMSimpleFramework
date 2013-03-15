//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

@interface CMMTimeIntervalArray : CCArray{
	CCArray *createList,*destroyList;
	void (^callback_whenObjectsAdded)(CCArray *),(^callback_whenObjectsRemoved)(CCArray *);
}

-(void)step;

@property (nonatomic, readonly) CCArray *createList,*destroyList;
@property (nonatomic, copy) void (^callback_whenObjectsAdded)(CCArray *),(^callback_whenObjectsRemoved)(CCArray *);

-(void)setCallback_whenObjectsAdded:(void (^)(CCArray *objects_))block_;
-(void)setCallback_whenObjectsRemoved:(void (^)(CCArray *objects_))block_;

@end