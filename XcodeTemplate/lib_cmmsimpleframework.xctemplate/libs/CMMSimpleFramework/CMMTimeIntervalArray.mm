//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMTimeIntervalArray.h"

@implementation CMMTimeIntervalArray
@synthesize createList,destroyList,filter_whenAddedObject,filter_whenRemovedObject,callback_whenAddedObject,callback_whenRemovedObject;

-(id)initWithCapacity:(NSUInteger)capacity{
	if(!(self = [super initWithCapacity:capacity])) return self;
	
	createList = [[CCArray alloc] init];
	destroyList = [[CCArray alloc] init];
	
	return self;
}

-(void)step{
	ccArray *data_ = destroyList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		[super removeObject:data_->arr[index_]];
	
		if(filter_whenRemovedObject){
			filter_whenRemovedObject(data_->arr[index_]);
		}
	}
	if(callback_whenRemovedObject){
		callback_whenRemovedObject(destroyList);
	}
	[destroyList removeAllObjects];
	
	data_ = createList->data;
	count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		[super addObject:data_->arr[index_]];
		
		if(filter_whenAddedObject){
			filter_whenAddedObject(data_->arr[index_]);
		}
	}
	if(callback_whenAddedObject){
		callback_whenAddedObject(createList);
	}
	[createList removeAllObjects];
}

#pragma mark Adding Objects

-(void)addObject:(id)object{
	[createList addObject:object];
}

-(void)addObjectsFromArray:(CCArray*)otherArray{
	[createList addObjectsFromArray:otherArray];
}

-(void)addObjectsFromNSArray:(NSArray*)otherArray{
	[createList addObjectsFromNSArray:otherArray];
}

-(void)insertObject:(id)object atIndex:(NSUInteger)index{
	NSAssert(YES, @"CMMTimeIntervalArray : can't use 'insertObject:atIndex' method");
}

#pragma mark Removing Objects

-(void)removeObject:(id)object{
	[destroyList addObject:object];
}

-(void)removeObjectAtIndex:(NSUInteger)index{
	[self removeObject:[self objectAtIndex:index]];
}

-(void)fastRemoveObject:(id)object{
	[self removeObject:object];
}

-(void)fastRemoveObjectAtIndex:(NSUInteger)index{
	[self removeObjectAtIndex:index];
}

-(void)removeObjectsInArray:(CCArray*)otherArray{
	ccArray *otherData_ = otherArray->data;
	uint count_ = otherData_->num;
	for(uint index_ = 0; index_ < count_; ++index_){
		[self removeObject:otherData_->arr[index_]];
	}
}

-(void)removeLastObject{
	NSAssert( data->num > 0, @"no objects added" );
	[self removeObjectAtIndex:data->num-1];
}

-(void)removeAllObjects{
	for(uint index_ = 0; index_ < data->num; ++index_){
		[self removeObject:data->arr[index_]];
	}
}

-(void)dealloc{
	[callback_whenRemovedObject release];
	[callback_whenAddedObject release];
	[filter_whenAddedObject release];
	[filter_whenRemovedObject release];
	[createList release];
	[destroyList release];
	[super dealloc];
}

@end
