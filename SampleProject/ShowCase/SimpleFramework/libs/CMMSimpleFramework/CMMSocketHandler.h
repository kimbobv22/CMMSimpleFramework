//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMPacketData.h"
#import "CMMMacro.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <fcntl.h>
#include <unistd.h>

typedef enum{
	CMMSocketHandlerConnectionState_connected,
	CMMSocketHandlerConnectionState_disconnected,
} CMMSocketHandlerConnectionState;

#define cmmVarCMMSocketHandlerStatePacket_keyName_connectionState @"csocste"

//sample packet
@interface CMMSocketHandlerStatePacket : CMMPacket{
	CMMSocketHandlerConnectionState connectionState;
}

+(id)packetWithConnectionState:(CMMSocketHandlerConnectionState)connectionState_;
-(id)initWithConnectionState:(CMMSocketHandlerConnectionState)connectionState_;

@property (nonatomic, readwrite) CMMSocketHandlerConnectionState connectionState;

@end

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

-(void)receivePacketData:(CMMPacketData *)packetData_ fromAddressData:(NSData *)addressData_;

//server side
-(void)sendPacketData:(CMMPacketData *)packetData_ toAddressData:(NSData *)addressData_;
-(void)sendPacket:(CMMPacket *)packet_ toAddressData:(NSData *)addressData_;
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toAddressData:(NSData *)addressData_;

//client side(to server) || server side(to all client)
-(void)sendPacketData:(CMMPacketData *)packetData_;
-(void)sendPacket:(CMMPacket *)packet_;
-(void)sendBytes:(void *)bytes_ length:(uint)length_;

@optional
-(void)receiveData DEPRECATED_ATTRIBUTE;

@end

static NSString * cmmFuncCMMSocketHandler_NSStringfromAddressData(NSData * addressData_){
    int         err;
    NSString *  result;
    char        hostStr[NI_MAXHOST];
    char        servStr[NI_MAXSERV];
    
    result = nil;
    
    if (addressData_ != nil) {
		
        // If it's a IPv4 address embedded in an IPv6 address, just bring it as an IPv4
        // address.  Remember, this is about display, not functionality, and users don't
        // want to see mapped addresses.
        
        if ([addressData_ length] >= sizeof(struct sockaddr_in6)) {
            const struct sockaddr_in6 * addr6Ptr;
            
            addr6Ptr = (sockaddr_in6 *)[addressData_ bytes];
            if (addr6Ptr->sin6_family == AF_INET6) {
                if ( IN6_IS_ADDR_V4MAPPED(&addr6Ptr->sin6_addr) || IN6_IS_ADDR_V4COMPAT(&addr6Ptr->sin6_addr) ) {
                    struct sockaddr_in  addr4;
                    
                    memset(&addr4, 0, sizeof(addr4));
                    addr4.sin_len         = sizeof(addr4);
                    addr4.sin_family      = AF_INET;
                    addr4.sin_port        = addr6Ptr->sin6_port;
                    addr4.sin_addr.s_addr = addr6Ptr->sin6_addr.__u6_addr.__u6_addr32[3];
                    addressData_ = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
                    assert(addressData_ != nil);
                }
            }
        }
        err = getnameinfo((sockaddr *)[addressData_ bytes], (socklen_t) [addressData_ length], hostStr, sizeof(hostStr), servStr, sizeof(servStr), NI_NUMERICHOST | NI_NUMERICSERV);
        if (err == 0) {
            result = [NSString stringWithFormat:@"%s:%s", hostStr, servStr];
            assert(result != nil);
        }
    }
	
    return result;
}

@interface CMMSocketHandler : NSObject<CMMSocketHandlerProtocol>{
	id<CMMSocketHandlerDelegate> delegate;
	CFSocketRef _cfSocket;
	CFHostRef _cfHost;
	uint port;
	NSString *hostName;
	NSData *hostAddress;
}

+(id)handler;

-(BOOL)startHostOnPort:(uint)port_;
-(BOOL)connectToHostName:(NSString *)hostName_ port:(uint)port_;

-(void)closeSocket;

@property (nonatomic, assign) id<CMMSocketHandlerDelegate> delegate;
@property (nonatomic, readwrite) uint port;
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, retain) NSData *hostAddress;
@property (nonatomic, readonly) BOOL isHost;

@end