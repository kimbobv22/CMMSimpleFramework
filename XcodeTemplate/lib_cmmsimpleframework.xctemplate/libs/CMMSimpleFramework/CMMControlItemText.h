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
	
	UIToolbar *_toolBar;
	UITextField *_textField;
	void (^callback_whenChangedItemVale)(id sender_,NSString *itemValue_);
}

+(id)controlItemTextWithWidth:(float)width_ barSprite:(CCSprite *)barSprite_;
+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_;

-(id)initWithWidth:(float)width_ barSprite:(CCSprite *)barSprite_;
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_;

-(void)redrawWithBar;

-(void)update:(ccTime)dt_;

@property (nonatomic, retain) NSString *itemValue;
@property (nonatomic, readwrite) ccColor3B textColor;
@property (nonatomic, copy) void (^callback_whenChangedItemVale)(id sender_,NSString *itemValue_);

@end
