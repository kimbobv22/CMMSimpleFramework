//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenuV.h"
#import "CMMScene.h"

@implementation CMMScrollMenuVItemDragView{
	CMMMenuItem *_targetItem;
}
@synthesize targetItem = _targetItem;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	_targetItem = nil;
	
	return self;
}

-(void)setTargetItem:(CMMMenuItem *)targetItem_{
	_targetItem = targetItem_;
	if(_targetItem){
		CCTexture2D *texture_ = [CMMDrawingUtil captureFromNode:_targetItem];
		CGRect textureRect_ = CGRectZero;
		textureRect_.size = texture_.contentSize;
		
		[self setTexture:texture_];
		[self setTextureRect:textureRect_];
	}
}

@end

@interface CMMScrollMenuV(Private)

-(void)_appearItemDragViewWithItem:(CMMMenuItem *)item_;
-(void)_disappearItemDragViewWithItem:(CMMMenuItem *)item_;
-(void)_disappearItemDragView;

-(CGPoint)_offsetOfItemDragView:(CGPoint)targetPoint_ dt:(ccTime)dt_;

@end

static CMMScrollMenuVItemDragViewOffsetFilter _staticCMMScrollMenuV_block_filter_itemDragViewOffset = ^CGPoint(CGPoint orginalPoint_, CGPoint targetPoint_,ccTime dt_){
	return targetPoint_;
};
static CMMScrollMenuVItemDragViewCallback _staticCMMScrollMenuV_block_callback_itemDragViewAppeared_ = ^void(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_, void(^callback_)(void)){
	[itemDragView_ setPosition:targetPoint_];
	[itemDragView_ setOpacity:180];
	callback_();
};
static CMMScrollMenuVItemDragViewCallback _staticCMMScrollMenuV_block_callback_itemDragViewDisappeared_ = ^void(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_, void(^callback_)(void)){
	[itemDragView_ stopAllActions];
	[itemDragView_ setOpacity:180];
	[itemDragView_ runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.2 position:targetPoint_],[CCCallBlock actionWithBlock:^{
		callback_();
	}], nil]];
};

@implementation CMMScrollMenuV{
	CMMScrollMenuVItemDragView *_itemDragView;
	ccTime _curDragStartDelayTime;
	CGPoint _firstTouchPoint;
}
@synthesize dragStartDelayTime,dragStartDistance,switchMode,onDragItem;
@synthesize itemDragView = _itemDragView;
@synthesize filter_canDragItem,filter_itemDragViewOffset,callback_itemDragViewAppeared,callback_itemDragViewDisappeared;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	_curDragStartDelayTime = 0.0f;
	dragStartDelayTime = 1.0f;
	dragStartDistance = 30.0f;
	switchMode = CMMScrollMenuVSwitchMode_switch;
	
	//add front view
	_itemDragView = [CMMScrollMenuVItemDragView node];
	[[[CMMScene sharedScene] frontLayer] addChild:_itemDragView];
	[_itemDragView setVisible:NO];
	
	[self setCanDragY:YES];
	
	[self setFilter_itemDragViewOffset:_staticCMMScrollMenuV_block_filter_itemDragViewOffset];
	[self setCallback_itemDragViewAppeared:_staticCMMScrollMenuV_block_callback_itemDragViewAppeared_];
	[self setCallback_itemDragViewDisappeared:_staticCMMScrollMenuV_block_callback_itemDragViewDisappeared_];
	
	return self;
}
-(BOOL)isOnDragItem{
	return [_itemDragView visible] && [touchDispatcher touchCount] > 0;
}
-(void)update:(ccTime)dt_{
	[super update:dt_];
	
	CMMTouchDispatcherItem *touchItem_ = [[self innerTouchDispatcher] touchItemAtIndex:0];
	if(touchItem_){		
		CMMMenuItem *touchedItem_ = (CMMMenuItem *)[touchItem_ node];
		
		//when item drag
		if([self isOnDragItem]){
			CGPoint beforeInnerLayerPoint_ = [innerLayer position];
			CGSize innerSize_ = [innerLayer contentSize];
			CGPoint touchPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:[touchItem_ touch]]];
			touchPoint_.x = 0;
			touchPoint_.y -= _contentSize.height/2.0f;
			touchPoint_.y = (touchPoint_.y/_contentSize.height) * 6.0f;
			touchPoint_ = ccpSub([innerLayer position], touchPoint_);
			
			if(touchPoint_.y>0)
				touchPoint_.y = 0;
			else if(touchPoint_.y<-(innerSize_.height-_contentSize.height))
				touchPoint_.y = -(innerSize_.height-_contentSize.height);
			
			[self setInnerPosition:touchPoint_];
			CGPoint targetPoint_ = [CMMTouchUtil pointFromTouch:[touchItem_ touch]];
			
			switch(switchMode){
				case CMMScrollMenuVSwitchMode_move:{
					CGPoint innerCurPoint_ = [innerLayer convertToNodeSpace:targetPoint_];
					CGPoint innerBefPoint_ = [innerLayer convertToNodeSpace:[CMMTouchUtil prepointFromTouch:[touchItem_ touch]]];
					
					innerBefPoint_ = ccpSub(innerBefPoint_, ccpSub(beforeInnerLayerPoint_, touchPoint_));
					int targetIndex_ = [self indexOfItem:touchedItem_];
					
					float targetOperator_ = 1.0f;
					if(innerCurPoint_.y > innerBefPoint_.y){
						targetIndex_ = MAX(targetIndex_-1,0);
					}else if(innerCurPoint_.y < innerBefPoint_.y){
						targetIndex_ = MIN(targetIndex_+1,[self count]);
						targetOperator_ = -1.0f;
					}
					
					CMMMenuItem *targetItem_ = [self itemAtIndex:targetIndex_];
					if((innerCurPoint_.y - [targetItem_ position].y) * targetOperator_ > 0){
						[self moveItem:touchedItem_ toIndex:targetIndex_];
					}
					
					targetPoint_.x = [self convertToWorldSpace:ccp(_contentSize.width*0.5f,0.0f)].x;
					[_itemDragView setPosition:targetPoint_];
					break;
				}
				case CMMScrollMenuVSwitchMode_switch:
				default:{
					[_itemDragView setPosition:[self _offsetOfItemDragView:targetPoint_ dt:dt_]];
					
					break;
				}
			}
		}
		//when item touch
		else if(filter_canDragItem && filter_canDragItem(touchedItem_)){
			_curDragStartDelayTime += dt_;
			
			if(_curDragStartDelayTime >= dragStartDelayTime){
				[_itemDragView setTargetItem:touchedItem_];
				[self _appearItemDragViewWithItem:touchedItem_];
				
				switch(switchMode){
					case CMMScrollMenuVSwitchMode_move:{
						[touchedItem_ setVisible:NO];
						break;
					}
					case CMMScrollMenuVSwitchMode_switch:
					default:{break;}
				}
			}
		}
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	_firstTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	_curDragStartDelayTime = 0.0f;
	
	CMMTouchDispatcherItem *touchItem_ = [[self innerTouchDispatcher] touchItemAtIndex:0];
	if(touchItem_){
		if([self isOnDragItem]){
			switch(switchMode){
				case CMMScrollMenuVSwitchMode_move:{
					if(![CMMTouchUtil isNodeInTouch:self touch:touch_]){
						[self touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
					}
					
					break;
				}
				case CMMScrollMenuVSwitchMode_switch:
				default:{
					break;
				}
			}
			return;
		}else{
			CGPoint touchPoint_ = [CMMTouchUtil pointFromTouch:touch_];
			if(ABS(ccpSub(touchPoint_,_firstTouchPoint).x)>dragStartDistance)
				_curDragStartDelayTime = dragStartDelayTime;
		}
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	_curDragStartDelayTime = 0;
	
	CMMTouchDispatcherItem *touchItem_ = [[self innerTouchDispatcher] touchItemAtIndex:0];
	if(touchItem_){
		if([self isOnDragItem]){
			CMMMenuItem *item_ = [_itemDragView targetItem];
			BOOL isRestoreDragItemView_ = YES;
			CGPoint touchPoint_ = [CMMTouchUtil pointFromTouch:touch_];
			
			switch(switchMode){
				case CMMScrollMenuVSwitchMode_move:{
					[item_ setVisible:YES];
					isRestoreDragItemView_ = NO;
					break;
				}
				case CMMScrollMenuVSwitchMode_switch:
				default:{
					//handle link switch
					CMMLayer *parentLayer_ = (CMMLayer *)[touchDispatcher_ target];
					if(![CMMTouchUtil isNodeInPoint:self point:touchPoint_]){
						ccArray *pData_ = parentLayer_.children->data;
						int pCount_ = pData_->num;
						for(uint index_=0;index_<pCount_;++index_){
							CCNode *pChild_ = pData_->arr[index_];
							if(pChild_ == self) continue;
							if([CMMTouchUtil isNodeInPoint:pChild_ point:touchPoint_]
							   && [pChild_ isKindOfClass:[self class]]){
								CMMScrollMenu *tScrolMenu_ = (CMMScrollMenu *)pChild_;
								int tIndex_ = [tScrolMenu_ indexOfPoint:touchPoint_];
								if(tIndex_ == NSNotFound)
									tIndex_ = [tScrolMenu_ count];
								
								isRestoreDragItemView_ = ![self linkSwitchItem:item_ toScrolMenu:tScrolMenu_ toIndex:tIndex_];
							}
						}
					}
					//handle switch
					if(isRestoreDragItemView_){
						int tIndex_ = [self indexOfPoint:touchPoint_];
						if(tIndex_ != NSNotFound)
							isRestoreDragItemView_ = ![self switchItem:item_ toIndex:tIndex_];
					}
					
					break;
				}
			}
			
			[self touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
			if(!isRestoreDragItemView_) [self _disappearItemDragView];
			
			return;
		}
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	_curDragStartDelayTime = 0;
	
	if([self isOnDragItem]){
		CMMMenuItem *touchedItem_ = [_itemDragView targetItem];
		[self _disappearItemDragViewWithItem:touchedItem_];
		[touchedItem_ setVisible:YES];
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
}

+(void)setDefaultFilter_itemDragViewOffset:(CMMScrollMenuVItemDragViewOffsetFilter)block_{
	NSAssert(block_, nil);
	[_staticCMMScrollMenuV_block_filter_itemDragViewOffset release];
	_staticCMMScrollMenuV_block_filter_itemDragViewOffset = [block_ copy];
}
+(void)setDefaultCallback_itemDragViewAppeared:(CMMScrollMenuVItemDragViewCallback)block_{
	[_staticCMMScrollMenuV_block_callback_itemDragViewAppeared_ release];
	_staticCMMScrollMenuV_block_callback_itemDragViewAppeared_ = [block_ copy];
}
+(void)setDefaultCallback_itemDragViewDisappeared:(CMMScrollMenuVItemDragViewCallback)block_{
	[_staticCMMScrollMenuV_block_callback_itemDragViewDisappeared_ release];
	_staticCMMScrollMenuV_block_callback_itemDragViewDisappeared_ = [block_ copy];
}

-(void)cleanup{
	[self setFilter_canDragItem:nil];
	[self setFilter_itemDragViewOffset:nil];
	[self setCallback_itemDragViewAppeared:nil];
	[self setCallback_itemDragViewDisappeared:nil];
	[_itemDragView removeFromParentAndCleanup:YES];
	[super cleanup];
}
-(void)dealloc{
	[filter_canDragItem release];
	[filter_itemDragViewOffset release];
	[callback_itemDragViewAppeared release];
	[callback_itemDragViewDisappeared release];
	[super dealloc];
}

@end

@implementation CMMScrollMenuV(Display)

-(void)doUpdateInnerSize{
	CGSize innerSize_ = [innerLayer contentSize];
	
	float beforeHeight_ = innerSize_.height;
	float targetHeight_ = 0;
	
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMMenuItem *item_ = data_->arr[index_];
		targetHeight_ += [item_ contentSize].height+marginPerItem;
	}
	targetHeight_-= marginPerItem;
	targetHeight_ = MAX(targetHeight_, _contentSize.height);
	[innerLayer setContentSize:CGSizeMake(_contentSize.width, targetHeight_)];
	
	CGPoint targetPoint_ = ccpAdd([innerLayer position], ccp(0,beforeHeight_-targetHeight_));
	[innerLayer setPosition:targetPoint_];
	[self setInnerPosition:targetPoint_];
	for(uint index_=0;index_<count_;++index_){
		CMMMenuItem *item_ = data_->arr[index_];
		[item_ setPosition:ccpSub([item_ position], ccp(0,beforeHeight_-targetHeight_))];
	}
}
-(void)updateMenuArrangeWithInterval:(ccTime)dt_{
	CGSize innerSize_ = [innerLayer contentSize];
	float totalItemHeight_ = 0;
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(int index_=0;index_<count_;++index_){
		CMMMenuItem *item_ = data_->arr[index_];
		CGSize itemSize_ = [item_ contentSize];
		CGPoint targetPoint_ = cmmFunc_positionIPN(self, item_);
		CGPoint itemPoint_ = [item_ position];
		CGPoint itemAnchorPoint_ = [item_ anchorPoint];
		targetPoint_.y = innerSize_.height-(totalItemHeight_+itemSize_.height*(1.0f-itemAnchorPoint_.y));
		CGPoint addPoint_ = ccpMult(ccpSub(targetPoint_,itemPoint_), dt_*cmmVarCMMScrollMenu_defaultOrderingAccelRate);
		targetPoint_ = ccpAdd(itemPoint_, addPoint_);
		[item_ setPosition:targetPoint_];
		totalItemHeight_ += itemSize_.height+marginPerItem;
	}
}

@end

@implementation CMMScrollMenuV(Common)

-(void)addItem:(CMMMenuItem *)item_ atIndex:(int)index_{
	NSAssert([item_ isKindOfClass:[CMMSprite class]], @"CMMScrolMenuH only support CMMSprite as children.");
	[super addItem:item_ atIndex:index_];
	
	CGPoint targetPoint_ = cmmFunc_positionIPN(self, item_);
	targetPoint_.y = [innerLayer contentSize].height;
	CMMMenuItem *preItem_ = [self itemAtIndex:index_-1];
	if(preItem_) targetPoint_.y = preItem_.position.y-preItem_.contentSize.height;
	item_.position = targetPoint_;
}

@end

@implementation CMMScrollMenuV(Private)

-(void)_appearItemDragViewWithItem:(CMMMenuItem *)item_{
	[_itemDragView setVisible:YES];
	CGPoint targetPoint_ = [[_itemDragView parent] convertToNodeSpace:[innerLayer convertToWorldSpace:[item_ position]]];
	callback_itemDragViewAppeared(_itemDragView,targetPoint_,^void(void){
		[_itemDragView setVisible:YES];
	});
}
-(void)_disappearItemDragViewWithItem:(CMMMenuItem *)item_{
	if(item_){
		CGPoint targetPoint_ = [[_itemDragView parent] convertToNodeSpace:[innerLayer convertToWorldSpace:[item_ position]]];
		callback_itemDragViewDisappeared(_itemDragView,targetPoint_,^void(void){
			[_itemDragView setVisible:NO];
		});
	}else{
		[_itemDragView setVisible:NO];
	}
	
	[_itemDragView setTargetItem:nil];
}
-(void)_disappearItemDragView{
	[self _disappearItemDragViewWithItem:nil];
}

-(CGPoint)_offsetOfItemDragView:(CGPoint)targetPoint_ dt:(ccTime)dt_{
	CGPoint result_ = targetPoint_;
	
	if(filter_itemDragViewOffset){
		result_ = filter_itemDragViewOffset([_itemDragView position],targetPoint_,dt_);
	}
	
	return result_;
}

@end