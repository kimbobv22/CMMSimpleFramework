//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMenuItem.h"

@interface CMMMenuItem(Private)

-(void)_stopFadeAction;

@end

@implementation CMMMenuItem(Private)

-(void)_stopFadeAction{
	[self stopAction:_fadeInAction];
	[self stopAction:_fadeOutAction];
}

@end

@implementation CMMMenuItem
@synthesize key,userData,delegate,callback_pushdown,callback_pushup,callback_pushcancel;

+(id)menuItemWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ frameSize:frameSize_] autorelease];
}
+(id)menuItemWithFrameSeq:(int)frameSeq_{
	return [[[self alloc] initWithFrameSeq:frameSeq_] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	key = userData = nil;
	delegate = nil;
	touchCancelDistance = 30.0f;
	
	callback_pushdown = callback_pushup = callback_pushcancel = nil;
	_fadeInAction = [[CCTintTo actionWithDuration:0.1f red:255 green:255 blue:255] retain];
	_fadeOutAction = [[CCTintTo actionWithDuration:0.1f red:140 green:140 blue:140] retain];
	
	return self;
}
-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	CCTexture2D *frameTexture_ = [[CMMDrawingManager sharedManager] textureFrameWithFrameSeq:frameSeq_ size:frameSize_];
	if(!frameTexture_){
		[self release];
		return nil;
		
	}
	return [self initWithTexture:frameTexture_];
}
-(id)initWithFrameSeq:(int)frameSeq_{
	return [self initWithFrameSeq:frameSeq_ frameSize:cmmVarCMMMenuItem_defaultMenuItemSize];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	if(callback_pushdown){
		callback_pushdown(self);
	}else if(cmmFuncCommon_respondsToSelector(delegate,@selector(menuItem_isCanPush:))){
		if(![delegate menuItem_isCanPush:self]){
			[touchDispatcher_ removeTouchItemAtTouch:touch_];
			return;
		}
	}
	[self _stopFadeAction];
	[self runAction:_fadeOutAction];
	if(cmmFuncCommon_respondsToSelector(delegate,@selector(menuItem_whenPushdown:)))
		[delegate menuItem_whenPushdown:self];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[self _stopFadeAction];
	[self runAction:_fadeInAction];
	if(callback_pushup){
		callback_pushup(self);
	}else if(cmmFuncCommon_respondsToSelector(delegate,@selector(menuItem_whenPushup:))){
		[delegate menuItem_whenPushup:self];
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[self _stopFadeAction];
	[self runAction:_fadeInAction];
	if(callback_pushcancel){
		callback_pushcancel(self);
	}else if(cmmFuncCommon_respondsToSelector(delegate,@selector(menuItem_whenPushcancel:))){
		[delegate menuItem_whenPushcancel:self];
	}
}

-(void)updateDisplay{}

-(void)dealloc{
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