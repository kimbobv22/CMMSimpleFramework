//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItemSlider.h"

ccColor3B CMMControlItemSliderBackColorLeft = ccc3(80, 100, 200);
ccColor3B CMMControlItemSliderBackColorRight = ccc3(200, 200, 200);

@interface CMMControlItemSlider(Private)

-(void)_setPointXOfButton:(float)x_;

@end

@implementation CMMControlItemSlider{
	CMM9SliceBar *_maskSprite,*_barSprite;
	CCSprite *_resultBackSprite;
}
@synthesize buttonItem,backColorL,backColorR,itemValue,unitValue,itemValueRange,snappable,callback_whenItemValueChanged;

+(id)controlItemSliderWithWidth:(float)width_ maskFrame:(CCSpriteFrame *)maskFrame_ barFrame:(CCSpriteFrame *)barFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_{
	return [[[self alloc] initWithWidth:width_ maskFrame:maskFrame_ barFrame:barFrame_ buttonFrame:buttonFrame_] autorelease];
}
+(id)controlItemSliderWithWidth:(float)width_ frameSeq:(uint)frameSeq_{
	return [[[self alloc] initWithWidth:width_ frameSeq:frameSeq_] autorelease];
}

-(id)initWithWidth:(float)width_ maskFrame:(CCSpriteFrame *)maskFrame_ barFrame:(CCSpriteFrame *)barFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_{
	CGSize frameSize_ = CGSizeZero;
	frameSize_.width = width_+10.0f;
	frameSize_.height = [buttonFrame_ rect].size.height+10.0f;
	
	if(!(self = [super initWithFrameSize:frameSize_])) return self;
	[touchDispatcher setMaxMultiTouchCount:0];
	
	buttonItem = [CMMMenuItem node];
	[buttonItem setTouchCancelDistance:100.0f];
	[self setButtonFrame:buttonFrame_];
	
	CGSize sliderSize_ = CGSizeMake(width_, [maskFrame_ rect].size.height);
	_maskSprite = [[CMM9SliceBar sliceBarWithTexture:[maskFrame_ texture] targetRect:[maskFrame_ rect]] retain];
	[_maskSprite setContentSize:sliderSize_];
	_barSprite = [CMM9SliceBar sliceBarWithTexture:[barFrame_ texture] targetRect:[barFrame_ rect]];
	[_barSprite setContentSize:sliderSize_];
	
	_resultBackSprite = [CCSprite node];
	
	backColorL = CMMControlItemSliderBackColorLeft;
	backColorR = CMMControlItemSliderBackColorRight;
	
	snappable = NO;
	
	[self addChild:buttonItem z:2];
	[self addChild:_barSprite z:1];
	[self addChild:_resultBackSprite z:0];
	
	[self setUnitValue:1.0f];
	[self setItemValueRange:CMMFloatRange(0.0f,10.0f)];
	[self setItemValue:0.0f];
	
	[self redraw];
	
	return self;
}
-(id)initWithWidth:(float)width_ frameSeq:(uint)frameSeq_{
	CMMDrawingManager *sharedDrawingManager_ = [CMMDrawingManager sharedManager];
	CMMDrawingManagerItem *drawingItem_ = [sharedDrawingManager_ drawingItemAtIndex:frameSeq_];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSpriteFrame *maskFrame_ = [[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SlideMask];
	CCSpriteFrame *barFrame_ = [[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SlideBar];
	CCSpriteFrame *buttonFrame_ = [[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SlideButton];
	
	return [self initWithWidth:width_ maskFrame:maskFrame_ barFrame:barFrame_ buttonFrame:buttonFrame_];
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	[self setDoRedraw:YES];
}

-(void)setEnable:(BOOL)enable_{
	[super setEnable:enable_];
	[_barSprite setColor:(enable?ccWHITE:disabledColor)];
	[buttonItem setColor:(enable?ccWHITE:disabledColor)];
	[_resultBackSprite setColor:(enable?ccWHITE:disabledColor)];
}

-(void)setButtonFrame:(CCSpriteFrame *)frame_{
	[buttonItem setNormalFrame:frame_];
	[buttonItem setSelectedFrame:frame_];
	[self setDoRedraw:YES];
}
-(void)setButtonFrameWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_{
	[self setButtonFrame:[CCSpriteFrame frameWithTexture:texture_ rect:rect_]];
}
-(void)setButtonFrameWithSprite:(CCSprite *)sprite_{
	[self setButtonFrame:[CCSpriteFrame frameWithTexture:[sprite_ texture] rect:[sprite_ textureRect]]];
}

-(void)setBackColorL:(ccColor3B)backColorL_{
	backColorL = backColorL_;
	[self setDoRedraw:YES];
}
-(void)setBackColorR:(ccColor3B)backColorR_{
	backColorR = backColorR_;
	[self setDoRedraw:YES];
}

-(void)setItemValue:(float)itemValue_{
	float convertItemValue_ = floorf(itemValue_/unitValue) * unitValue;
	convertItemValue_ = MAX(itemValueRange.loc,MIN(itemValueRange.len,convertItemValue_));
	BOOL doCallback_ = itemValue != convertItemValue_;
	float beforeItemValue_ = itemValue;
	itemValue = convertItemValue_;
	
	float buttonPointX_ = (_contentSize.width*(((snappable ? itemValue : itemValue_)-itemValueRange.loc)/(itemValueRange.len-itemValueRange.loc)));
	[self _setPointXOfButton:buttonPointX_];
	
	if(doCallback_ && callback_whenItemValueChanged){
		callback_whenItemValueChanged(itemValue,beforeItemValue_);
	}
}

-(void)setUnitValue:(float)unitValue_{
	unitValue = unitValue_;
	[self setItemValue:itemValue];
}
-(void)setItemValueRange:(CMMFloatRange)itemValueRange_{
	itemValueRange = itemValueRange_;
	[self setItemValue:itemValue];
}

-(void)_setPointXOfButton:(float)x_{
	CGSize buttonSize_ = [buttonItem contentSize];
	
	float targetWidth_ = _contentSize.width - buttonSize_.width;
	float convertX_ = targetWidth_ * cmmFunc_MINMAX((x_/_contentSize.width), 0.0f, 1.0f);
	[buttonItem setPosition:ccp(convertX_+buttonSize_.width*0.5f,_contentSize.height*0.5f)];
	[self setDoRedraw:YES];
}

-(void)redraw{
	[super redraw];
	if(!_maskSprite) return;
	
	CGSize buttonSize_ = [buttonItem contentSize];
	CGSize targetSize_ = CGSizeMake(_contentSize.width-buttonSize_.width*0.5f, [_maskSprite contentSize].height);
	[_maskSprite setContentSize:targetSize_];
	[_barSprite setContentSize:targetSize_];
	
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:_contentSize.width height:_contentSize.height];
	
	[render_ begin];
	[render_ addChild:_maskSprite];
	
	ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	[_maskSprite setPosition:cmmFunc_positionIPN(self,_maskSprite)];
	[_maskSprite visit];
	[_maskSprite removeFromParentAndCleanup:NO];
	
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
	float itemValue_ = (itemValueRange.len-itemValueRange.loc) * ((convertPoint_.x-buttonSize_.width/2.0f)/(_contentSize.width-buttonSize_.width)) +itemValueRange.loc;
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

@implementation CMMControlItemSlider(Configuration)

+(void)setDefaultBackColorLeft:(ccColor3B)color_{
	CMMControlItemSliderBackColorLeft = color_;
}
+(void)setDefaultBackColorRight:(ccColor3B)color_{
	CMMControlItemSliderBackColorRight = color_;
}

@end
