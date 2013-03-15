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
	
	touch = [touch_ retain];
	node = [node_ retain];
	
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
			[_cachedTouchItems_ addObject:[CMMTouchDispatcherItem touchItemWithTouch:nil node:nil]];
	}
	
	if(_cachedTouchItems_.count<=0) return nil;
	
	CMMTouchDispatcherItem *touchItem_ = [_cachedTouchItems_ cachedObject];
	return touchItem_;
}
-(void)cacheTouchItem:(CMMTouchDispatcherItem *)touchItem_{
	touchItem_.touch = nil;
	touchItem_.node = nil;
	[_cachedTouchItems_ addObject:touchItem_];
}

@end

static SEL _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_maxCount];

@implementation CMMTouchDispatcher
@synthesize touchList,target,touchCount,maxMultiTouchCount,pinchState;

+(id)touchDispatherWithTarget:(CCNode *)target_{
	return [[[self alloc] initWithTarget:target_] autorelease];
}
-(id)initWithTarget:(CCNode *)target_{
	if(!(self = [super init])) return self;
	
	touchList = [[CCArray alloc] init];
	target = target_;
	maxMultiTouchCount = cmmVarConfig_defaultMultiTouchAllowCount;
	pinchState = CMMPinchStateMake(0.0f, 0.0f);
	
	if(!_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchShouldAllow]){
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchShouldAllow] = @selector(touchDispatcher:shouldAllowTouch:event:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchBegan] = @selector(touchDispatcher:whenTouchBegan:event:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchMoved] = @selector(touchDispatcher:whenTouchMoved:event:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchEnded] = @selector(touchDispatcher:whenTouchEnded:event:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchCancelled] = @selector(touchDispatcher:whenTouchCancelled:event:);
		
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_PinchBegan] = @selector(touchDispatcher:whenPinchBegan:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_PinchMoved] = @selector(touchDispatcher:whenPinchMoved:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_PinchEnded] = @selector(touchDispatcher:whenPinchEnded:);
		_sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_PinchCancelled] = @selector(touchDispatcher:whenPinchCancelled:);
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
	CCNode<CMMTouchDispatcherDelegate> *child_ = touchItem_.node;	
	objc_msgSend(child_, _sharedCMMTouchDispatcher_TouchSelectors_[CMMTouchSelectorID_TouchMoved], self, touch_, event_);
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

@implementation CMMTouchDispatcher(PinchHandler)

-(void)_performPinchSelector:(CMMTouchSelectorID)selectorID_ pinchState:(CMMPinchState)pinchState_ touchPhase:(UITouchPhase)touchPhase_{
	CCArray *targetNodes_ = [CCArray array];
	
	ccArray *data_ = touchList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMTouchDispatcherItem *touchItem_ = data_->arr[index_];
		CCNode<CMMTouchDispatcherDelegate> *child_ = [touchItem_ node];
		UITouch *touch_ = [touchItem_ touch];
		if([touch_ phase] == touchPhase_
		   && cmmFunc_respondsToSelector(child_, _sharedCMMTouchDispatcher_TouchSelectors_[selectorID_])
		   && [targetNodes_ indexOfObject:child_] == NSNotFound){
			[targetNodes_ addObject:child_];
			
			IMP childIMP_ = [[child_ class] instanceMethodForSelector:_sharedCMMTouchDispatcher_TouchSelectors_[selectorID_]];
			childIMP_(child_,_sharedCMMTouchDispatcher_TouchSelectors_[selectorID_],self,pinchState_);
		}
	}
}

-(void)whenPinchBeganWithPinchState:(CMMPinchState)pinchState_{
	[self _performPinchSelector:CMMTouchSelectorID_PinchBegan pinchState:pinchState_ touchPhase:UITouchPhaseBegan];
}
-(void)whenPinchMovedWithPinchState:(CMMPinchState)pinchState_{
	[self _performPinchSelector:CMMTouchSelectorID_PinchMoved pinchState:pinchState_ touchPhase:UITouchPhaseMoved];
}
-(void)whenPinchEndedWithPinchState:(CMMPinchState)pinchState_{
	[self _performPinchSelector:CMMTouchSelectorID_PinchEnded pinchState:pinchState_ touchPhase:UITouchPhaseEnded];
}
-(void)whenPinchCancelledWithPinchState:(CMMPinchState)pinchState_{
	[self _performPinchSelector:CMMTouchSelectorID_PinchCancelled pinchState:pinchState_ touchPhase:UITouchPhaseCancelled];
}

@end

@implementation CMMTouchDispatcher(CMMSceneExtension)

-(void)_updatePinchState{
	if([touchList count] < 2){
		pinchState = CMMPinchStateMake(0.0f, 0.0f);
		return;
	}
	
	BOOL isNew_ = NO;
	ccArray *data_ = touchList->data;
	CMMTouchDispatcherItem *touchItem1_ = data_->arr[0];
	CMMTouchDispatcherItem *touchItem2_ = data_->arr[1];
	
	UITouch *beforeTouch1_ = pinchState.touch1;
	UITouch *beforeTouch2_ = pinchState.touch2;
	
	pinchState.touch1 = [touchItem1_ touch];
	pinchState.touch2 = [touchItem2_ touch];
	
	if(pinchState.touch1 != beforeTouch1_ || pinchState.touch2 != beforeTouch2_){
		isNew_ = YES;
	}
	
	CGPoint touchPoint1_ = [CMMTouchUtil pointFromTouch:pinchState.touch1];
	CGPoint touchPoint2_ = [CMMTouchUtil pointFromTouch:pinchState.touch2];
	CGPoint diffPoint_ = ccpSub(touchPoint2_,touchPoint1_);
	float pinchDistance_ = ccpLength(diffPoint_);
	float pinchRadians_ = ccpToAngle(diffPoint_);
	
	if(isNew_){
		pinchState.firstDistance = pinchState.lastDistance = pinchDistance_;
		pinchState.firstRadians = pinchState.lastRadians = pinchRadians_;
		pinchState.lastScale = 1.0f;
	}else{
		pinchState.lastDistance = pinchState.distance;
		pinchState.lastRadians = pinchState.radians;
		pinchState.lastScale = pinchState.scale;
	}
	
	pinchState.scale = pinchDistance_/pinchState.firstDistance;
	pinchState.distance = pinchDistance_;
	pinchState.radians = pinchRadians_;
}

-(void)whenTouchesBeganFromScene:(NSSet *)touches_ event:(UIEvent *)event_{
	for(UITouch *touch_ in touches_){
		[self whenTouchBegan:touch_ event:event_];
	}
	
	if([touchList count] == 2){
		pinchState = CMMPinchStateMake(0.0f,0.0f);
		pinchState.touch1 = nil;
		pinchState.touch2 = nil;
		[self _updatePinchState];
		[self whenPinchBeganWithPinchState:pinchState];
	}
}
-(void)whenTouchesMovedFromScene:(NSSet *)touches_ event:(UIEvent *)event_{
	for(UITouch *touch_ in touches_){
		[self whenTouchMoved:touch_ event:event_];
	}
	
	if([touchList count] >= 2){
		[self _updatePinchState];
		[self whenPinchMovedWithPinchState:pinchState];
	}
}
-(void)whenTouchesEndedFromScene:(NSSet *)touches_ event:(UIEvent *)event_{
	if((pinchState.touch1 && [touches_ containsObject:pinchState.touch1])
	   || (pinchState.touch2 && [touches_ containsObject:pinchState.touch2])){
		[self whenPinchEndedWithPinchState:pinchState];
	}
	
	for(UITouch *touch_ in touches_){
		[self whenTouchEnded:touch_ event:event_];
	}
	[self _updatePinchState];
}
-(void)whenTouchesCancelledFromScene:(NSSet *)touches_ event:(UIEvent *)event_{
	if((pinchState.touch1 && [touches_ containsObject:pinchState.touch1])
	   || (pinchState.touch2 && [touches_ containsObject:pinchState.touch2])){
		[self whenPinchCancelledWithPinchState:pinchState];
	}
	
	for(UITouch *touch_ in touches_){
		[self whenTouchCancelled:touch_ event:event_];
	}
	[self _updatePinchState];
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

+(SEL)touchSelectorAtTouchSelectID:(CMMTouchSelectorID)touchSelectorID_{
	if(touchSelectorID_>= CMMTouchSelectorID_maxCount) return nil;
	return _sharedCMMTouchDispatcher_TouchSelectors_[touchSelectorID_];
}

@end