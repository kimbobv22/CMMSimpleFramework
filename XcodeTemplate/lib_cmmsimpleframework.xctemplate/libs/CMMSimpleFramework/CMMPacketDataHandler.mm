//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMPacketDataHandler.h"

@implementation CMMPacketDataHandlerItem
@synthesize handler,userData;

+(id)handlerItemWithHandler:(CMMPacketDataHandler *)handler_{
	return [[[self alloc] initWithHandler:handler_] autorelease];
}
-(id)initWithHandler:(CMMPacketDataHandler *)handler_{
	if(!(self = [super init])) return self;
	
	handler = [handler_ retain];
	
	return self;
}

-(BOOL)shouldReceivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_{
	return YES;
}
-(void)receivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_{}

-(void)dealloc{
	[userData release];
	[handler release];
	[super dealloc];
}

@end

@implementation CMMPacketDataHandler
@synthesize itemList,owner;

+(id)handlerWithOwner:(id)owner_{
	return [[[self alloc] initWithOwner:owner_] autorelease];
}
-(id)initWithOwner:(id)owner_{
	if(!(self = [super init])) return self;
	
	owner = [owner_ retain];
	itemList = [[CCArray alloc] init];
	
	return self;
}

-(void)addHandlerItem:(CMMPacketDataHandlerItem *)handlerItem_{
	uint index_ = [self indexOfHandlerItem:handlerItem_];
	if(index_ != NSNotFound) return;
	[handlerItem_ setHandler:self];
	[itemList addObject:handlerItem_];
}

-(CMMPacketDataHandlerItem *)handlerItemAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [itemList objectAtIndex:index_];
}

-(void)removeHandlerItem:(CMMPacketDataHandlerItem *)handlerItem_{
	uint index_ = [self indexOfHandlerItem:handlerItem_];
	if(index_ == NSNotFound) return;
	[itemList removeObjectAtIndex:index_];
}
-(void)removeHandlerItemAtIndex:(uint)index_{
	[self removeHandlerItem:[self handlerItemAtIndex:index_]];
}
-(void)removeAllHandlerItems{
	ccArray *data_ = itemList->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMPacketDataHandlerItem *handlerItem_ = data_->arr[index_];
		[self removeHandlerItem:handlerItem_];
	}
}

-(uint)indexOfHandlerItem:(CMMPacketDataHandlerItem *)handlerItem_{
	return [itemList indexOfObject:handlerItem_];
}

-(void)receivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_{
	ccArray *data_ = itemList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMPacketDataHandlerItem *handlerItem_ = data_->arr[index_];
		if([handlerItem_ shouldReceivePacketData:packetData_ fromID:fromID_]){
			[handlerItem_ receivePacketData:packetData_ fromID:fromID_];
		}
	}
}

-(void)dealloc{
	[owner release];
	[itemList release];
	[super dealloc];
}

@end
