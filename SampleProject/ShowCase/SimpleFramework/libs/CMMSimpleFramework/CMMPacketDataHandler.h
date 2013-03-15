//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMGameKit.h"
#import "CCArray.h"

@class CMMPacketDataHandler;

@interface CMMPacketDataHandlerItem : NSObject<CMMPacketDataReceiverProtocol>{
	CMMPacketDataHandler *handler;
	id userData;
}

+(id)handlerItemWithHandler:(CMMPacketDataHandler *)handler_;
-(id)initWithHandler:(CMMPacketDataHandler *)handler_;

-(BOOL)shouldReceivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_;

@property (nonatomic, retain) CMMPacketDataHandler *handler;
@property (nonatomic, retain) id userData;

@end

@interface CMMPacketDataHandler : NSObject<CMMPacketDataReceiverProtocol>{
	id owner;
	CCArray *itemList;
}

+(id)handlerWithOwner:(id)owner_;
-(id)initWithOwner:(id)owner_;

-(void)addHandlerItem:(CMMPacketDataHandlerItem *)handlerItem_;

-(CMMPacketDataHandlerItem *)handlerItemAtIndex:(uint)index_;

-(void)removeHandlerItem:(CMMPacketDataHandlerItem *)handlerItem_;
-(void)removeHandlerItemAtIndex:(uint)index_;
-(void)removeAllHandlerItems;

-(uint)indexOfHandlerItem:(CMMPacketDataHandlerItem *)handlerItem_;

@property (nonatomic, retain) id owner;
@property (nonatomic, readonly) CCArray *itemList;

@end
