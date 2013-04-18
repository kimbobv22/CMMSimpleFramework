//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItem.h"
#import "CMM9SliceBar.h"
#import "CMMMenuItem.h"

extern ccColor3B CMMControlItemSliderBackColorLeft;
extern ccColor3B CMMControlItemSliderBackColorRight;

@interface CMMControlItemSlider : CMMControlItem{
	CMMMenuItem *buttonItem;
	
	ccColor3B backColorL,backColorR;
	
	float itemValue,unitValue;
	CMMFloatRange itemValueRange;
	BOOL snappable;
	
	void (^callback_whenItemValueChanged)(float itemValue_, float beforeItemValue_);
}

+(id)controlItemSliderWithWidth:(float)width_ maskFrame:(CCSpriteFrame *)maskFrame_ barFrame:(CCSpriteFrame *)barFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_;
+(id)controlItemSliderWithWidth:(float)width_ frameSeq:(uint)frameSeq_;

-(id)initWithWidth:(float)width_ maskFrame:(CCSpriteFrame *)maskFrame_ barFrame:(CCSpriteFrame *)barFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_;
-(id)initWithWidth:(float)width_ frameSeq:(uint)frameSeq_;

-(void)setButtonFrame:(CCSpriteFrame *)frame_;
-(void)setButtonFrameWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_;
-(void)setButtonFrameWithSprite:(CCSprite *)sprite_;

@property (nonatomic, readonly) CMMMenuItem *buttonItem;
@property (nonatomic, readwrite) ccColor3B backColorL,backColorR;
@property (nonatomic, readwrite) float itemValue,unitValue;
@property (nonatomic, readwrite) CMMFloatRange itemValueRange;
@property (nonatomic, readwrite) BOOL snappable;
@property (nonatomic, copy) void (^callback_whenItemValueChanged)(float itemValue_, float beforeItemValue_);

-(void)setCallback_whenItemValueChanged:(void (^)(float itemValue_, float beforeItemValue_))block_;

@end

@interface CMMControlItemSlider(Configuration)

+(void)setDefaultBackColorLeft:(ccColor3B)color_;
+(void)setDefaultBackColorRight:(ccColor3B)color_;

@end