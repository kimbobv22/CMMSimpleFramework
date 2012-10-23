//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMPopupDispatcher.h"
#import "CMMScene.h"

static CMMSimpleCache *_cachedPopupItems_ = nil;

@implementation CMMPopupDispatcherItem
@synthesize delegate,popup;

+(id)popupItemWithPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_{
	return [[[self alloc] initWithPopup:popup_ delegate:delegate_] autorelease];
}
-(id)initWithPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_{
	if(!(self = [super init])) return self;
	
	self.popup = popup_;
	self.delegate = delegate_;
	
	return self;
}

-(void)dealloc{
	[popup release];
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
	int count_ = data_->num;
	if(count_<=0) return;
	
	CMMPopupDispatcherItem *popupItem_ = data_->arr[0];
	CCNode *firstPopup_ = popupItem_.popup;
	[scene reorderChild:firstPopup_ z:cmmVarCMMPopupDispatcher_defaultPopupZOrder];
	firstPopup_.scale = 0.98f;
	[firstPopup_ runAction:[CCScaleTo actionWithDuration:0.1 scale:1.0f]];
	
	for(uint index_=1;index_<count_;++index_){
		popupItem_ = data_->arr[index_];
		[scene reorderChild:popupItem_.popup z:cmmVarCMMPopupDispatcher_defaultPopupZOrder-index_];
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
	popupItem_.popup = nil;
	popupItem_.delegate = nil;
	[_cachedPopupItems_ addObject:popupItem_];
}

@end

@implementation CMMPopupDispatcher
@synthesize scene,popupList,popupCount,curPopup;

+(id)popupDispatcherWithScene:(CMMScene *)scene_{
	return [[[self alloc] initWithScene:scene_] autorelease];
}
-(id)initWithScene:(CMMScene *)scene_{
	if(!(self = [super init])) return self;
	
	scene = scene_;
	popupList = [[CCArray alloc] init];
	
	return self;
}

-(int)popupCount{
	return popupList.count;
}

-(void)addPopupItem:(CMMPopupDispatcherItem *)popupItem_ atIndex:(int)index_{
	if([self indexOfPopup:popupItem_.popup] != NSNotFound) return;
	[popupList insertObject:popupItem_ atIndex:index_];
	[scene addChild:popupItem_.popup z:-1];
	[self _resortPopup];
}
-(CMMPopupDispatcherItem *)addPopupItemWithPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_ atIndex:(int)index_{
	CMMPopupDispatcherItem *popupItem_ = [self cachedPopupItem];
	if(!popupItem_)
		popupItem_ = [CMMPopupDispatcherItem popupItemWithPopup:nil delegate:nil];
	
	popupItem_.popup = popup_;
	popupItem_.delegate = delegate_;
	[self addPopupItem:popupItem_ atIndex:index_];
	return popupItem_;
}
-(CMMPopupDispatcherItem *)addPopupItemWithPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_{
	return [self addPopupItemWithPopup:popup_ delegate:delegate_ atIndex:[self popupCount]];
}

-(void)removePopupItem:(CMMPopupDispatcherItem *)popupItem_ withData:(id)data_{
	[popupItem_.popup removeFromParentAndCleanup:YES];
	
	id<CMMPopupDispatcherDelegate> delegate_ = popupItem_.delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_, @selector(popupDispatcher:whenClosedWithReceivedData:)))
		[delegate_ popupDispatcher:popupItem_ whenClosedWithReceivedData:data_];
	
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
-(void)removePopupItemAtPopup:(CMMLayerPopup *)popup_ withData:(id)data_{
	[self removePopupItemAtIndex:[self indexOfPopup:popup_] withData:data_];
}
-(void)removePopupItemAtPopup:(CMMLayerPopup *)popup_{
	[self removePopupItemAtPopup:popup_ withData:nil];
}

-(CMMPopupDispatcherItem *)popupItemAtIndex:(int)index_{
	if(index_ == NSNotFound || index_>= [self popupCount]) return nil;
	return [popupList objectAtIndex:index_];
}

-(int)indexOfPopupItem:(CMMPopupDispatcherItem *)popupItem_{
	return [popupList indexOfObject:popupItem_];
}
-(int)indexOfPopup:(CMMLayerPopup *)popup_{
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
	[popupList release];
	[super dealloc];
}

@end