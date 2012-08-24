//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMCustomUIJoypad.h"

@interface CMMCustomUIJoypadButton(Private)

-(void)_callbackPushdown;
-(void)_callbackPushup;
-(void)_callbackPushcancel;

@end

@implementation CMMCustomUIJoypadButton(Private)

-(void)_callbackPushdown{
	if(callback_pushdown) callback_pushdown(self);
	_curPushDelayTime = 0.0f;
}
-(void)_callbackPushup{
	if(callback_pushup) callback_pushup(self);
}
-(void)_callbackPushcancel{
	if(callback_pushcancel) callback_pushcancel(self);
}

@end

@implementation CMMCustomUIJoypadButton
@synthesize pushDelayTime,isAutoPushdown,callback_pushdown,callback_pushup,callback_pushcancel;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	touchCancelDistance = 30.0f;
	pushDelayTime = 0.3f;
	isAutoPushdown = NO;
	_isOnPush = NO;
	_curPushDelayTime = 0.0f;
	
	return self;
}

-(void)update:(ccTime)dt_{
	_curPushDelayTime = MIN(_curPushDelayTime+dt_,cmmVarCMMCustomUIJoypadButton_maxPushDelayTime);
	
	if(isAutoPushdown && _isOnPush && _curPushDelayTime>=pushDelayTime)
		[self _callbackPushdown];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	_isOnPush = YES;
	if(_curPushDelayTime>=pushDelayTime)
		[self _callbackPushdown];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	_isOnPush = NO;
	[self _callbackPushup];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	_isOnPush = NO;
	[self _callbackPushcancel];
}

-(void)dealloc{
	[callback_pushdown release];
	[callback_pushup release];
	[callback_pushcancel release];
	[super dealloc];
}

@end

@implementation CMMCustomUIJoypadStick
@synthesize delegate,stickVector;

+(id)stickWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_ radius:(float)radius_{
	return [[[self alloc] initWithStickSprite:stickSprite_ backSprite:backSprite_ radius:radius_] autorelease];
}
+(id)stickWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_{
	return [[[self alloc] initWithStickSprite:stickSprite_ backSprite:backSprite_] autorelease];
}

-(id)initWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_ radius:(float)radius_{
	_stick = [CMMSprite spriteWithTexture:stickSprite_.texture rect:stickSprite_.textureRect];
	_backSprite = [CCSprite spriteWithTexture:backSprite_.texture rect:backSprite_.textureRect];
	
	if(!(self = [super initWithColor:ccc4(0, 0, 0, 0) width:radius_*2.0f height:radius_*2.0f])) return self;
		
	[self addChild:_backSprite z:0];
	[self addChild:_stick z:1];
	[self setStickVector:CGPointZero];
	
	return self;
}
-(id)initWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_{
	return [self initWithStickSprite:stickSprite_ backSprite:backSprite_ radius:backSprite_.contentSize.width/2.0f];
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	_backSprite.position = ccp(contentSize_.width/2.0f,contentSize_.height/2.0f);
}
-(void)setOpacity:(GLubyte)opacity{
	[super setOpacity:0.0f];
	[_stick setOpacity:opacity];
	[_backSprite setOpacity:opacity];
}

-(void)setStickVector:(CGPoint)stickVector_{
	float radius_ = contentSize_.width/2.0f;
	CGPoint targetPoint_ = ccpMult(stickVector_, radius_);
	targetPoint_ = ccpAdd(targetPoint_, ccp(radius_,radius_));
	
	if(!CGPointEqualToPoint(ccpSub(targetPoint_ , _stick.position) , CGPointZero)){
		if(!cmmFuncCommon_respondsToSelector(delegate, @selector(customUIJoypadStick:whenChangedStickVector:))){
			CCLOG(@"Does not exist delegate method (customUIJoypadStick:whenChangedStickVector:)");
		}else{
			[((id<CMMCustomUIJoypadStickDelegate>)delegate) customUIJoypadStick:self whenChangedStickVector:stickVector_];
		}
	}
	
	[_stick setPosition:targetPoint_];
}
-(CGPoint)stickVector{
	float radius_ = contentSize_.width/2.0f;
	CGPoint stickPoint_ = _stick.position;
	CGPoint centerPoint_ = ccp(radius_,radius_);
	CGPoint diffPoint_ = ccpSub(stickPoint_, centerPoint_);
	return ccp(diffPoint_.x/radius_,diffPoint_.y/radius_);
}

-(void)moveStickPositionTo:(CGPoint)worldPoint_{
	float radius_ = contentSize_.width/2.0f;
	CGPoint convertPoint_ = [self convertToNodeSpace:worldPoint_];
	CGPoint centerPoint_ = ccp(radius_,radius_);
	CGPoint diffPoint_ = ccpSub(convertPoint_, centerPoint_);
	
	if(ccpLength(diffPoint_)>radius_)
		diffPoint_ = ccpMult(ccpNormalize(diffPoint_), radius_);
	
	[self setStickVector:ccp(diffPoint_.x/radius_,diffPoint_.y/radius_)];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	[self moveStickPositionTo:[CMMTouchUtil pointFromTouch:touch_]];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	[self moveStickPositionTo:[CMMTouchUtil pointFromTouch:touch_]];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	[self setStickVector:CGPointZero];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	[self setStickVector:CGPointZero];
}

-(void)dealloc{
	[delegate release];
	[super dealloc];
}

@end

@interface CMMCustomUIJoypad(Private)

-(void)_callbackpushdownWithButton:(CMMCustomUIJoypadButton *)button_;
-(void)_callbackpushupWithButton:(CMMCustomUIJoypadButton *)button_;
-(void)_callbackpushcancelWithButton:(CMMCustomUIJoypadButton *)button_;

@end

@implementation CMMCustomUIJoypad(Private)

-(void)_callbackpushdownWithButton:(CMMCustomUIJoypadButton *)button_{
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(customUIJoypad:whenPushdownWithButton:)))
		[((id<CMMCustomUIJoypadDelegate>)delegate) customUIJoypad:self whenPushdownWithButton:button_];
}
-(void)_callbackpushupWithButton:(CMMCustomUIJoypadButton *)button_{
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(customUIJoypad:whenPushupWithButton:)))
		[((id<CMMCustomUIJoypadDelegate>)delegate) customUIJoypad:self whenPushupWithButton:button_];
}
-(void)_callbackpushcancelWithButton:(CMMCustomUIJoypadButton *)button_{
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(customUIJoypad:whenPushcancelWithButton:)))
		[((id<CMMCustomUIJoypadDelegate>)delegate) customUIJoypad:self whenPushcancelWithButton:button_];
}

@end

@implementation CMMCustomUIJoypad
@synthesize stick,buttonA,buttonB;

+(id)joypadWithStickSprite:(CCSprite *)stickSprite_ stickBackSprite:(CCSprite *)stickBackSprite_ stickRadius:(float)stickRadius_ buttonASprite:(CCSprite *)buttonASprite_ buttonBSprite:(CCSprite *)buttonBSprite_{
	return [[[self alloc] initWithStickSprite:stickSprite_ stickBackSprite:stickBackSprite_ stickRadius:stickRadius_ buttonASprite:buttonASprite_ buttonBSprite:buttonBSprite_] autorelease];
}
+(id)joypadWithSpriteFrameFileName:(NSString *)fileName_{
	return [[[self alloc] initWithSpriteFrameFileName:fileName_] autorelease];
}

-(id)initWithStickSprite:(CCSprite *)stickSprite_ stickBackSprite:(CCSprite *)stickBackSprite_ stickRadius:(float)stickRadius_ buttonASprite:(CCSprite *)buttonASprite_ buttonBSprite:(CCSprite *)buttonBSprite_{
	
	CGSize frameSize_ = [CCDirector sharedDirector].winSize;
	if(!(self = [super initWithColor:ccc4(0, 0, 0, 0) width:frameSize_.width height:frameSize_.height])) return self;
	
	stick = [CMMCustomUIJoypadStick stickWithStickSprite:stickSprite_ backSprite:stickBackSprite_ radius:stickRadius_];
	stick.delegate = self;
	
	buttonA = [CMMCustomUIJoypadButton spriteWithTexture:buttonASprite_.texture rect:buttonASprite_.textureRect];
	buttonA.callback_pushdown = ^(id sender_){[self _callbackpushdownWithButton:sender_];};
	buttonA.callback_pushup = ^(id sender_){[self _callbackpushupWithButton:sender_];};
	buttonA.callback_pushcancel = ^(id sender_){[self _callbackpushcancelWithButton:sender_];};
	
	buttonB = [CMMCustomUIJoypadButton spriteWithTexture:buttonBSprite_.texture rect:buttonBSprite_.textureRect];
	buttonB.callback_pushdown = ^(id sender_){[self _callbackpushdownWithButton:sender_];};
	buttonB.callback_pushup = ^(id sender_){[self _callbackpushupWithButton:sender_];};
	buttonB.callback_pushcancel = ^(id sender_){[self _callbackpushcancelWithButton:sender_];};
	
	[self addChild:stick z:1];
	[self addChild:buttonA z:1];
	[self addChild:buttonB z:1];
	[self resetJoypadPosition];
	
	return self;
}
-(id)initWithSpriteFrameFileName:(NSString *)fileName_{
	NSString *spriteFrameName_ = [fileName_ stringByDeletingPathExtension];

	CCSprite *stickSprite_ = [CCSprite spriteWithSpriteFrameName:[spriteFrameName_ stringByAppendingString:@"_STICK.png"]];
	CCSprite *stickBackSprite_ = [CCSprite spriteWithSpriteFrameName:[spriteFrameName_ stringByAppendingString:@"_STICK_BACK.png"]];
	CCSprite *buttonASprite_ = [CCSprite spriteWithSpriteFrameName:[spriteFrameName_ stringByAppendingString:@"_BTN_A.png"]];
	CCSprite *buttonBSprite_ = [CCSprite spriteWithSpriteFrameName:[spriteFrameName_ stringByAppendingString:@"_BTN_B.png"]];
	
	return [self initWithStickSprite:stickSprite_ stickBackSprite:stickBackSprite_ stickRadius:stickBackSprite_.contentSize.width/2.0f buttonASprite:buttonASprite_ buttonBSprite:buttonBSprite_];
}

-(void)setOpacity:(GLubyte)opacity{
	[super setOpacity:0.0f];
	[stick setOpacity:opacity];
	[buttonA setOpacity:opacity];
	[buttonB setOpacity:opacity];
}

-(void)resetJoypadPositionWithDictionary:(NSDictionary *)dictionary_{
	CGPoint stickPoint_ = [[dictionary_ objectForKey:cmmVarCMMCustomUIJoypad_positionKey_stick] CGPointValue];
	CGPoint buttonAPoint_ = [[dictionary_ objectForKey:cmmVarCMMCustomUIJoypad_positionKey_buttonA] CGPointValue];
	CGPoint buttonBPoint_ = [[dictionary_ objectForKey:cmmVarCMMCustomUIJoypad_positionKey_buttonB] CGPointValue];
	
	[stick setPosition:stickPoint_];
	[buttonA setPosition:buttonAPoint_];
	[buttonB setPosition:buttonBPoint_];
}
-(void)resetJoypadPosition{
	NSMutableDictionary *tempDic_ = [NSMutableDictionary dictionary];
	
	CGPoint stickPoint_ = ccp(50,50);
	CGPoint buttonAPoint_ = ccp(contentSize_.width-170.0f,60.0f);
	CGPoint buttonBPoint_ = ccp(contentSize_.width-50.0f,100.0f);
	
	[tempDic_ setObject:[NSValue valueWithCGPoint:stickPoint_] forKey:cmmVarCMMCustomUIJoypad_positionKey_stick];
	[tempDic_ setObject:[NSValue valueWithCGPoint:buttonAPoint_] forKey:cmmVarCMMCustomUIJoypad_positionKey_buttonA];
	[tempDic_ setObject:[NSValue valueWithCGPoint:buttonBPoint_] forKey:cmmVarCMMCustomUIJoypad_positionKey_buttonB];
	[self resetJoypadPositionWithDictionary:tempDic_];
}

-(void)customUIJoypadStick:(CMMCustomUIJoypadStick *)stick_ whenChangedStickVector:(CGPoint)vector_{
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(customUIJoypad:whenChangedStickVector:)))
		[((id<CMMCustomUIJoypadDelegate>)delegate) customUIJoypad:self whenChangedStickVector:vector_];
}

-(void)update:(ccTime)dt_{
	[buttonA update:dt_];
	[buttonB update:dt_];
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ isAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return ([CMMTouchUtil isNodeInTouch:stick touch:touch_] || [CMMTouchUtil isNodeInTouch:buttonA touch:touch_] || [CMMTouchUtil isNodeInTouch:buttonB touch:touch_]);
}

@end