#import "CMMStringUtil.h"

static NSString *_resourcePath_ = nil;
static NSString *_documentPath_ = nil;

@implementation CMMStringUtil

+(NSString *)replace:(NSString *)targetStr_ searchStr:(NSString *)searchStr_ replaceStr:(NSString *)replaceStr_{
	NSMutableString *tempTargetStr_ = [NSMutableString stringWithString:targetStr_];
	NSRange substr_ = [tempTargetStr_ rangeOfString:searchStr_];
	
	while(substr_.location != NSNotFound){
		[tempTargetStr_ replaceCharactersInRange:substr_ withString:replaceStr_];
		substr_ = [tempTargetStr_ rangeOfString:searchStr_];
	}
	
	return tempTargetStr_;
}

+(NSString *)stringPathOfResoruce:(NSString *)fileName_ extension:(NSString *)extension_{
	if(!_resourcePath_)
		_resourcePath_ = [[NSString stringWithFormat:@"%@/",[[NSBundle mainBundle] resourcePath]] retain];
	
	NSString *resultStr_ = _resourcePath_;
	if(fileName_){
		resultStr_ = [resultStr_ stringByAppendingString:fileName_];
		if(extension_)
			resultStr_ = [resultStr_ stringByAppendingFormat:@".%@",extension_];
	}
	
	return resultStr_;
}
+(NSString *)stringPathOfResoruce:(NSString *)fileName_{
	return [self stringPathOfResoruce:fileName_ extension:nil];
}
+(NSString *)stringPathOfResoruce{
	return [self stringPathOfResoruce:nil];
}

+(NSString *)stringPathOfDocument:(NSString *)fileName_ extension:(NSString *)extension_{
	if(!_documentPath_){
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															 NSUserDomainMask,
															 YES);
		_documentPath_ = [[NSString stringWithFormat:@"%@/",[paths objectAtIndex:0]] retain];
	}
	
	NSString *resultStr_ = _documentPath_;
	if(fileName_){
		resultStr_ = [resultStr_ stringByAppendingString:fileName_];
		if(extension_)
			resultStr_ = [resultStr_ stringByAppendingFormat:@".%@",extension_];
	}
	
	return resultStr_;
}
+(NSString *)stringPathOfDocument:(NSString *)fileName_{
	return [self stringPathOfDocument:fileName_ extension:nil];
}
+(NSString *)stringPathOfDocument{
	return [self stringPathOfDocument:nil];
}

+(NSString *)stringPathWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_{
	return isInDocument_?[self stringPathOfDocument:fileName_ extension:extension_]:[self stringPathOfResoruce:fileName_ extension:extension_];
}
+(NSString *)stringPathWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self stringPathWithFileName:fileName_ isInDocument:isInDocument_ extension:nil];
}

+(NSString *)stringTimeStyleFromccTime:(ccTime)dt_{
	return [NSString stringWithFormat:@"%02d:%02d",(((int)dt_)%3600)/60,((int)dt_)%60];
}
+(NSString *)stringDecimalStyleFromNumber:(float)number_{
	NSNumberFormatter *formatter_ = [[[NSNumberFormatter alloc] init] autorelease];
	[formatter_ setNumberStyle:kCFNumberFormatterDecimalStyle];
	return [formatter_ stringFromNumber:[NSNumber numberWithFloat:number_]];
}

@end
