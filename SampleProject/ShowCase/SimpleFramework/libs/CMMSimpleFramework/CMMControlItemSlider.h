//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItem.h"
#import "CMM9SliceBar.h"
#import "CMMMenuItem.h"

@interface CMMControlItemSlider : CMMControlItem{
	CMM9SliceBar *_maskSprite,*_barSprite;
	CCSprite *_resultBackSprite;
	CMMMenuItem *buttonItem;
	
	ccColor3B backColorL,backColorR;
	
	float itemValue,unitValue;
	CMMFloatRange itemValueRange;
	BOOL snappable;
	void (^callback_whenItemValueChanged)(float itemValue_, float beforeItemValue_);
}

+(id)controlItemSliderWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_;

+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_;
+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_;

-(id)initWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_;

-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_;
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_;

-(void)setButtonSprite:(CCSprite *)buttonSprite_;
-(void)redrawWithBar;

@property (nonatomic, readonly) CMMMenuItem *buttonItem;
@property (nonatomic, readwrite) ccColor3B backColorL,backColorR;
@property (nonatomic, readwrite) float itemValue,unitValue;
@property (nonatomic, readwrite) CMMFloatRange itemValueRange;
@property (nonatomic, readwrite) BOOL snappable;
@property (nonatomic, copy) void (^callback_whenItemValueChanged)(float itemValue_, float beforeItemValue_);

-(void)setCallback_whenItemValueChanged:(void (^)(float itemValue_, float beforeItemValue_))block_;

@end