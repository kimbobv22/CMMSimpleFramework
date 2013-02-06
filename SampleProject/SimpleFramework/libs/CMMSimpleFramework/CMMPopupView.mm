//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMPopupView.h"
#import "CMMScene.h"

@implementation CMMPopupLayer
@synthesize lazyCleanup;
@synthesize callback_didOpen, callback_didClose;
@synthesize callback_becomeHeadPopup,callback_resignHeadPopup;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	[self setTouchEnabled:YES];
	
	lazyCleanup = NO;
	
	return self;
}

-(void)close{
	[[[CMMScene sharedScene] popupView] removePopup:self];
}

-(void)onEnter{
	[super onEnter];
	if(callback_didOpen){
		callback_didOpen(self);
	}
}
-(void)onExit{
	[super onExit];
	if(callback_didClose){
		callback_didClose(self);
	}
}

-(void)setZOrder:(NSInteger)zOrder{}

-(void)cleanup{
	[self setCallback_didOpen:nil];
	[self setCallback_didClose:nil];
	[self setCallback_becomeHeadPopup:nil];
	[self setCallback_resignHeadPopup:nil];
	[super cleanup];
}
-(void)dealloc{
	[callback_becomeHeadPopup release];
	[callback_resignHeadPopup release];
	[callback_didOpen release];
	[callback_didClose release];
	[super dealloc];
}

@end

@interface CMMPopupView(Private)

-(void)_setHeadPopup:(CMMPopupLayer *)popup_;
-(void)_updatePopupOrder;

@end

@implementation CMMPopupView(Private)

-(void)_updatePopupOrder{
	ccArray *data_ = popupList->data;
	int count_ = data_->num;
	if(count_ == 0) return;
	[self _setHeadPopup:data_->arr[0]];
}
-(void)_setHeadPopup:(CMMPopupLayer *)popup_{
	if(headPopup == popup_) return;
	
	CMMPopupLayer *beforeHeadPopup_ = headPopup;
	
	if(headPopup
	   && [headPopup callback_resignHeadPopup]
	   && [self indexOfPopup:headPopup] != NSNotFound){
		[headPopup callback_resignHeadPopup](headPopup);
	}
	[headPopup release];
	headPopup = [popup_ retain];
	
	if(headPopup
	   && [headPopup callback_becomeHeadPopup]
	   && [self indexOfPopup:headPopup] != NSNotFound){
		[headPopup callback_becomeHeadPopup](headPopup);
	}
	
	if(callback_whenHeadPopupChanged){
		callback_whenHeadPopupChanged(headPopup,beforeHeadPopup_);
	}
}

@end

@implementation CMMPopupView
@synthesize popupList,count,headPopup,backgroundNode,showOnlyOne;
@synthesize callback_whenHeadPopupChanged;

+(id)popupView{
	return [[[self alloc] init] autorelease];
}
-(id)init{
	if(!(self = [super init])) return self;
	
	popupList = [[CCArray alloc] init];
	[self addBackgroundNode:[CCLayerColor layerWithColor:ccc4(0, 0, 0, 180)]];
	showOnlyOne = NO;
	
	return self;
}

-(uint)count{
	return [popupList count];
}

-(void)visit{
	kmGLPushMatrix();
	
	[self transform];
	[self draw];
	
	ccArray *data_ = popupList->data;
	int count_ = data_->num;
	for(int index_=(showOnlyOne?0:count_-1);index_>=0;--index_){
		CMMPopupLayer *popup_ = data_->arr[index_];
		
		[backgroundNode visit];
		[popup_ visit];
	}
	
	_orderOfArrival = 0;
	
	kmGLPopMatrix();
}

-(void)addBackgroundNode:(CCNode<CCRGBAProtocol> *)backgroundNode_{
	if(backgroundNode){
		[backgroundNode removeFromParentAndCleanup:YES];
		[backgroundNode release];
	}
	
	backgroundNode = [backgroundNode_ retain];
	[backgroundNode setParent:self]; //lazy ref
}

-(void)addPopup:(CMMPopupLayer *)popup_ atIndex:(uint)index_{
	if([self indexOfPopup:popup_] != NSNotFound) return;
	
	[popupList insertObject:popup_ atIndex:index_];
	[self addChild:popup_];
	[self _updatePopupOrder];
}
-(void)addPopup:(CMMPopupLayer *)popup_{
	[self addPopup:popup_ atIndex:[self count]];
}

-(void)removePopup:(CMMPopupLayer *)popup_{
	uint index_ = [self indexOfPopup:popup_];
	if(index_ == NSNotFound) return;
	
	[popup_ removeFromParentAndCleanup:![popup_ isLazyCleanup]];
	[popupList removeObjectAtIndex:index_];
	[self _updatePopupOrder];
}
-(void)removePopupAtIndex:(uint)index_{
	[self removePopup:[self popupAtIndex:index_]];
}

-(void)switchPopup:(CMMPopupLayer *)popup_ toIndex:(uint)toIndex_{
	uint index_= [self indexOfPopup:popup_];
	if(index_ == NSNotFound || index_ == toIndex_) return;
	[popupList exchangeObjectAtIndex:index_ withObjectAtIndex:toIndex_];
	[self _updatePopupOrder];
}
-(void)switchPopupAtIndex:(uint)atIndex_ toIndex:(uint)toIndex_{
	[self switchPopup:[self popupAtIndex:atIndex_] toIndex:toIndex_];
}

-(CMMPopupLayer *)popupAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [popupList objectAtIndex:index_];
}
-(uint)indexOfPopup:(CMMPopupLayer *)popup_{
	return [popupList indexOfObject:popup_];
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return (_children && _children->data->num > 0);
}

-(void)cleanup{
	[self setCallback_whenHeadPopupChanged:nil];
	[backgroundNode setParent:nil];
	[self _setHeadPopup:nil];
	[super cleanup];
}
-(void)dealloc{
	[callback_whenHeadPopupChanged release];
	[headPopup release];
	[backgroundNode release];
	[popupList release];
	[super dealloc];
}

@end