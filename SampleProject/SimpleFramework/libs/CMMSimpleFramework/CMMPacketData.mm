//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMPacketData.h"
#import "CMMSimpleCache.h"

static CMMSimpleCache *_cachedCMMPacketData_ = nil;

@implementation CMMPacketData
@synthesize type,data;

+(CMMPacketData *)packetDataWithPackedData:(NSData *)data_{
	return [NSKeyedUnarchiver unarchiveObjectWithData:[data_ zlibInflate]];
}

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

-(NSData *)toPackedData{
	return [[NSKeyedArchiver archivedDataWithRootObject:self] zlibDeflate];
}

-(void)encodeWithCoder:(NSCoder *)encoder_{
	[encoder_ encodeInt:type forKey:cmmVarCMMPacketData_keyName_type];
	[encoder_ encodeObject:data forKey:cmmVarCMMPacketData_keyName_data];
}
-(id)initWithCoder:(NSCoder *)decoder_{
	if(!(self = [self initWithType:(CMMPacketDataType)[decoder_ decodeIntForKey:cmmVarCMMPacketData_keyName_type]])) return self;

	[self setData:[decoder_ decodeObjectForKey:cmmVarCMMPacketData_keyName_type]];
	
	return self;
}
-(id)copyWithZone:(NSZone *)zone_{
	CMMPacketData *copy_ = [[[self class] allocWithZone:zone_] initWithType:type];
	[copy_ setData:[[data copy] autorelease]];
	return copy_;
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