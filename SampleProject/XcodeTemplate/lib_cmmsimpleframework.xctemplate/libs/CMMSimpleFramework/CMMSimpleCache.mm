//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSimpleCache.h"

@implementation CMMSimpleCache
@synthesize itemList,count;

+(id)cache{
	return [[[self alloc] init] autorelease];
}
-(id)init{
	if(!(self = [super init])) return self;
	
	itemList = [[CCArray alloc] init];
	
	return self;
}

-(NSUInteger)count{
	return [itemList count];
}

-(id)cachedObject{
	NSUInteger count_ = [self count];
	if(count_==0)
		return nil;
	
	id object_ = [[[itemList lastObject] retain] autorelease];
	[itemList removeObjectAtIndex:count_-1];
	return object_;
}
-(void)cacheObject:(id)object_{
	[itemList addObject:object_];
}
-(void)clearCache{
	[itemList removeAllObjects];
}

-(void)dealloc{
	[itemList release];
	[super dealloc];
}

@end
