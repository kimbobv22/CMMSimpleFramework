//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMTouchDispatcher.h"
#import "CMMScene.h"

static CMMSimpleCache *_cachedTouchItems_ = nil;

@implementation CMMTouchDispatcherItem
@synthesize touch,node;

+(id)touchItemWithTouch:(UITouch *)touch_ node:(CCNode<CMMTouchDispatcherDelegate> *)node_{
	return [[[self alloc] initWithTouch:touch_ node:node_] autorelease];
}
-(id)initWithTouch:(UITouch *)touch_ node:(CCNode<CMMTouchDispatcherDelegate> *)node_{
	if(!(self = [super init])) return self;
	
	self.touch = touch_;
	self.node = node_;
	
	return self;
}

-(void)dealloc{
	[touch release];
	[node release];
	[super dealloc];
}

@end

@interface CMMTouchDispatcher(Private)

-(CMMTouchDispatcherItem *)cachedTouchItem;
-(void)cacheTouchItem:(CMMTouchDispatcherItem *)touchItem_;

@end

@implementation CMMTouchDispatcher(Private)

-(CMMTouchDispatcherItem *)cachedTouchItem{
	if(!_cachedTouchItems_){
		_cachedTouchItems_ = [[CMMSimpleCache alloc] init];
		
		for(uint index_=0;index_<cmmVarCMMTouchDispather_defaultCacheCount;++index_)
			[_cachedTouchItems_ cacheObject:[CMMTouchDispatcherItem touchItemWithTouch:nil node:nil]];
	}
	
	if(_cachedTouchItems_.count<=0) return nil;
	
	CMMTouchDispatcherItem *touchItem_ = [_cachedTouchItems_ cachedObject];
	return touchItem_;
}
-(void)cacheTouchItem:(CMMTouchDispatcherItem *)touchItem_{
	touchItem_.touch = nil;
	touchItem_.node = nil;
	[_cachedTouchItems_ cacheObject:touchItem_];
}

@end

static SEL _sharedTouchSelectors_[TouchSelectorID_maxCount];

@implementation CMMTouchDispatcher
@synthesize touchList,target,touchCount,maxMultiTouchCount;

+(id)touchDispatherWithTarget:(CCNode *)target_{
	return [[[self alloc] initWithTarget:target_] autorelease];
}
-(id)initWithTarget:(CCNode *)target_{
	if(!(self = [super init])) return self;
	
	touchList = [[CCArray alloc] init];
	target = target_;
	maxMultiTouchCount = cmmVarConfig_defaultMultiTouchAllowCount;
	
	if(!_sharedTouchSelectors_[TouchSelectorID_began]){
		_sharedTouchSelectors_[TouchSelectorID_began] = @selector(touchDispatcher:whenTouchBegan:event:);
		_sharedTouchSelectors_[TouchSelectorID_moved] = @selector(touchDispatcher:whenTouchMoved:event:);
		_sharedTouchSelectors_[TouchSelectorID_ended] = @selector(touchDispatcher:whenTouchEnded:event:);
		_sharedTouchSelectors_[TouchSelectorID_cancelled] = @selector(touchDispatcher:whenTouchCancelled:event:);
	}
	
	return self;
}

-(int)touchCount{
	return touchList.count;
}

-(void)dealloc{
	[touchList release];
	[super dealloc];
}

@end

@implementation CMMTouchDispatcher(Handler)

-(void)whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	if(self.touchCount >= maxMultiTouchCount+1) return;
	if(!target.children) return;
	
	ccArray *data_ = target.children->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CCNode<CMMTouchDispatcherDelegate> *child_ = data_->arr[index_];
		if([CMMTouchUtil isNodeInTouch:child_ touch:touch_]
		   && cmmFuncCommon_respondsToSelector(child_, _sharedTouchSelectors_[TouchSelectorID_began])){
			
			if(cmmFuncCommon_respondsToSelector(child_, @selector(touchDispatcher:isAllowTouch:event:)))
				if(![child_ touchDispatcher:self isAllowTouch:touch_ event:event_])
					continue;
			
			[self addTouchItemWithTouch:touch_ node:child_];
			objc_msgSend(child_, _sharedTouchSelectors_[TouchSelectorID_began], self, touch_, event_);
			break;
		}
	}
}
-(void)whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcherItem *touchItem_ = [self touchItemAtTouch:touch_];
	if(!touchItem_) return;
	CCNode<CMMTouchDispatcherDelegate> *child_ = touchItem_.node;	
	if(cmmFuncCommon_respondsToSelector(child_, _sharedTouchSelectors_[TouchSelectorID_moved]))
		objc_msgSend(child_, _sharedTouchSelectors_[TouchSelectorID_moved], self, touch_, event_);
}
-(void)whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcherItem *touchItem_ = [self touchItemAtTouch:touch_];
	if(!touchItem_) return;
	CCNode<CMMTouchDispatcherDelegate> *child_ = touchItem_.node;
	if(cmmFuncCommon_respondsToSelector(child_, _sharedTouchSelectors_[TouchSelectorID_ended]))
		objc_msgSend(child_, _sharedTouchSelectors_[TouchSelectorID_ended], self, touch_, event_);
	[self removeTouchItem:touchItem_];
}
-(void)whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcherItem *touchItem_ = [self touchItemAtTouch:touch_];
	if(!touchItem_) return;
	CCNode<CMMTouchDispatcherDelegate> *child_ = touchItem_.node;
	if(cmmFuncCommon_respondsToSelector(child_, _sharedTouchSelectors_[TouchSelectorID_cancelled]))
		objc_msgSend(child_, _sharedTouchSelectors_[TouchSelectorID_cancelled], self, touch_, event_);
	[self removeTouchItem:touchItem_];
}

@end

@implementation CMMTouchDispatcher(Common)

-(CMMTouchDispatcherItem *)touchItemAtIndex:(int)index_{
	if(index_ == NSNotFound || touchList.count<=index_) return nil;
	return [touchList objectAtIndex:index_];
}
-(CMMTouchDispatcherItem *)touchItemAtTouch:(UITouch *)touch_{
	return [self touchItemAtIndex:[self indexOfTouch:touch_]];
}
-(CMMTouchDispatcherItem *)touchItemAtNode:(CCNode<CMMTouchDispatcherDelegate> *)node_{
	return [self touchItemAtIndex:[self indexOfNode:node_]];
}

-(void)addTouchItem:(CMMTouchDispatcherItem *)touchItem_{
	[touchList addObject:touchItem_];
}
-(CMMTouchDispatcherItem *)addTouchItemWithTouch:(UITouch *)touch_ node:(CCNode<CMMTouchDispatcherDelegate> *)node_{
	CMMTouchDispatcherItem *touchItem_ = [self cachedTouchItem];
	if(!touchItem_)
		touchItem_ = [CMMTouchDispatcherItem touchItemWithTouch:nil node:nil];
	
	touchItem_.touch = touch_;
	touchItem_.node = node_;
	[self addTouchItem:touchItem_];
	
	return touchItem_;
}

-(void)removeTouchItem:(CMMTouchDispatcherItem *)touchItem_{
	if(!touchItem_) return;
	
	[self cacheTouchItem:touchItem_];
	[touchList removeObject:touchItem_];
}
-(void)removeTouchItemAtTouch:(UITouch *)touch_{
	[self removeTouchItem:[self touchItemAtTouch:touch_]];
}
-(void)removeTouchItemAtNode:(CCNode<CMMTouchDispatcherDelegate> *)node_{
	[self removeTouchItem:[self touchItemAtNode:node_]];
}

-(int)indexOfTouch:(UITouch *)touch_{
	ccArray *data_ = touchList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMTouchDispatcherItem *touchItem_ = data_->arr[index_];
		if(touchItem_.touch == touch_)
			return index_;
	}
	return NSNotFound;
}
-(int)indexOfNode:(CCNode<CMMTouchDispatcherDelegate> *)node_{
	ccArray *data_ = touchList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMTouchDispatcherItem *touchItem_ = data_->arr[index_];
		if(touchItem_.node == node_)
			return index_;
	}
	return NSNotFound;
}

-(void)cancelTouch:(CMMTouchDispatcherItem *)touchItem_{
	if(!touchItem_) return;
	[touchItem_.node touchDispatcher:self whenTouchCancelled:touchItem_.touch event:nil];
	[self removeTouchItem:touchItem_];
}
-(void)cancelTouchAtTouch:(UITouch *)touch_{
	[self cancelTouch:[self touchItemAtTouch:touch_]];
}
-(void)cancelTouchAtNode:(CCNode<CMMTouchDispatcherDelegate> *)node_{
	[self cancelTouch:[self touchItemAtNode:node_]];
}

@end

@implementation CMMTouchDispatcher(Shared)

+(SEL)touchSelectorAtTouchSelectID:(TouchSelectorID)touchSelectorID_{
	if(touchSelectorID_>= TouchSelectorID_maxCount) return nil;
	return _sharedTouchSelectors_[touchSelectorID_];
}

@end