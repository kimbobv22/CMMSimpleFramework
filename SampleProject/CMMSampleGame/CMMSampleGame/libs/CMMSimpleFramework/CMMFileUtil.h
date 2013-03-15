#import "cocos2d.h"
#import "CMMEncryptionUtil.h"
#import "CMMMacro.h"

@interface CMMFileUtil : NSObject

+(BOOL)isExistWithFilePath:(NSString *)filePath_;
+(BOOL)isExistWithFileName:(NSString *)fileName isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_;
+(BOOL)isExistWithFileName:(NSString *)fileName isInDocument:(BOOL)isInDocument_;

+(NSData *)dataWithSourceData:(NSData *)sourceData_ range:(NSRange)range_;

+(NSData *)dataWithFilePath:(NSString *)filePath_ encryptionKey:(NSString *)encryptionKey_;
+(NSData *)dataWithFilePath:(NSString *)filePath_;
+(NSData *)dataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_ encryptionKey:(NSString *)encryptionKey_;
+(NSData *)dataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_;
+(NSData *)dataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

+(void)deleteFileWithFileName:(NSString *)fileName_ extension:(NSString *)extension_;
+(void)deleteFileWithFileName:(NSString *)fileName_;

+(void)writeFileInBackgroundWithData:(NSData *)data_ path:(NSString *)path_ block:(void(^)(NSError *))block_;

@end

@interface CMMFileUtil(Dictionary)

+(NSDictionary *)dictionaryWithData:(NSData *)data_;
+(NSDictionary *)dictionaryWithFilePath:(NSString *)filePath_ encryptionKey:(NSString *)encryptionKey_;
+(NSDictionary *)dictionaryWithFilePath:(NSString *)filePath_;
+(NSDictionary *)dictionaryWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_ encryptionKey:(NSString *)encryptionKey_;
+(NSDictionary *)dictionaryWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_;
+(NSDictionary *)dictionaryWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

@end

@interface CMMFileUtil(ImageData)

+(CCTexture2D *)textureWithData:(NSData *)data_ textureKey:(NSString *)textureKey_;
+(CCTexture2D *)textureWithFilePath:(NSString *)filePath_ encryptionKey:(NSString *)encryptionKey_;
+(CCTexture2D *)textureWithFilePath:(NSString *)filePath_;
+(CCTexture2D *)textureWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_ encryptionKey:(NSString *)encryptionKey_;
+(CCTexture2D *)textureWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_;
+(CCTexture2D *)textureWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

+(void *)imageDataWithCGImage:(CGImageRef)cgImage_;
+(void *)imageDataWithFilePath:(NSString *)filePath_;
+(void *)imageDataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_;
+(void *)imageDataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

@end