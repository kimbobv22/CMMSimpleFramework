//  Created by JGroup(kimbobv22@gmail.com)
// 12.08.15

#import "CMMScrollMenu.h"

@interface CMMScrollMenu(Private)

-(void)_removeItemDirect:(CCNode *)item_;

@end

@implementation CMMScrollMenu(Private)

-(void)_removeItemDirect:(CCNode *)item_{
	[innerTouchDispatcher cancelTouchAtNode:(id<CMMTouchDispatcherDelegate>)item_];
	[itemList removeObject:item_];
	[item_ removeFromParentAndCleanup:NO];
	[self doUpdateInnerSize];
	[self setTouchState:CMMTouchState_onScroll];
	
	int count_ = [self count];
	if(index>=count_)
		[self setIndex:count_-1];
}

@end

@implementation CMMScrollMenu
@synthesize index,count,itemList,delegate,marginPerItem,isCanSelectItem;

+(id)scrollMenuWithFrameSize:(CGSize)frameSize_ color:(ccColor4B)tcolor_{
	return [[[self alloc] initWithColor:tcolor_ width:frameSize_.width height:frameSize_.height] autorelease];
}
+(id)scrollMenuWithFrameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithColor:cmmVarCMMScrollMenu_defaultColor width:frameSize_.width height:frameSize_.height] autorelease];
}

+(id)scrollMenuWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_{
	CMMScrollMenu *scrollMenu_ = [self scrollMenuWithFrameSize:frameSize_];
	
	CCSprite *frameSprite_ = [CCSprite spriteWithTexture:[[CMMDrawingManager sharedManager] textureBatchBarWithFrameSeq:frameSeq_ batchBarSeq:batchBarSeq_ size:frameSize_]];
	[scrollMenu_ addChild:frameSprite_];
	frameSprite_.position = cmmFuncCommon_positionInParent(scrollMenu_, frameSprite_);
	CMMLayerMDScrollbar scrollBar_ = CMMLayerMDScrollbar();
	scrollBar_.distanceX = scrollBar_.distanceY = 6.0f;
	[scrollMenu_ setScrollbar:scrollBar_];
	
	return scrollMenu_;
}

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	index = -1;
	itemList = [[CCArray alloc] init];
	delegate = nil;
	marginPerItem = 1.0f;
	isCanSelectItem = YES;
	
	return self;
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	if(itemList) [self doUpdateInnerSize];
}

-(int)count{
	return itemList.count;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	//arragne item
	[self updateMenuArrangeWithInterval:dt_];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	if(!isCanSelectItem || touchState == CMMTouchState_onScroll){
		[self setTouchState:CMMTouchState_onDrag];
		return;
	}

	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	
	CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher touchItemAtTouch:touch_];
	if(touchItem_ && cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenPushdownWithItem:)))
		[delegate scrollMenu:self whenPushdownWithItem:(CMMMenuItem *)[touchItem_ node]];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher touchItemAtTouch:touch_];
	
	switch(touchState){
		case CMMTouchState_onTouchChild:{
			if(touchItem_ && cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenPushupWithItem:)))
				[delegate scrollMenu:self whenPushupWithItem:(CMMMenuItem *)[touchItem_ node]];
			
			CMMMenuItem *item_ = (CMMMenuItem *)[touchItem_ node];
			[self setIndex:[self indexOfItem:item_]];
			
			break;
		}
		default: break;
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	switch(touchState){
		case CMMTouchState_onTouchChild:{
			CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher touchItemAtTouch:touch_];
			if(touchItem_ && cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenPushcancelWithItem:)))
				[delegate scrollMenu:self whenPushcancelWithItem:(CMMMenuItem *)[touchItem_ node]];
			
			break;
		}
		default: break;
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
}

-(void)setIndex:(int)index_{
	if(index == index_) return;

	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanSelectAtIndex:)))
		if(![delegate scrollMenu:self isCanSelectAtIndex:index_]) return;
	
	index = index_;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenSelectedAtIndex:)))
		[delegate scrollMenu:self whenSelectedAtIndex:index];
}

-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len{
	return [itemList countByEnumeratingWithState:state objects:stackbuf count:len];
}

-(void)dealloc{
	[itemList release];
	[super dealloc];
}

@end

@implementation CMMScrollMenu(Display)

-(void)doUpdateInnerSize{}
-(void)updateMenuArrangeWithInterval:(ccTime)dt_{}

@end

@implementation CMMScrollMenu(Common)

-(void)addItem:(CMMMenuItem *)item_ atIndex:(int)index_{
	if([self indexOfItem:item_] != NSNotFound) return;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanAddItem:atIndex:)))
		if(![delegate scrollMenu:self isCanAddItem:item_ atIndex:index_]) return;
	
	[itemList insertObject:item_ atIndex:index_];
	[self doUpdateInnerSize];
	[innerLayer addChild:item_ z:cmmVarCMMScrollMenu_defaultChildZOrder];
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenAddedItem:atIndex:)))
		[delegate scrollMenu:self whenAddedItem:item_ atIndex:index_];
}
-(void)addItem:(CMMMenuItem *)item_{
	[self addItem:item_ atIndex:[self count]];
}

-(void)removeItem:(CMMMenuItem *)item_{
	int targetIndex_ = [self indexOfItem:item_];
	if(targetIndex_ == NSNotFound) return;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanRemoveItem:)))
		if(![delegate scrollMenu:self isCanRemoveItem:item_]) return;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenRemovedItem:)))
		[delegate scrollMenu:self whenRemovedItem:item_];
	
	[self _removeItemDirect:item_];
}
-(void)removeItemAtIndex:(int)index_{
	[self removeItem:[self itemAtIndex:index_]];
}
-(void)removeAllItems{
	ccArray *data_ = itemList->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMMenuItem *item_ = data_->arr[index_];
		[self removeItem:item_];
	}
}

-(CMMMenuItem *)itemAtIndex:(int)index_{
	if(index_ < 0 || index_>=[self count] || index_ == NSNotFound) return nil;
	return [itemList objectAtIndex:index_];
}

@end

@implementation CMMScrollMenu(Switch)

-(BOOL)switchItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_{
	int targetIndex_ = [self indexOfItem:item_];
	if(targetIndex_ == NSNotFound || targetIndex_ == toIndex_) return NO;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanSwitchItem:toIndex:))){
		if(![delegate scrollMenu:self isCanSwitchItem:item_ toIndex:toIndex_]) return NO;
	}else return NO; //must have delegate
	
	[itemList exchangeObjectAtIndex:targetIndex_ withObjectAtIndex:toIndex_];
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenSwitchedItem:toIndex:)))
		[delegate scrollMenu:self whenSwitchedItem:item_ toIndex:toIndex_];
	
	return YES;
}
-(BOOL)switchItemAtIndex:(int)index_ toIndex:(int)toIndex_{
	return [self switchItem:[self itemAtIndex:index_] toIndex:toIndex_];
}

-(BOOL)linkSwitchItem:(CMMMenuItem *)item_ toScrolMenu:(CMMScrollMenu *)toScrolMenu_ toIndex:(int)toIndex_{
	if([self indexOfItem:item_] == NSNotFound || !toScrolMenu_) return NO;
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanLinkSwitchItem:toScrollMenu:toIndex:))){
		if(![delegate scrollMenu:self isCanLinkSwitchItem:item_ toScrollMenu:toScrolMenu_ toIndex:toIndex_]) return NO;
	}else return NO; //must have delegate
	
	item_ = [[item_ retain] autorelease];
	[self _removeItemDirect:item_]; // delete directly
	[toScrolMenu_ addItem:item_ atIndex:toIndex_];
	
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:whenLinkSwitchedItem:toScrollMenu:toIndex:)))
		[delegate scrollMenu:self whenLinkSwitchedItem:item_ toScrollMenu:toScrolMenu_ toIndex:toIndex_];
	
	return YES;
}
-(BOOL)linkSwitchItemAtIndex:(int)index_ toScrolMenu:(CMMScrollMenu *)toScrolMenu_ toIndex:(int)toIndex_{
	return [self linkSwitchItem:[self itemAtIndex:index_] toScrolMenu:toScrolMenu_ toIndex:toIndex_];
}

@end

@implementation CMMScrollMenu(Search)

-(int)indexOfItem:(CMMMenuItem *)item_{
	return [itemList indexOfObject:item_];
}
-(int)indexOfPoint:(CGPoint)worldPoint_{
	CGPoint convertPoint_ = [innerLayer convertToNodeSpace:worldPoint_];
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMMenuItem *item_ = data_->arr[index_];
		if(CGRectContainsPoint([item_ boundingBox], convertPoint_))
			return index_;
	}
	
	return NSNotFound;
}
-(int)indexOfTouch:(UITouch *)touch_{
	return [self indexOfPoint:[CMMTouchUtil pointFromTouch:touch_]];
}

@end
