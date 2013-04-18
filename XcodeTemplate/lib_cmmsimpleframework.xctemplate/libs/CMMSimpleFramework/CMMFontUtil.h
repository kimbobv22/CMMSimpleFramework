//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

extern float CMMFontUtilDefaultFontSize;
extern CGSize CMMFontUtilDefaultDimensions;
extern CCTextAlignment CMMFontUtilDefaultHAlignment;
extern CCVerticalTextAlignment CMMFontUtilDefaultVAlignment;
extern CCLineBreakMode CMMFontUtilDefaultLineBreakMode;
extern NSString *CMMFontUtilDefaultFontName;

@interface CMMFontPreset : NSObject{
	float fontSize;
	CGSize dimensions;
	CCTextAlignment hAlignment;
	CCVerticalTextAlignment vAlignment;
	CCLineBreakMode lineBreakMode;
	NSString *fontName;
}

+(id)preset;

@property (nonatomic, readwrite) float fontSize;
@property (nonatomic, readwrite) CGSize dimensions;
@property (nonatomic, readwrite) CCTextAlignment hAlignment;
@property (nonatomic, readwrite) CCVerticalTextAlignment vAlignment;
@property (nonatomic, readwrite) CCLineBreakMode lineBreakMode;
@property (nonatomic, copy) NSString *fontName;

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

+(void)setDefaultFontSize:(float)fontSize_;
+(void)setDefaultDimensions:(CGSize)dimensions_;
+(void)setDefaultHAlignment:(CCTextAlignment)HAlignment_;
+(void)setDefaultVAlignment:(CCVerticalTextAlignment)VAlignment_;
+(void)setDefaultLineBreakMode:(CCLineBreakMode)lineBreakMode_;
+(void)setDefaultFontName:(NSString *)fontName_;

@end

@interface CMMFontUtil(Preset)

+(NSDictionary *)presetList;

+(void)setPreset:(CMMFontPreset *)preset_ forKey:(NSString *)key_;
+(void)removePresetForKey:(NSString *)key_;
+(CMMFontPreset *)presetForKey:(NSString *)key_;

+(CCLabelTTF *)labelWithString:(NSString *)string_ withPresetKey:(NSString *)presetKey_;

@end