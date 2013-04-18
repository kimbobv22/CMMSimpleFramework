//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMFontUtil.h"

float CMMFontUtilDefaultFontSize = 14.0f;
CGSize CMMFontUtilDefaultDimensions = (CGSize){0,0};
CCTextAlignment CMMFontUtilDefaultHAlignment = kCCTextAlignmentCenter;
CCVerticalTextAlignment CMMFontUtilDefaultVAlignment = kCCVerticalTextAlignmentCenter;
CCLineBreakMode CMMFontUtilDefaultLineBreakMode = kCCLineBreakModeWordWrap;
NSString *CMMFontUtilDefaultFontName = @"Helvetica";

@implementation CMMFontPreset
@synthesize fontSize,dimensions,hAlignment,vAlignment,lineBreakMode,fontName;

+(id)preset{
	return [[[self alloc] init] autorelease];
}
-(id)init{
	if(!(self = [super init])) return self;
	
	fontSize = CMMFontUtilDefaultFontSize;
	dimensions = CMMFontUtilDefaultDimensions;
	hAlignment = CMMFontUtilDefaultHAlignment;
	vAlignment = CMMFontUtilDefaultVAlignment;
	lineBreakMode = CMMFontUtilDefaultLineBreakMode;
	fontName = [CMMFontUtilDefaultFontName copy];
	
	return self;
}

-(void)dealloc{
	[fontName release];
	[super dealloc];
}

@end

@implementation CMMFontUtil

+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ fontName:(NSString*)fontName_{
	return [CCLabelTTF labelWithString:string_ fontName:fontName_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_ fontName:CMMFontUtilDefaultFontName];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:CMMFontUtilDefaultLineBreakMode];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:CMMFontUtilDefaultVAlignment];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:CMMFontUtilDefaultHAlignment];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_ fontSize:(float)fontSize_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:CMMFontUtilDefaultDimensions];
}
+(CCLabelTTF *)labelWithString:(NSString *)string_{
	return [self labelWithString:string_ fontSize:CMMFontUtilDefaultFontSize];
}

@end

@implementation CMMFontUtil(Configuration)

+(void)setDefaultFontSize:(float)fontSize_{
	CMMFontUtilDefaultFontSize = fontSize_;
}
+(void)setDefaultDimensions:(CGSize)dimensions_{
	CMMFontUtilDefaultDimensions = dimensions_;
}
+(void)setDefaultHAlignment:(CCTextAlignment)HAlignment_{
	CMMFontUtilDefaultHAlignment = HAlignment_;
}
+(void)setDefaultVAlignment:(CCVerticalTextAlignment)VAlignment_{
	CMMFontUtilDefaultVAlignment = VAlignment_;
}
+(void)setDefaultLineBreakMode:(CCLineBreakMode)lineBreakMode_{
	CMMFontUtilDefaultLineBreakMode = lineBreakMode_;
}
+(void)setDefaultFontName:(NSString *)fontName_{
	[CMMFontUtilDefaultFontName release];
	CMMFontUtilDefaultFontName = [fontName_ copy];
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
	return [self labelWithString:string_ fontSize:[preset_ fontSize] dimensions:[preset_ dimensions] hAlignment:[preset_ hAlignment] vAlignment:[preset_ vAlignment] lineBreakMode:[preset_ lineBreakMode] fontName:[preset_ fontName]];
}

@end