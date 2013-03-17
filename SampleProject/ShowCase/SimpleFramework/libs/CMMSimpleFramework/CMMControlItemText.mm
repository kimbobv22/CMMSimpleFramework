//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItemText.h"
#import "CMMScene.h"

@implementation CMMControlItemText
@synthesize itemValue,title,textColor,placeHolder,placeHolderColor,placeHolderOpacity,passwordForm,keyboardType;
@synthesize callback_whenItemValueChanged,callback_whenReturnKeyEntered,callback_whenKeypadShown,callback_whenKeypadHidden;
@synthesize filter_shouldShowKeypad,filter_shouldHideKeypad;
@synthesize textLabel = _textLabel;
@synthesize placeHolderLabel = _placeHolderLabel;

+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ frameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithBarSprite:barSprite_ frameSize:frameSize_] autorelease];
}
+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_{
	return [[[self alloc] initWithBarSprite:barSprite_ width:width_] autorelease];
}

+(id)controlItemTextWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ frameSize:frameSize_] autorelease];
}
+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ width:width_] autorelease];
}

-(id)initWithBarSprite:(CCSprite *)barSprite_ frameSize:(CGSize)frameSize_{
	_barSprite = [CMM9SliceBar sliceBarWithTargetSprite:barSprite_];
	[_barSprite setContentSize:frameSize_];
	
	if(!(self = [super initWithFrameSize:frameSize_])) return self;
	
	[touchDispatcher setMaxMultiTouchCount:0];
	
	_textLabel = [CMMFontUtil labelWithString:@"" fontSize:[CMMFontUtil defaultFontSize] dimensions:CGSizeMake(frameSize_.width-10.0f, [CMMFontUtil defaultFontSize]) hAlignment:kCCTextAlignmentLeft vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeHeadTruncation];
	[_textLabel setPosition:ccp(_contentSize.width/2,_contentSize.height/2)];
	[self setTextColor:ccBLACK];
	
	_placeHolderLabel = [CMMFontUtil labelWithString:@"" fontSize:[CMMFontUtil defaultFontSize] dimensions:CGSizeMake(frameSize_.width-10.0f, [CMMFontUtil defaultFontSize]) hAlignment:kCCTextAlignmentLeft vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeHeadTruncation];
	[_placeHolderLabel setPosition:ccp(_contentSize.width/2,_contentSize.height/2)];
	[self setPlaceHolderColor:ccBLACK];
	[self setPlaceHolderOpacity:100];
	
	[self addChild:_barSprite z:0];
	[self addChild:_textLabel z:1];
	[self addChild:_placeHolderLabel z:2];
	[self setItemValue:nil];
	
	CGSize screenSize_ = [[CCDirector sharedDirector] winSize];
	_backView = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenSize_.width,screenSize_.height)];
	[_backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f]];
	
	CGRect textFieldRect_ = CGRectZero;
	textFieldRect_.size = CGSizeMake(screenSize_.width *0.5f, 27);
	textFieldRect_.origin = ccp(screenSize_.width *0.5f-textFieldRect_.size.width*0.5f+30.0f,screenSize_.height*0.2f-textFieldRect_.size.height*0.5f);
	
	//text field
	_textField = [[[UITextField alloc] initWithFrame:textFieldRect_] autorelease];
	[_textField setBorderStyle:UITextBorderStyleRoundedRect];
	[_textField setDelegate:self];
	[_textField setReturnKeyType:UIReturnKeyDone];
	[self setKeyboardType:UIKeyboardTypeDefault];
	[_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
	
	//label
	_textTitleLabel = [[[UILabel alloc] initWithFrame:textFieldRect_] autorelease];
	[_textTitleLabel setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
	[_textTitleLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
	[_textTitleLabel setTextAlignment:NSTextAlignmentRight];
	
	[_backView addSubview:_textField];
	[_backView addSubview:_textTitleLabel];
	UITapGestureRecognizer *backViewGesture_ = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callback_backViewGestureRecognizer:)] autorelease];
	[backViewGesture_ setNumberOfTapsRequired:1];
	[_backView addGestureRecognizer:backViewGesture_];
	
	return self;
}
-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_{
	return [self initWithBarSprite:barSprite_ frameSize:CGSizeMake(width_, [barSprite_ contentSize].height)];
}

-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	CMMDrawingManagerItem *drawingItem_ = [[CMMDrawingManager sharedManager] drawingItemAtIndex:0];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSprite *barSprite_ = [CCSprite spriteWithSpriteFrame:[[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_TextBar]];
	frameSize_.height = MAX([barSprite_ contentSize].height,frameSize_.height);
	return [self initWithBarSprite:barSprite_ frameSize:frameSize_];
}
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [self initWithFrameSeq:frameSeq_ frameSize:CGSizeMake(width_, 0.0f)];
}

-(void)setTextColor:(ccColor3B)textColor_{
	_textLabel.color = textColor_;
}
-(ccColor3B)textColor{
	return _textLabel.color;
}
-(void)setPlaceHolder:(NSString *)placeHolder_{
	[_textField setPlaceholder:placeHolder_];
	[_placeHolderLabel setString:placeHolder_];
	_doRedraw = YES;
}
-(NSString *)placeHolder{
	return [_textField placeholder];
}
-(void)setPlaceHolderColor:(ccColor3B)placeHolderColor_{
	[_placeHolderLabel setColor:placeHolderColor_];
}
-(ccColor3B)placeHolderColor{
	return [_placeHolderLabel color];
}
-(void)setPlaceHolderOpacity:(GLubyte)placeHolderOpacity_{
	[_placeHolderLabel setOpacity:placeHolderOpacity_];
}
-(GLubyte)placeHolderOpacity{
	return [_placeHolderLabel opacity];
}

-(void)setPasswordForm:(BOOL)passwordForm_{
	[_textField setSecureTextEntry:passwordForm_];
	_doRedraw = YES;
}
-(BOOL)isPasswordForm{
	return [_textField isSecureTextEntry];
}
-(void)setKeyboardType:(UIKeyboardType)keyboardType_{
	[_textField setKeyboardType:keyboardType_];
}
-(UIKeyboardType)keyboardType{
	return [_textField keyboardType];
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	[self redrawWithBar];
}

-(void)setTitle:(NSString *)title_{
	[_textTitleLabel setText:title_];
	CGRect curRect_ = [_textTitleLabel frame];
	CGRect sourceRect_ = [_textField frame];
	curRect_.origin = ccp(sourceRect_.origin.x-curRect_.size.width-10.0f,sourceRect_.origin.y);
	[_textTitleLabel setFrame:curRect_];
}
-(NSString *)title{
	return [_textTitleLabel text];
}

-(void)setItemValue:(NSString *)itemValue_{
	BOOL doCallback_ = ![itemValue isEqualToString:itemValue_];
	
	[itemValue release];
	itemValue = [!itemValue_?@"":itemValue_ copy];
	[_textLabel setString:itemValue];
	_doRedraw = YES;
	
	if(doCallback_ && callback_whenItemValueChanged){
		callback_whenItemValueChanged(itemValue_);
	}
}

-(void)setEnable:(BOOL)enable_{
	[super setEnable:enable_];
	[_barSprite setColor:(enable?ccWHITE:disabledColor)];
}

-(void)redraw{
	[super redraw];
	
	if([self isPasswordForm]){
		[_textLabel setString:@""];
		
		if(itemValue){
			uint count_ = [itemValue length];
			NSMutableString *resultStr_ = [NSMutableString string];
			for(uint index_=0;index_<count_;++index_){
				[resultStr_ appendString:@"*"];
			}
			
			[_textLabel setString:resultStr_];
		}
	}
	
	[_placeHolderLabel setVisible:([[self itemValue] length] == 0)];
	[_barSprite setPosition:cmmFunc_positionIPN(self, _barSprite)];
}
-(void)redrawWithBar{
	CGRect targetTextureRect_ = CGRectZero;
	targetTextureRect_.size = _contentSize;
	[_barSprite setContentSize:_contentSize];
	[self redraw];
}

-(void)showTextField{
	if([_backView superview]) return;
	
	if(filter_shouldShowKeypad){
		if(!filter_shouldShowKeypad())
			return;
	}
	
	_textField.text = itemValue;
	[[[CCDirectorIOS sharedDirector] view] addSubview:_backView];
	[_textField becomeFirstResponder];
	[[CMMScene sharedScene] setTouchEnable:NO];
	
	if(callback_whenKeypadShown){
		callback_whenKeypadShown();
	}
}
-(void)hideTextField{
	if(![_backView superview]) return;
	
	if(filter_shouldHideKeypad){
		if(!filter_shouldHideKeypad())
			return;
	}
	
	[[CMMScene sharedScene] setTouchEnable:YES];
	[_textField resignFirstResponder];
	[_backView removeFromSuperview];
	[self setItemValue:[_textField text]];
	if(callback_whenKeypadHidden){
		callback_whenKeypadHidden();
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	[self showTextField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self setItemValue:[_textField text]];
	[self hideTextField];
	if(callback_whenReturnKeyEntered){
		callback_whenReturnKeyEntered();
	}
	return NO;
}

-(void)callback_backViewGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer_{
	[self hideTextField];
}

-(void)cleanup{
	[self setCallback_whenItemValueChanged:nil];
	[self setCallback_whenReturnKeyEntered:nil];
	[self setCallback_whenKeypadShown:nil];
	[self setCallback_whenKeypadHidden:nil];
	[self setFilter_shouldShowKeypad:nil];
	[self setFilter_shouldHideKeypad:nil];
	[super cleanup];
}

-(void)dealloc{
	[callback_whenItemValueChanged release];
	[callback_whenReturnKeyEntered release];
	[callback_whenKeypadShown release];
	[callback_whenKeypadHidden release];
	[filter_shouldShowKeypad release];
	[filter_shouldHideKeypad release];
	[_backView release];
	[itemValue release];
	[super dealloc];
}

@end
