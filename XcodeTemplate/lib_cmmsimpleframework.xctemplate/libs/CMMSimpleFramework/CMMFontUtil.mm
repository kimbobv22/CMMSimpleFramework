//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMFontUtil.h"

@implementation CCFontDefinition(CMMExtension)

+(id)preset{
	return [[[self alloc] init] autorelease];
}

-(id)copyWithZone:(NSZone *)zone_{
	CCFontDefinition *copy_ = [[[self class] alloc] init];
	[copy_ setFontSize:[self fontSize]];
	[copy_ setDimensions:[self dimensions]];
	[copy_ setAlignment:[self alignment]];
	[copy_ setVertAlignment:[self vertAlignment]];
	[copy_ setLineBreakMode:[self lineBreakMode]];
	[copy_ setFontName:[self fontName]];
	
	[copy_ setFontFillColor:[self fontFillColor]];
	
	[copy_ enableShadow:[self shadowEnabled]];
	[copy_ setShadowOffset:[self shadowOffset]];
	[copy_ setShadowBlur:[self shadowBlur]];
	
	[copy_ enableStroke:[self strokeEnabled]];
	[copy_ setStrokeSize:[self strokeSize]];
	[copy_ setStrokeColor:[self strokeColor]];
	
	return copy_;
}

@end

static CCFontDefinition *_CMMFontUtilDefaultPreset_ = [CMMFontUtil defaultPreset];
static BOOL _CMMFontUtilEnableEffect_ = YES;

@implementation CMMFontUtil

+(CCLabelTTF *)labelWithString:(NSString *)string_ withPreset:(CCFontDefinition *)preset_{
	//apply default preset
	[preset_ setFontFillColor:[_CMMFontUtilDefaultPreset_ fontFillColor]];
	
	if(!_CMMFontUtilEnableEffect_){
		[preset_ enableShadow:NO];
		[preset_ enableStroke:NO];
	}
	
	return [CCLabelTTF labelWithString:string_ fontDefinition:preset_];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ fontName:(NSString*)fontName_{
	
	CCFontDefinition *preset_ = [[_CMMFontUtilDefaultPreset_ copy] autorelease];
	[preset_ setFontName:fontName_];
	[preset_ setFontSize:fontSize_];
	[preset_ setDimensions:dimensions_];
	[preset_ setAlignment:hAlignment_];
	[preset_ setVertAlignment:vAlignment_];
	[preset_ setLineBreakMode:lineBreakMode_];
	return [self labelWithString:string_ withPreset:preset_];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_ fontName:[_CMMFontUtilDefaultPreset_ fontName]];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:[_CMMFontUtilDefaultPreset_ lineBreakMode]];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:[_CMMFontUtilDefaultPreset_ vertAlignment]];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:[_CMMFontUtilDefaultPreset_ alignment]];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:[_CMMFontUtilDefaultPreset_ dimensions]];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_{
	return [self labelWithString:string_ fontSize:[_CMMFontUtilDefaultPreset_ fontSize]];
}

@end

@implementation CMMFontUtil(Configuration)

+(CCFontDefinition *)defaultPreset{
	if(!_CMMFontUtilDefaultPreset_){
		_CMMFontUtilDefaultPreset_ = [[CCFontDefinition alloc] initWithFontName:@"Helvetica" fontSize:14.0f];
		[_CMMFontUtilDefaultPreset_ setAlignment:kCCTextAlignmentCenter];
		[_CMMFontUtilDefaultPreset_ setVertAlignment:kCCVerticalTextAlignmentCenter];
		[_CMMFontUtilDefaultPreset_ setLineBreakMode:kCCLineBreakModeWordWrap];

		[_CMMFontUtilDefaultPreset_ setFontFillColor:ccWHITE];
		[_CMMFontUtilDefaultPreset_ enableShadow:YES];
		[_CMMFontUtilDefaultPreset_ setShadowBlur:0.05];
		[_CMMFontUtilDefaultPreset_ setShadowOffset:CGSizeMake(1.0f, -1.0f)];
	}
	return _CMMFontUtilDefaultPreset_;
}
+(void)setDefaultPreset:(CCFontDefinition *)preset_{
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

+(void)setPreset:(CCFontDefinition *)preset_ forKey:(NSString *)key_{
	[[self _presetList] setObject:preset_ forKey:key_];
}
+(void)removePresetForKey:(NSString *)key_{
	[[self _presetList] removeObjectForKey:key_];
}
+(CCFontDefinition *)presetForKey:(NSString *)key_{
	return [[self _presetList] objectForKey:key_];
}

+(CCLabelTTF *)labelWithString:(NSString *)string_ withPresetKey:(NSString *)presetKey_{
	CCFontDefinition *preset_ = [self presetForKey:presetKey_];
	if(!preset_){
		CCLOGWARN(@"CMMFontUtil : Font preset is nil");
		return [self labelWithString:string_];
	}
	
	return [self labelWithString:string_ withPreset:[[preset_ copy] autorelease]];
}

@end