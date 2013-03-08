//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenuV.h"
#import "CMMScene.h"

@implementation CMMScrollMenuVItemDragView
@synthesize targetIndex;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	targetIndex = -1;
	
	return self;
}

@end

@interface CMMScrollMenuV(Private)

-(void)_moveItemDragView:(CMMMenuItem *)item_;
-(void)_addItemDragView;
-(void)_clearItemDragView;

-(CGPoint)_offsetOfDraggedItemAtPoint:(CGPoint)targetPoint_ dt:(ccTime)dt_;

@end

@implementation CMMScrollMenuV(Private)

-(void)_moveItemDragView:(CMMMenuItem *)item_{
	if(action_itemDragViewCancelled){
		CGPoint targetPoint_ = [item_ position];
		CCFiniteTimeAction *targetAction_ = action_itemDragViewCancelled(_itemDragView,[innerLayer convertToWorldSpace:targetPoint_]);
		[_itemDragView runAction:[CCSequence actions:targetAction_,[CCCallBlock actionWithBlock:^{
			[self _clearItemDragView];
		}], nil]];
	}else{
		[self _clearItemDragView];
	}
}
-(void)_addItemDragView{
	if([_itemDragView parent]) return;
	[[[CMMScene sharedScene] frontLayer] addChild:_itemDragView];
}
-(void)_clearItemDragView{
	[_itemDragView removeFromParentAndCleanup:NO];
}

-(CGPoint)_offsetOfDraggedItemAtPoint:(CGPoint)targetPoint_ dt:(ccTime)dt_{
	CGPoint result_ = targetPoint_;
	
	if(filter_offsetOfDraggedItem){
		result_ = filter_offsetOfDraggedItem([_itemDragView position],targetPoint_,dt_);
	}
	
	return result_;
}

@end

static CCFiniteTimeAction *(^_staticCMMScrollMenuV_block_action_itemDragViewCancelled_)(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_) = ^CCFiniteTimeAction *(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_) {
	[itemDragView_ setOpacity:180];
	return [CCMoveTo actionWithDuration:0.2 position:targetPoint_];
};
static CGPoint(^_staticCMMScrollMenuV_block_filter_offsetOfDraggedItem)(CGPoint orginalPoint_ ,CGPoint targetPoint_, ccTime dt_) = ^CGPoint(CGPoint orginalPoint_ ,CGPoint targetPoint_, ccTime dt_) {
	return ccpSub(targetPoint_,ccp(-30.0f,0.0f));
};

@implementation CMMScrollMenuV
@synthesize dragStartDelayTime,dragStartDistance;
@synthesize filter_canDragItem,filter_offsetOfDraggedItem,action_itemDragViewCancelled;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	_curDragStartDelayTime = 0.0f;
	dragStartDelayTime = 1.0f;
	dragStartDistance = 30.0f;
	_itemDragView = [[CMMScrollMenuVItemDragView node] retain];
	[self setCanDragY:YES];
	
	if(_staticCMMScrollMenuV_block_filter_offsetOfDraggedItem){
		[self setFilter_offsetOfDraggedItem:_staticCMMScrollMenuV_block_filter_offsetOfDraggedItem];
	}
	
	if(_staticCMMScrollMenuV_block_action_itemDragViewCancelled_){
		[self setAction_itemDragViewCancelled:_staticCMMScrollMenuV_block_action_itemDragViewCancelled_];
	}
	
	return self;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];

	switch(touchState){
		case CMMTouchState_onTouchChild:{
			CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher touchItemAtIndex:0];
			if(!touchItem_) break;
			
			CMMMenuItem *item_ = (CMMMenuItem *)[touchItem_ node];
		
			if(!filter_canDragItem || !filter_canDragItem(item_)) break;
			
			_curDragStartDelayTime += dt_;
			
			if(_curDragStartDelayTime >= dragStartDelayTime){
				CCTexture2D *texture_ = [CMMDrawingUtil captureFromNode:item_];
				CGRect textureRect_ = CGRectZero;
				textureRect_.size = texture_.contentSize;
				
				[_itemDragView setTexture:texture_];
				[_itemDragView setTextureRect:textureRect_];
				[_itemDragView setTargetIndex:[self indexOfItem:item_]];
				[_itemDragView setPosition:[innerLayer convertToWorldSpace:[item_ position]]];
				
				[self setTouchState:CMMTouchState_onFixed];
				[self _addItemDragView];
			}
			break;
		}
		case CMMTouchState_onFixed:{
			CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher touchItemAtIndex:0];
			
			CGSize innerSize_ = [innerLayer contentSize];
			CGPoint touchPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touchItem_.touch]];
			touchPoint_.x = 0;
			touchPoint_.y -= _contentSize.height/2.0f;
			touchPoint_.y = (touchPoint_.y/_contentSize.height) * 6.0f;
			touchPoint_ = ccpSub([innerLayer position], touchPoint_);
			
			if(touchPoint_.y>0)
				touchPoint_.y = 0;
			else if(touchPoint_.y<-(innerSize_.height-_contentSize.height))
				touchPoint_.y = -(innerSize_.height-_contentSize.height);
			
			[innerLayer setPosition:touchPoint_];
			[_itemDragView setPosition:[self _offsetOfDraggedItemAtPoint:[CMMTouchUtil pointFromTouch:[touchItem_ touch]] dt:dt_]];
			
			break;
		}
		default: break;
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	_firstTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	_curDragStartDelayTime = 0.0f;
	
	switch(touchState){
		case CMMTouchState_onTouchChild:{
			CGPoint touchPoint_ = [CMMTouchUtil pointFromTouch:touch_];
			if(ABS(ccpSub(touchPoint_,_firstTouchPoint).x)>dragStartDistance)
				_curDragStartDelayTime = dragStartDelayTime;
			
			break;
		}
		default: break;
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	_curDragStartDelayTime = 0;
	
	switch(touchState){
		case CMMTouchState_onFixed:{
			
			CMMMenuItem *item_ = [self itemAtIndex:[_itemDragView targetIndex]];
			BOOL isRestoreDragItemView_ = YES;
			CGPoint touchPoint_ = [CMMTouchUtil pointFromTouch:touch_];
			
			//handle link switch
			CMMLayer *parentLayer_ = (CMMLayer *)touchDispatcher_.target;
			CGPoint parentPoint_ = [parentLayer_ convertToNodeSpace:touchPoint_];
			if(!CGRectContainsPoint([self boundingBox], parentPoint_)){
				ccArray *pData_ = parentLayer_.children->data;
				int pCount_ = pData_->num;
				for(uint index_=0;index_<pCount_;++index_){
					CCNode *pChild_ = pData_->arr[index_];
					if(pChild_ == self) continue;
					if(CGRectContainsPoint([pChild_ boundingBox], parentPoint_)
					   && [pChild_ isKindOfClass:[CMMScrollMenu class]]){
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
			
			if(!isRestoreDragItemView_) [self _clearItemDragView];
			
			[self touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
			
			break;
		}
		default:{
			[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
			break;
		}
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	_curDragStartDelayTime = 0;
	
	switch(touchState){
		case CMMTouchState_onFixed:{
			CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher touchItemAtTouch:touch_];
			CMMMenuItem *item_ = (CMMMenuItem *)[touchItem_ node];
			[self _moveItemDragView:item_];
			
			break;
		}
		default: break;
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
}

+(void)setDefaultFilter_offsetOfDraggedItem:(CGPoint (^)(CGPoint orginalPoint_, CGPoint targetPoint_,ccTime dt_))block_{
	[_staticCMMScrollMenuV_block_filter_offsetOfDraggedItem release];
	_staticCMMScrollMenuV_block_filter_offsetOfDraggedItem = [block_ copy];
}
+(void)setDefaultAction_itemDragViewCancelled:(CCFiniteTimeAction *(^)(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_))block_{
	[_staticCMMScrollMenuV_block_action_itemDragViewCancelled_ release];
	_staticCMMScrollMenuV_block_action_itemDragViewCancelled_ = [block_ copy];
}

-(void)cleanup{
	[self setFilter_canDragItem:nil];
	[self setFilter_offsetOfDraggedItem:nil];
	[self setAction_itemDragViewCancelled:nil];
	[_itemDragView removeFromParentAndCleanup:YES];
	[super cleanup];
}
-(void)dealloc{
	[filter_canDragItem release];
	[filter_offsetOfDraggedItem release];
	[action_itemDragViewCancelled release];
	[_itemDragView release];
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
		targetHeight_ += item_.contentSize.height+marginPerItem;
	}
	targetHeight_-= marginPerItem;
	targetHeight_ = MAX(targetHeight_, _contentSize.height);
	[innerLayer setContentSize:CGSizeMake(_contentSize.width, targetHeight_)];
	
	CGPoint targetPoint_ = ccpAdd([innerLayer position], ccp(0,beforeHeight_-targetHeight_));
	[innerLayer setPosition:targetPoint_];
	for(uint index_=0;index_<count_;++index_){
		CMMMenuItem *item_ = data_->arr[index_];
		item_.position = ccpSub(item_.position, ccp(0,beforeHeight_-targetHeight_));
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
		targetPoint_.y = innerSize_.height-(totalItemHeight_+itemSize_.height*(1.0f-item_.anchorPoint.y));
		targetPoint_ = ccpAdd(item_.position, ccpMult(ccpSub(targetPoint_,item_.position), dt_*cmmVarCMMScrollMenu_defaultOrderingAccelRate));
		item_.position = targetPoint_;
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