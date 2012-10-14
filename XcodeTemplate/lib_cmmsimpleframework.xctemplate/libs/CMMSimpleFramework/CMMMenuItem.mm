//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMenuItem.h"

@interface CMMMenuItem(Private)

-(void)_stopFadeAction;
-(void)_setMenuItemImage:(CCSprite *)sprite_;

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

@end

@implementation CMMMenuItem
@synthesize key,userData,selectedImage,delegate,isEnable,callback_pushdown,callback_pushup,callback_pushcancel;

+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ batchBarSeq:batchBarSeq_ frameSize:frameSize_] autorelease];
}
+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ batchBarSeq:batchBarSeq_] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	key = userData = nil;
	_normalImage = [[CCSprite alloc] initWithTexture:texture rect:rect];
	selectedImage = nil;
	delegate = nil;
	touchCancelDistance = 30.0f;
	isEnable = YES;
	
	callback_pushdown = callback_pushup = callback_pushcancel = nil;
	_fadeInAction = [[CCTintTo actionWithDuration:0.1f red:255 green:255 blue:255] retain];
	_fadeOutAction = [[CCTintTo actionWithDuration:0.1f red:140 green:140 blue:140] retain];
	
	[self initializeTouchDispatcher];
	
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
	[self _stopFadeAction];
	[self _setMenuItemImage:_normalImage];
	if(isEnable){
		[self runAction:_fadeInAction];
	}else{
		[self runAction:_fadeOutAction];
	}
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return isEnable;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	[self _stopFadeAction];
	[self _setMenuItemImage:_normalImage];
	if(selectedImage){
		[self _setMenuItemImage:selectedImage];
	}
	[self runAction:_fadeOutAction];
	[self callCallback_pushdown];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	[self _stopFadeAction];
	[self _setMenuItemImage:_normalImage];
	[self runAction:_fadeInAction];
	[self callCallback_pushup];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	[self _stopFadeAction];
	[self _setMenuItemImage:_normalImage];
	[self runAction:_fadeInAction];
	[self callCallback_pushcancel];
}

-(void)updateDisplay{}

-(void)dealloc{
	[selectedImage release];
	[_normalImage release];
	[delegate release];
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
@synthesize title;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	labelTitle = [CMMFontUtil labelWithstring:@" "];
	[self addChild:labelTitle z:1];
	[self updateDisplay];
	
	return self;
}
-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	[self updateDisplay];
}
-(void)updateDisplay{
	[super updateDisplay];
	[labelTitle setPosition:ccp(self.contentSize.width/2,self.contentSize.height/2)];
}

-(void)setTitle:(NSString *)title_{
	[labelTitle setString:title_];
	[self updateDisplay];
}
-(NSString *)title{
	return labelTitle.string;
}

@end