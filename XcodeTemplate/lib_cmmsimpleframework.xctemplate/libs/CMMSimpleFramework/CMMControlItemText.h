//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItem.h"
#import "CMM9SliceBar.h"
#import "CMMFontUtil.h"

extern NSString *CMMControlItemTextPasswordCharacter;

@interface CMMControlItemText : CMMControlItem<UITextFieldDelegate>{
	NSString *itemValue;
	NSString *passwordCharacter;
	
	void (^callback_whenItemValueChanged)(NSString *itemValue_);
	void (^callback_whenReturnKeyEntered)(),(^callback_whenKeypadShown)(),(^callback_whenKeypadHidden)();
	BOOL (^filter_shouldShowKeypad)(),(^filter_shouldHideKeypad)();
}

+(id)controlItemTextWithFrameSize:(CGSize)frameSize_ barFrame:(CCSpriteFrame *)barFrame_;
+(id)controlItemTextWithWidth:(float)width_ barFrame:(CCSpriteFrame *)barFrame_;

+(id)controlItemTextWithFrameSize:(CGSize)frameSize_ frameSeq:(uint)frameSeq_;
+(id)controlItemTextWithWidth:(float)width_ frameSeq:(uint)frameSeq_;

-(id)initWithFrameSize:(CGSize)frameSize_ barFrame:(CCSpriteFrame *)barFrame_;
-(id)initWithWidth:(float)width_ barFrame:(CCSpriteFrame *)barFrame_;

-(id)initWithFrameSize:(CGSize)frameSize_ frameSeq:(uint)frameSeq_;
-(id)initWithWidth:(float)width_ frameSeq:(uint)frameSeq_;

-(void)showTextField;
-(void)hideTextField;

@property (nonatomic, copy) NSString *itemValue;
@property (nonatomic, assign) NSString *title;

@property (nonatomic, readonly) CCLabelTTF *textLabel;
@property (nonatomic, readwrite) ccColor3B textColor;

@property (nonatomic, assign) NSString *placeHolder;
@property (nonatomic, readonly) CCLabelTTF *placeHolderLabel;
@property (nonatomic, readwrite) ccColor3B placeHolderColor;
@property (nonatomic, readwrite) GLubyte placeHolderOpacity;

@property (nonatomic, readwrite, getter = isPasswordForm) BOOL passwordForm;
@property (nonatomic, copy) NSString *passwordCharacter;
@property (nonatomic, readwrite) UIKeyboardType keyboardType;

@property (nonatomic, copy) void (^callback_whenItemValueChanged)(NSString *itemValue_);
@property (nonatomic, copy) void (^callback_whenReturnKeyEntered)(),(^callback_whenKeypadShown)(),(^callback_whenKeypadHidden)();
@property (nonatomic, copy) BOOL (^filter_shouldShowKeypad)(),(^filter_shouldHideKeypad)();

-(void)setCallback_whenItemValueChanged:(void (^)(NSString *itemValue_))block_;

@end

@interface CMMControlItemText(Configuration)

-(void)setDefaultPasswordCharacter:(NSString *)character_;

@end