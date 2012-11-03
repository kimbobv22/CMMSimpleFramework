//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

@interface CMMFontUtil : NSObject

+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ fontName:(NSString*)fontName_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_;

@end

@interface CMMFontUtil(Setting)

+(void)setDefaultFontSize:(float)fontSize_;
+(void)setDefaultDimensions:(CGSize)dimensions_;
+(void)setDefaultHAlignment:(CCTextAlignment)HAlignment_;
+(void)setDefaultVAlignment:(CCVerticalTextAlignment)VAlignment_;
+(void)setDefaultLineBreakMode:(CCLineBreakMode)lineBreakMode_;
+(void)setDefaultFontName:(NSString *)fontName_;

+(float)defaultFontSize;
+(CGSize)defaultDimensions;
+(CCTextAlignment)defaultHAlignment;
+(CCVerticalTextAlignment)defaultVAlignment;
+(CCLineBreakMode)defaultLineBreakMode;
+(NSString *)defaultFontName;

@end