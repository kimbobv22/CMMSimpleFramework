//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMTouchDispatcher.h"
#import "CMMScene.h"

static CMMSimpleCache *_cachedTouchItems_ = nil;

@implementation CMMTouchDispatcherItem{
	CGPoint _firstTouchPoint;
}
@synthesize touch,node,firstTouchPoint = _firstTouchPoint;

+(id)touchItemWithTouch:(UITouch *)touch_ node:(CCNode<CMMTouchDispatcherDelegate> *)node_{
	return [[[self alloc] initWithTouch:touch_ node:node_] autorelease];
}
-(id)initWithTouch:(UITouch *)touch_ node:(CCNode<CMMTouchDispatcherDelegate> *)node_{
	if(!(self = [super init])) return self;
	
	[self setTouch:touch_];
	[self setNode:node_];
	
	return self;
}

-(void)setTouch:(UITouch *)touch_{
	[touch release];
	touch = [touch_ retain];
	
	_firstTouchPoint = CGPointZero;
	if(touch){
		_firstTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
	}
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

+(SEL)touchSelectorAtTouchSelectID:(CMMTouchSelectorID)touchSelectorID_;

@end

static SEL _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_maxCount];

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
	
	if(!_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchShouldAllow]){
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchShouldAllow] = @selector(touchDispatcher:shouldAllowTouch:event:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchBegan] = @selector(touchDispatcher:whenTouchBegan:event:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchMoved] = @selector(touchDispatcher:whenTouchMoved:event:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchEnded] = @selector(touchDispatcher:whenTouchEnded:event:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchCancelled] = @selector(touchDispatcher:whenTouchCancelled:event:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchCancelModeGetter] = @selector(touchCancelMode);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchCancelDistanceSetter] = @selector(setTouchCancelDistance:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchCancelDistanceGetter] = @selector(touchCancelDistance);
	}
	
	return self;
}

-(int)touchCount{
	return [touchList count];
}

-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len{
	return [touchList countByEnumeratingWithState:state objects:buffer count:len];
}

-(void)dealloc{
	[touchList release];
	[super dealloc];
}

@end

@implementation CMMTouchDispatcher(TouchHandler)

-(void)whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	if([self touchCount] >= maxMultiTouchCount+1) return;
	
	CCArray *children_ = [target children];
	if(!children_) return;
	
	[target sortAllChildren];
	
	ccArray *data_ = children_->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CCNode<CMMTouchDispatcherDelegate> *child_ = data_->arr[index_];
		if([CMMTouchUtil isNodeInTouch:child_ touch:touch_]
		   && cmmFunc_respondsToSelector(child_, _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchBegan])){
			
			if(cmmFunc_respondsToSelector(child_, _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchShouldAllow]))
				if(![child_ touchDispatcher:self shouldAllowTouch:touch_ event:event_])
					continue;
			
			[self addTouchItemWithTouch:touch_ node:child_];
			objc_msgSend(child_, _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchBegan], self, touch_, event_);
			break;
		}
	}
}
-(void)whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcherItem *touchItem_ = [self touchItemAtTouch:touch_];
	if(!touchItem_) return;
	CCNode<CMMTouchDispatcherDelegate> *child_ = [touchItem_ node];
	objc_msgSend(child_, _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchMoved], self, touch_, event_);
	
	if(cmmFunc_respondsToSelector(child_, _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchCancelModeGetter])
	   && cmmFunc_respondsToSelector(child_, _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchCancelDistanceGetter])){
		
		BOOL doCancel_ = NO;
		switch([child_ touchCancelMode]){
			case CMMTouchCancelMode_move:{
				doCancel_ = ccpDistance([touchItem_ firstTouchPoint], [CMMTouchUtil pointFromTouch:touch_]) >= [child_ touchCancelDistance];
				break;
			}
			case CMMTouchCancelMode_goOut:
			default:{
				doCancel_ = ![CMMTouchUtil isNodeInTouch:child_ touch:touch_ margin:[child_ touchCancelDistance]];
				break;
			}
		}
		
		if(doCancel_) [self cancelTouch:touchItem_]; 
		return;
	}
}
-(void)whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcherItem *touchItem_ = [self touchItemAtTouch:touch_];
	if(!touchItem_) return;
	CCNode<CMMTouchDispatcherDelegate> *child_ = [touchItem_ node];
	objc_msgSend(child_, _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchEnded], self, touch_, event_);
	[self removeTouchItem:touchItem_];
}
-(void)whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcherItem *touchItem_ = [self touchItemAtTouch:touch_];
	if(!touchItem_) return;
	CCNode<CMMTouchDispatcherDelegate> *child_ = [touchItem_ node];
	objc_msgSend(child_, _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchCancelled], self, touch_, event_);
	[self removeTouchItem:touchItem_];
}

@end

@implementation CMMTouchDispatcher(CMMSceneExtension)

-(void)whenTouchesBeganFromScene:(NSSet *)touches_ event:(UIEvent *)event_{
	for(UITouch *touch_ in touches_){
		[self whenTouchBegan:touch_ event:event_];
	}
}
-(void)whenTouchesMovedFromScene:(NSSet *)touches_ event:(UIEvent *)event_{
	for(UITouch *touch_ in touches_){
		[self whenTouchMoved:touch_ event:event_];
	}
}
-(void)whenTouchesEndedFromScene:(NSSet *)touches_ event:(UIEvent *)event_{
	for(UITouch *touch_ in touches_){
		[self whenTouchEnded:touch_ event:event_];
	}
}
-(void)whenTouchesCancelledFromScene:(NSSet *)touches_ event:(UIEvent *)event_{
	for(UITouch *touch_ in touches_){
		[self whenTouchCancelled:touch_ event:event_];
	}
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
	[[touchItem_ node] touchDispatcher:self whenTouchCancelled:[touchItem_ touch] event:nil];
	[self removeTouchItem:touchItem_];
}
-(void)cancelTouchAtTouch:(UITouch *)touch_{
	[self cancelTouch:[self touchItemAtTouch:touch_]];
}
-(void)cancelTouchAtNode:(CCNode<CMMTouchDispatcherDelegate> *)node_{
	[self cancelTouch:[self touchItemAtNode:node_]];
}
-(void)cancelAllTouches{
	ccArray *data_ = touchList->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		[self cancelTouch:data_->arr[index_]];
	}
}

@end

@implementation CMMTouchDispatcher(Private)

-(CMMTouchDispatcherItem *)cachedTouchItem{
	if(!_cachedTouchItems_){
		_cachedTouchItems_ = [[CMMSimpleCache alloc] init];
		
		for(uint index_=0;index_<cmmVarCMMTouchDispather_defaultCacheCount;++index_)
			[_cachedTouchItems_ addObject:[CMMTouchDispatcherItem touchItemWithTouch:nil node:nil]];
	}
	
	if([_cachedTouchItems_ count]<=0) return nil;
	
	CMMTouchDispatcherItem *touchItem_ = [_cachedTouchItems_ cachedObject];
	return touchItem_;
}
-(void)cacheTouchItem:(CMMTouchDispatcherItem *)touchItem_{
	[touchItem_ setTouch:nil];
	[touchItem_ setNode:nil];
	[_cachedTouchItems_ addObject:touchItem_];
}

+(SEL)touchSelectorAtTouchSelectID:(CMMTouchSelectorID)touchSelectorID_{
	return _sharedCMMTouchDispatcher_TouchSelectors_[touchSelectorID_];
}

@end