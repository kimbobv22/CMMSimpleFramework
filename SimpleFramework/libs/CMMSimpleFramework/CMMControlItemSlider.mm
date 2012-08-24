//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItemSlider.h"

@interface CMMControlItemSlider(Private)

-(void)_setPointXOfButton:(float)x_;

@end

@implementation CMMControlItemSlider
@synthesize itemValue,unitValue,minValue,maxValue,callback_whenChangedItemVale;

+(id)controlItemSliderWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backSpriteL:(CCSprite *)backSpriteL_ backSpriteR:(CCSprite *)backSpriteR_ buttonSprite:(CCSprite *)buttonSprite_{
	return [[[self alloc] initWithWidth:width_ maskSprite:maskSprite_ barSprite:barSprite_ backSpriteL:backSpriteL_ backSpriteR:backSpriteR_ buttonSprite:buttonSprite_] autorelease];
}
+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ width:width_] autorelease];
}

-(id)initWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backSpriteL:(CCSprite *)backSpriteL_ backSpriteR:(CCSprite *)backSpriteR_ buttonSprite:(CCSprite *)buttonSprite_{
	
	_maskSprite = [[CCSprite alloc] initWithTexture:maskSprite_.texture rect:maskSprite_.textureRect];
	_barSprite = [[CCSprite alloc] initWithTexture:barSprite_.texture rect:barSprite_.textureRect];
	_backSpriteL = [[CCSprite alloc] initWithTexture:backSpriteL_.texture rect:backSpriteL_.textureRect];
	_backSpriteR = [[CCSprite alloc] initWithTexture:backSpriteR_.texture rect:backSpriteR_.textureRect];
	_buttonSprite = [CMMMenuItem spriteWithTexture:buttonSprite_.texture rect:buttonSprite_.textureRect];
	_buttonSprite.touchCancelDistance = 100.0f;
	_resultBarSprite = [CCSprite node];
	_resultBackSprite = [CCSprite node];
	_resultMaskSprite = [[CCSprite node] retain];
	
	CGSize frameSize_ = CGSizeZero;
	frameSize_.width = width_+10.0f;
	frameSize_.height = _buttonSprite.contentSize.height+10.0f;
	if(!(self = [super initWithFrameSize:frameSize_])) return self;
	
	callback_whenChangedItemVale = nil;
	[self addChild:_buttonSprite z:2];
	[self addChild:_resultBarSprite z:1];
	[self addChild:_resultBackSprite z:0];
	[self setUnitValue:1.0f];
	[self setMinValue:0.0f];
	[self setMaxValue:10.0f];
	[self setItemValue:1.0f];
	
	return self;
}
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_{
	CMMDrawingManager *sharedDrawingManager_ = [CMMDrawingManager sharedManager];
	CMMDrawingManagerItem *drawingItem_ = [sharedDrawingManager_ drawingItemAtIndex:frameSeq_];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSprite *maskSprite_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_slider_mask]];
	CCSprite *barSprite_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_slider_bar]];
	CCSprite *backSpriteL_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_slider_backLeft]];
	CCSprite *backSpriteR_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_slider_backRight]];
	CCSprite *buttonSprite_ = [CMMMenuItem spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_slider_button]];
	
	return [self initWithWidth:width_ maskSprite:maskSprite_ barSprite:barSprite_ backSpriteL:backSpriteL_ backSpriteR:backSpriteR_ buttonSprite:buttonSprite_];
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	[self redrawWithBar];
}

-(void)setItemValue:(float)itemValue_{
	float convertItemValue_ = floorf(itemValue_/unitValue) * unitValue;
	convertItemValue_ = MAX(minValue,MIN(maxValue,convertItemValue_));
	BOOL doCallback_ = itemValue != convertItemValue_;
	float beforeItemValue_ = itemValue;
	itemValue = convertItemValue_;
	
	float buttonPointX_ = ((self.contentSize.width-_buttonSprite.contentSize.width)*((itemValue_-minValue)/(maxValue-minValue)))+_buttonSprite.contentSize.width/2.0f;
	[self _setPointXOfButton:buttonPointX_];
	
	if(doCallback_){
		if(!callback_whenChangedItemVale && cmmFuncCommon_respondsToSelector(delegate, @selector(controlItemSlider:whenChangedItemValue:beforeItemValue:)))
			[((id<CMMControlItemSliderDelegate>)delegate) controlItemSlider:self whenChangedItemValue:itemValue beforeItemValue:beforeItemValue_];
		else if(callback_whenChangedItemVale)
			callback_whenChangedItemVale(self,itemValue,beforeItemValue_);
	}
}

-(void)setMinValue:(float)minValue_{
	minValue = minValue_;
	[self setItemValue:itemValue];
}
-(void)setMaxValue:(float)maxValue_{
	maxValue = maxValue_;
	[self setItemValue:itemValue];
}
-(void)setUnitValue:(float)unitValue_{
	unitValue = unitValue_;
	[self setItemValue:itemValue];
}

-(void)_setPointXOfButton:(float)x_{
	CGSize frameSize_ = self.contentSize;
	CGSize buttonSize_ = _buttonSprite.contentSize;
	
	if(x_<buttonSize_.width/2)
		x_ = buttonSize_.width/2;
	else if(x_>frameSize_.width-buttonSize_.width/2)
		x_ = frameSize_.width-buttonSize_.width/2;
	
	_buttonSprite.position = ccp(x_,frameSize_.height/2);
	[self redraw];
}

-(void)redraw{
	CGSize frameSize_ = self.contentSize;
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:frameSize_.width height:frameSize_.height];
	
	[_backSpriteL.texture setAliasTexParameters];
	_backSpriteL.scaleX = _buttonSprite.position.x/(_backSpriteL.contentSize.width);
	_backSpriteL.anchorPoint = ccp(0.0f,0.5f);
	_backSpriteL.position = ccp(0.0f,frameSize_.height/2);
	
	[_backSpriteR.texture setAliasTexParameters];
	_backSpriteR.scaleX = (frameSize_.width-_buttonSprite.position.x)/_backSpriteR.contentSize.width;
	_backSpriteR.anchorPoint = ccp(0.0f,0.5f);
	_backSpriteR.position = ccp(_buttonSprite.position.x,frameSize_.height/2);
	
	[render_ begin];
	
	[_backSpriteL visit];
	[_backSpriteR visit];
	
	[render_ end];
	
	[_resultBackSprite setTexture:[CMMDrawingUtil textureMaskWithFrameSize:frameSize_ sprite:render_.sprite spritePoint:ccp(frameSize_.width/2,frameSize_.height/2) maskSprite:_resultMaskSprite maskPoint:ccp(frameSize_.width/2,frameSize_.height/2)]];
	CGRect targetTextureRect_ = CGRectZero;
	targetTextureRect_.size = frameSize_;
	[_resultBackSprite setTextureRect:targetTextureRect_];
	_resultBackSprite.position = ccp(frameSize_.width/2,frameSize_.height/2);
}
-(void)redrawWithBar{
	CGSize buttonSize_ = _buttonSprite.contentSize;
	CGSize frameSize_ = self.contentSize;
	CGRect targetTextureRect_ = CGRectZero;
	targetTextureRect_.size = frameSize_;
	
	//make bar
	CCTexture2D *barTexture_ = [CMMDrawingUtil textureBarWithFrameSize:frameSize_ edgeSprite:_barSprite barCropWidth:2.0f startPoint:ccp(buttonSize_.width/4.0f,frameSize_.height/2) width:frameSize_.width-buttonSize_.width/2.0f];
	
	[_resultBarSprite setTexture:barTexture_];
	[_resultBarSprite setTextureRect:targetTextureRect_];
	_resultBarSprite.position = ccp(frameSize_.width/2,frameSize_.height/2);
	
	//make mask
	CCTexture2D *maskTexture_ = [CMMDrawingUtil textureBarWithFrameSize:frameSize_ edgeSprite:_maskSprite barCropWidth:2.0f startPoint:ccp(buttonSize_.width/4.0f,frameSize_.height/2) width:frameSize_.width-buttonSize_.width/2.0f];
	
	[_resultMaskSprite setTexture:maskTexture_];
	[_resultMaskSprite setTextureRect:targetTextureRect_];
	_resultMaskSprite.position = ccp(frameSize_.width/2,frameSize_.height/2);
		
	[self redraw];
	[self setItemValue:itemValue];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	if(!isEnable) return;
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtTouch:touch_];
	if(!touchItem_){
		[touchDispatcher_ cancelTouchAtTouch:touch_];
		return;
	}
	
	CGPoint convertPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touch_]];
	CGSize buttonSize_ = _buttonSprite.contentSize;
	float itemValue_ = (maxValue-minValue) * ((convertPoint_.x-buttonSize_.width/2.0f)/(self.contentSize.width-buttonSize_.width)) +minValue;
	[self setItemValue:itemValue_];
}

-(void)dealloc{
	[callback_whenChangedItemVale release];
	[_resultMaskSprite release];
	[_maskSprite release];
	[_barSprite release];
	[_backSpriteL release];
	[_backSpriteR release];
	[super dealloc];
}

@end
