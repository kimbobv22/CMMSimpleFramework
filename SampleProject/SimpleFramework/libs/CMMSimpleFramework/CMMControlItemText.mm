//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItemText.h"

@implementation CMMControlItemText
@synthesize itemValue,textColor,callback_whenChangedItemVale;

+(id)controlItemTextWithWidth:(float)width_ barSprite:(CCSprite *)barSprite_{
	return [[[self alloc] initWithWidth:width_ barSprite:barSprite_] autorelease];
}
+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ width:width_] autorelease];
}

-(id)initWithWidth:(float)width_ barSprite:(CCSprite *)barSprite_{
	CGSize frameSize_ = CGSizeMake(width_, barSprite_.contentSize.height);
	
	_barSprite = [CMMSpriteBatchBar batchBarWithTargetSprite:barSprite_ batchBarSize:frameSize_];
	
	if(!(self = [super initWithFrameSize:CGSizeMake(width_, barSprite_.contentSize.height)])) return self;
	
	_textLabel = [CMMFontUtil labelWithstring:@"" fontSize:cmmVarCMMFontUtil_defaultFontSize dimensions:CGSizeMake(frameSize_.width-10.0f, cmmVarCMMFontUtil_defaultFontSize) hAlignment:kCCTextAlignmentLeft vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeHeadTruncation];
	_textLabel.position = ccp(contentSize_.width/2,contentSize_.height/2);
	[self setTextColor:ccBLACK];
	
	[self addChild:_barSprite z:0];
	[self addChild:_textLabel z:1];
	[self setItemValue:nil];
	
	// ## issue
	CGSize screenSize_ = [[CCDirector sharedDirector] winSize];
	_toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,screenSize_.width,37)];
	_textField = [[UITextField alloc] initWithFrame: CGRectMake(5, 5, screenSize_.width-10, 27)];
	_textField.borderStyle = UITextBorderStyleRoundedRect;
	_textField.delegate = self;
	_textField.keyboardType = UIKeyboardTypeDefault;
	_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	_textField.inputAccessoryView = _toolBar;
	[_toolBar addSubview:_textField];
	callback_whenChangedItemVale = nil;
	
	[self scheduleUpdate];
	
	return self;
}
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_{
	CMMDrawingManagerItem *drawingItem_ = [[CMMDrawingManager sharedManager] drawingItemAtIndex:0];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	return [self initWithWidth:width_ barSprite:[CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_text_bar]]];
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
	[_barSprite setPosition:cmmFuncCommon_position_center(self, _barSprite)];
}
-(void)redrawWithBar{
	CGRect targetTextureRect_ = CGRectZero;
	targetTextureRect_.size = contentSize_;
	
	[_barSprite setContentSize:contentSize_];
	[self redraw];
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	if(_toolBar.superview){
		if(![_textLabel.string isEqualToString:_textField.text]){
			[_textLabel setString:!_textField.text?@"":_textField.text];
			_doRedraw = YES;
		}
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	
	if(_toolBar.superview) return;
	_textField.text = itemValue;
	[[CCDirectorIOS sharedDirector].view addSubview:_toolBar];
	[_textField becomeFirstResponder];
	[_textField becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	[_textField resignFirstResponder];
	[_toolBar removeFromSuperview];
	[self setItemValue:_textField.text];
	return NO;
}

-(void)dealloc{
	[_textField release];
	[_toolBar release];
	[_barSprite release];
	[super dealloc];
}

@end
