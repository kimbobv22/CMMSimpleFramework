//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItemSlider.h"

@interface CMMControlItemSlider(Private)

-(void)_setPointXOfButton:(float)x_;

@end

@implementation CMMControlItemSlider
@synthesize buttonItem,backColorL,backColorR,itemValue,unitValue,minValue,maxValue,callback_whenItemValueChanged;

+(id)controlItemSliderWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_{
	return [[[self alloc] initWithWidth:width_ maskSprite:maskSprite_ barSprite:barSprite_ backColorL:backColorL_ backColorR:backColorR_ buttonSprite:buttonSprite_] autorelease];
}

+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ width:width_ backColorL:backColorL_ backColorR:backColorR_] autorelease];
}
+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ width:width_] autorelease];
}

-(id)initWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_{
	
	CGSize sliderSize_ = CGSizeMake(width_, [maskSprite_ contentSize].height);
	_maskSprite = [[CMM9SliceBar sliceBarWithTargetSprite:maskSprite_] retain];
	[_maskSprite setContentSize:sliderSize_];
	_barSprite = [CMM9SliceBar sliceBarWithTargetSprite:barSprite_];
	[_barSprite setContentSize:sliderSize_];
	
	_resultBackSprite = [CCSprite node];
	
	buttonItem = [CMMMenuItem node];
	[buttonItem setTouchCancelDistance:100.0f];
	[self setButtonSprite:buttonSprite_];
	
	backColorL = backColorL_;
	backColorR = backColorR_;
	
	CGSize frameSize_ = CGSizeZero;
	frameSize_.width = width_+10.0f;
	frameSize_.height = [buttonItem contentSize].height+10.0f;
	if(!(self = [super initWithFrameSize:frameSize_])) return self;
	
	[touchDispatcher setMaxMultiTouchCount:0];
	
	[self addChild:buttonItem z:2];
	[self addChild:_barSprite z:1];
	[self addChild:_resultBackSprite z:0];
	
	[self setUnitValue:1.0f];
	[self setMinValue:0.0f];
	[self setMaxValue:10.0f];
	[self setItemValue:0.0f];
	
	return self;
}

-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_{
	CMMDrawingManager *sharedDrawingManager_ = [CMMDrawingManager sharedManager];
	CMMDrawingManagerItem *drawingItem_ = [sharedDrawingManager_ drawingItemAtIndex:frameSeq_];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSprite *maskSprite_ = [CCSprite spriteWithSpriteFrame:[[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SlideMask]];
	CCSprite *barSprite_ = [CCSprite spriteWithSpriteFrame:[[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SlideBar]];
	CCSprite *buttonSprite_ = [CMMMenuItem spriteWithSpriteFrame:[[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SlideButton]];
	
	return [self initWithWidth:width_ maskSprite:maskSprite_ barSprite:barSprite_ backColorL:backColorL_ backColorR:backColorR_ buttonSprite:buttonSprite_];
}
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [self initWithFrameSeq:frameSeq_ width:width_ backColorL:ccc3(80, 100, 200) backColorR:ccc3(200, 200, 200)];
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	[self redrawWithBar];
}

-(void)setEnable:(BOOL)enable_{
	[super setEnable:enable_];
	[_barSprite setColor:(enable?ccWHITE:disabledColor)];
	[buttonItem setColor:(enable?ccWHITE:disabledColor)];
	[_resultBackSprite setColor:(enable?ccWHITE:disabledColor)];
}

-(void)setButtonSprite:(CCSprite *)buttonSprite_{
	[buttonItem setNormalImage:buttonSprite_];
	[buttonItem setSelectedImage:buttonSprite_];
	_doRedraw = YES;
}

-(void)setBackColorL:(ccColor3B)backColorL_{
	backColorL = backColorL_;
	_doRedraw = YES;
}
-(void)setBackColorR:(ccColor3B)backColorR_{
	backColorR = backColorR_;
	_doRedraw = YES;
}

-(void)setItemValue:(float)itemValue_{
	float convertItemValue_ = floorf(itemValue_/unitValue) * unitValue;
	convertItemValue_ = MAX(minValue,MIN(maxValue,convertItemValue_));
	BOOL doCallback_ = itemValue != convertItemValue_;
	float beforeItemValue_ = itemValue;
	itemValue = convertItemValue_;
	
	float buttonPointX_ = ((self.contentSize.width-[buttonItem contentSize].width)*((itemValue_-minValue)/(maxValue-minValue)))+[buttonItem contentSize].width/2.0f;
	[self _setPointXOfButton:buttonPointX_];
	
	if(doCallback_ && callback_whenItemValueChanged){
		callback_whenItemValueChanged(itemValue,beforeItemValue_);
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
	CGSize buttonSize_ = [buttonItem contentSize];
	
	if(x_<buttonSize_.width/2)
		x_ = buttonSize_.width/2;
	else if(x_>_contentSize.width-buttonSize_.width/2)
		x_ = _contentSize.width-buttonSize_.width/2;
	
	[buttonItem setPosition:ccp(x_,_contentSize.height/2)];
	_doRedraw = YES;
}

-(void)redraw{
	[super redraw];
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:_contentSize.width height:_contentSize.height];
	
	[render_ begin];
	[render_ addChild:_maskSprite];
	
	ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	[_maskSprite setPosition:cmmFunc_positionIPN(self,_maskSprite)];
	[_maskSprite visit];
	[_maskSprite removeFromParentAndCleanup:YES];
	
	CGPoint buttonPoint_ = [buttonItem position];
	
	ccGLBlendFunc(GL_DST_ALPHA, GL_ZERO);
	ccDrawSolidRect(CGPointZero, ccp(buttonPoint_.x,_contentSize.height),ccc4f(backColorL.r/255.0f, backColorL.g/255.0f, backColorL.b/255.0f, _realOpacity/255.0f));
	ccDrawSolidRect(ccp(buttonPoint_.x,0.0f), ccp(_contentSize.width,_contentSize.height),ccc4f(backColorR.r/255.0f, backColorR.g/255.0f, backColorR.b/255.0f, _realOpacity/255.0f));
	
	[render_ end];
	
	[_resultBackSprite setTexture:[[render_ sprite] texture]];
	CGRect targetTextureRect_ = CGRectZero;
	targetTextureRect_.size = _contentSize;
	[_resultBackSprite setTextureRect:targetTextureRect_];
	_resultBackSprite.position = ccp(_contentSize.width/2,_contentSize.height/2);
	[_barSprite setPosition:cmmFunc_positionIPN(self, _barSprite)];
}

-(void)redrawWithBar{
	CGSize buttonSize_ = [buttonItem contentSize];
	_maskSprite.contentSize = _barSprite.contentSize = CGSizeMake(_contentSize.width-buttonSize_.width/2.0f, [_maskSprite contentSize].height);
	
	[self redraw];
	[self setItemValue:itemValue];
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return [super touchDispatcher:touchDispatcher_ shouldAllowTouch:touch_ event:event_] && [CMMTouchUtil isNodeInTouch:buttonItem touch:touch_];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher addTouchItemWithTouch:touch_ node:buttonItem];
	[buttonItem touchDispatcher:touchDispatcher whenTouchBegan:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtTouch:touch_];
	if(!touchItem_){
		[touchDispatcher_ cancelTouchAtTouch:touch_];
		return;
	}
	
	CGPoint convertPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touch_]];
	CGSize buttonSize_ = [buttonItem contentSize];
	float itemValue_ = (maxValue-minValue) * ((convertPoint_.x-buttonSize_.width/2.0f)/(self.contentSize.width-buttonSize_.width)) +minValue;
	[self setItemValue:itemValue_];
}

-(void)cleanup{
	[self setCallback_whenItemValueChanged:nil];
	[super cleanup];
}

-(void)dealloc{
	[callback_whenItemValueChanged release];
	[_maskSprite release];
	[super dealloc];
}

@end
