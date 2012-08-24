#import "cocos2d.h"

@interface CMMFileUtil : NSObject

+(BOOL)isExistWithFilePath:(NSString *)filePath_;
+(BOOL)isExistWithFileName:(NSString *)fileName isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_;
+(BOOL)isExistWithFileName:(NSString *)fileName isInDocument:(BOOL)isInDocument_;

+(NSData *)dataWithSourceData:(NSData *)sourceData_ range:(NSRange)range_;

+(NSData *)dataWithFilePath:(NSString *)filePath_;
+(NSData *)dataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_;
+(NSData *)dataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

+(CCTexture2D *)textureWithData:(NSData *)data_ textureKey:(NSString *)textureKey_;
+(CCTexture2D *)textureWithFilePath:(NSString *)filePath_;
+(CCTexture2D *)textureWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_;
+(CCTexture2D *)textureWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

+(NSDictionary *)dictionaryWithData:(NSData *)data_;
+(NSDictionary *)dictionaryWithFilePath:(NSString *)filePath_;
+(NSDictionary *)dictionaryWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_;
+(NSDictionary *)dictionaryWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

+(void)deleteFileWithFileName:(NSString *)fileName_ extension:(NSString *)extension_;
+(void)deleteFileWithFileName:(NSString *)fileName_;

@end