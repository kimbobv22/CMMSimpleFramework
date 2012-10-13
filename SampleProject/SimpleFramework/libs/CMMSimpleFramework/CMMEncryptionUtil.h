//  Created by JGroup(kimbobv22@gmail.com)

#import <CommonCrypto/CommonCryptor.h>
#import "NSData+Base64.h"

@interface CMMEncryptionUtil : NSObject

+(NSData*)encryptData:(NSData*)data_ withKey:(NSString *)key_;
+(NSData*)decryptData:(NSData*)data_ withKey:(NSString *)key_;

+(NSString*)encryptBase64String:(NSString*)string_ withKey:(NSString *)key_ separateLines:(BOOL)separateLines_;
+(NSString*)decryptBase64String:(NSString*)encryptedBase64String_ withKey:(NSString *)key_;

@end
