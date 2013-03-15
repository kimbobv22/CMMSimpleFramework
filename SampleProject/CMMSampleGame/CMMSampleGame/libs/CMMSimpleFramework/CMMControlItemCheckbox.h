//
//  CMMControlItemCheckbox.h
//  SimpleFramework
//
//  Created by Kim Jazz on 13. 3. 4..
//
//

#import "CMMControlItem.h"
#import "CMMMenuItem.h"

@interface CMMControlItemCheckbox : CMMControlItem{
	CMMMenuItem *_backSprite;
	CCSprite *_checkSprite;
	BOOL checked;
	
	void(^callback_whenChanged)(BOOL isChecked_);
}

+(id)controlItemCheckboxWithBackSprite:(CCSprite *)backSprite_ checkSprite:(CCSprite *)checkSprite_;
+(id)controlItemCheckboxWithFrameSeq:(int)frameSeq_;

-(id)initWithBackSprite:(CCSprite *)backSprite_ checkSprite:(CCSprite *)checkSprite_;
-(id)initWithFrameSeq:(int)frameSeq_;

-(void)setCheckedDirectly:(BOOL)checked_;

@property (nonatomic, readwrite, getter = isChecked) BOOL checked;
@property (nonatomic, copy) void(^callback_whenChanged)(BOOL itemValue_);

-(void)setCallback_whenChanged:(void (^)(BOOL isChecked_))block_;

@end
