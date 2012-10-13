//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenuH.h"

@implementation CMMScrollMenuHItem

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	touchCancelDistance = 30.0f;
	_firstTouchPoint = CGPointZero;
	
	return self;
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	_firstTouchPoint = [CMMTouchUtil pointFromTouch:touch_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];

	if([touchDispatcher touchCount] <=0 && ccpDistance([CMMTouchUtil pointFromTouch:touch_], _firstTouchPoint)>touchCancelDistance)
		if(touchDispatcher_)
			[touchDispatcher_ cancelTouchAtTouch:touch_];
}

@end

@implementation CMMScrollMenuH
@synthesize fouceItemScale,nonefouceItemScale,minScrollAccelToSnap,isSnapAtItem;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	marginPerItem = 5.0f;
	isSnapAtItem = YES;
	fouceItemScale = nonefouceItemScale = 1.0f;
	minScrollAccelToSnap = 10.0f;
	[super setIsCanDragX:YES];
	
	return self;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	
	switch(touchState){
		case CMMTouchState_none:{
			if(!isSnapAtItem) break;
			CMMMenuItem *item_ = [self itemAtIndex:index];
			if(!item_) break;
			
			CGSize itemSize_ = item_.contentSize;
			CGPoint itemPoint_ = item_.position;
			itemPoint_.x += itemSize_.width*(0.5f-item_.anchorPoint.x);
			itemPoint_.y += itemSize_.height*(0.5f-item_.anchorPoint.y);
			itemPoint_ = [_innerLayer convertToWorldSpace:itemPoint_];
			CGPoint centerPoint_ = [self convertToWorldSpace:ccp(contentSize_.width/2.0f,contentSize_.height/2.0f)];
			CGPoint diffPoint_ = ccpSub(itemPoint_,centerPoint_);
			diffPoint_ = ccpMult(diffPoint_, dt_*dragAccelRate);
			
			CGPoint orgPoint_ = [self innerPosition];
			CGPoint targetPoint_ = ccpSub(orgPoint_,diffPoint_);
			targetPoint_.y = orgPoint_.y;
			
			[self setInnerPosition:targetPoint_];
			
			break;
		}
		case CMMTouchState_onScroll:{
			if(!isSnapAtItem || minScrollAccelToSnap < ABS(_scrollAccelX) || [self count] <= 0) break;
			
			self.touchState = CMMTouchState_none;
			int minIndex_ = -1;
			float minDistance_ = contentSize_.width;
			CGPoint centerPoint_ = [self convertToWorldSpace:ccp(contentSize_.width/2.0f,contentSize_.height/2.0f)];
			ccArray *data_ = itemList->data;
			int count_ = data_->num;
			for(uint index_=0;index_<count_;++index_){
				CMMMenuItem *item_ = data_->arr[index_];
				CGSize itemSize_ = item_.contentSize;
				CGPoint targetPoint_ = item_.position;
				targetPoint_.x += itemSize_.width*(0.5f-item_.anchorPoint.x);
				targetPoint_.y += itemSize_.height*(0.5f-item_.anchorPoint.y);
				targetPoint_ = [_innerLayer convertToWorldSpace:targetPoint_];
				float targetDistance_ = ccpDistance(centerPoint_, targetPoint_);
				
				if(minDistance_>targetDistance_){
					minIndex_ = index_;
					minDistance_ = targetDistance_;
				}
			}
			
			if(minIndex_ >= 0)
				[self setIndex:minIndex_];
			
			break;
		}
		default: break;
	}
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
	targetWidth_ = MAX(targetWidth_, contentSize_.width);
	self.innerSize = CGSizeMake(targetWidth_,contentSize_.height);
}
-(void)updateMenuArrangeWithInterval:(ccTime)dt_{
	float totalItemWidth_ = marginPerItem;
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(int index_=0;index_<count_;++index_){
		CMMMenuItem *item_ = data_->arr[index_];
		CGSize itemSize_ = item_.contentSize;
		CGPoint targetPoint_ = cmmFuncCommon_position_center(self, item_);
		targetPoint_.x = totalItemWidth_+itemSize_.width*(item_.anchorPoint.x);
		targetPoint_ = ccpAdd(item_.position, ccpMult(ccpSub(targetPoint_,item_.position), dt_*cmmVarCMMScrollMenu_defaultOrderingAccelRate));
		item_.position = targetPoint_;
		totalItemWidth_ += itemSize_.width+marginPerItem;
	}
}

@end

@implementation CMMScrollMenuH(Common)

-(void)addItem:(CMMMenuItem *)item_ atIndex:(int)index_{
	//NSAssert([item_ isKindOfClass:[CMMScrollMenuHItem class]], @"CMMScrolMenuV only support CMMScrolMenuVItem as children.");
	[super addItem:item_ atIndex:index_];
	
	CGPoint targetPoint_ = cmmFuncCommon_position_center(self, item_);
	targetPoint_.x = marginPerItem;
	CMMMenuItem *preItem_ = [self itemAtIndex:index_-1];
	if(preItem_) targetPoint_.x = preItem_.position.x+preItem_.contentSize.width+marginPerItem;
	item_.position = targetPoint_;
}

@end