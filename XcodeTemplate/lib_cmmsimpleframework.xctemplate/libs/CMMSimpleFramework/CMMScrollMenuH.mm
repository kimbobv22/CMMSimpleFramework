//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenuH.h"

@implementation CMMScrollMenuHItem

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	[self setTouchCancelDistance:30.0f];
	[self initializeTouchDispatcher];
	[self setPushUpAction:nil];
	[self setPushDownAction:nil];
	
	return self;
}

-(CMMTouchCancelMode)touchCancelMode{
	return ([touchDispatcher touchCount] > 0 ? [super touchCancelMode] : CMMTouchCancelMode_move);
}

@end

@implementation CMMScrollMenuH{
	BOOL _onSnapping;
}
@synthesize snapAtItem,targetScrollSpeedToPass;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	marginPerItem = 5.0f;
	snapAtItem = YES;
	targetScrollSpeedToPass = 100.0f;
	_onSnapping = NO;
	[super setCanDragX:YES];
	
	return self;
}

-(void)setIndex:(int)index_{
	if(index == index_) return;
	[super setIndex:index_];
	_onSnapping = YES;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	
	if(!_onSnapping){
		CGPoint centerPoint_ = [self convertToWorldSpace:ccp(_contentSize.width*0.5f,_contentSize.height*0.5f)];
		int newIndex_ = [self indexOfPoint:centerPoint_ margin:marginPerItem];
		
		if(snapAtItem && targetScrollSpeedToPass <= ABS([self currentScrollSpeedX]) && newIndex_ == index){
			newIndex_ = MAX(0,MIN(([self currentScrollSpeedX] > 0.0f ? newIndex_-1 : newIndex_+1),[self count]-1));
			[self setCurrentScrollSpeedX:0.0f];
		}
		
		if(newIndex_ != NSNotFound){
			[self setIndex:newIndex_];
		}
	}
	
	if(snapAtItem && _onSnapping
	   && index >= 0 && index != NSNotFound
	   && [self count] > 0
	   && [touchDispatcher touchCount] == 0){
		CMMMenuItem *targetItem_ = [self itemAtIndex:index];
		CGSize itemSize_ = [targetItem_ contentSize];
		CGPoint itemPoint_ = [targetItem_ position];
		CGPoint itemAnchorPoint_ = [targetItem_ anchorPoint];
		
		itemPoint_.x += itemSize_.width*(0.5f-itemAnchorPoint_.x);
		itemPoint_.y += itemSize_.height*(0.5f-itemAnchorPoint_.y);
		itemPoint_ = [innerLayer convertToWorldSpace:itemPoint_];
		CGPoint centerPoint_ = [self convertToWorldSpace:ccp(_contentSize.width*0.5f,_contentSize.height*0.5f)];
		CGPoint diffPoint_ = ccpSub(itemPoint_,centerPoint_);
		CGPoint addPoint_ = ccp((diffPoint_.x*scrollSpeed)*dt_,0.0f);
		
		if(ABS(addPoint_.x) < 0.1f){
			addPoint_ = diffPoint_;
		}
		
		CGPoint originalPoint_ = [innerLayer position];
		CGPoint targetPoint_ = ccpSub(originalPoint_,addPoint_);
		if(ccpDistance(targetPoint_, originalPoint_) > 0.1f){
			[self setInnerPosition:targetPoint_];
		}else{
			_onSnapping = NO;
		}
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	_onSnapping = NO;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	_onSnapping = snapAtItem;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	_onSnapping = snapAtItem;
}

@end

@implementation CMMScrollMenuH(Display)

-(void)doUpdateInnerSize{
	float targetWidth_ = marginPerItem*2.0f;
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CCNode *item_ = data_->arr[index_];
		targetWidth_ += item_.contentSize.width+marginPerItem;
	}
	targetWidth_-= marginPerItem;
	targetWidth_ = MAX(targetWidth_, _contentSize.width);
	[innerLayer setContentSize:CGSizeMake(targetWidth_,_contentSize.height)];
}
-(void)updateMenuArrangeWithInterval:(ccTime)dt_{
	float totalItemWidth_ = marginPerItem;
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(int index_=0;index_<count_;++index_){
		CMMMenuItem *item_ = data_->arr[index_];
		CGSize itemSize_ = item_.contentSize;
		CGPoint targetPoint_ = cmmFunc_positionIPN(self, item_);
		targetPoint_.x = totalItemWidth_+itemSize_.width*(item_.anchorPoint.x);
		targetPoint_ = ccpAdd(item_.position, ccpMult(ccpSub(targetPoint_,item_.position), dt_*cmmVarCMMScrollMenu_defaultOrderingAccelRate));
		[item_ setPosition:targetPoint_];
		totalItemWidth_ += itemSize_.width+marginPerItem;
	}
}

@end

@implementation CMMScrollMenuH(Common)

-(void)addItem:(CMMMenuItem *)item_ atIndex:(int)index_{
	[super addItem:item_ atIndex:index_];
	
	CGPoint targetPoint_ = cmmFunc_positionIPN(self, item_);
	targetPoint_.x = marginPerItem;
	CMMMenuItem *preItem_ = [self itemAtIndex:index_-1];
	if(preItem_) targetPoint_.x = preItem_.position.x+preItem_.contentSize.width+marginPerItem;
	[item_ setPosition:targetPoint_];
}

@end