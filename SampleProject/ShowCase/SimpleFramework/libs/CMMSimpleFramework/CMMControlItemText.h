//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItem.h"
#import "CMM9SliceBar.h"
#import "CMMFontUtil.h"

@class CMMControlItemText;


@interface CMMControlItemText : CMMControlItem<UITextFieldDelegate>{
	CCLabelTTF *_textLabel,*_placeHolderLabel;
	CMM9SliceBar *_barSprite;
	
	NSString *itemValue;
	
	UIView *_backView;
	UILabel *_textTitleLabel;
	UITextField *_textField;
	
	void (^callback_whenItemValueChanged)(NSString *itemValue_);
	void (^callback_whenReturnKeyEntered)(),(^callback_whenKeypadShown)(),(^callback_whenKeypadHidden)();
	BOOL (^filter_shouldShowKeypad)(),(^filter_shouldHideKeypad)();
}

+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ frameSize:(CGSize)frameSize_;
+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_;

+(id)controlItemTextWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_;
+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_;

-(id)initWithBarSprite:(CCSprite *)barSprite_ frameSize:(CGSize)frameSize_;
-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_;

-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_;
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_;

-(void)redrawWithBar;

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
@property (nonatomic, readwrite) UIKeyboardType keyboardType;

@property (nonatomic, copy) void (^callback_whenItemValueChanged)(NSString *itemValue_);
@property (nonatomic, copy) void (^callback_whenReturnKeyEntered)(),(^callback_whenKeypadShown)(),(^callback_whenKeypadHidden)();
@property (nonatomic, copy) BOOL (^filter_shouldShowKeypad)(),(^filter_shouldHideKeypad)();

-(void)setCallback_whenItemValueChanged:(void (^)(NSString *itemValue_))block_;

@end