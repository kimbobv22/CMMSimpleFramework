//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMFontUtil.h"

@implementation CMMFontPreset
@synthesize fillColor,fontSize,dimensions,hAlignment,vAlignment,lineBreakMode,fontName,enableStroke,enableShadow;
@synthesize strokePreset,shadowPreset;

+(id)preset{
	return [[[self alloc] init] autorelease];
}
-(id)init{
	if(!(self = [super init])) return self;
	
	fillColor = ccWHITE;
	fontSize = 14.0f;
	dimensions = CGSizeZero;
	hAlignment = kCCTextAlignmentCenter;
	vAlignment = kCCVerticalTextAlignmentCenter;
	lineBreakMode = kCCLineBreakModeWordWrap;
	fontName = @"Helvetica";
	enableStroke = NO;
	enableShadow = YES;
	
	strokePreset = CMMFontPresetStroke();
	shadowPreset = CMMFontPresetShadow();
	
	return self;
}

-(void)dealloc{
	[fontName release];
	[super dealloc];
}

@end

static CMMFontPreset *_CMMFontUtilDefaultPreset_ = [CMMFontUtil defaultPreset];
static BOOL _CMMFontUtilEnableEffect_ = YES;

@interface CMMFontUtil(Private)

+(void)_renderEffect:(CCLabelTTF *)label_ withPreset:(CMMFontPreset *)preset_;

@end

@implementation CMMFontUtil(Private)

+(void)_renderEffect:(CCLabelTTF *)label_ withPreset:(CMMFontPreset *)preset_{
	if(!_CMMFontUtilEnableEffect_) return;
	[label_ setFontFillColor:[preset_ fillColor] updateImage:YES];
	if([preset_ enableStroke]){
		CMMFontPresetStroke strokePreset_ = [preset_ strokePreset];
		[label_ enableStrokeWithColor:strokePreset_.color size:strokePreset_.size updateImage:YES];
	}
	if([preset_ enableShadow]){
		CMMFontPresetShadow shadowPreset_ = [preset_ shadowPreset];
		[label_ enableShadowWithOffset:shadowPreset_.offset opacity:shadowPreset_.opacity blur:shadowPreset_.blur updateImage:YES];
	}
}

@end

@implementation CMMFontUtil

+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ fontName:(NSString*)fontName_{
	CCLabelTTF *label_ = [CCLabelTTF labelWithString:string_ fontName:fontName_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_];
	[self _renderEffect:label_ withPreset:[self defaultPreset]];
	
	return label_;
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_ fontName:[_CMMFontUtilDefaultPreset_ fontName]];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:[_CMMFontUtilDefaultPreset_ lineBreakMode]];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:[_CMMFontUtilDefaultPreset_ vAlignment]];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:[_CMMFontUtilDefaultPreset_ hAlignment]];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:[_CMMFontUtilDefaultPreset_ dimensions]];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_{
	return [self labelWithString:string_ fontSize:[_CMMFontUtilDefaultPreset_ fontSize]];
}

@end

@implementation CMMFontUtil(Configuration)

+(CMMFontPreset *)defaultPreset{
	if(!_CMMFontUtilDefaultPreset_){
		_CMMFontUtilDefaultPreset_ = [[CMMFontPreset alloc] init];
	}
	return _CMMFontUtilDefaultPreset_;
}
+(void)setDefaultPreset:(CMMFontPreset *)preset_{
	[_CMMFontUtilDefaultPreset_ release];
	_CMMFontUtilDefaultPreset_ = [preset_ retain];
}

+(BOOL)enableEffect{
	return _CMMFontUtilEnableEffect_;
}
+(void)setEnableEffect:(BOOL)bool_{
	_CMMFontUtilEnableEffect_ = bool_;
}

@end

NSMutableDictionary *_sharedCMMFontUtilPresetList_ = nil;

@implementation CMMFontUtil(Preset)

+(NSMutableDictionary *)_presetList{
	if(!_sharedCMMFontUtilPresetList_){
		_sharedCMMFontUtilPresetList_ = [[NSMutableDictionary alloc] init];
	}
	
	return _sharedCMMFontUtilPresetList_;
}
+(NSDictionary *)presetList{
	return [NSDictionary dictionaryWithDictionary:[self _presetList]];
}

+(void)setPreset:(CMMFontPreset *)preset_ forKey:(NSString *)key_{
	[[self _presetList] setObject:preset_ forKey:key_];
}
+(void)removePresetForKey:(NSString *)key_{
	[[self _presetList] removeObjectForKey:key_];
}
+(CMMFontPreset *)presetForKey:(NSString *)key_{
	return [[self _presetList] objectForKey:key_];
}

+(CCLabelTTF *)labelWithString:(NSString *)string_ withPresetKey:(NSString *)presetKey_{
	CMMFontPreset *preset_ = [self presetForKey:presetKey_];
	if(!preset_){
		CCLOGWARN(@"CMMFontUtil : Font preset is nil");
		return [self labelWithString:string_];
	}
	
	CCLabelTTF *label_ = [CCLabelTTF labelWithString:string_ fontName:[preset_ fontName] fontSize:[preset_ fontSize] dimensions:[preset_ dimensions] hAlignment:[preset_ hAlignment] vAlignment:[preset_ vAlignment] lineBreakMode:[preset_ lineBreakMode]];
	[self _renderEffect:label_ withPreset:preset_];
	
	return label_;
}

@end