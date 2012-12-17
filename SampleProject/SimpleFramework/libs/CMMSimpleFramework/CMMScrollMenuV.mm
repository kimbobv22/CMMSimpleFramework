//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenuV.h"

@interface CMMScrollMenuV(Private)

-(void)_moveDragViewItemTo:(CCNode *)item_;
-(void)_clearDragViewItem;

@end

@implementation CMMScrollMenuV(Private)

-(void)_moveDragViewItemTo:(CCNode *)item_{
	[_dragItemView runAction:[CCSequence actions:[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.2 position:[self convertToNodeSpace:[innerLayer convertToWorldSpace:item_.position]]] rate:3], [CCCallFunc actionWithTarget:self selector:@selector(_clearDragViewItem)], nil]];
}
-(void)_clearDragViewItem{
	_dragItemView.opacity = 0;
}

@end

@implementation CMMScrollMenuDragItem
@synthesize targetIndex;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	targetIndex = -1;
	
	return self;
}

@end

@implementation CMMScrollMenuV
@synthesize dragStartDelayTime,dragStartDistance;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	_curDragStartDelayTime = 0.0f;
	dragStartDelayTime = 1.0f;
	dragStartDistance = 30.0f;
	_dragItemView = [CMMScrollMenuDragItem node];
	[self addChild:_dragItemView z:9];
	[self setCanDragY:YES];
	
	return self;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];

	switch(touchState){
		case CMMTouchState_onTouchChild:{
			CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher touchItemAtIndex:0];
			if(!touchItem_) break;
			
			CMMMenuItem *item_ = (CMMMenuItem *)[touchItem_ node];
			
			if(!cmmFuncCommon_respondsToSelector(delegate, @selector(scrollMenu:isCanDragItem:))
			   || ![((id<CMMScrollMenuVDelegate>)delegate) scrollMenu:self isCanDragItem:item_]) break;
			
			_curDragStartDelayTime += dt_;
			
			if(_curDragStartDelayTime >= dragStartDelayTime){
				CCTexture2D *texture_ = [CMMDrawingUtil captureFromNode:item_];
				CGRect textureRect_ = CGRectZero;
				textureRect_.size = texture_.contentSize;
				
				[_dragItemView setTexture:texture_];
				[_dragItemView setTextureRect:textureRect_];
				_dragItemView.targetIndex = [self indexOfItem:item_];
				_dragItemView.visible = YES;
				_dragItemView.opacity = 180;
				_dragItemView.position = ccpSub([self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touchItem_.touch]], ccp(self.contentSize.width/4.0f,0));
				
				[self setTouchState:CMMTouchState_onFixed];
			}
			break;
		}
		case CMMTouchState_onFixed:{
			CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher touchItemAtIndex:0];
			
			CGSize innerSize_ = [innerLayer contentSize];
			CGPoint touchPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touchItem_.touch]];
			touchPoint_.x = 0;
			touchPoint_.y -= contentSize_.height/2.0f;
			touchPoint_.y = (touchPoint_.y/contentSize_.height) * 6.0f;
			touchPoint_ = ccpSub([innerLayer position], touchPoint_);
			
			if(touchPoint_.y>0)
				touchPoint_.y = 0;
			else if(touchPoint_.y<-(innerSize_.height-contentSize_.height))
				touchPoint_.y = -(innerSize_.height-contentSize_.height);
			
			[innerLayer setPosition:touchPoint_];
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
		}case CMMTouchState_onFixed:{
			_dragItemView.position = ccpSub([self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touch_]], ccp(self.contentSize.width/4.0f,0));
			break;
		}
		default:
			break;
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	_curDragStartDelayTime = 0;
	
	switch(touchState){
		case CMMTouchState_onFixed:{
			CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher touchItemAtTouch:touch_];
			CMMMenuItem *item_ = (CMMMenuItem *)[touchItem_ node];
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
			
			if(isRestoreDragItemView_)
				[self _moveDragViewItemTo:item_];
			else [self _clearDragViewItem];
			
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
			[self _moveDragViewItemTo:item_];
			
			break;
		}
		default: break;
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
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
	targetHeight_ = MAX(targetHeight_, contentSize_.height);
	[innerLayer setContentSize:CGSizeMake(contentSize_.width, targetHeight_)];
	
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
		CGPoint targetPoint_ = cmmFuncCommon_positionInParent(self, item_);
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
	
	CGPoint targetPoint_ = cmmFuncCommon_positionInParent(self, item_);
	targetPoint_.y = [innerLayer contentSize].height;
	CMMMenuItem *preItem_ = [self itemAtIndex:index_-1];
	if(preItem_) targetPoint_.y = preItem_.position.y-preItem_.contentSize.height;
	item_.position = targetPoint_;
}

@end