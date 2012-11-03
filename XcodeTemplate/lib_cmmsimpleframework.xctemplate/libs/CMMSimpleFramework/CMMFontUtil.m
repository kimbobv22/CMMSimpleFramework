//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMFontUtil.h"

static float _sharedCMMFontUtil_defaultFontSize_ = 14.0f;
static CGSize _sharedCMMFontUtil_defaultDimensions_ = (CGSize){0,0};
static CCTextAlignment _sharedCMMFontUtil_defaultHAlignment_ = kCCTextAlignmentCenter;
static CCVerticalTextAlignment _sharedCMMFontUtil_defaultVAlignment_ = kCCVerticalTextAlignmentCenter;
static CCLineBreakMode _sharedCMMFontUtil_defaultLineBreakMode_ = kCCLineBreakModeWordWrap;
static NSString *_sharedCMMFontUtil_defaultFontName_ = @"Helvetica";

@implementation CMMFontUtil

+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ fontName:(NSString*)fontName_{
	return [CCLabelTTF labelWithString:string_ fontName:fontName_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_{
	return [self labelWithstring:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_ fontName:_sharedCMMFontUtil_defaultFontName_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_{
	return [self labelWithstring:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:_sharedCMMFontUtil_defaultLineBreakMode_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_{
	return [self labelWithstring:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:_sharedCMMFontUtil_defaultVAlignment_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_{
	return [self labelWithstring:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:_sharedCMMFontUtil_defaultHAlignment_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_{
	return [self labelWithstring:string_ fontSize:fontSize_ dimensions:_sharedCMMFontUtil_defaultDimensions_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_{
	return [self labelWithstring:string_ fontSize:_sharedCMMFontUtil_defaultFontSize_];
}

@end

@implementation CMMFontUtil(Setting)

+(void)setDefaultFontSize:(float)fontSize_{
	_sharedCMMFontUtil_defaultFontSize_ = fontSize_;
}
+(void)setDefaultDimensions:(CGSize)dimensions_{
	_sharedCMMFontUtil_defaultDimensions_ = dimensions_;
}
+(void)setDefaultHAlignment:(CCTextAlignment)HAlignment_{
	_sharedCMMFontUtil_defaultHAlignment_ = HAlignment_;
}
+(void)setDefaultVAlignment:(CCVerticalTextAlignment)VAlignment_{
	_sharedCMMFontUtil_defaultVAlignment_ = VAlignment_;
}
+(void)setDefaultLineBreakMode:(CCLineBreakMode)lineBreakMode_{
	_sharedCMMFontUtil_defaultLineBreakMode_ = lineBreakMode_;
}
+(void)setDefaultFontName:(NSString *)fontName_{
	[_sharedCMMFontUtil_defaultFontName_ release];
	_sharedCMMFontUtil_defaultFontName_ = [fontName_ copy];
}

+(float)defaultFontSize{
	return _sharedCMMFontUtil_defaultFontSize_;
}
+(CGSize)defaultDimensions{
	return _sharedCMMFontUtil_defaultDimensions_;
}
+(CCTextAlignment)defaultHAlignment{
	return _sharedCMMFontUtil_defaultHAlignment_;
}
+(CCVerticalTextAlignment)defaultVAlignment{
	return _sharedCMMFontUtil_defaultVAlignment_;
}
+(CCLineBreakMode)defaultLineBreakMode{
	return _sharedCMMFontUtil_defaultLineBreakMode_;
}
+(NSString *)defaultFontName{
	return _sharedCMMFontUtil_defaultFontName_;
}

@end