#import "CMMStringUtil.h"

static NSDateFormatter *_staticCMMStringUtil_dateFormatter_ = nil;

@interface CMMStringUtil(Private)

+(NSDateFormatter *)_cmmDateFormatterWithFormat:(NSString *)format_;

@end

@implementation CMMStringUtil(Private)

+(NSDateFormatter *)_cmmDateFormatterWithFormat:(NSString *)format_{
	if(!_staticCMMStringUtil_dateFormatter_){
		_staticCMMStringUtil_dateFormatter_ = [[NSDateFormatter alloc] init];
		[_staticCMMStringUtil_dateFormatter_ setLocale:[NSLocale currentLocale]];
	}
	
	[_staticCMMStringUtil_dateFormatter_ setDateFormat:format_];
	return _staticCMMStringUtil_dateFormatter_;
}

@end

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
	NSString *resultStr_ = @""; //issue
	if(fileName_){
		resultStr_ = [resultStr_ stringByAppendingString:fileName_];
		if(extension_)
			resultStr_ = [resultStr_ stringByAppendingPathExtension:extension_];
	}
	
	return [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:resultStr_];
}
+(NSString *)stringPathOfResoruce:(NSString *)fileName_{
	return [self stringPathOfResoruce:fileName_ extension:nil];
}
+(NSString *)stringPathOfResoruce{
	return [self stringPathOfResoruce:nil];
}

+(NSString *)stringPathOfDocument:(NSString *)fileName_ extension:(NSString *)extension_{
	NSString *resultStr_ = @"../Documents/"; //issue
	if(fileName_){
		resultStr_ = [resultStr_ stringByAppendingString:fileName_];
		if(extension_)
			resultStr_ = [resultStr_ stringByAppendingPathExtension:extension_];
	}
	
	return [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:resultStr_];
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

+(NSDate *)dateWithString:(NSString *)string_ dateFormat:(NSString *)dateFormat_{
	return [[self _cmmDateFormatterWithFormat:dateFormat_] dateFromString:string_];
}
+(NSString *)stringWithDate:(NSDate *)date_ dateFormat:(NSString *)dateFormat_{
	return [[self _cmmDateFormatterWithFormat:dateFormat_] stringFromDate:date_];
}
+(NSString *)stringWithTodayDateWithdateFormat:(NSString *)dateFormat_{
	return [self stringWithDate:[NSDate date] dateFormat:dateFormat_];
}

@end
