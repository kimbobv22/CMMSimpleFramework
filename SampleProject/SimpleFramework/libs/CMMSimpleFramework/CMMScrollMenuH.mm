//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScrollMenuH.h"

@implementation CMMScrollMenuHItem

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	touchCancelDistance = 30.0f;
	_firstTouchPoint = CGPointZero;
	
	[self initializeTouchDispatcher];
	
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
	[super setCanDragX:YES];
	
	return self;
}

-(void)setIndex:(int)index_{
	[super setIndex:index_];
	_isOnSnap = YES && isSnapAtItem;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	
	switch(touchState){
		case CMMTouchState_none:{
			if(!_isOnSnap) break;
			CMMMenuItem *item_ = [self itemAtIndex:index];
			if(!item_) break;
			
			CGSize itemSize_ = [item_ contentSize];
			CGPoint itemPoint_ = [item_ position];
			CGPoint itemAnchorPoint_ = [item_ anchorPoint];
			
			itemPoint_.x += itemSize_.width*(0.5f-itemAnchorPoint_.x);
			itemPoint_.y += itemSize_.height*(0.5f-itemAnchorPoint_.y);
			itemPoint_ = [innerLayer convertToWorldSpace:itemPoint_];
			CGPoint centerPoint_ = [self convertToWorldSpace:ccp(contentSize_.width/2.0f,contentSize_.height/2.0f)];
			CGPoint diffPoint_ = ccpSub(itemPoint_,centerPoint_);
			
			diffPoint_ = ccpMult(diffPoint_, dt_*dragSpeed);
			
			CGPoint orgPoint_ = [innerLayer position];
			CGPoint targetPoint_ = ccpSub(orgPoint_,diffPoint_);
			targetPoint_.y = orgPoint_.y;
			
			if(ccpDistance(targetPoint_, [innerLayer position]) > 0.1f){
				[innerLayer setPosition:targetPoint_];
			}else{
				_isOnSnap = NO;
			}
			
			break;
		}
		case CMMTouchState_onScroll:{
			if(!isSnapAtItem || [itemList count] <= 0 || minScrollAccelToSnap < ABS(_curScrollSpeedX)) break;
			
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
				targetPoint_ = [innerLayer convertToWorldSpace:targetPoint_];
				float targetDistance_ = ccpDistance(centerPoint_, targetPoint_);
				
				if(minDistance_>targetDistance_){
					minIndex_ = index_;
					minDistance_ = targetDistance_;
				}
			}
			
			if(minIndex_ >= 0){
				[self setIndex:minIndex_];
				[self setTouchState:CMMTouchState_none];
			}
			
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
	[innerLayer setContentSize:CGSizeMake(targetWidth_,contentSize_.height)];
}
-(void)updateMenuArrangeWithInterval:(ccTime)dt_{
	float totalItemWidth_ = marginPerItem;
	ccArray *data_ = itemList->data;
	int count_ = data_->num;
	for(int index_=0;index_<count_;++index_){
		CMMMenuItem *item_ = data_->arr[index_];
		CGSize itemSize_ = item_.contentSize;
		CGPoint targetPoint_ = cmmFuncCommon_positionInParent(self, item_);
		targetPoint_.x = totalItemWidth_+itemSize_.width*(item_.anchorPoint.x);
		targetPoint_ = ccpAdd(item_.position, ccpMult(ccpSub(targetPoint_,item_.position), dt_*cmmVarCMMScrollMenu_defaultOrderingAccelRate));
		[item_ setPosition:targetPoint_];
		totalItemWidth_ += itemSize_.width+marginPerItem;
	}
}

@end

@implementation CMMScrollMenuH(Common)

-(void)addItem:(CMMMenuItem *)item_ atIndex:(int)index_{
	NSAssert([item_ isKindOfClass:[CMMScrollMenuHItem class]], @"CMMScrolMenuV only support CMMScrolMenuVItem as children.");
	[super addItem:item_ atIndex:index_];
	
	CGPoint targetPoint_ = cmmFuncCommon_positionInParent(self, item_);
	targetPoint_.x = marginPerItem;
	CMMMenuItem *preItem_ = [self itemAtIndex:index_-1];
	if(preItem_) targetPoint_.x = preItem_.position.x+preItem_.contentSize.width+marginPerItem;
	[item_ setPosition:targetPoint_];
}

@end