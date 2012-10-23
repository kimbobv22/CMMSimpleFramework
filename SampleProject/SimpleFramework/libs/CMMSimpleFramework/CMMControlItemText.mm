//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItemText.h"
#import "CMMScene.h"

@implementation CMMControlItemText
@synthesize itemValue,itemTitle,textColor,callback_whenChangedItemVale;

+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_ height:(float)height_{
	return [[[self alloc] initWithBarSprite:barSprite_ width:width_ height:height_] autorelease];
}
+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_{
	return [[[self alloc] initWithBarSprite:barSprite_ width:width_] autorelease];
}

+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_ height:(float)height_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ width:width_ height:height_] autorelease];
}
+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ width:width_] autorelease];
}

-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_ height:(float)height_{
	CGSize frameSize_ = CGSizeMake(width_, height_);
	
	_barSprite = [CMMSpriteBatchBar batchBarWithTargetSprite:barSprite_ batchBarSize:frameSize_];
	
	if(!(self = [super initWithFrameSize:frameSize_])) return self;
	
	_textLabel = [CMMFontUtil labelWithstring:@"" fontSize:cmmVarCMMFontUtil_defaultFontSize dimensions:CGSizeMake(frameSize_.width-10.0f, cmmVarCMMFontUtil_defaultFontSize) hAlignment:kCCTextAlignmentLeft vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeHeadTruncation];
	_textLabel.position = ccp(contentSize_.width/2,contentSize_.height/2);
	[self setTextColor:ccBLACK];
	
	[self addChild:_barSprite z:0];
	[self addChild:_textLabel z:1];
	[self setItemValue:nil];
	
	CGSize screenSize_ = [[CCDirector sharedDirector] winSize];
	_backView = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenSize_.width,screenSize_.height)];
	[_backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f]];

	CGRect textFieldRect_ = CGRectZero;
	textFieldRect_.size = CGSizeMake(screenSize_.width *0.5f, 27);
	textFieldRect_.origin = ccp(screenSize_.width *0.5f-textFieldRect_.size.width*0.5f+30.0f,screenSize_.height*0.2f-textFieldRect_.size.height*0.5f);

	//text field
	_textField = [[[UITextField alloc] initWithFrame:textFieldRect_] autorelease];
	_textField.borderStyle = UITextBorderStyleRoundedRect;
	_textField.delegate = self;
	_textField.keyboardType = UIKeyboardTypeDefault;
	_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	
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
	
	[self scheduleUpdate];
	
	return self;
}
-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_{
	return [self initWithBarSprite:barSprite_ width:width_ height:[barSprite_ contentSize].height];
}

-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ height:(float)height_{
	CMMDrawingManagerItem *drawingItem_ = [[CMMDrawingManager sharedManager] drawingItemAtIndex:0];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSprite *barSprite_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_text_bar]];
	return [self initWithBarSprite:barSprite_ width:width_ height:MAX([barSprite_ contentSize].height,height_)];
}
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [self initWithFrameSeq:frameSeq_ width:width_ height:0];
}

-(void)setTextColor:(ccColor3B)textColor_{
	_textLabel.color = textColor_;
}
-(ccColor3B)textColor{
	return _textLabel.color;
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	[self redrawWithBar];
}

-(void)setOpacity:(GLubyte)opacity{
	[super setOpacity:opacity];
	[_barSprite setOpacity:opacity];
}
-(void)setColor:(ccColor3B)color{
	[super setColor:color];
	[_barSprite setColor:color];
}

-(void)setItemTitle:(NSString *)itemTitle_{
	[_textTitleLabel setText:itemTitle_];
	CGRect curRect_ = [_textTitleLabel frame];
	CGRect sourceRect_ = [_textField frame];
	curRect_.origin = ccp(sourceRect_.origin.x-curRect_.size.width-10.0f,sourceRect_.origin.y);
	[_textTitleLabel setFrame:curRect_];
}
-(NSString *)itemTitle{
	return [_textTitleLabel text];
}

-(void)setItemValue:(NSString *)itemValue_{
	BOOL doCallback_ = ![itemValue isEqualToString:itemValue_];
	
	[itemValue release];
	itemValue = [!itemValue_?@"":itemValue_ retain];
	[_textLabel setString:itemValue];
	_doRedraw = YES;
	
	if(doCallback_){
		if(!callback_whenChangedItemVale && cmmFuncCommon_respondsToSelector(delegate, @selector(controlItemText:whenChangedItemValue:))){
			[((id<CMMControlItemTextDelegate>)delegate) controlItemText:self whenChangedItemValue:itemValue_];
		}else if(callback_whenChangedItemVale){
			callback_whenChangedItemVale(self, itemValue_);
		}
	}
}

-(void)redraw{
	[super redraw];
	[_barSprite setPosition:cmmFuncCommon_positionInParent(self, _barSprite)];
}
-(void)redrawWithBar{
	CGRect targetTextureRect_ = CGRectZero;
	targetTextureRect_.size = contentSize_;
	[_barSprite setContentSize:contentSize_];
	[self redraw];
}

-(void)showTextField{
	if([_backView superview]) return;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(controlItemTextShouldShow:))){
		if(![((id<CMMControlItemTextDelegate>)delegate) controlItemTextShouldShow:self])
			return;
	}
	
	_textField.text = itemValue;
	[[[CCDirectorIOS sharedDirector] view] addSubview:_backView];
	[_textField becomeFirstResponder];
	[CMMTouchDispatcher setAllTouchDispatcherEnable:NO];
}
-(void)hideTextField{
	if(![_backView superview]) return;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(controlItemTextShouldHide:))){
		if(![((id<CMMControlItemTextDelegate>)delegate) controlItemTextShouldHide:self])
			return;
	}
	
	[CMMTouchDispatcher setAllTouchDispatcherEnable:YES];
	[_textField resignFirstResponder];
	[_backView removeFromSuperview];
	[self setItemValue:[_textField text]];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	[self showTextField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self setItemValue:[_textField text]];
	[self hideTextField];
	return NO;
}

-(void)callback_backViewGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer_{
	[self hideTextField];
}

-(void)cleanup{
	[callback_whenChangedItemVale release];
	callback_whenChangedItemVale = nil;
	[super cleanup];
}

-(void)dealloc{
	[callback_whenChangedItemVale release];
	[_backView release];
	[super dealloc];
}

@end
