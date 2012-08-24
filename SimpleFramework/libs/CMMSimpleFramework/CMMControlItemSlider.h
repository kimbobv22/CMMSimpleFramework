//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItem.h"
#import "CMMMenuItem.h"

@class CMMControlItemSlider;

@protocol CMMControlItemSliderDelegate <CMMControlItemDelegate>

@optional
-(void)controlItemSlider:(CMMControlItemSlider *)controlItem_ whenChangedItemValue:(float)itemValue_ beforeItemValue:(float)beforeItemValue_;

@end

@interface CMMControlItemSlider : CMMControlItem{
	CCSprite *_maskSprite,*_barSprite,*_backSpriteL,*_backSpriteR;
	CCSprite *_resultBarSprite,*_resultBackSprite,*_resultMaskSprite;
	CMMMenuItem *_buttonSprite;
	
	float itemValue,unitValue,minValue,maxValue;
	void (^callback_whenChangedItemVale)(id sender_,float itemValue_, float beforeItemValue_);
}

+(id)controlItemSliderWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backSpriteL:(CCSprite *)backSpriteL_ backSpriteR:(CCSprite *)backSpriteR_ buttonSprite:(CCSprite *)buttonSprite_;
+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_;

-(id)initWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backSpriteL:(CCSprite *)backSpriteL_ backSpriteR:(CCSprite *)backSpriteR_ buttonSprite:(CCSprite *)buttonSprite_;
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_;

-(void)redrawWithBar;

@property (nonatomic, readwrite) float itemValue,unitValue,minValue,maxValue;
@property (nonatomic, copy) void (^callback_whenChangedItemVale)(id sender_,float itemValue_, float beforeItemValue_);

@end
