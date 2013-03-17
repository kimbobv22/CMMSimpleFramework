//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItemSwitch.h"

@interface CMMControlItemSwitch(Private)

-(void)_setPointXOfButton:(float)x_;

@end

@implementation CMMControlItemSwitch
@synthesize itemValue,callback_whenItemValueChanged;

+(id)controlItemSwitchWithMaskSprite:(CCSprite *)maskSprite_ backSprite:(CCSprite *)backSprite_ buttonSprite:(CCSprite *)buttonSprite_{
	return [[[self alloc] initWithMaskSprite:maskSprite_ backSprite:backSprite_ buttonSprite:buttonSprite_] autorelease];
}
+(id)controlItemSwitchWithFrameSeq:(int)frameSeq_{
	return [[[self alloc] initWithFrameSeq:frameSeq_] autorelease];
}

-(id)initWithMaskSprite:(CCSprite *)maskSprite_ backSprite:(CCSprite *)backSprite_ buttonSprite:(CCSprite *)buttonSprite_{
	_maskSprite = [[CCSprite alloc] initWithTexture:maskSprite_.texture rect:maskSprite_.textureRect];
	_backSprite = [[CCSprite alloc] initWithTexture:backSprite_.texture rect:backSprite_.textureRect];
	buttonItem = [CMMMenuItem node];
	[buttonItem setTouchCancelDistance:100.0f];
	_resultBackSprite = [CCSprite node];
	
	if(!(self = [super initWithFrameSize:_maskSprite.contentSize])) return self;
	
	[touchDispatcher setMaxMultiTouchCount:0];
	
	[self addChild:buttonItem z:1];
	[self setButtonSprite:buttonSprite_];
	[self addChild:_resultBackSprite z:0];
	[self setItemValue:NO];
	
	return self;
	
}
-(id)initWithFrameSeq:(int)frameSeq_{
	CMMDrawingManager *sharedDrawingManager_ = [CMMDrawingManager sharedManager];
	CMMDrawingManagerItem *drawingItem_ = [sharedDrawingManager_ drawingItemAtIndex:frameSeq_];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSprite *maskSprite_ = [CCSprite spriteWithSpriteFrame:[[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SwitchMask]];
	CCSprite *backSprite_ = [CCSprite spriteWithSpriteFrame:[[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SwitchBack]];
	CCSprite *buttonSprite_ = [CCSprite spriteWithSpriteFrame:[[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SwitchButton]];
	
	return [self initWithMaskSprite:maskSprite_ backSprite:backSprite_ buttonSprite:buttonSprite_];
}

-(void)setEnable:(BOOL)enable_{
	[super setEnable:enable_];
	[_backSprite setColor:(enable?ccWHITE:disabledColor)];
	[buttonItem setColor:(enable?ccWHITE:disabledColor)];
	[_resultBackSprite setColor:(enable?ccWHITE:disabledColor)];
}

-(void)setButtonSprite:(CCSprite *)buttonSprite_{
	[buttonItem setNormalImage:buttonSprite_];
	[buttonItem setSelectedImage:buttonSprite_];
	_doRedraw = YES;
}

-(void)setItemValue:(BOOL)itemValue_{
	BOOL doCallback_ = itemValue != itemValue_;
	itemValue = itemValue_;
	[self _setPointXOfButton:(itemValue?_contentSize.width-buttonItem.contentSize.width/2:buttonItem.contentSize.width/2)];
	
	if(doCallback_ && callback_whenItemValueChanged){
		callback_whenItemValueChanged(itemValue);
	}
}

-(void)_setPointXOfButton:(float)x_{
	CGSize frameSize_ = _contentSize;
	CGSize buttonSize_ = [buttonItem contentSize];
	
	if(x_<buttonSize_.width/2.0f)
		x_ = buttonSize_.width/2.0f;
	else if(x_>frameSize_.width-buttonSize_.width/2)
		x_ = frameSize_.width-buttonSize_.width/2;
	
	[buttonItem setPosition:ccp(x_,frameSize_.height/2)];
	_doRedraw = YES;
}

-(void)redraw{
	[super redraw];
	CGSize frameSize_ = _contentSize;
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:frameSize_.width height:frameSize_.height];
	[render_ begin];
	[CMMDrawingUtil drawMask:render_ sprite:_backSprite spritePoint:[buttonItem position] maskSprite:_maskSprite maskPoint:ccp(frameSize_.width/2,frameSize_.height/2)];
	[render_ end];
	
	CCTexture2D *resultTexture_ = render_.sprite.texture;
	CGRect resultTextureRect_ = CGRectZero;
	resultTextureRect_.size = resultTexture_.contentSize;
	
	[_resultBackSprite setTexture:resultTexture_];
	[_resultBackSprite setTextureRect:resultTextureRect_];
	
	_resultBackSprite.position = ccp(frameSize_.width/2,frameSize_.height/2);
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	_isTouchMoved = NO;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtTouch:touch_];
	if(!touchItem_){
		[touchDispatcher_ cancelTouchAtTouch:touch_];
		return;
	}
	
	_isTouchMoved = YES;
	
	CGPoint convertPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touch_]];
	[self _setPointXOfButton:convertPoint_.x];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	if(_isTouchMoved){
		CGPoint convertPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touch_]];
		[self setItemValue:(convertPoint_.x > self.contentSize.width/2)];
	}else if([CMMTouchUtil isNodeInTouch:self touch:touch_]){
		[self setItemValue:!itemValue];
	}
	_isTouchMoved = NO;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	[self setItemValue:itemValue];
	_isTouchMoved = NO;
}

-(void)cleanup{
	[self setCallback_whenItemValueChanged:nil];
	[super cleanup];
}

-(void)dealloc{
	[callback_whenItemValueChanged release];
	[_backSprite release];
	[_maskSprite release];
	[super dealloc];
}

@end
