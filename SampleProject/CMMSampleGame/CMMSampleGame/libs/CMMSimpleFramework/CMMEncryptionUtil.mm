//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMEncryptionUtil.h"

@implementation CMMEncryptionUtil

+(NSData*)encryptData:(NSData*)data_ withKey:(NSString *)key_{
    NSData* result = nil;
	
    unsigned char cKey[kCCKeySizeAES256];
	bzero(cKey, sizeof(cKey));
    [[key_ dataUsingEncoding:NSUTF8StringEncoding] getBytes:cKey length:kCCKeySizeAES256];
	
    char cIv[kCCBlockSizeAES128];
    bzero(cIv, kCCBlockSizeAES128);
    
	size_t bufferSize = [data_ length] + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t encryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,kCCAlgorithmAES128,kCCOptionPKCS7Padding,cKey,kCCKeySizeAES256,cIv,[data_ bytes],[data_ length],buffer,bufferSize,&encryptedSize);
	if(cryptStatus == kCCSuccess){
		result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
	}else{
        free(buffer);
    }
	
	return result;
}

+(NSData*)decryptData:(NSData*)data_ withKey:(NSString *)key_{
    NSData* result = nil;
	
    unsigned char cKey[kCCKeySizeAES256];
	bzero(cKey, sizeof(cKey));
    [[key_ dataUsingEncoding:NSUTF8StringEncoding] getBytes:cKey length:kCCKeySizeAES256];
	
    char cIv[kCCBlockSizeAES128];
    bzero(cIv, kCCBlockSizeAES128);
    
	size_t bufferSize = [data_ length] + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t decryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,kCCAlgorithmAES128,kCCOptionPKCS7Padding,cKey,kCCKeySizeAES256,cIv,[data_ bytes],[data_ length],buffer,bufferSize,&decryptedSize);
	
	if(cryptStatus == kCCSuccess){
		result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
	}else{
        free(buffer);
    }
	
	return result;
}

+(NSString*)encryptBase64String:(NSString*)string_ withKey:(NSString *)key_ separateLines:(BOOL)separateLines_{
    NSData* data = [self encryptData:[string_ dataUsingEncoding:NSUTF8StringEncoding] withKey:key_];
    return [data base64EncodedStringWithSeparateLines:separateLines_];
}

+(NSString*)decryptBase64String:(NSString*)encryptedBase64String_ withKey:(NSString *)key_{
    NSData* encryptedData_ = [NSData dataFromBase64String:encryptedBase64String_];
    NSData* data_ = [self decryptData:encryptedData_ withKey:key_];
    if(!data_){
        return nil;
    }
	return [[[NSString alloc] initWithData:data_ encoding:NSUTF8StringEncoding] autorelease];
}

@end
