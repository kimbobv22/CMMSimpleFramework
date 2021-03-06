//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMenuItem.h"

@interface CMMMenuItem(Private)

-(void)_stopFadeAction;
-(void)_setOnSelect:(BOOL)onSelect_;

@end

@implementation CMMMenuItem(Private)

-(void)_stopFadeAction{
	if(pushUpAction) [self stopAction:pushUpAction];
	if(pushDownAction) [self stopAction:pushDownAction];
}
-(void)_setOnSelect:(BOOL)onSelect_{
	onSelect = onSelect_;
	[self _stopFadeAction];
	if(onSelect){
		if(pushDownAction) [self runAction:pushDownAction];
		[self setDisplayFrame:selectedFrame];
	}else{
		if(enable){
			if(pushUpAction) [self runAction:pushUpAction];
		}else{
			if(pushDownAction) [self runAction:pushDownAction];
		}
		[self setDisplayFrame:normalFrame];
	}
}

@end

@implementation CMMMenuItem
@synthesize key,normalFrame,selectedFrame,enable,onSelect,filter_canSelectItem,callback_pushdown,callback_pushup,callback_pushcancel,pushDownAction,pushUpAction;

+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ batchBarSeq:batchBarSeq_ frameSize:frameSize_] autorelease];
}
+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_{
	return [[[self alloc] initWithFrameSeq:frameSeq_ batchBarSeq:batchBarSeq_] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect_ rotated:(BOOL)rotated{
	
	pushUpAction = [[CCTintTo actionWithDuration:0.1f red:255 green:255 blue:255] retain];
	pushDownAction = [[CCTintTo actionWithDuration:0.1f red:140 green:140 blue:140] retain];
	
	if(!(self = [super initWithTexture:texture rect:rect_ rotated:rotated])) return self;
	
	normalFrame = [[CCSpriteFrame alloc] initWithTexture:texture rect:rect_];
	selectedFrame = [[CCSpriteFrame alloc] initWithTexture:texture rect:rect_];
	touchCancelDistance = 30.0f;
	enable = YES;
	onSelect = NO;
	
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

-(void)setEnable:(BOOL)enable_{
	enable = enable_;
	[self _setOnSelect:NO];
}
-(BOOL)isOnSelect{
	return onSelect;
}

-(void)setNormalFrame:(CCSpriteFrame *)frame_{
	[normalFrame release];
	normalFrame = [frame_ retain];
	[self _setOnSelect:onSelect];
}
-(void)setNormalFrameWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_{
	[self setNormalFrame:[CCSpriteFrame frameWithTexture:texture_ rect:rect_]];
}
-(void)setNormalFrameWithSprite:(CCSprite *)sprite_{
	[self setNormalFrame:[CCSpriteFrame frameWithTexture:[sprite_ texture] rect:[sprite_ textureRect]]];
}

-(void)setSelectedFrame:(CCSpriteFrame *)frame_{
	[selectedFrame release];
	selectedFrame = [frame_ retain];
	[self _setOnSelect:onSelect];
}
-(void)setSelectedFrameWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_{
	[self setSelectedFrame:[CCSpriteFrame frameWithTexture:texture_ rect:rect_]];
}
-(void)setSelectedFrameWithSprite:(CCSprite *)sprite_{
	[self setSelectedFrame:[CCSpriteFrame frameWithTexture:[sprite_ texture] rect:[sprite_ textureRect]]];
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return enable && (!filter_canSelectItem || filter_canSelectItem(self));
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	[self _setOnSelect:YES];
	[self callCallback_pushdown];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	[self _setOnSelect:NO];
	[self callCallback_pushup];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	[self _setOnSelect:NO];
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
	[normalFrame release];
	[selectedFrame release];
	[callback_pushdown release];
	[callback_pushup release];
	[callback_pushcancel release];
	[pushUpAction release];
	[pushDownAction release];
	[key release];
	[super dealloc];
}

@end

@implementation CMMMenuItem(Callback)

-(void)callCallback_pushdown{
	if(callback_pushdown){
		callback_pushdown(self);
	}
}
-(void)callCallback_pushup{
	if(callback_pushup){
		callback_pushup(self);
	}
}
-(void)callCallback_pushcancel{
	if(callback_pushcancel){
		callback_pushcancel(self);
	}
}

@end

@implementation CMMMenuItemL
@synthesize title,labelTitle,titleAlign,titleSize,titleColor;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	labelTitle = [CMMFontUtil labelWithString:@" "];
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
-(void)setTitleSize:(float)titleSize_{
	[labelTitle setFontSize:titleSize_];
}
-(float)titleSize{
	return [labelTitle fontSize];
}
-(void)setTitleColor:(ccColor3B)titleColor_{
	[labelTitle setColor:titleColor_];
}
-(ccColor3B)titleColor{
	return [labelTitle color];
}

-(void)updateDisplay{
	[super updateDisplay];
	CGPoint targetPoint_ = CGPointZero;
	
	switch(titleAlign){
		case kCCTextAlignmentLeft:
			targetPoint_ = ccp(labelTitle.contentSize.width/2.0f + 10.0f,_contentSize.height/2);
			break;
		case kCCTextAlignmentRight:
			targetPoint_ = ccp(_contentSize.width-(labelTitle.contentSize.width/2.0f + 10.0f),_contentSize.height/2);
			break;
		case kCCTextAlignmentCenter:
		default:
			targetPoint_ = ccp(_contentSize.width/2,_contentSize.height/2);
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