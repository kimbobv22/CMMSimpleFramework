//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMPacketData.h"
#import "CMMMacro.h"

@class CMMSocketHandler;
@protocol CMMSocketHandlerDelegate <CMMPacketDataReceiverProtocol>

@optional
-(void)socketHandler:(CMMSocketHandler *)handler_ didStartWithAddressData:(NSData *)addressData_;
-(void)socketHandler:(CMMSocketHandler *)handler_ didStopWithError:(NSError *)error_;

-(void)socketHandler:(CMMSocketHandler *)handler_ didReceivePacketData:(CMMPacketData *)packetData_ fromAddressData:(NSData *)fromAddressData_;
-(void)socketHandler:(CMMSocketHandler *)handler_ didReceiveError:(NSError *)error_;

-(void)socketHandler:(CMMSocketHandler *)handler_ didSendPacketData:(CMMPacketData *)packetData_ toAddressData:(NSData *)toAddressData_;
-(void)socketHandler:(CMMSocketHandler *)handler_ didFailToSendPacketData:(CMMPacketData *)packetData_ toAddressData:(NSData *)toAddressData_ withError:(NSError *)error_;

@end

@protocol CMMSocketHandlerProtocol <NSObject>

-(void)addConnectedClientWithAddressData:(NSData *)addressData_;
-(void)receiveData;

//server side
-(void)sendPacketData:(CMMPacketData *)packetData_ toAddressData:(NSData *)addressData_;
-(void)sendPacket:(CMMPacket *)packet_ toAddressData:(NSData *)addressData_;
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toAddressData:(NSData *)addressData_;

//client side(to server) || server side(to all client)
-(void)sendPacketData:(CMMPacketData *)packetData_;
-(void)sendPacket:(CMMPacket *)packet_;
-(void)sendBytes:(void *)bytes_ length:(uint)length_;

@end

@interface CMMSocketHandler : NSObject<CMMSocketHandlerProtocol>{
	id<CMMSocketHandlerDelegate> delegate;
	CFSocketRef _cfSocket;
	CFHostRef _cfHost;
	uint port;
	NSString *hostName;
	NSData *hostAddress;
	CCArray *clientAddressList;
}

+(id)handler;

-(BOOL)startHostOnPort:(uint)port_;
-(BOOL)connectToHostName:(NSString *)hostName_ port:(uint)port_;

-(void)closeSocket;

-(NSData *)addressDataAtIndex:(uint)index_;

@property (nonatomic, assign) id<CMMSocketHandlerDelegate> delegate;
@property (nonatomic, readwrite) uint port;
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSData *hostAddress;
@property (nonatomic, readonly) CCArray *clientAddressList;
@property (nonatomic, readonly) BOOL isHost;

@end