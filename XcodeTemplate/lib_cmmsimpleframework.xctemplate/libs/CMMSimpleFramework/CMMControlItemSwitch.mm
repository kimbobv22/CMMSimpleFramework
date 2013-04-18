//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItemSwitch.h"

ccColor3B CMMControlItemSwitchBackColorLeft = ccc3(80, 100, 200);
ccColor3B CMMControlItemSwitchBackColorRight = ccc3(200, 200, 200);

ccColor3B CMMControlItemSwitchBackLabelColorLeft = CMMControlItemSwitchBackColorRight;
ccColor3B CMMControlItemSwitchBackLabelColorRight = CMMControlItemSwitchBackColorLeft;

GLubyte CMMControlItemSwitchBackLabelOpacityLeft = 255;
GLubyte CMMControlItemSwitchBackLabelOpacityRight = 255;

float CMMControlItemSwitchBackLabelSizeLeft = 18.0f;
float CMMControlItemSwitchBackLabelSizeRight = 18.0f;

NSString *CMMControlItemSwitchBackLabelStringLeft = @"ON";
NSString *CMMControlItemSwitchBackLabelStringRight = @"OFF";

@interface CMMControlItemSwitch(Private)

-(void)_setPointXOfButton:(float)x_;

@end

@implementation CMMControlItemSwitch{
	CCSprite *_maskSprite,*_resultBackSprite;
	CCLabelTTF *_backLabelL,*_backLabelR;
	BOOL _isTouchMoved;
}
@synthesize itemValue,buttonItem,callback_whenItemValueChanged;
@synthesize backColorL,backColorR;
@synthesize backLabelColorL,backLabelColorR,backLabelOpacityL,backLabelOpacityR,backLabelSizeL,backLabelSizeR,backLabelStringL,backLabelStringR;

+(id)controlItemSwitchWithMaskFrame:(CCSpriteFrame *)maskFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_{
	return [[[self alloc] initWithMaskFrame:maskFrame_ buttonFrame:buttonFrame_] autorelease];
}
+(id)controlItemSwitchWithFrameSeq:(uint)frameSeq_{
	return [[[self alloc] initWithFrameSeq:frameSeq_] autorelease];
}

-(id)initWithMaskFrame:(CCSpriteFrame *)maskFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_{
	if(!(self = [super initWithFrameSize:[maskFrame_ rect].size])) return self;
	[touchDispatcher setMaxMultiTouchCount:0];
	
	_maskSprite = [[CCSprite alloc] initWithTexture:[maskFrame_ texture] rect:[maskFrame_ rect]];
	buttonItem = [CMMMenuItem node];
	[buttonItem setTouchCancelDistance:100.0f];
	
	_backLabelL = [[CMMFontUtil labelWithString:CMMControlItemSwitchBackLabelStringLeft fontSize:CMMControlItemSwitchBackLabelSizeLeft] retain];
	[[_backLabelL texture] setAliasTexParameters];
	[_backLabelL setColor:CMMControlItemSwitchBackLabelColorLeft];
	[_backLabelL setOpacity:CMMControlItemSwitchBackLabelOpacityLeft];
	
	_backLabelR = [[CMMFontUtil labelWithString:CMMControlItemSwitchBackLabelStringRight fontSize:CMMControlItemSwitchBackLabelSizeRight] retain];
	[[_backLabelR texture] setAliasTexParameters];
	[_backLabelR setColor:CMMControlItemSwitchBackLabelColorRight];
	[_backLabelR setOpacity:CMMControlItemSwitchBackLabelOpacityRight];
	
	[_backLabelL setScaleY:-1.0f];
	[_backLabelR setScaleY:-1.0f];
	
	_resultBackSprite = [CCSprite node];
	
	backColorL = CMMControlItemSwitchBackColorLeft;
	backColorR = CMMControlItemSwitchBackColorRight;
	
	[self addChild:buttonItem z:2];
	[self addChild:_resultBackSprite z:0];
	[self setButtonFrame:buttonFrame_];
	
	[self setItemValue:NO];
	[self redraw];
	
	return self;
}
-(id)initWithFrameSeq:(uint)frameSeq_{
	CMMDrawingManager *sharedDrawingManager_ = [CMMDrawingManager sharedManager];
	CMMDrawingManagerItem *drawingItem_ = [sharedDrawingManager_ drawingItemAtIndex:frameSeq_];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSpriteFrame *maskFrame_ = [[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SwitchMask];
	CCSpriteFrame *buttonFrame_ = [[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_SwitchButton];
	
	return [self initWithMaskFrame:maskFrame_ buttonFrame:buttonFrame_];
}

-(void)setBackLabelColorL:(ccColor3B)backLabelColorL_{
	[_backLabelL setColor:backLabelColorL_];
	[self setDoRedraw:YES];
}
-(ccColor3B)backLabelColorL{
	return [_backLabelL color];
}
-(void)setBackLabelColorR:(ccColor3B)backLabelColorR_{
	[_backLabelR setColor:backLabelColorR_];
	[self setDoRedraw:YES];
}
-(ccColor3B)backLabelColorR{
	return [_backLabelR color];
}
-(void)setBackLabelOpacityL:(GLubyte)backLabelOpacityL_{
	[_backLabelL setOpacity:backLabelOpacityL_];
	[self setDoRedraw:YES];
}
-(GLubyte)backLabelOpacityL{
	return [_backLabelL opacity];
}
-(void)setBackLabelOpacityR:(GLubyte)backLabelOpacityR_{
	[_backLabelR setOpacity:backLabelOpacityR_];
	[self setDoRedraw:YES];
}
-(GLubyte)backLabelOpacityR{
	return [_backLabelR opacity];
}
-(void)setBackLabelSizeL:(float)backLabelSizeL_{
	[_backLabelL setFontSize:backLabelSizeL_];
	[self setDoRedraw:YES];
}
-(float)backLabelSizeL{
	return [_backLabelL fontSize];
}
-(void)setBackLabelSizeR:(float)backLabelSizeR_{
	[_backLabelR setFontSize:backLabelSizeR_];
	[self setDoRedraw:YES];
}
-(float)backLabelSizeR{
	return [_backLabelR fontSize];
}
-(void)setBackLabelStringL:(NSString *)backLabelStringL_{
	[_backLabelL setString:backLabelStringL_];
	[self setDoRedraw:YES];
}
-(NSString *)backLabelStringL{
	return [_backLabelL string];
}
-(void)setBackLabelStringR:(NSString *)backLabelStringR_{
	[_backLabelR setString:backLabelStringR_];
	[self setDoRedraw:YES];
}
-(NSString *)backLabelStringR{
	return [_backLabelR string];
}

-(void)setEnable:(BOOL)enable_{
	[super setEnable:enable_];
	[buttonItem setColor:(enable?ccWHITE:disabledColor)];
	[self setDoRedraw:YES];
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
	
	buttonSize_.width *= 0.5f;
	
	if(x_<buttonSize_.width)
		x_ = buttonSize_.width;
	else if(x_>frameSize_.width-buttonSize_.width)
		x_ = frameSize_.width-buttonSize_.width;
	
	CGPoint buttonPoint_ = ccp(x_,frameSize_.height*0.5f);
	[buttonItem setPosition:buttonPoint_];
	[_backLabelL setPosition:cmmFunc_positionIPN(self, _backLabelL, ccp(0.5f,0.5f),ccp(-(frameSize_.width-buttonPoint_.x),0.0f))];
	[_backLabelR setPosition:cmmFunc_positionIPN(self, _backLabelL, ccp(0.5f,0.5f),ccp(buttonPoint_.x,0.0f))];
	[self setDoRedraw:YES];
}

-(void)redraw{
	[super redraw];
	if(!_maskSprite) return;
	
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:_contentSize.width height:_contentSize.height];
	[render_ begin];
	
	ccColor3B backColorL_ = backColorL;
	ccColor3B backColorR_ = backColorR;
	
	backColorL_ = (enable ? backColorL : ccc3(backColorL_.r*(((float)disabledColor.r)/255.0f),backColorL_.g*(((float)disabledColor.g)/255.0f),backColorL_.b*(((float)disabledColor.b)/255.0f)));
	backColorR_ = (enable ? backColorR : ccc3(backColorR_.r*(((float)disabledColor.r)/255.0f),backColorR_.g*(((float)disabledColor.g)/255.0f),backColorR_.b*(((float)disabledColor.b)/255.0f)));
	
	ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	[_maskSprite setPosition:cmmFunc_positionIPN(self,_maskSprite)];
	[_maskSprite visit];
	
	CGPoint buttonPoint_ = [buttonItem position];
	
	ccGLBlendFunc(GL_DST_ALPHA, GL_ZERO);
	ccDrawSolidRect(CGPointZero, ccp(buttonPoint_.x,_contentSize.height),ccc4f(backColorL_.r/255.0f, backColorL_.g/255.0f, backColorL_.b/255.0f, _realOpacity/255.0f));
	ccDrawSolidRect(ccp(buttonPoint_.x,0.0f), ccp(_contentSize.width,_contentSize.height),ccc4f(backColorR_.r/255.0f, backColorR_.g/255.0f, backColorR_.b/255.0f, _realOpacity/255.0f));
	
	[_backLabelL visit];
	[_backLabelR visit];
	
	[render_ end];
	
	CCTexture2D *resultTexture_ = [[render_ sprite] texture];
	CGRect resultTextureRect_ = CGRectZero;
	resultTextureRect_.size = [resultTexture_ contentSize];
	
	[_resultBackSprite setTexture:resultTexture_];
	[_resultBackSprite setTextureRect:resultTextureRect_];
	
	[_resultBackSprite setPosition:ccp(_contentSize.width*0.5f,_contentSize.height*0.5f)];
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
	[_maskSprite release];
	[_backLabelL release];
	[_backLabelR release];
	[super dealloc];
}

@end

@implementation CMMControlItemSwitch(Configuration)

+(void)setDefaultBackColorLeft:(ccColor3B)color_{
	CMMControlItemSwitchBackColorLeft = color_;
}
+(void)setDefaultBackColorRight:(ccColor3B)color_{
	CMMControlItemSwitchBackColorRight = color_;
}

+(void)setDefaultBackLabelColorLeft:(ccColor3B)color_{
	CMMControlItemSwitchBackLabelColorLeft = color_;
}
+(void)setDefaultBackLabelColorRight:(ccColor3B)color_{
	CMMControlItemSwitchBackLabelColorRight = color_;
}

+(void)setDefaultBackLabelOpacityLeft:(GLubyte)opacity_{
	CMMControlItemSwitchBackLabelOpacityLeft = opacity_;
}
+(void)setDefaultBackLabelOpacityRight:(GLubyte)opacity_{
	CMMControlItemSwitchBackLabelOpacityRight = opacity_;
}

+(void)setDefaultBackLabelSizeLeft:(float)size_{
	CMMControlItemSwitchBackLabelSizeLeft = size_;
}
+(void)setDefaultBackLabelSizeRight:(float)size_{
	CMMControlItemSwitchBackLabelSizeRight = size_;
}

+(void)setDefaultBackLabelStringLeft:(NSString *)string_{
	[CMMControlItemSwitchBackLabelStringLeft release];
	CMMControlItemSwitchBackLabelStringLeft = [string_ copy];
}
+(void)setDefaultBackLabelStringRight:(NSString *)string_{
	[CMMControlItemSwitchBackLabelStringRight release];
	CMMControlItemSwitchBackLabelStringRight = [string_ copy];
}

@end
