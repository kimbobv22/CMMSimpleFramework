//  Created by JGroup(kimbobv22@gmail.com)

#import <Foundation/Foundation.h>

#define cmmVarCMMPacketData_maxCacheCount 20

@class CMMPacketData;
@class CMMPacket;

enum CMMPacketDataType{
	CMMPacketDataType_packet,
	CMMPacketDataType_bytes,
};

@protocol CMMPacketDataReceiverProtocol <NSObject>

@optional
-(void)receivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_;

@end

@protocol CMMPacketDataSenderProtocol <NSObject>

-(void)sendPacketData:(CMMPacketData *)packetData_ toIDs:(NSArray *)toIDs_;
-(void)sendPacket:(CMMPacket *)packet_ toIDs:(NSArray *)toIDs_;
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toIDs:(NSArray *)toIDs_;

-(void)sendPacketData:(CMMPacketData *)packetData_ toID:(NSString *)toID_;
-(void)sendPacket:(CMMPacket *)packet_ toID:(NSString *)toID_;
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toID:(NSString *)toID_;

-(void)sendPacketDataToAll:(CMMPacketData *)packetData_;
-(void)sendPacketToAll:(CMMPacket *)packet_;
-(void)sendBytesToAll:(void *)bytes_ length:(uint)length_;

@optional
-(void)sendPacketDataToServer:(CMMPacketData *)packetData_;
-(void)sendPacketToServer:(CMMPacket *)packet_;
-(void)sendBytesToServer:(void *)bytes_ length:(uint)length_;

@end

@interface CMMPacketData : NSData{
	CMMPacketDataType type;
	id data;
}

+(id)packetDataWithType:(CMMPacketDataType)type_;
+(id)packetData;
+(id)packetDataWithBytes:(void *)bytes_ length:(uint)length_;
+(id)packetDataWithPacket:(CMMPacket *)packet_;

-(id)initWithType:(CMMPacketDataType)type_;
-(id)initWithBytes:(void *)bytes_ length:(uint)length_;
-(id)initWithPacket:(CMMPacket *)packet_;

-(void)setDataWithPacket:(CMMPacket *)packet_;
-(void)setDataWithBytes:(void *)bytes_ length:(uint)length_;

-(void)resetData;

@property (nonatomic, readwrite) CMMPacketDataType type;
@property (nonatomic, retain) id data;

@end

@interface CMMPacketData(Cache)

+(CMMPacketData *)createData;
+(CMMPacketData *)cachedData;
+(void)cacheData:(CMMPacketData *)data_;
+(void)clearCache;

@end

#define cmmVarCMMPacket_keyName_mainData @"m0"

@interface CMMPacket : NSObject<NSCopying,NSCoding>{
	id mainData;
}

+(id)packet;

@property (nonatomic, retain) id mainData;

@end
