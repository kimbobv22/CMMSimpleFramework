//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItemSlider.h"

@interface CMMControlItemSlider(Private)

-(void)_setPointXOfButton:(float)x_;

@end

@implementation CMMControlItemSlider
@synthesize backColorL,backColorR,itemValue,unitValue,minValue,maxValue,callback_whenChangedItemVale;

+(id)controlItemSliderWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor4B)backColorL_ backColorR:(ccColor4B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_{
	return [[[self alloc] initWithWidth:width_ maskSprite:maskSprite_ barSprite:barSprite_ backColorL:backColorL_ backColorR:backColorR_ buttonSprite:buttonSprite_] autorelease];
}

+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor4B)backColorL_ backColorR:(ccColor4B)backColorR_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ width:width_ backColorL:backColorL_ backColorR:backColorR_] autorelease];
}
+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ width:width_] autorelease];
}

-(id)initWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor4B)backColorL_ backColorR:(ccColor4B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_{
	
	CGSize sliderSize_ = CGSizeMake(width_, [maskSprite_ contentSize].height);
	_maskSprite = [[CMMControlItemBatchBar batchBarWithTargetSprite:maskSprite_  batchBarSize:sliderSize_] retain];
	_barSprite = [CMMControlItemBatchBar batchBarWithTargetSprite:barSprite_ batchBarSize:sliderSize_];
	
	_resultBackSprite = [CCSprite node];
	
	_buttonSprite = [CMMMenuItem spriteWithTexture:buttonSprite_.texture rect:buttonSprite_.textureRect];
	_buttonSprite.touchCancelDistance = 100.0f;
	
	backColorL = backColorL_;
	backColorR = backColorR_;
	
	CGSize frameSize_ = CGSizeZero;
	frameSize_.width = width_+10.0f;
	frameSize_.height = _buttonSprite.contentSize.height+10.0f;
	if(!(self = [super initWithFrameSize:frameSize_])) return self;
	
	callback_whenChangedItemVale = nil;
	[self addChild:_buttonSprite z:2];
	[self addChild:_barSprite z:1];
	[self addChild:_resultBackSprite z:0];
	
	[self setUnitValue:1.0f];
	[self setMinValue:0.0f];
	[self setMaxValue:10.0f];
	[self setItemValue:0.0f];
	
	[self scheduleUpdate];
	
	return self;
}

-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor4B)backColorL_ backColorR:(ccColor4B)backColorR_{
	CMMDrawingManager *sharedDrawingManager_ = [CMMDrawingManager sharedManager];
	CMMDrawingManagerItem *drawingItem_ = [sharedDrawingManager_ drawingItemAtIndex:frameSeq_];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSprite *maskSprite_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_slider_mask]];
	CCSprite *barSprite_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_slider_bar]];
	CCSprite *buttonSprite_ = [CMMMenuItem spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_slider_button]];
	
	return [self initWithWidth:width_ maskSprite:maskSprite_ barSprite:barSprite_ backColorL:backColorL_ backColorR:backColorR_ buttonSprite:buttonSprite_];
}
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [self initWithFrameSeq:frameSeq_ width:width_ backColorL:ccc4(80, 100, 200, 255) backColorR:ccc4(200, 200, 200, 255)];
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	[self redrawWithBar];
}

-(void)setBackColorL:(ccColor4B)backColorL_{
	backColorL = backColorL_;
	_doRedraw = YES;
}
-(void)setBackColorR:(ccColor4B)backColorR_{
	backColorR = backColorR_;
	_doRedraw = YES;
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
	CGSize buttonSize_ = _buttonSprite.contentSize;
	
	if(x_<buttonSize_.width/2)
		x_ = buttonSize_.width/2;
	else if(x_>contentSize_.width-buttonSize_.width/2)
		x_ = contentSize_.width-buttonSize_.width/2;
	
	_buttonSprite.position = ccp(x_,contentSize_.height/2);
	_doRedraw = YES;
}

-(void)redraw{
	[super redraw];
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:contentSize_.width height:contentSize_.height];
	
	[render_ begin];
	[render_ addChild:_maskSprite];
	[_maskSprite setPosition:cmmFuncCommon_position_center(self,_maskSprite)];
	[_maskSprite visit];
	[_maskSprite removeFromParentAndCleanup:YES];
	
	ccGLBlendFunc(GL_DST_ALPHA, GL_ZERO);
	glLineWidth(contentSize_.height);
	
	ccDrawColor4B(backColorL.r, backColorL.g, backColorL.b, backColorL.a);
	ccDrawLine(ccp(0.0f,contentSize_.height/2.0f), ccp(_buttonSprite.position.x,contentSize_.height/2.0f));
	
	ccDrawColor4B(backColorR.r, backColorR.g, backColorR.b, backColorR.a);
	ccDrawLine(ccp(_buttonSprite.position.x,contentSize_.height/2.0f), ccp(contentSize_.width,contentSize_.height/2.0f));
	
	[render_ end];
	
	[_resultBackSprite setTexture:render_.sprite.texture];
	CGRect targetTextureRect_ = CGRectZero;
	targetTextureRect_.size = contentSize_;
	[_resultBackSprite setTextureRect:targetTextureRect_];
	_resultBackSprite.position = ccp(contentSize_.width/2,contentSize_.height/2);
	[_barSprite setPosition:cmmFuncCommon_position_center(self, _barSprite)];
}

-(void)redrawWithBar{
	CGSize buttonSize_ = _buttonSprite.contentSize;
	_maskSprite.contentSize = _barSprite.contentSize = CGSizeMake(contentSize_.width-buttonSize_.width/2.0f, [_maskSprite contentSize].height);
		
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
	[_maskSprite release];
	[super dealloc];
}

@end
