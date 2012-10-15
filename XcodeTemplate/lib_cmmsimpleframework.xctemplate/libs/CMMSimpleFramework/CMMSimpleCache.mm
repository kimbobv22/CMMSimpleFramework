//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSimpleCache.h"

@implementation CMMSimpleCache

-(id)cachedObjectAtIndex:(uint)index_{
	id object_ = [[[super objectAtIndex:index_] retain] autorelease];
	[self removeObjectAtIndex:index_];
	return object_;
}
-(id)cachedObject{
	if(data->num > 0){
		return [self cachedObjectAtIndex:data->num-1];
	}
	return nil;
}

@end
