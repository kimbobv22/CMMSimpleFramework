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

+(NSData *)dataWithFilePath:(NSString *)filePath_ encryptionKey:(NSString *)encryptionKey_{
	NSData *targetData_ = [NSData dataWithContentsOfFile:filePath_];
	if(targetData_ && encryptionKey_){
		targetData_ = [CMMEncryptionUtil decryptData:targetData_ withKey:encryptionKey_];
	}
	
	return targetData_;
}
+(NSData *)dataWithFilePath:(NSString *)filePath_{
	NSData *targetData_ = [NSData dataWithContentsOfFile:filePath_];
	return targetData_;
}
+(NSData *)dataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_ encryptionKey:(NSString *)encryptionKey_{
	return [self dataWithFilePath:[CMMStringUtil stringPathWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_] encryptionKey:encryptionKey_];
}
+(NSData *)dataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_{
	return [self dataWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_ encryptionKey:nil];
}
+(NSData *)dataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self dataWithFileName:fileName_ isInDocument:isInDocument_ extension:nil];
}

+(void)deleteFileWithFileName:(NSString *)fileName_ extension:(NSString *)extension_{
	[[NSFileManager defaultManager] removeItemAtPath:[CMMStringUtil stringPathOfDocument:fileName_ extension:extension_] error:nil];
}
+(void)deleteFileWithFileName:(NSString *)fileName_{
	[self deleteFileWithFileName:fileName_ extension:nil];
}

+(void)writeFileInBackgroundWithData:(NSData *)data_ path:(NSString *)path_ block:(void(^)(NSError *))block_{
	cmmFunc_callBackQueue(^{
		NSError *error_ = nil;
		[data_ writeToFile:path_ options:NSDataWritingAtomic error:&error_];
		if(block_){
			cmmFunc_callMainQueue(^{
				block_(error_);
			});
		}
	});
}

@end

@implementation CMMFileUtil(Dictionary)

+(NSDictionary *)dictionaryWithData:(NSData *)data_{
	NSPropertyListFormat format;
	return (NSDictionary*)[NSPropertyListSerialization
						   propertyListFromData:data_
						   mutabilityOption:NSPropertyListMutableContainersAndLeaves
						   format:&format
						   errorDescription:nil];
}
+(NSDictionary *)dictionaryWithFilePath:(NSString *)filePath_ encryptionKey:(NSString *)encryptionKey_{
	return [self dictionaryWithData:[self dataWithFilePath:filePath_ encryptionKey:encryptionKey_]];
}
+(NSDictionary *)dictionaryWithFilePath:(NSString *)filePath_{
	return [self dictionaryWithFilePath:filePath_ encryptionKey:nil];
}
+(NSDictionary *)dictionaryWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_ encryptionKey:(NSString *)encryptionKey_{
	return [self dictionaryWithFilePath:[CMMStringUtil stringPathWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_] encryptionKey:encryptionKey_];
}
+(NSDictionary *)dictionaryWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_{
	return [self dictionaryWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_ encryptionKey:nil];
}
+(NSDictionary *)dictionaryWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self dictionaryWithFileName:fileName_ isInDocument:isInDocument_ extension:nil];
}

@end

@implementation CMMFileUtil(ImageData)

+(CCTexture2D *)textureWithData:(NSData *)data_ textureKey:(NSString *)textureKey_{
	return [[CCTextureCache sharedTextureCache] addCGImage:[UIImage imageWithData:data_].CGImage forKey:textureKey_];
}
+(CCTexture2D *)textureWithFilePath:(NSString *)filePath_ encryptionKey:(NSString *)encryptionKey_{
	return [self textureWithData:[self dataWithFilePath:filePath_ encryptionKey:encryptionKey_] textureKey:filePath_];
}
+(CCTexture2D *)textureWithFilePath:(NSString *)filePath_{
	return [self textureWithFilePath:filePath_ encryptionKey:nil];
}
+(CCTexture2D *)textureWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_ encryptionKey:(NSString *)encryptionKey_{
	return [self textureWithFilePath:[CMMStringUtil stringPathWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_] encryptionKey:encryptionKey_];
}
+(CCTexture2D *)textureWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_{
	return [self textureWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_ encryptionKey:nil];
}
+(CCTexture2D *)textureWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self textureWithFileName:fileName_ isInDocument:isInDocument_ extension:nil];
}

+(void *)imageDataWithCGImage:(CGImageRef)cgImage_{
	if(!cgImage_){
		CCLOG(@"CMMFileUtil : failed to get data. CGImage is nil");
		return nil;
	}
	
	CGImageAlphaInfo alphaInfo_ = CGImageGetAlphaInfo(cgImage_);
	CCConfiguration *ccConf_ = [CCConfiguration sharedConfiguration];
	
	BOOL hasAlpha_ = NO;
	
#ifdef __CC_PLATFORM_IOS
	unsigned int version_ = [ccConf_ OSVersion];
	if(version_ >= kCCiOSVersion_4_0 && version_ < kCCiOSVersion_5_0 )
		hasAlpha_ = ((alphaInfo_ == kCGImageAlphaNoneSkipLast) || (alphaInfo_ == kCGImageAlphaPremultipliedLast) || (alphaInfo_ == kCGImageAlphaPremultipliedFirst) || (alphaInfo_ == kCGImageAlphaLast) || (alphaInfo_ == kCGImageAlphaFirst) ? YES : NO);
	else
#endif // __CC_PLATFORM_IOS
		hasAlpha_ = ((alphaInfo_ == kCGImageAlphaPremultipliedLast) || (alphaInfo_ == kCGImageAlphaPremultipliedFirst) || (alphaInfo_ == kCGImageAlphaLast) || (alphaInfo_ == kCGImageAlphaFirst) ? YES : NO);
	
	CGColorSpaceRef	colorSpace_ = CGImageGetColorSpace(cgImage_);
	CCTexture2DPixelFormat pixelFormat_;
	
	if(colorSpace_){
		if(hasAlpha_){
			pixelFormat_ = kCCTexture2DPixelFormat_Default;
			alphaInfo_ = kCGImageAlphaPremultipliedLast;
		}else{
			alphaInfo_ = kCGImageAlphaNoneSkipLast;
			
			if(kCCTexture2DPixelFormat_Default == kCCTexture2DPixelFormat_RGBA8888)
				pixelFormat_ = kCCTexture2DPixelFormat_RGBA8888;
			else
				pixelFormat_ = kCCTexture2DPixelFormat_RGB565;
		}
	}else{
		pixelFormat_ = kCCTexture2DPixelFormat_A8;
	}
	
	NSUInteger textureWidth_,textureHeight_;
	textureWidth_ = CGImageGetWidth(cgImage_);
	textureHeight_ = CGImageGetHeight(cgImage_);
	if(![ccConf_ supportsNPOT]){
		textureWidth_ = ccNextPOT(textureWidth_);
		textureHeight_ = ccNextPOT(textureHeight_);
	}
		
#ifdef __CC_PLATFORM_IOS
	if([ccConf_ OSVersion] >= kCCiOSVersion_5_0){
		NSUInteger bpp_ = [[CCTexture2D class] bitsPerPixelForFormat:pixelFormat_];
		NSUInteger bytes_ = textureWidth_ * bpp_ / 8;
		NSUInteger mod_ = bytes_ % 4;
		
		if(mod_ != 0){
			NSUInteger neededBytes_ = (4 - mod_)/(bpp_/8);
			textureWidth_ = textureWidth_ + neededBytes_;
		}
		
	}
#endif // IOS
	
	NSUInteger maxTextureSize_ = [ccConf_ maxTextureSize];
	if(textureHeight_ > maxTextureSize_ || textureWidth_ > maxTextureSize_){
		CCLOG(@"CMMFileUtil : image data(%lu x %lu) is bigger than the supported %lu x %lu",(long)textureWidth_,(long)textureHeight_,(long)maxTextureSize_,(long)maxTextureSize_);
		return nil;
	}
	
	CGSize imageSize_ = CGSizeMake(CGImageGetWidth(cgImage_), CGImageGetHeight(cgImage_));
	CGContextRef context_;
	void *data_;
	
	switch(pixelFormat_) {
		case kCCTexture2DPixelFormat_RGBA8888:
		case kCCTexture2DPixelFormat_RGBA4444:
		case kCCTexture2DPixelFormat_RGB5A1:
		case kCCTexture2DPixelFormat_RGB565:
		case kCCTexture2DPixelFormat_RGB888:
			colorSpace_ = CGColorSpaceCreateDeviceRGB();
			data_ = malloc(textureHeight_ * textureWidth_ * 4);
			context_ = CGBitmapContextCreate(data_, textureWidth_, textureHeight_, 8, 4 * textureWidth_, colorSpace_, alphaInfo_ | kCGBitmapByteOrder32Big);
			CGColorSpaceRelease(colorSpace_);
			break;
		case kCCTexture2DPixelFormat_A8:
			data_ = malloc(textureHeight_ * textureWidth_);
			alphaInfo_ = kCGImageAlphaOnly;
			context_ = CGBitmapContextCreate(data_, textureWidth_, textureHeight_, 8, textureWidth_, NULL, alphaInfo_);
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid pixel format"];
	}
	
	CGContextClearRect(context_, CGRectMake(0, 0, textureWidth_, textureHeight_));
	CGContextTranslateCTM(context_, 0, textureHeight_ - imageSize_.height);
	CGContextDrawImage(context_, CGRectMake(0, 0, CGImageGetWidth(cgImage_), CGImageGetHeight(cgImage_)), cgImage_);
	
	void *tempData_;
	unsigned int * inPixel32_;
	unsigned short *outPixel16_;
	
	if(pixelFormat_ == kCCTexture2DPixelFormat_RGB565) {
		//Convert "RRRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA" to "RRRRRGGGGGGBBBBB"
		tempData_ = malloc(textureHeight_ * textureWidth_ * 2);
		inPixel32_ = (unsigned int*)data_;
		outPixel16_ = (unsigned short*)tempData_;
		for(unsigned int i = 0; i < textureWidth_ * textureHeight_; ++i, ++inPixel32_)
			*outPixel16_++ = ((((*inPixel32_ >> 0) & 0xFF) >> 3) << 11) | ((((*inPixel32_ >> 8) & 0xFF) >> 2) << 5) | ((((*inPixel32_ >> 16) & 0xFF) >> 3) << 0);
		free(data_);
		data_ = tempData_;
		
	}
	
	else if(pixelFormat_ == kCCTexture2DPixelFormat_RGB888) {
		//Convert "RRRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA" to "RRRRRRRRGGGGGGGGBBBBBBB"
		tempData_ = malloc(textureHeight_ * textureWidth_ * 3);
		char *inData_ = (char*)data_;
		char *outData_ = (char*)tempData_;
		int j=0;
		for(unsigned int i = 0; i < textureWidth_ * textureHeight_ *4; i++) {
			outData_[j++] = inData_[i++];
			outData_[j++] = inData_[i++];
			outData_[j++] = inData_[i++];
		}
		free(data_);
		data_ = tempData_;
		
	}
	
	else if (pixelFormat_ == kCCTexture2DPixelFormat_RGBA4444) {
		//Convert "RRRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA" to "RRRRGGGGBBBBAAAA"
		tempData_ = malloc(textureHeight_ * textureWidth_ * 2);
		inPixel32_ = (unsigned int*)data_;
		outPixel16_ = (unsigned short*)tempData_;
		for(unsigned int i = 0; i < textureWidth_ * textureHeight_; ++i, ++inPixel32_)
			*outPixel16_++ =
			((((*inPixel32_ >> 0) & 0xFF) >> 4) << 12) | // R
			((((*inPixel32_ >> 8) & 0xFF) >> 4) << 8) | // G
			((((*inPixel32_ >> 16) & 0xFF) >> 4) << 4) | // B
			((((*inPixel32_ >> 24) & 0xFF) >> 4) << 0); // A
		
		
		free(data_);
		data_ = tempData_;
		
	}
	else if (pixelFormat_ == kCCTexture2DPixelFormat_RGB5A1) {
		//Convert "RRRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA" to "RRRRRGGGGGBBBBBA"
		tempData_ = malloc(textureHeight_ * textureWidth_ * 2);
		inPixel32_ = (unsigned int*)data_;
		outPixel16_ = (unsigned short*)tempData_;
		for(unsigned int i = 0; i < textureWidth_ * textureHeight_; ++i, ++inPixel32_) {
			if ((*inPixel32_ >> 31))// A can be 1 or 0
				*outPixel16_++ =
				((((*inPixel32_ >> 0) & 0xFF) >> 3) << 11) | // R
				((((*inPixel32_ >> 8) & 0xFF) >> 3) << 6) | // G
				((((*inPixel32_ >> 16) & 0xFF) >> 3) << 1) | // B
				1; // A
			else
				*outPixel16_++ = 0;
		}
		
		free(data_);
		data_ = tempData_;
	}
	
	CGContextRelease(context_);
	
	return data_;
}
+(void *)imageDataWithFilePath:(NSString *)filePath_{
	return [[UIImage imageWithData:[self dataWithFilePath:filePath_]] CGImage];
}
+(void *)imageDataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_{
	return [self imageDataWithFilePath:[CMMStringUtil stringPathWithFileName:fileName_ isInDocument:isInDocument_ extension:extension_]];
}
+(void *)imageDataWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self imageDataWithFileName:fileName_ isInDocument:isInDocument_ extension:nil];
}
@end
