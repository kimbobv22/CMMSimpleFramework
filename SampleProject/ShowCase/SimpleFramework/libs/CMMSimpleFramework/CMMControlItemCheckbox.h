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
	BOOL checked;
	void(^callback_whenChanged)(BOOL isChecked_);
}

+(id)controlItemCheckboxWithBackFrame:(CCSpriteFrame *)backFrame_ checkFrame:(CCSpriteFrame *)checkFrame_;
+(id)controlItemCheckboxWithFrameSeq:(uint)frameSeq_;

-(id)initWithBackFrame:(CCSpriteFrame *)backSprite_ checkFrame:(CCSpriteFrame *)checkFrame_;
-(id)initWithFrameSeq:(uint)frameSeq_;

-(void)setCheckedDirectly:(BOOL)checked_;

@property (nonatomic, readwrite, getter = isChecked) BOOL checked;
@property (nonatomic, copy) void(^callback_whenChanged)(BOOL itemValue_);

-(void)setCallback_whenChanged:(void (^)(BOOL isChecked_))block_;

@end
