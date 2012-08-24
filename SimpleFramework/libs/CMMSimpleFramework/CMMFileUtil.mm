#import "CMMFileUtil.h"
#import "CMMStringUtil.h"

@implementation CMMFileUtil

+(BOOL)isExistWithFilePath:(NSString *)filePath_{
	return [[NSFileManager defaultManager] fileExistsAtPath:filePath_];
}
+(BOOL)isExistWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_{
	return [self isExistWithFilePath:[CMMStringUtil stringPathWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_]];
}
+(BOOL)isExistWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self isExistWithFileName:fileName_ isInDocument:isInDocument_ extension:nil];
}

+(NSData *)dataWithSourceData:(NSData *)sourceData_ range:(NSRange)range_{
	NSRange targetRange_ = range_;
	
	if(targetRange_.location+targetRange_.length>[sourceData_ length])
		targetRange_.length = sourceData_.length - targetRange_.location;
	
	return [sourceData_ subdataWithRange:targetRange_];
}

+(NSData *)dataWithFilePath:(NSString *)filePath_{
	NSData *targetData_ = [NSData dataWithContentsOfFile:filePath_];
	return targetData_;
}
+(NSData *)dataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_{
	return [self dataWithFilePath:[CMMStringUtil stringPathWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_]];
}
+(NSData *)dataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self dataWithFileName:fileName_ isInDocument:isInDocument_];
}

+(CCTexture2D *)textureWithData:(NSData *)data_ textureKey:(NSString *)textureKey_{
	return [[CCTextureCache sharedTextureCache] addCGImage:[UIImage imageWithData:data_].CGImage forKey:textureKey_];
}
+(CCTexture2D *)textureWithFilePath:(NSString *)filePath_{
	return [self textureWithData:[self dataWithFilePath:filePath_] textureKey:filePath_];
}
+(CCTexture2D *)textureWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_{
	return [self textureWithFilePath:[CMMStringUtil stringPathWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_]];
}
+(CCTexture2D *)textureWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self textureWithFileName:fileName_ isInDocument:isInDocument_ extension:nil];
}

+(NSDictionary *)dictionaryWithData:(NSData *)data_{
	NSPropertyListFormat format;
	return (NSDictionary*)[NSPropertyListSerialization
						   propertyListFromData:data_
						   mutabilityOption:NSPropertyListMutableContainersAndLeaves
						   format:&format
						   errorDescription:nil];
}
+(NSDictionary *)dictionaryWithFilePath:(NSString *)filePath_{
	return [self dictionaryWithData:[self dataWithFilePath:filePath_]];
}
+(NSDictionary *)dictionaryWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_{
	return [self dictionaryWithFilePath:[CMMStringUtil stringPathWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_]];
}
+(NSDictionary *)dictionaryWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self dictionaryWithFileName:fileName_ isInDocument:isInDocument_ extension:nil];
}

+(void)deleteFileWithFileName:(NSString *)fileName_ extension:(NSString *)extension_{
	[[NSFileManager defaultManager] removeItemAtPath:[CMMStringUtil stringPathOfDocument:fileName_ extension:extension_] error:nil];
}
+(void)deleteFileWithFileName:(NSString *)fileName_{
	[self deleteFileWithFileName:fileName_ extension:nil];
}

@end
