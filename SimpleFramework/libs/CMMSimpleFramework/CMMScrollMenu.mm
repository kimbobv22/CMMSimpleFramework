//  Created by JGroup(kimbobv22@gmail.com)
// 12.08.15

#import "CMMScrollMenu.h"

@implementation CMMScrollMenuDragItem
@synthesize targetIndex;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	targetIndex = -1;
	
	return self;
}

@end

@interface CMMScrollMenu(Private)

-(void)_removeObjectDirect:(CMMMenuItem *)menuItem_;
-(void)_updateInnerSize;
-(void)_moveDragViewItemToMenuItem:(CMMMenuItem *)menuItem_;
-(void)_clearDragViewItem;

@end

@implementation CMMScrollMenu(Private)

-(void)_removeObjectDirect:(CMMMenuItem *)menuItem_{
	[_innerLayer.touchDispatcher cancelTouchAtNode:menuItem_];
	[itemList removeObject:menuItem_];
	[menuItem_ removeFromParentAndCleanup:NO];
	[self _updateInnerSize];
	self.touchState = CMMTouchState_onScroll;
	
	int count_ = [self count];
	if(index>=count_)
		self.index = count_-1;
}
-(void)_updateInnerSize{
	CGSize frameSize_ = [self contentSize];
	CGSize innerSize_ = [self innerSize];
	
	float beforeHeight_ = innerSize_.height;
	float targetHeight_ = 0;
	
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;index_++){
		CMMMenuItem *menuItem_ = data_->arr[index_];
		targetHeight_ += menuItem_.contentSize.height+marginPerMenuItem;
	}
	targetHeight_-= marginPerMenuItem;
	targetHeight_ = MAX(targetHeight_, frameSize_.height);
	self.innerSize = CGSizeMake(frameSize_.width, targetHeight_);
	
	CGPoint targetPoint_ = ccpAdd(_innerLayer.position, ccp(0,beforeHeight_-targetHeight_));
	//targetPoint_.y = MIN(_innerLayer.position.y,-_innerLayer.contentSize.height+self.contentSize.height);
	_innerLayer.position = targetPoint_;
	for(uint index_=0;index_<count_;index_++){
		CMMMenuItem *menuItem_ = data_->arr[index_];
		menuItem_.position = ccpSub(menuItem_.position, ccp(0,beforeHeight_-targetHeight_));
	}
}
-(void)_moveDragViewItemToMenuItem:(CMMMenuItem *)menuItem_{
	[_dragMenuItemView runAction:[CCSequence actions:[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.2 position:[self convertToNodeSpace:[_innerLayer convertToWorldSpace:menuItem_.position]]] rate:3], [CCCallFunc actionWithTarget:self selector:@selector(_clearDragViewItem)], nil]];
}
-(void)_clearDragViewItem{
	_dragMenuItemView.opacity = 0;
}

@end

@implementation CMMScrollMenu
@synthesize index,count,itemList,delegate,marginPerMenuItem,isCanSelectMenuItem;

+(id)scrollMenuWithFrameSize:(CGSize)frameSize_ color:(ccColor4B)tcolor_{
	return [[[self alloc] initWithColor:tcolor_ width:frameSize_.width height:frameSize_.height] autorelease];
}
+(id)scrollMenuWithFrameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithColor:cmmVarCMMScrollMenu_defaultColor width:frameSize_.width height:frameSize_.height] autorelease];
}

+(id)scrollMenuWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	CMMScrollMenu *scrollMenu_ = [self scrollMenuWithFrameSize:frameSize_];

	CCSprite *frameSprite_ = [CCSprite spriteWithTexture:[[CMMDrawingManager sharedManager] textureFrameWithFrameSeq:frameSeq_ size:frameSize_ backGroundYN:NO]];
	frameSprite_.position = cmmFuncCommon_position_center(scrollMenu_, frameSprite_);
	[scrollMenu_ addChildDirect:frameSprite_];

	return scrollMenu_;
}

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	index = -1;
	itemList = [[CCArray alloc] init];
	delegate = nil;
	marginPerMenuItem = 1.0f;
	_beDragMenuItemDelayTime = 0.0f;
	isCanSelectMenuItem = YES;
	self.isCanDragY = YES;
	
	_dragMenuItemView = [CMMScrollMenuDragItem node];
	[self addChildDirect:_dragMenuItemView z:9];
	
	return self;
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	if(itemList) [self _updateInnerSize];
}

-(int)count{
	return itemList.count;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	
	//ordering menu item
	CGSize innerSize_ = [self innerSize];
	float totalMenuItemHeight_ = 0.0f;
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(int index_=0;index_<count_;index_++){
		CMMMenuItem *menuItem_ = data_->arr[index_];
		CGSize menuItemSize_ = menuItem_.contentSize;
		CGPoint targetPoint_ = ccp(innerSize_.width/2,innerSize_.height-(totalMenuItemHeight_+menuItemSize_.height/2));
		targetPoint_  = ccpAdd(menuItem_.position, ccpMult(ccpSub(targetPoint_,menuItem_.position), dt_*cmmVarCMMScrollMenu_defaultOrderingAccelRate));
		menuItem_.position = targetPoint_;
		totalMenuItemHeight_ += menuItemSize_.height+marginPerMenuItem;
	}
	
	switch(touchState){
		case CMMTouchState_onTouchChild:{
			if(!cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanDragMenuItem:))) return;
			
			CMMTouchDispatcher *innerTouchDispatcher_ = _innerLayer.touchDispatcher;
			CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher_ touchItemAtIndex:0];
			if(!touchItem_) break;
			
			CMMMenuItem *menuItem_ = (CMMMenuItem *)touchItem_.node;
			_beDragMenuItemDelayTime += dt_;
			
			if(_beDragMenuItemDelayTime >= cmmVarCMMScrollMenu_defaultDragMenuItemDelayTime){
				CCTexture2D *texture_ = [CMMDrawingUtil copyFromTexture:menuItem_];
				[_dragMenuItemView setTexture:texture_];
				CGRect textureRect_ = CGRectZero;
				textureRect_.size = texture_.contentSize;
				[_dragMenuItemView setTextureRect:textureRect_];
				_dragMenuItemView.targetIndex = [self indexOfMenuItem:menuItem_];
				_dragMenuItemView.visible = YES;
				_dragMenuItemView.opacity = 180;
				_dragMenuItemView.position = ccpSub([self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touchItem_.touch]], ccp(self.contentSize.width/4.0f,0));
				
				self.touchState = CMMTouchState_onDragChild;
			}
			break;
		}
		case CMMTouchState_onDragChild:{
			CMMTouchDispatcher *innerTouchDispatcher_ = _innerLayer.touchDispatcher;
			CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher_ touchItemAtIndex:0];
			
			CGSize frameSize_ = [self contentSize];
			CGSize innerSize_ = [self innerSize];
			CGPoint touchPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touchItem_.touch]];
			touchPoint_.x = 0;
			touchPoint_.y -= frameSize_.height/2.0f;
			touchPoint_.y = (touchPoint_.y/frameSize_.height) * 6.0f;
			touchPoint_ = ccpSub(_innerLayer.position, touchPoint_);
			
			if(touchPoint_.y>0)
				touchPoint_.y = 0;
			else if(touchPoint_.y<-(innerSize_.height-frameSize_.height))
				touchPoint_.y = -(innerSize_.height-frameSize_.height);
			
			_innerLayer.position = touchPoint_;
			
			break;
		}
		default: break;
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	if(!isCanSelectMenuItem)
		self.touchState = CMMTouchState_onDrag;
	else [super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	
	_firstTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
	
	CMMTouchDispatcherItem *touchItem_ = [_innerLayer.touchDispatcher touchItemAtTouch:touch_];
	if(touchItem_ && cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenPushdownWithMenuItem:)))
		[delegate scrollMenu:self whenPushdownWithMenuItem:(CMMMenuItem *)touchItem_.node];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	_beDragMenuItemDelayTime = 0;
	
	switch(touchState){
		case CMMTouchState_onTouchChild:{
			[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
			if(touchState == CMMTouchState_onDrag) break;
			if(!cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanDragMenuItem:))) break;
			
			CMMTouchDispatcher *innerTouchDispatcher_ = _innerLayer.touchDispatcher;
			CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher_ touchItemAtIndex:0];
			CGPoint touchPoint_ = [CMMTouchUtil pointFromTouch:touch_];
			
			if([delegate scrollMenu:self isCanDragMenuItem:(CMMMenuItem *)touchItem_.node]
			   && ABS(ccpSub(touchPoint_,_firstTouchPoint).x)>cmmVarCMMScrollMenu_defaultDragMenuItemDitance){
				_beDragMenuItemDelayTime = 1.0f;
			}
			
			break;
		}case CMMTouchState_onDragChild:{
			_dragMenuItemView.position = ccpSub([self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touch_]], ccp(self.contentSize.width/4.0f,0));
			break;
		}
		default:
			[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
			break;
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcher *innerTouchDispatcher_ = _innerLayer.touchDispatcher;
	CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher_ touchItemAtTouch:touch_];
	_beDragMenuItemDelayTime = 0;
	
	switch(touchState){
		case CMMTouchState_onTouchChild:{
			if(touchItem_ && cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenPushupWithMenuItem:)))
				[delegate scrollMenu:self whenPushupWithMenuItem:(CMMMenuItem *)touchItem_.node];
			
			CMMMenuItem *menuItem_ = (CMMMenuItem *)touchItem_.node;
			self.index = [self indexOfMenuItem:menuItem_];
			[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
			
			break;
		}
		case CMMTouchState_onDragChild:{
			CMMMenuItem *menuItem_ = (CMMMenuItem *)touchItem_.node;
			BOOL isRestoreDragMenuItemView_ = YES;
			CGPoint touchPoint_ = [CMMTouchUtil pointFromTouch:touch_];
			
			//handle link switch
			CMMLayer *parentLayer_ = (CMMLayer *)touchDispatcher_.target;
			CGPoint parentPoint_ = [parentLayer_ convertToNodeSpace:touchPoint_];
			if(!CGRectContainsPoint([self boundingBox], parentPoint_)){
				ccArray *pData_ = parentLayer_.children->data;
				int pCount_ = pData_->num;
				for(uint index_=0;index_<pCount_;index_++){
					CCNode *pChild_ = pData_->arr[index_];
					if(pChild_ == self) continue;
					if(CGRectContainsPoint([pChild_ boundingBox], parentPoint_)
					   && [pChild_ isKindOfClass:[CMMScrollMenu class]]){
						CMMScrollMenu *tScrolMenu_ = (CMMScrollMenu *)pChild_;
						int tIndex_ = [tScrolMenu_ indexOfPoint:touchPoint_];
						if(tIndex_ == NSNotFound)
							tIndex_ = [tScrolMenu_ count];
						
						isRestoreDragMenuItemView_ = ![self linkSwitchMenuItem:menuItem_ toScrolMenu:tScrolMenu_ toIndex:tIndex_];
					}
				}
			}
			
			//handle switch
			if(isRestoreDragMenuItemView_){
				int tIndex_ = [self indexOfPoint:touchPoint_];
				if(tIndex_ != NSNotFound)
					isRestoreDragMenuItemView_ = ![self switchMenuItem:menuItem_ toIndex:tIndex_];
			}
			
			if(isRestoreDragMenuItemView_)
				[self _moveDragViewItemToMenuItem:menuItem_];
			else [self _clearDragViewItem];
			
			[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
			
			break;
		}
		default:
			[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
			break;
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcher *innerTouchDispatcher_ = _innerLayer.touchDispatcher;
	CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher_ touchItemAtTouch:touch_];
	_beDragMenuItemDelayTime = 0;
	
	switch(touchState){
		case CMMTouchState_onDragChild:{
			CMMMenuItem *menuItem_ = (CMMMenuItem *)touchItem_.node;
			[self _moveDragViewItemToMenuItem:menuItem_];
			[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
			
			break;
		}
		case CMMTouchState_onTouchChild:{
			if(touchItem_ && cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenPushcancelWithMenuItem:)))
				[delegate scrollMenu:self whenPushcancelWithMenuItem:(CMMMenuItem *)touchItem_.node];
			
			[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
			break;
		}
		default:
			[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
			break;
	}
}

-(void)setIndex:(int)index_{
	if(index == index_) return;

	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanSelectAtIndex:)))
		if(![delegate scrollMenu:self isCanSelectAtIndex:index_]) return;
	
	index = index_;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenSelectedAtIndex:)))
		[delegate scrollMenu:self whenSelectedAtIndex:index];
}

-(void)dealloc{
	[itemList release];
	[super dealloc];
}

@end

@implementation CMMScrollMenu(Common)

-(void)addMenuItem:(CMMMenuItem *)menuItem_ atIndex:(int)index_{
	if([self indexOfMenuItem:menuItem_] != NSNotFound) return;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanAddMenuItem:atIndex:)))
		if(![delegate scrollMenu:self isCanAddMenuItem:menuItem_ atIndex:index_]) return;
	
	[itemList insertObject:menuItem_ atIndex:index_];
	[self _updateInnerSize];
	menuItem_.position = ccp(self.contentSize.width/2,_innerLayer.contentSize.height);
	[self addChild:menuItem_ z:cmmVarCMMScrollMenu_defaultChildZOrder];
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenAddedMenuItem:atIndex:)))
		[delegate scrollMenu:self whenAddedMenuItem:menuItem_ atIndex:index_];
}
-(void)addMenuItem:(CMMMenuItem *)menuItem_{
	[self addMenuItem:menuItem_ atIndex:[self count]];
}

-(void)removeMenuItem:(CMMMenuItem *)menuItem_{
	int targetIndex_ = [self indexOfMenuItem:menuItem_];
	if(targetIndex_ == NSNotFound) return;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanRemoveMenuItem:)))
		if(![delegate scrollMenu:self isCanRemoveMenuItem:menuItem_]) return;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenRemovedMenuItem:)))
		[delegate scrollMenu:self whenRemovedMenuItem:menuItem_];
	
	[self _removeObjectDirect:menuItem_];
}
-(void)removeMenuItemAtIndex:(int)index_{
	[self removeMenuItem:[self menuItemAtIndex:index_]];
}

-(CMMMenuItem *)menuItemAtIndex:(int)index_{
	if(index_ == NSNotFound || index_>=[self count]) return nil;
	return [itemList objectAtIndex:index_];
}
-(CMMMenuItem *)menuItemAtKey:(id)key_{
	return [self menuItemAtIndex:[self indexOfKey:key_]];
}

@end

@implementation CMMScrollMenu(Switch)

-(BOOL)switchMenuItem:(CMMMenuItem *)menuItem_ toIndex:(int)toIndex_{
	int targetIndex_ = [self indexOfMenuItem:menuItem_];
	if(targetIndex_ == NSNotFound) return NO;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanSwitchMenuItem:toIndex:))){
		if(![delegate scrollMenu:self isCanSwitchMenuItem:menuItem_ toIndex:toIndex_]) return NO;
	}else return NO; //must have delegate
	
	[itemList exchangeObjectAtIndex:targetIndex_ withObjectAtIndex:toIndex_];
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenSwitchedMenuItem:toIndex:)))
		[delegate scrollMenu:self whenSwitchedMenuItem:menuItem_ toIndex:toIndex_];
	
	return YES;
}
-(BOOL)switchMenuItemAtIndex:(int)index_ toIndex:(int)toIndex_{
	return [self switchMenuItem:[self menuItemAtIndex:index_] toIndex:toIndex_];
}

-(BOOL)linkSwitchMenuItem:(CMMMenuItem *)menuItem_ toScrolMenu:(CMMScrollMenu *)toScrolMenu_ toIndex:(int)toIndex_{
	if([self indexOfMenuItem:menuItem_] == NSNotFound || !toScrolMenu_) return NO;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanLinkSwitchMenuItem:toScrollMenu:toIndex:))){
		if(![delegate scrollMenu:self isCanLinkSwitchMenuItem:menuItem_ toScrollMenu:toScrolMenu_ toIndex:toIndex_]) return NO;
	}else return NO; //must have delegate
	
	menuItem_ = [[menuItem_ retain] autorelease];
	[self _removeObjectDirect:menuItem_]; // delete directly
	[toScrolMenu_ addMenuItem:menuItem_ atIndex:toIndex_];
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenLinkSwitchedMenuItem:toScrollMenu:toIndex:)))
		[delegate scrollMenu:self whenLinkSwitchedMenuItem:menuItem_ toScrollMenu:toScrolMenu_ toIndex:toIndex_];
	
	return YES;
}
-(BOOL)linkSwitchMenuItemAtIndex:(int)index_ toScrolMenu:(CMMScrollMenu *)toScrolMenu_ toIndex:(int)toIndex_{
	return [self linkSwitchMenuItem:[self menuItemAtIndex:index_] toScrolMenu:toScrolMenu_ toIndex:toIndex_];
}

@end

@implementation CMMScrollMenu(Search)

-(int)indexOfMenuItem:(CMMMenuItem *)menuItem_{
	return [itemList indexOfObject:menuItem_];
}
-(int)indexOfKey:(id)key_{
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;index_++){
		CMMMenuItem *tMenuItem_ = data_->arr[index_];
		if(tMenuItem_.key == key_)
			return index_;
	}
	
	
	return NSNotFound;
}
-(int)indexOfPoint:(CGPoint)worldPoint_{
	CGPoint convertPoint_ = [_innerLayer convertToNodeSpace:worldPoint_];
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;index_++){
		CMMMenuItem *menuItem_ = data_->arr[index_];
		if(CGRectContainsPoint([menuItem_ boundingBox], convertPoint_))
			return index_;
	}
	
	return NSNotFound;
}
-(int)indexOfTouch:(UITouch *)touch_{
	return [self indexOfPoint:[CMMTouchUtil pointFromTouch:touch_]];
}

@end
