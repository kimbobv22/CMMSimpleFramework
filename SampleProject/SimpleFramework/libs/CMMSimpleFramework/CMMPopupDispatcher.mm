//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMPopupDispatcher.h"

static CMMSimpleCache *_cachedPopupItems_ = nil;

@implementation CMMPopupLayer
@synthesize popupDispatcherItem,lazyCleanup;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	[self setIsTouchEnabled:YES];
	
	popupDispatcherItem = nil;
	lazyCleanup = NO;
	
	return self;
}

-(void)closeWithSendData:(id)data_{
	[popupDispatcherItem popup:self didCloseWithReceivedData:data_];
}
-(void)close{
	[self closeWithSendData:nil];
}

@end

@implementation CMMPopupDispatcherItem
@synthesize popupDispatcher,delegate,popup;

+(id)popupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_{
	return [[[self alloc] initWithPopup:popup_ delegate:delegate_] autorelease];
}
-(id)initWithPopup:(CMMPopupLayer *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_{
	if(!(self = [super init])) return self;
	
	[self setPopup:popup_];
	[self setDelegate:delegate_];;
	
	return self;
}

-(void)setPopup:(CMMPopupLayer *)popup_{
	if(popup == popup_) return;
	[popup release];
	popup = [popup_ retain];
	if(popup){
		[popup setPopupDispatcherItem:self];
	}
}

-(void)popup:(CMMPopupLayer *)popup_ didCloseWithReceivedData:(id)data_{
	[popupDispatcher removePopupItem:self withData:data_];
}

-(void)dealloc{
	[popup release];
	[super dealloc];
}

@end

@implementation CMMPopupMasterView
@synthesize backgroundNode,showOnlyOne;

+(id)viewWithPopupDispatcher:(CMMPopupDispatcher *)popupDispatcher_{
	return [[[self alloc] initWithPopupDispatcher:popupDispatcher_] autorelease];
}
-(id)initWithPopupDispatcher:(CMMPopupDispatcher *)popupDispatcher_{
	if(!(self = [super init])) return self;
	
	[self addBackgroundNode:[CCLayerColor layerWithColor:ccc4(0, 0, 0, 180)]];
	showOnlyOne = NO;
	
	return self;
}

-(void)visit{
	kmGLPushMatrix();
	
	[self transform];
	[self draw];

	if(children_){
		
		[self sortAllChildren];
		
		ccArray *data_ = children_->data;
		uint count_ = data_->num;
		for(uint index_=(showOnlyOne?data_->num-1:0);index_<count_;++index_){
			CMMPopupLayer *popup_ = data_->arr[index_];
			
			[backgroundNode visit];
			[popup_ visit];
		}
	}
	
	orderOfArrival_ = 0;
	
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

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return (children_ && children_->data->num > 0);
}

-(void)cleanup{
	[backgroundNode setParent:nil];
	[super cleanup];
}

-(void)dealloc{
	[backgroundNode release];
	[super dealloc];
}

@end

@interface CMMPopupDispatcher(Private)

-(void)_resortPopup;
-(CMMPopupDispatcherItem *)cachedPopupItem;
-(void)cachePopupItem:(CMMPopupDispatcherItem *)popupItem_;

@end

@implementation CMMPopupDispatcher(Private)

-(void)_resortPopup{
	ccArray *data_ = popupList->data;
	uint count_ = data_->num;
	
	for(uint index_=0;index_<count_;++index_){
		CMMPopupDispatcherItem *popupItem_ = data_->arr[index_];
		CMMPopupLayer *popup_ = [popupItem_ popup];
		[popup_ setZOrder:count_-index_];
	}
}
-(CMMPopupDispatcherItem *)cachedPopupItem{
	if(!_cachedPopupItems_){
		_cachedPopupItems_ = [[CMMSimpleCache alloc] init];
		for(uint index_=0;index_<cmmVarCMMPopupDispather_defaultCacheCount;++index_)
			[_cachedPopupItems_ addObject:[CMMPopupDispatcherItem popupItemWithPopup:nil delegate:nil]];
	}
	
	if([_cachedPopupItems_ count]<=0) return nil;
	
	CMMPopupDispatcherItem *touchItem_ = [_cachedPopupItems_ cachedObject];
	return touchItem_;
}
-(void)cachePopupItem:(CMMPopupDispatcherItem *)popupItem_{
	[popupItem_ setPopup:nil];
	[popupItem_ setPopupDispatcher:nil];
	[popupItem_ setDelegate:nil];
	[_cachedPopupItems_ addObject:popupItem_];
}

@end

@implementation CMMPopupDispatcher
@synthesize target,popupList,popupCount,headPopup,masterView;

+(id)popupDispatcherWithTarget:(CCNode *)target_{
	return [[[self alloc] initWithTarget:target_] autorelease];
}
-(id)initWithTarget:(CCNode *)target_{
	if(!(self = [super init])) return self;
	
	popupList = [[CCArray alloc] init];
	masterView = [[CMMPopupMasterView alloc] initWithPopupDispatcher:self];
	[self setTarget:target_];
	
	return self;
}

-(void)setTarget:(CCNode *)target_{
	target = target_;
	[masterView removeFromParentAndCleanup:NO];
	if(target){
		[target addChild:masterView z:cmmVarCMMPopupDispatcher_defaultPopupZOrder];
	}
}

-(int)popupCount{
	return [popupList count];
}

-(CMMPopupLayer *)headPopup{
	if([popupList count] == 0) return nil;
	return [popupList->data->arr[0] popup];
}

-(void)addPopupItem:(CMMPopupDispatcherItem *)popupItem_ atIndex:(int)index_{
	CMMPopupLayer *popup_ = [popupItem_ popup];
	if([self indexOfPopup:popup_] != NSNotFound) return;
	
	[popupList insertObject:popupItem_ atIndex:index_];
	[masterView addChild:popup_];
	[self _resortPopup];
	
	id<CMMPopupDispatcherDelegate> delegate_ = [popupItem_ delegate];
	if(cmmFuncCommon_respondsToSelector(delegate_, @selector(popupDispatcher:didOpenPopup:))){
		[delegate_ popupDispatcher:self didOpenPopup:popup_];
	}
}
-(CMMPopupDispatcherItem *)addPopupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_ atIndex:(int)index_{
	CMMPopupDispatcherItem *popupItem_ = [self cachedPopupItem];
	if(!popupItem_)
		popupItem_ = [CMMPopupDispatcherItem popupItemWithPopup:nil delegate:nil];

	[popupItem_ setPopupDispatcher:self];
	[popupItem_ setPopup:popup_];
	[popupItem_ setDelegate:delegate_];
	[self addPopupItem:popupItem_ atIndex:index_];
	return popupItem_;
}
-(CMMPopupDispatcherItem *)addPopupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_{
	return [self addPopupItemWithPopup:popup_ delegate:delegate_ atIndex:[self popupCount]];
}

-(void)removePopupItem:(CMMPopupDispatcherItem *)popupItem_ withData:(id)data_{
	CMMPopupLayer *popupLayer_ = [popupItem_ popup];
	
	id<CMMPopupDispatcherDelegate> delegate_ = [popupItem_ delegate];
	if(cmmFuncCommon_respondsToSelector(delegate_, @selector(popupDispatcher:didClosePopup:withReceivedData:))){
		[delegate_ popupDispatcher:self didClosePopup:popupLayer_ withReceivedData:data_];
	}
	
	[popupLayer_ removeFromParentAndCleanup:![popupLayer_ isLazyCleanup]];
	[self cachePopupItem:popupItem_];
	[popupList removeObject:popupItem_];
	[self _resortPopup];
}
-(void)removePopupItem:(CMMPopupDispatcherItem *)popupItem_{
	[self removePopupItem:popupItem_ withData:nil];
}
-(void)removePopupItemAtIndex:(int)index_ withData:(id)data_{
	[self removePopupItem:[self popupItemAtIndex:index_] withData:data_];
}
-(void)removePopupItemAtIndex:(int)index_{
	[self removePopupItemAtIndex:index_ withData:nil];
}
-(void)removePopupItemAtPopup:(CMMPopupLayer *)popup_ withData:(id)data_{
	[self removePopupItemAtIndex:[self indexOfPopup:popup_] withData:data_];
}
-(void)removePopupItemAtPopup:(CMMPopupLayer *)popup_{
	[self removePopupItemAtPopup:popup_ withData:nil];
}

-(CMMPopupDispatcherItem *)popupItemAtIndex:(int)index_{
	if(index_ == NSNotFound || index_>= [self popupCount]) return nil;
	return [popupList objectAtIndex:index_];
}

-(int)indexOfPopupItem:(CMMPopupDispatcherItem *)popupItem_{
	return [popupList indexOfObject:popupItem_];
}
-(int)indexOfPopup:(CMMPopupLayer *)popup_{
	ccArray *data_ = popupList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMPopupDispatcherItem *popupItem_ = data_->arr[index_];
		if(popupItem_.popup == popup_)
			return index_;
	}
	return NSNotFound;
}

-(void)dealloc{
	[masterView removeFromParentAndCleanup:YES];
	[masterView release];
	[popupList release];
	[super dealloc];
}

@end