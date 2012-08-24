//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMFontUtil.h"

@implementation CMMFontUtil

+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ fontName:(NSString*)fontName_{
	return [CCLabelTTF labelWithString:string_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_ fontName:fontName_ fontSize:fontSize_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_{
	return [self labelWithstring:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_ fontName:cmmVarCMMFontUtil_defaultFontName];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_{
	return [self labelWithstring:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:cmmVarCMMFontUtil_defaultLineBreakMode];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_{
	return [self labelWithstring:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:cmmVarCMMFontUtil_defaultVAlignment];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_{
	return [self labelWithstring:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:cmmVarCMMFontUtil_defaultHAlignment];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_{
	return [self labelWithstring:string_ fontSize:fontSize_ dimensions:cmmVarCMMFontUtil_defaultDimensions];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_{
	return [self labelWithstring:string_ fontSize:cmmVarCMMFontUtil_defaultFontSize];
}

@end
