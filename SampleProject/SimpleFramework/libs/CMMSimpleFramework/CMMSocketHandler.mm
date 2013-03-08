//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSocketHandler.h"
#import "CMMConnectionMonitor.h"

@implementation CMMSocketHandlerStatePacket
@synthesize connectionState;

+(id)packetWithConnectionState:(CMMSocketHandlerConnectionState)connectionState_{
	return [[[self alloc] initWithConnectionState:connectionState_] autorelease];
}
-(id)initWithConnectionState:(CMMSocketHandlerConnectionState)connectionState_{
	if(!(self = [super init])) return self;
	
	connectionState = connectionState_;
	
	return self;
}
-(id)initWithCoder:(NSCoder *)decoder_{
	if(!(self = [super initWithCoder:decoder_])) return self;
	
	connectionState = (CMMSocketHandlerConnectionState)[decoder_ decodeIntForKey:cmmVarCMMConnectionMonitor_reachabilityChangedNotification];
	
	return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder_{
	[super encodeWithCoder:encoder_];
	[encoder_ encodeInt:connectionState forKey:cmmVarCMMConnectionMonitor_reachabilityChangedNotification];
}
-(id)copyWithZone:(NSZone *)zone_{
	CMMSocketHandlerStatePacket *copy_ = [super copyWithZone:zone_];
	[copy_ setConnectionState:connectionState];
	return copy_;
}

@end

@interface CMMSocketHandler(Private)

-(BOOL)setupSocketConnectedToAddress:(NSData *)address_ port:(NSUInteger)port_ error:(NSError **)errorPtr_;
-(void)stopWithError:(NSError *)error_;
-(void)stopWithStreamError:(CFStreamError)streamError_;

-(void)hostResolutionDone;
-(void)stopHostResolution;

@end

static void _callbackCFSocket(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info){
	CMMSocketHandler *socketHandler_ = (CMMSocketHandler *)info;
	switch(type){
		case kCFSocketAcceptCallBack:{
			CCLOG(@"kCFSocketAcceptCallBack");
			break;
		}
		case kCFSocketDataCallBack:{
			if(data != nil){
				CMMPacketData *packetData_ = [CMMPacketData packetDataWithPackedData:(NSData *)data];
				[socketHandler_ receivePacketData:packetData_ fromAddressData:(NSData *)address];
				[CMMPacketData cacheData:packetData_];
			}else{
				[socketHandler_ receivePacketData:nil fromAddressData:(NSData *)address];
			}
			break;
		}
		default: break;
	}
}

static void _callbackCFSocketHostResolve(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError *error, void *info){
	CMMSocketHandler *socketHandler_ = (CMMSocketHandler *)info;
	if((error != NULL) && (error->domain != 0)){
		[socketHandler_ stopWithStreamError:*error];
	}else{
		[socketHandler_ hostResolutionDone];
	}
}

@implementation CMMSocketHandler(Private)

-(BOOL)setupSocketConnectedToAddress:(NSData *)address_ port:(NSUInteger)port_ error:(NSError **)errorPtr_{
	sa_family_t socketFamily_;
	int err_;
	int junk_;
	int sock_;
	const CFSocketContext context_ = {0, (void *)self, NULL, NULL, NULL };
	CFRunLoopSourceRef rls_;
	
	assert((address_ == nil) || ([address_ length] <= sizeof(struct sockaddr_storage)));
	assert(port_ < 65536);
	assert(_cfSocket == NULL);
	
	// Create the UDP socket itself.  First try IPv6 and, if that's not available, revert to IPv6.
	//
	// IMPORTANT: Even though we're using IPv6 by default, we can still work with IPv4 due to the
	// miracle of IPv4-mapped addresses.
	
	err_ = 0;
	sock_ = socket(AF_INET6, SOCK_DGRAM, 0);
	if(sock_ >= 0) {
		socketFamily_ = AF_INET6;
	}else{
		sock_ = socket(AF_INET, SOCK_DGRAM, 0);
		if(sock_ >= 0){
			socketFamily_ = AF_INET;
		}else{
			err_ = errno;
			socketFamily_ = 0;       // quietens a warning from the compiler
			assert(err_ != 0);       // Obvious, but it quietens a warning from the static analyser.
		}
	}
	
	// Bind or connect the socket, depending on whether we're in server or client mode.
	
	if(err_ == 0) {
		struct sockaddr_storage addr_;
		struct sockaddr_in *addr4_;
		struct sockaddr_in6 *addr6_;
		
		addr4_ = (struct sockaddr_in * ) &addr_;
		addr6_ = (struct sockaddr_in6 *) &addr_;
		
		memset(&addr_, 0, sizeof(addr_));
		if(address_ == nil){
			// Server mode.  Set up the address based on the socket family of the socket
			// that we created, with the wildcard address and the caller-supplied port number.
			addr_.ss_family = socketFamily_;
			if(socketFamily_ == AF_INET) {
				addr4_->sin_len         = sizeof(*addr4_);
				addr4_->sin_port        = htons(port_);
				addr4_->sin_addr.s_addr = INADDR_ANY;
			}else{
				assert(socketFamily_ == AF_INET6);
				addr6_->sin6_len         = sizeof(*addr6_);
				addr6_->sin6_port        = htons(port_);
				addr6_->sin6_addr        = in6addr_any;
			}
		}else{
			// Client mode.  Set up the address on the caller-supplied address and port
			// number.  Also, if the address is IPv4 and we created an IPv6 socket,
			// convert the address to an IPv4-mapped address.
			if([address_ length] > sizeof(addr_)) {
				assert(NO);         // very weird
				[address_ getBytes:&addr_ length:sizeof(addr_)];
			}else{
				[address_ getBytes:&addr_ length:[address_ length]];
			}
			if(addr_.ss_family == AF_INET) {
				if(socketFamily_ == AF_INET6){
					struct in_addr ipv4Addr_;
					
					// Convert IPv4 address to IPv4-mapped-into-IPv6 address.
					
					ipv4Addr_ = addr4_->sin_addr;
					
					addr6_->sin6_len         = sizeof(*addr6_);
					addr6_->sin6_family      = AF_INET6;
					addr6_->sin6_port        = htons(port_);
					addr6_->sin6_addr.__u6_addr.__u6_addr32[0] = 0;
					addr6_->sin6_addr.__u6_addr.__u6_addr32[1] = 0;
					addr6_->sin6_addr.__u6_addr.__u6_addr16[4] = 0;
					addr6_->sin6_addr.__u6_addr.__u6_addr16[5] = 0xffff;
					addr6_->sin6_addr.__u6_addr.__u6_addr32[3] = ipv4Addr_.s_addr;
				}else{
					addr4_->sin_port = htons(port_);
				}
			}else{
				assert(addr_.ss_family == AF_INET6);
				addr6_->sin6_port        = htons(port_);
			}
			if((addr_.ss_family == AF_INET) && (socketFamily_ == AF_INET6)){
				addr6_->sin6_len         = sizeof(*addr6_);
				addr6_->sin6_port        = htons(port_);
				addr6_->sin6_addr        = in6addr_any;
			}
		}
		if(address_ == nil){
			err_ = bind(sock_, (const struct sockaddr *) &addr_, addr_.ss_len);
		}else{
			err_ = connect(sock_, (const struct sockaddr *) &addr_, addr_.ss_len);
		}
		if(err_ < 0){
			err_ = errno;
		}
	}
	
	// From now on we want the socket in non-blocking mode to prevent any unexpected
	// blocking of the main thread.  None of the above should block for any meaningful
	// amount of time.
	
	if(err_ == 0){
		int flags_ = fcntl(sock_, F_GETFL);
		err_ = fcntl(sock_, F_SETFL, flags_ | O_NONBLOCK);
		if(err_ < 0){
			err_ = errno;
		}
	}
	
	// Wrap the socket in a CFSocket that's scheduled on the runloop.
	
	if(err_ == 0){
		_cfSocket = CFSocketCreateWithNative(NULL, sock_, kCFSocketDataCallBack , _callbackCFSocket, &context_);
		
		// The socket will now take care of cleaning up our file descriptor.
		
		assert(CFSocketGetSocketFlags(_cfSocket) & kCFSocketCloseOnInvalidate );
		sock_ = -1;
		
		rls_ = CFSocketCreateRunLoopSource(NULL, _cfSocket, 0);
		assert(rls_ != NULL);
		
		CFRunLoopAddSource(CFRunLoopGetCurrent(), rls_, kCFRunLoopDefaultMode);
		CFRelease(rls_);
	}
	
	// Handle any errors.
	if (sock_ != -1) {
		junk_ = close(sock_);
		assert(junk_ == 0);
	}
	assert((err_ == 0) == (_cfSocket != NULL) );
	if((_cfSocket == NULL) && (errorPtr_ != NULL) ) {
		*errorPtr_ = [NSError errorWithDomain:NSPOSIXErrorDomain code:err_ userInfo:nil];
	}
	
	return (err_ == 0);
}
-(void)stopWithError:(NSError *)error_{
	[self closeSocket];
	if(cmmFunc_respondsToSelector(delegate, @selector(socketHandler:didStopWithError:))){
		[delegate socketHandler:self didStopWithError:error_];
	}
}
-(void)stopWithStreamError:(CFStreamError)streamError_{
	NSDictionary *userInfo_ = nil;
	if(streamError_.domain == kCFStreamErrorDomainNetDB){
		userInfo_ = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:streamError_.error], kCFGetAddrInfoFailureKey ,nil];
	}
	
    NSError *error_ = [NSError errorWithDomain:(NSString *)kCFErrorDomainCFNetwork code:kCFHostErrorUnknown userInfo:userInfo_];
    [self stopWithError:error_];
}

-(void)hostResolutionDone{
	assert(port != 0);
	assert(_cfHost != NULL);
	assert(_cfSocket == NULL);
	assert(hostAddress == nil);

	NSError *error_ = nil;
	Boolean isResolve_;
    NSArray *resolvedAddresses_ = (NSArray *)CFHostGetAddressing(_cfHost, &isResolve_);
    if(isResolve_ && resolvedAddresses_ != nil){
		for(NSData *address_ in resolvedAddresses_){
			const sockaddr * addrPtr_ = (const struct sockaddr *)[address_ bytes];
			uint addressLength_ = [address_ length];
			assert(addressLength_ >= sizeof(sockaddr));
			
			if(addrPtr_->sa_family == AF_INET || addrPtr_->sa_family == AF_INET6){
				if([self setupSocketConnectedToAddress:address_ port:port error:&error_]){
					CFDataRef hostAddress_ = CFSocketCopyPeerAddress(_cfSocket);
					assert(hostAddress_ != NULL);
					[self setHostAddress:(NSData *)hostAddress_];
					CFRelease(hostAddress_);
					break;
				}
			}
		}
	}
    
	if(hostAddress == nil && error_ == nil){
		error_ = [NSError errorWithDomain:(NSString *)kCFErrorDomainCFNetwork code:kCFHostErrorHostNotFound userInfo:nil];
	}
	
	if(error_ == nil){
		[self stopHostResolution];
		if(cmmFunc_respondsToSelector(delegate, @selector(socketHandler:didStartWithAddressData:))){
			[delegate socketHandler:self didStartWithAddressData:hostAddress];
		}
	}else{
		[self stopWithError:error_];
	}
}
-(void)stopHostResolution{
	if(_cfHost != NULL){
		CFHostSetClient(_cfHost, NULL, NULL);
		CFHostCancelInfoResolution(_cfHost, kCFHostAddresses);
		CFHostUnscheduleFromRunLoop(_cfHost, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		CFRelease(_cfHost);
		_cfHost = NULL;
	}
}

@end

@implementation CMMSocketHandler
@synthesize delegate,port,hostName,hostAddress,isHost;

+(id)handler{
	return [[[self alloc] init] autorelease];
}

-(id)init{
	if(!(self = [super init])) return self;
	
	return self;
}

-(BOOL)isHost{
	return (hostName == nil);
}
-(void)closeSocket{
	[self stopHostResolution];
	port = 0;
	if(_cfSocket != NULL){
		CFSocketInvalidate(_cfSocket);
        CFRelease(_cfSocket);
        _cfSocket = NULL;
	}
}

-(BOOL)startHostOnPort:(uint)port_{
	assert((port_ > 0) && (port_ < 65536));
	assert(port == 0);
	
	NSError *error_ = nil;
	if(port ==0){
		if([self setupSocketConnectedToAddress:nil port:port_ error:&error_]){
			port = port_;
			
			if(cmmFunc_respondsToSelector(delegate, @selector(socketHandler:didStartWithAddressData:))){
				CFDataRef localAddress_ = CFSocketCopyAddress(_cfSocket);
				[delegate socketHandler:self didStartWithAddressData:(NSData *)localAddress_];
				CFRelease(localAddress_);
			}
		}else{
			[self stopWithError:error_];
		}
		
		return !error_;
	}
	
	return NO;
}

-(BOOL)connectToHostName:(NSString *)hostName_ port:(uint)port_{
	assert(hostName_ != nil);
	assert((port_ > 0) && (port_ < 65536));
	assert(port == 0);
	if(port == 0){
		CFStreamError streamError_;
		CFHostClientContext context_ = {0, (void *)(self), NULL, NULL, NULL};
		
		_cfHost = CFHostCreateWithName(NULL, (CFStringRef) hostName_);
		CFHostSetClient(_cfHost, _callbackCFSocketHostResolve, &context_);
		CFHostScheduleWithRunLoop(_cfHost, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		if(CFHostStartInfoResolution(_cfHost, kCFHostAddresses, &streamError_)){
			[self setHostName:hostName_];
			port = port_;
			return YES;
		}else{
			[self stopWithStreamError:streamError_];
		}
	}
	
	return NO;
}

-(void)receivePacketData:(CMMPacketData *)packetData_ fromAddressData:(NSData *)addressData_{
	if(packetData_ && cmmFunc_respondsToSelector(delegate, @selector(socketHandler:didReceivePacketData:fromAddressData:))){
		[delegate socketHandler:self didReceivePacketData:packetData_ fromAddressData:addressData_];
	}else if(!packetData_ && cmmFunc_respondsToSelector(delegate, @selector(socketHandler:didReceiveError:))){
		[delegate socketHandler:self didReceiveError:[NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil]];
	}
}

-(void)sendPacketData:(CMMPacketData *)packetData_ toAddressData:(NSData *)addressData_{
	NSData *packedData_ = [packetData_ toPackedData];
	
    assert(packedData_ != nil);
	assert((addressData_ != nil) == [self isHost]);
	
	int error_;
    int sock_ = CFSocketGetNative(_cfSocket);
    assert(sock_ >= 0);
	
	const struct sockaddr *addrPtr_ = NULL;
	socklen_t addrLength_ = 0;
	if(addressData_){
		addrPtr_ = (const struct sockaddr *)[addressData_ bytes];
		addrLength_ = [addressData_ length];
	}
	
	ssize_t bytesWritten_ = sendto(sock_, [packedData_ bytes], [packedData_ length], 0, addrPtr_, addrLength_);
	
	if(bytesWritten_ < 0){
		error_ = errno;
	}else if(bytesWritten_ == 0){
		error_ = EPIPE;
	}else{
		assert((NSUInteger)bytesWritten_ == [packedData_ length]);
		error_ = 0;
	}
    
	if(error_ == 0){
		if(cmmFunc_respondsToSelector(delegate, @selector(socketHandler:didSendPacketData:toAddressData:))){
			[delegate socketHandler:self didSendPacketData:packetData_ toAddressData:addressData_];
		}
	}else{
		if(cmmFunc_respondsToSelector(delegate, @selector(socketHandler:didFailToSendPacketData:toAddressData:withError:))){
			[delegate socketHandler:self didFailToSendPacketData:packetData_ toAddressData:addressData_ withError:[NSError errorWithDomain:NSPOSIXErrorDomain code:error_ userInfo:nil]];
		}
	}
	
	[CMMPacketData cacheData:packetData_];
}
-(void)sendPacket:(CMMPacket *)packet_ toAddressData:(NSData *)addressData_{
	CMMPacketData *packetData_ = [CMMPacketData cachedData];
	if(!packetData_){
		packetData_ = [CMMPacketData packetData];
	}
	
	[packetData_ setDataWithPacket:packet_];
	[self sendPacketData:packetData_ toAddressData:addressData_];
}
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toAddressData:(NSData *)addressData_{
	CMMPacketData *packetData_ = [CMMPacketData cachedData];
	if(!packetData_){
		packetData_ = [CMMPacketData packetData];
	}
	
	[packetData_ setDataWithBytes:bytes_ length:length_];
	[self sendPacketData:packetData_ toAddressData:addressData_];
}

-(void)sendPacketData:(CMMPacketData *)packetData_{
	[self sendPacketData:packetData_ toAddressData:nil];
}
-(void)sendPacket:(CMMPacket *)packet_{
	[self sendPacket:packet_ toAddressData:nil];
}
-(void)sendBytes:(void *)bytes_ length:(uint)length_{
	[self sendBytes:bytes_ length:length_ toAddressData:nil];
}

-(void)dealloc{
	delegate = nil;
	[self closeSocket];
	[hostName release];
	[hostAddress release];
	[super dealloc];
}

@end