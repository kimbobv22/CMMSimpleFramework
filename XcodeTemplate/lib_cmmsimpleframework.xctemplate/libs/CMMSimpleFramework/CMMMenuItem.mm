//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMenuItem.h"

@interface CMMMenuItem(Private)

-(void)_stopFadeAction;
-(void)_setMenuItemImage:(CCSprite *)sprite_;
-(void)_setIsOnSelected:(BOOL)isOnSelected_;

@end

@implementation CMMMenuItem(Private)

-(void)_stopFadeAction{
	[self stopAction:_fadeInAction];
	[self stopAction:_fadeOutAction];
}
-(void)_setMenuItemImage:(CCSprite *)sprite_{
	[self setTexture:[sprite_ texture]];
	[self setTextureRect:[sprite_ textureRect]];
}
-(void)_setIsOnSelected:(BOOL)isOnSelected_{
	_isOnSelected = isOnSelected_;
	[self _stopFadeAction];
	if(_isOnSelected){
		[self runAction:_fadeOutAction];
		[self _setMenuItemImage:selectedImage];
	}else{
		[self runAction:isEnable?_fadeInAction:_fadeOutAction];
		[self _setMenuItemImage:normalImage];
	}
}

@end

@implementation CMMMenuItem
@synthesize key,userData,normalImage,selectedImage,delegate,isEnable,callback_pushdown,callback_pushup,callback_pushcancel;

+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ batchBarSeq:batchBarSeq_ frameSize:frameSize_] autorelease];
}
+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ batchBarSeq:batchBarSeq_] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	
	_fadeInAction = [[CCTintTo actionWithDuration:0.1f red:255 green:255 blue:255] retain];
	_fadeOutAction = [[CCTintTo actionWithDuration:0.1f red:140 green:140 blue:140] retain];
	
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	key = userData = nil;
	normalImage = [[CCSprite alloc] initWithTexture:texture rect:rect];
	selectedImage = [[CCSprite alloc] initWithTexture:texture rect:rect];
	delegate = nil;
	touchCancelDistance = 30.0f;
	isEnable = YES;
	_isOnSelected = NO;
	
	callback_pushdown = callback_pushup = callback_pushcancel = nil;
	
	return self;
}
-(id)initWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_{
	CCTexture2D *frameTexture_ = [[CMMDrawingManager sharedManager] textureBatchBarWithFrameSeq:frameSeq_ batchBarSeq:batchBarSeq_ size:frameSize_];
	if(!frameTexture_){
		[self release];
		return nil;
		
	}
	return [self initWithTexture:frameTexture_];
}
-(id)initWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_{
	return [self initWithFrameSeq:frameSeq_ batchBarSeq:batchBarSeq_ frameSize:cmmVarCMMMenuItem_defaultMenuItemSize];
}

-(void)setIsEnable:(BOOL)isEnable_{
	isEnable = isEnable_;
	[self _setIsOnSelected:NO];
}
-(BOOL)isOnSelected{
	return _isOnSelected;
}

-(void)setNormalImage:(CCSprite *)normalImage_{
	if(normalImage == normalImage_) return;
	[normalImage release];
	normalImage = [normalImage_ retain];
	[self _setIsOnSelected:_isOnSelected];
}
-(void)setSelectedImage:(CCSprite *)selectedImage_{
	if(selectedImage == selectedImage_) return;
	[selectedImage release];
	selectedImage = [selectedImage_ retain];
	[self _setIsOnSelected:_isOnSelected];
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return isEnable;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	[self _setIsOnSelected:YES];
	[self callCallback_pushdown];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	[self _setIsOnSelected:NO];
	[self callCallback_pushup];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	[self _setIsOnSelected:NO];
	[self callCallback_pushcancel];
}

-(void)updateDisplay{}

-(void)cleanup{
	[callback_pushdown release];
	callback_pushdown = nil;
	[callback_pushup release];
	callback_pushup = nil;
	[callback_pushcancel release];
	callback_pushcancel = nil;
	[super cleanup];
}

-(void)dealloc{
	[selectedImage release];
	[normalImage release];
	[callback_pushdown release];
	[callback_pushup release];
	[callback_pushcancel release];
	[_fadeOutAction release];
	[_fadeInAction release];
	[key release];
	[userData release];
	[super dealloc];
}

@end

@implementation CMMMenuItem(Callback)

-(void)callCallback_pushdown{
	if(callback_pushdown){
		callback_pushdown(self);
	}else if(cmmFuncCommon_respondsToSelector(delegate,@selector(menuItem_whenPushdown:)))
		[delegate menuItem_whenPushdown:self];
}
-(void)callCallback_pushup{
	if(callback_pushup){
		callback_pushup(self);
	}else if(cmmFuncCommon_respondsToSelector(delegate,@selector(menuItem_whenPushup:))){
		[delegate menuItem_whenPushup:self];
	}
}
-(void)callCallback_pushcancel{
	if(callback_pushcancel){
		callback_pushcancel(self);
	}else if(cmmFuncCommon_respondsToSelector(delegate,@selector(menuItem_whenPushcancel:))){
		[delegate menuItem_whenPushcancel:self];
	}
}

@end

@implementation CMMMenuItemLabelTTF
@synthesize title,titleAlign;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	labelTitle = [CMMFontUtil labelWithstring:@" "];
	titleAlign = kCCTextAlignmentCenter;
	[self addChild:labelTitle z:1];
	[self updateDisplay];
	
	return self;
}
-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	[self updateDisplay];
}
-(void)setTitleAlign:(CCTextAlignment)titleAlign_{
	titleAlign = titleAlign_;
	[self updateDisplay];
}

-(void)updateDisplay{
	[super updateDisplay];
	CGPoint targetPoint_ = CGPointZero;
	
	switch(titleAlign){
		case kCCTextAlignmentLeft:
			targetPoint_ = ccp(labelTitle.contentSize.width/2.0f + 10.0f,contentSize_.height/2);
			break;
		case kCCTextAlignmentRight:
			targetPoint_ = ccp(contentSize_.width-(labelTitle.contentSize.width/2.0f + 10.0f),contentSize_.height/2);
			break;
		case kCCTextAlignmentCenter:
		default:
			targetPoint_ = ccp(contentSize_.width/2,contentSize_.height/2);
			break;
	}
	
	[labelTitle setPosition:targetPoint_];
}

-(void)setTitle:(NSString *)title_{
	[labelTitle setString:title_];
	[self updateDisplay];
}
-(NSString *)title{
	return [labelTitle string];
}

@end