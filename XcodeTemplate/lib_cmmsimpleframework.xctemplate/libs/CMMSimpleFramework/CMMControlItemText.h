//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItem.h"
#import "CMMSpriteBatchBar.h"
#import "CMMFontUtil.h"

@class CMMControlItemText;

@protocol CMMControlItemTextDelegate<CMMControlItemDelegate>

@optional
-(void)controlItemText:(CMMControlItemText *)controlItem_ whenChangedItemValue:(NSString *)itemValue_;

@end

@interface CMMControlItemText : CMMControlItem<UITextFieldDelegate>{
	CCLabelTTF *_textLabel;
	CMMSpriteBatchBar *_barSprite;
	NSString *itemValue;
	
	UIView *_backView;
	UILabel *_textTitleLabel;
	UITextField *_textField;
	void (^callback_whenChangedItemVale)(id sender_,NSString *itemValue_);
}

+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_ height:(float)height_;
+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_;

+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_ height:(float)height_;
+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_;

-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_ height:(float)height_;
-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_;

-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ height:(float)height_;
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_;

-(void)redrawWithBar;

-(void)showTextField;
-(void)hideTextField;

@property (nonatomic, copy) NSString *itemValue;
@property (nonatomic, assign) NSString *itemTitle;
@property (nonatomic, readwrite) ccColor3B textColor;
@property (nonatomic, copy) void (^callback_whenChangedItemVale)(id sender_,NSString *itemValue_);

@end
