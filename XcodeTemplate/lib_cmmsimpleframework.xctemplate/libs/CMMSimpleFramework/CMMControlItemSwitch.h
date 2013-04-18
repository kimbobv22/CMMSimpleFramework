//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItem.h"
#import "CMMMenuItem.h"

extern ccColor3B CMMControlItemSwitchBackColorLeft;
extern ccColor3B CMMControlItemSwitchBackColorRight;

extern ccColor3B CMMControlItemSwitchBackLabelColorLeft;
extern ccColor3B CMMControlItemSwitchBackLabelColorRight;

extern GLubyte CMMControlItemSwitchBackLabelOpacityLeft;
extern GLubyte CMMControlItemSwitchBackLabelOpacityRight;

extern float CMMControlItemSwitchBackLabelSizeLeft;
extern float CMMControlItemSwitchBackLabelSizeRight;

extern NSString *CMMControlItemSwitchBackLabelStringLeft;
extern NSString *CMMControlItemSwitchBackLabelStringRight;

@interface CMMControlItemSwitch : CMMControlItem{
	CMMMenuItem *buttonItem;
	BOOL itemValue;
	ccColor3B backColorL,backColorR;
	
	void (^callback_whenItemValueChanged)(BOOL itemValue_);
}

+(id)controlItemSwitchWithMaskFrame:(CCSpriteFrame *)maskFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_;
+(id)controlItemSwitchWithFrameSeq:(uint)frameSeq_;

-(id)initWithMaskFrame:(CCSpriteFrame *)maskFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_;
-(id)initWithFrameSeq:(uint)frameSeq_;

-(void)setButtonFrame:(CCSpriteFrame *)frame_;
-(void)setButtonFrameWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_;
-(void)setButtonFrameWithSprite:(CCSprite *)sprite_;

@property (nonatomic, readwrite) BOOL itemValue;
@property (nonatomic, readonly) CMMMenuItem *buttonItem;
@property (nonatomic, readwrite) ccColor3B backColorL,backColorR;
@property (nonatomic, readwrite) ccColor3B backLabelColorL,backLabelColorR;
@property (nonatomic, readwrite) GLubyte backLabelOpacityL,backLabelOpacityR;
@property (nonatomic, readwrite) float backLabelSizeL,backLabelSizeR;
@property (nonatomic, assign) NSString *backLabelStringL,*backLabelStringR;
@property (nonatomic, copy) void (^callback_whenItemValueChanged)(BOOL itemValue_);

-(void)setCallback_whenItemValueChanged:(void (^)(BOOL itemValue_))block_;

@end

@interface CMMControlItemSwitch(Configuration)

+(void)setDefaultBackColorLeft:(ccColor3B)color_;
+(void)setDefaultBackColorRight:(ccColor3B)color_;

+(void)setDefaultBackLabelColorLeft:(ccColor3B)color_;
+(void)setDefaultBackLabelColorRight:(ccColor3B)color_;

+(void)setDefaultBackLabelOpacityLeft:(GLubyte)opacity_;
+(void)setDefaultBackLabelOpacityRight:(GLubyte)opacity_;

+(void)setDefaultBackLabelSizeLeft:(float)size_;
+(void)setDefaultBackLabelSizeRight:(float)size_;

+(void)setDefaultBackLabelStringLeft:(NSString *)string_;
+(void)setDefaultBackLabelStringRight:(NSString *)string_;

@end