//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

struct CMMFontPresetStroke{
	CMMFontPresetStroke(){
		color = ccBLACK;
		size = 0.1f;
	}
	CMMFontPresetStroke(ccColor3B color_, float size_) : color(color_), size(size_){}
	
	ccColor3B color;
	float size;
};
typedef CMMFontPresetStroke CMMFontPresetStroke;

struct CMMFontPresetShadow{
	CMMFontPresetShadow(){
		offset = CGSizeMake(1.0f, -1.0f);
		opacity = 0.8f;
		blur = 0.05f;
	}
	CMMFontPresetShadow(CGSize offset_, float opacity_, float blur_) : offset(offset_), opacity(opacity_), blur(blur_){}
	
	CGSize offset;
	float opacity;
	float blur;
};
typedef CMMFontPresetShadow CMMFontPresetShadow;

@interface CMMFontPreset : NSObject{
	ccColor3B fillColor;
	float fontSize;
	CGSize dimensions;
	CCTextAlignment hAlignment;
	CCVerticalTextAlignment vAlignment;
	CCLineBreakMode lineBreakMode;
	NSString *fontName;
	BOOL enableStroke,enableShadow;
	
	CMMFontPresetStroke strokePreset;
	CMMFontPresetShadow shadowPreset;
}

+(id)preset;

@property (nonatomic, readwrite) ccColor3B fillColor;
@property (nonatomic, readwrite) float fontSize;
@property (nonatomic, readwrite) CGSize dimensions;
@property (nonatomic, readwrite) CCTextAlignment hAlignment;
@property (nonatomic, readwrite) CCVerticalTextAlignment vAlignment;
@property (nonatomic, readwrite) CCLineBreakMode lineBreakMode;
@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, readwrite) BOOL enableStroke,enableShadow;
@property (nonatomic, readwrite) CMMFontPresetStroke strokePreset;
@property (nonatomic, readwrite) CMMFontPresetShadow shadowPreset;

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

+(CMMFontPreset *)defaultPreset;
+(void)setDefaultPreset:(CMMFontPreset *)preset_;

+(BOOL)enableEffect;
+(void)setEnableEffect:(BOOL)bool_;

@end

@interface CMMFontUtil(Preset)

+(NSDictionary *)presetList;

+(void)setPreset:(CMMFontPreset *)preset_ forKey:(NSString *)key_;
+(void)removePresetForKey:(NSString *)key_;
+(CMMFontPreset *)presetForKey:(NSString *)key_;

+(CCLabelTTF *)labelWithString:(NSString *)string_ withPresetKey:(NSString *)presetKey_;

@end