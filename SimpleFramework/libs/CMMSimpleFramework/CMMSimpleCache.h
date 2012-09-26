//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

@interface CMMSimpleCache : NSObject{
	CCArray *itemList;
}

+(id)cache;

-(id)cachedObject;
-(void)cacheObject:(id)object_;

@property (nonatomic, readonly) CCArray *itemList;
@property (nonatomic, readonly) NSUInteger count;

@end
