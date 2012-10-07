//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMPacket.h"
#import "CMMSimpleCache.h"

static CMMSimpleCache *_cachedCMMPacketData_ = nil;

@implementation CMMPacketData
@synthesize type,data;

+(id)packetDataWithType:(CMMPacketDataType)type_{
	return [[[self alloc] initWithType:type_] autorelease];
}
+(id)packetData{
	return [[[self alloc] initWithType:CMMPacketDataType_packet] autorelease];
}
+(id)packetDataWithBytes:(void *)bytes_ length:(uint)length_{
	return [[[self alloc] initWithBytes:bytes_ length:length_] autorelease];
}
+(id)packetDataWithPacket:(CMMPacket *)packet_{
	return [[[self alloc] initWithPacket:packet_] autorelease];
}

-(id)initWithType:(CMMPacketDataType)type_{
	if(!(self = [super init])) return self;

	type = type_;
	
	return self;
}
-(id)initWithBytes:(void *)bytes_ length:(uint)length_{
	if(!(self = [self initWithType:CMMPacketDataType_bytes])) return self;
	
	[self setDataWithBytes:bytes_ length:length_];
	
	return self;
}
-(id)initWithPacket:(CMMPacket *)packet_{
	if(!(self = [self initWithType:CMMPacketDataType_bytes])) return self;
	
	[self setDataWithPacket:packet_];
	
	return self;
}

-(void)setDataWithPacket:(CMMPacket *)packet_{
	[self setData:packet_];
	[self setType:CMMPacketDataType_packet];
}
-(void)setDataWithBytes:(void *)bytes_ length:(uint)length_{
	[self setData:[NSData dataWithBytes:bytes_ length:length_]];
	[self setType:CMMPacketDataType_bytes];
}

-(void)resetData{
	[self setData:nil];
}

-(void)dealloc{
	[data release];
	[super dealloc];
}

@end

@implementation CMMPacketData(Cache)

+(CMMPacketData *)createData{
	CMMPacketData *packetData_ = [self cachedData];
	if(!packetData_){
		packetData_ = [CMMPacketData packetData];
	}
	return packetData_;
}
+(CMMPacketData *)cachedData{
	if(!_cachedCMMPacketData_){
		_cachedCMMPacketData_ = [[CMMSimpleCache alloc] init];
	}
	
	return [_cachedCMMPacketData_ cachedObject];
}
+(void)cacheData:(CMMPacketData *)data_{
	if([_cachedCMMPacketData_ count] >= cmmVarCMMPacketData_maxCacheCount)
		return;
	[data_ resetData];
	[_cachedCMMPacketData_ cacheObject:data_];
}
+(void)clearCache{
	[_cachedCMMPacketData_ clearCache];
}

@end

@implementation CMMPacket
@synthesize mainData;

+(id)packet{
	return [[[self alloc] init] autorelease];
}

-(id)initWithCoder:(NSCoder *)decoder_{
	if(!(self = [super init])) return self;
	
	[self setMainData:[decoder_ decodeObjectForKey:cmmVarCMMPacket_keyName_mainData]];
	
	return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder_{
	[encoder_ encodeObject:mainData forKey:cmmVarCMMPacket_keyName_mainData];
}
-(id)copyWithZone:(NSZone *)zone_{
	CMMPacket *packet_ = [[[self class] allocWithZone:zone_] init];
	[packet_ setMainData:[[mainData copy] autorelease]];
	return packet_;
}

-(void)dealloc{
	[mainData release];
	[super dealloc];
}

@end
