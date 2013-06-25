//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

@interface CCFontDefinition(CMMExtension)<NSCopying>

+(id)preset;

@end

@interface CMMFontUtil : NSObject

+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ fontName:(NSString*)fontName_;
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_;
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_;
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_;
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_;
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_;
+(CCLabelTTF *)labelWithString:(NSString *)string_;

@end

@interface CMMFontUtil(Configuration)

+(CCFontDefinition *)defaultPreset;
+(void)setDefaultPreset:(CCFontDefinition *)preset_;

+(BOOL)enableEffect;
+(void)setEnableEffect:(BOOL)bool_;

@end

@interface CMMFontUtil(Preset)

+(NSDictionary *)presetList;

+(void)setPreset:(CCFontDefinition *)preset_ forKey:(NSString *)key_;
+(void)removePresetForKey:(NSString *)key_;
+(CCFontDefinition *)presetForKey:(NSString *)key_;

+(CCLabelTTF *)labelWithString:(NSString *)string_ withPresetKey:(NSString *)presetKey_;

@end