//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

@interface CMMSimpleCache : CCArray

-(id)cachedObjectAtIndex:(uint)index_;
-(id)cachedObject;

@property (nonatomic, readonly) id next;

@end
