//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItemSwitch.h"

@interface CMMControlItemSwitch(Private)

-(void)_setPointXOfButton:(float)x_;

@end

@implementation CMMControlItemSwitch
@synthesize itemValue,callback_whenChangedItemVale;

+(id)controlItemSwitchWithMaskSprite:(CCSprite *)maskSprite_ backSprite:(CCSprite *)backSprite_ buttonSprite:(CCSprite *)buttonSprite_{
	return [[[self alloc] initWithMaskSprite:maskSprite_ backSprite:backSprite_ buttonSprite:buttonSprite_] autorelease];
}
+(id)controlItemSwitchWithFrameSeq:(int)frameSeq_{
	return [[[self alloc] initWithFrameSeq:frameSeq_] autorelease];
}

-(id)initWithMaskSprite:(CCSprite *)maskSprite_ backSprite:(CCSprite *)backSprite_ buttonSprite:(CCSprite *)buttonSprite_{
	_maskSprite = [[CCSprite alloc] initWithTexture:maskSprite_.texture rect:maskSprite_.textureRect];
	_backSprite = [[CCSprite alloc] initWithTexture:backSprite_.texture rect:backSprite_.textureRect];
	_buttonSprite = [CMMMenuItem spriteWithTexture:buttonSprite_.texture rect:buttonSprite_.textureRect];
	_buttonSprite.touchCancelDistance = 100.0f;
	_resultBackSprite = [CCSprite node];
	
	if(!(self = [super initWithFrameSize:_maskSprite.contentSize])) return self;
	
	callback_whenChangedItemVale = nil;
	[self addChild:_buttonSprite z:1];
	[self addChild:_resultBackSprite z:0];
	[self setItemValue:NO];
	
	[self scheduleUpdate];
	
	return self;
	
}
-(id)initWithFrameSeq:(int)frameSeq_{
	CMMDrawingManager *sharedDrawingManager_ = [CMMDrawingManager sharedManager];
	CMMDrawingManagerItem *drawingItem_ = [sharedDrawingManager_ drawingItemAtIndex:frameSeq_];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSprite *maskSprite_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_switch_mask]];
	CCSprite *backSprite_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_switch_back]];
	CCSprite *buttonSprite_ = [CMMMenuItem spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_switch_button]];
	
	return [self initWithMaskSprite:maskSprite_ backSprite:backSprite_ buttonSprite:buttonSprite_];
}

-(void)setItemValue:(BOOL)itemValue_{
	BOOL doCallback_ = itemValue != itemValue_;
	itemValue = itemValue_;
	[self _setPointXOfButton:(itemValue?self.contentSize.width-_buttonSprite.contentSize.width/2:_buttonSprite.contentSize.width/2)];
	
	if(doCallback_){
		if(!callback_whenChangedItemVale && cmmFuncCommon_respondsToSelector(delegate, @selector(controlItemSwitch:whenChangedItemValue:)))
			[((id<CMMControlItemSwitchDelegate>)delegate) controlItemSwitch:self whenChangedItemValue:itemValue];
		else if(callback_whenChangedItemVale)
			callback_whenChangedItemVale(self,itemValue);
	}
}

-(void)_setPointXOfButton:(float)x_{
	CGSize frameSize_ = self.contentSize;
	CGSize buttonSize_ = _buttonSprite.contentSize;
	
	if(x_<buttonSize_.width/2.0f)
		x_ = buttonSize_.width/2.0f;
	else if(x_>frameSize_.width-buttonSize_.width/2)
		x_ = frameSize_.width-buttonSize_.width/2;
	
	_buttonSprite.position = ccp(x_,frameSize_.height/2);
	_doRedraw = YES;
}

-(void)redraw{
	[super redraw];
	CGSize frameSize_ = self.contentSize;
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:frameSize_.width height:frameSize_.height];
	[render_ begin];
	[CMMDrawingUtil drawMask:render_ sprite:_backSprite spritePoint:_buttonSprite.position maskSprite:_maskSprite maskPoint:ccp(frameSize_.width/2,frameSize_.height/2)];
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
	if(!isEnable) return;
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
	if(!isEnable) return;
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
	if(!isEnable) return;
	[self setItemValue:itemValue];
	_isTouchMoved = NO;
}

-(void)dealloc{
	[callback_whenChangedItemVale release];
	[_backSprite release];
	[_maskSprite release];
	[super dealloc];
}

@end
