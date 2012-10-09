//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

#define cmmVarCMMFontUtil_defaultFontSize 14.0f
#define cmmVarCMMFontUtil_defaultDimensions CGSizeZero
#define cmmVarCMMFontUtil_defaultHAlignment kCCTextAlignmentCenter
#define cmmVarCMMFontUtil_defaultVAlignment kCCVerticalTextAlignmentCenter
#define cmmVarCMMFontUtil_defaultLineBreakMode kCCLineBreakModeWordWrap
#define cmmVarCMMFontUtil_defaultFontName @"Helvetica"

@interface CMMFontUtil : NSObject

+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ fontName:(NSString*)fontName_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_;
+(CCLabelTTF *)labelWithstring:(NSString *)string_;

@end
