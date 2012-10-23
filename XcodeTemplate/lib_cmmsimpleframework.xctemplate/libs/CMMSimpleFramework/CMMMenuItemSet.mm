//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMenuItemSet.h"

@implementation CMMMenuItemSet
@synthesize itemList,alignType,lineHAlignType,lineVAlignType,unitPerLine,isEnable,count,delegate,callback_pushdown,callback_pushup;

+(id)menuItemSetWithMenuSize:(CGSize)menuSize_{
	return [[[self alloc] initWithMenuSize:menuSize_] autorelease];
}
+(id)menuItemSetWithMenuSize:(CGSize)menuSize_ menuItem:(CMMMenuItem *)menuItem_,...{
	va_list args_;
	va_start(args_,menuItem_);
	
	CCArray *array_ = [CCArray array];
	if(menuItem_){
		for(CMMMenuItem *tempItem_ = va_arg(args_, CMMMenuItem*);tempItem_;tempItem_ = va_arg(args_, CMMMenuItem*)){
			[array_ addObject:tempItem_];
		}
	}
	
	id target_ = [self menuItemSetWithMenuSize:menuSize_ menuItemArray:array_];
	
	va_end(args_);
	
	return target_;
}
+(id)menuItemSetWithMenuSize:(CGSize)menuSize_ menuItemArray:(CCArray *)array_{
	return [[[self alloc] initWithMenuSize:menuSize_ menuItemArray:array_] autorelease];
}

-(id)initWithMenuSize:(CGSize)menuSize_{
	if(!(self = [super initWithColor:ccc4(0, 0, 0, 0) width:menuSize_.width height:menuSize_.height])) return self;
	
	itemList = [[CCArray alloc] init];
	alignType = CMMMenuItemSetAlignType_vertical;
	lineHAlignType = CMMMenuItemSetLineHAlignType_top;
	lineVAlignType = CMMMenuItemSetLineVAlignType_left;
	unitPerLine = 1;
	isEnable  = YES;
	
	return self;
}
-(id)initWithMenuSize:(CGSize)menuSize_ menuItemArray:(CCArray *)array_{
	if(!(self = [self initWithMenuSize:menuSize_])) return self;
	
	ccArray *data_ = array_->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMMenuItem *menuItem_ = data_->arr[index_];
		[self addMenuItem:menuItem_];
	}
	
	[self updateDisplay];
	
	return self;
}

-(void)setUnitPerLine:(uint)unitPerLine_{
	unitPerLine = MAX(unitPerLine_,1);
}

-(uint)count{
	return [itemList count];
}

-(void)updateDisplay{
	uint itemCount_ = [self count];
	float targetLine_ = ceilf(((float)itemCount_)/(float)unitPerLine);
	CGSize areaSize_ = CGSizeZero;
	switch(alignType){
		case CMMMenuItemSetAlignType_horizontal:{
			areaSize_.width = contentSize_.width/targetLine_;
			areaSize_.height = contentSize_.height/(float)unitPerLine;
			break;
		}
		case CMMMenuItemSetAlignType_vertical:{
			areaSize_.width = contentSize_.width/(float)unitPerLine;
			areaSize_.height = contentSize_.height/targetLine_;
			break;
		}
		default:{
			CCLOG(@"CMMMenuItemSet : select the alignType.");
			break;
		}
	}
	
	int curUnitPerLine_ = unitPerLine;
	int curLine_ = -1,beforeLine_ = NSNotFound;
	int curLineItemCount_ = 0;
	float lineStartOffsetValue_ = 0;
	
	ccArray *data_ = itemList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		
		++curUnitPerLine_;
		if(curUnitPerLine_ >= unitPerLine){
			curLineItemCount_ = unitPerLine;
			if(index_+unitPerLine >= itemCount_)
				curLineItemCount_ -= ((index_+unitPerLine)-itemCount_);
			curUnitPerLine_ = 0;
			++curLine_;	
		}
		
		
		CMMMenuItem *menuItem_ = data_->arr[index_];
		CGSize menuItemSize_ = [menuItem_ contentSize];
		CGPoint menuItemAnchorPoint_ = [menuItem_ anchorPoint];
		CGPoint targetPoint_ = CGPointZero;
		
		switch(alignType){
			case CMMMenuItemSetAlignType_horizontal:{
				if(curLine_ != beforeLine_){
					switch(lineHAlignType){
						case CMMMenuItemSetLineHAlignType_top:{
							lineStartOffsetValue_ = 0.0f;
							break;
						}
						case CMMMenuItemSetLineHAlignType_middle:{
							lineStartOffsetValue_ = (unitPerLine - curLineItemCount_)*areaSize_.height/2.0f;
							break;
						}
						case CMMMenuItemSetLineHAlignType_bottom:{
							lineStartOffsetValue_ = (unitPerLine - curLineItemCount_)*areaSize_.height;
							break;
						}
						default: break;
					}
				}
				
				targetPoint_.x = (areaSize_.width*curLine_)+((areaSize_.width*0.5f)+menuItemSize_.width*(0.5f-menuItemAnchorPoint_.x));
				targetPoint_.y = contentSize_.height - (areaSize_.height*curUnitPerLine_)-((areaSize_.height*0.5f)+menuItemSize_.height*(0.5f-menuItemAnchorPoint_.y));
				targetPoint_.y -= lineStartOffsetValue_;
				
				break;
			}
			case CMMMenuItemSetAlignType_vertical:{
				if(curLine_ != beforeLine_){
					switch(lineVAlignType){
						case CMMMenuItemSetLineVAlignType_left:{
							lineStartOffsetValue_ = 0.0f;
							break;
						}
						case CMMMenuItemSetLineVAlignType_center:{
							lineStartOffsetValue_ = (unitPerLine - curLineItemCount_)*areaSize_.width/2.0f;
							break;
						}
						case CMMMenuItemSetLineVAlignType_right:{
							lineStartOffsetValue_ = (unitPerLine - curLineItemCount_)*areaSize_.width;
							break;
						}
						default: break;
					}
				}
				
				targetPoint_.x = (areaSize_.width * curUnitPerLine_)+((areaSize_.width*0.5f)+menuItemSize_.width*(0.5f-menuItemAnchorPoint_.x));
				targetPoint_.x += lineStartOffsetValue_;
				targetPoint_.y = contentSize_.height - (areaSize_.height * curLine_)-((areaSize_.height*0.5f)+menuItemSize_.height*(0.5f-menuItemAnchorPoint_.y));
				
				break;
			}
			default: break;
		}
		
		beforeLine_ = curLine_;
		
		[menuItem_ setPosition:targetPoint_];
	}
}

#if COCOS2D_DEBUG >= 1
-(void)draw{
	ccDrawColor4B(0, 255, 0, 180);
	glLineWidth(1.0f);
	ccDrawRect(CGPointZero, ccpFromSize(contentSize_));
	[super draw];
}
#endif

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return isEnable;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtTouch:touch_];
	if(touchItem_){
		CMMMenuItem *menuItem_ = (CMMMenuItem *)[touchItem_ node];
		[self callCallback_pushdownWithMenuItem:menuItem_];
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtTouch:touch_];
	if(touchItem_){
		[self callCallback_pushupWithMenuItem:(CMMMenuItem *)[touchItem_ node]];
	}
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
}

-(void)cleanup{
	[callback_pushdown release];
	callback_pushdown = nil;
	[callback_pushup release];
	callback_pushup = nil;
	[super cleanup];
}

-(void)dealloc{
	[itemList release];
	[callback_pushdown release];
	[callback_pushup release];
	[super dealloc];
}

@end

@implementation CMMMenuItemSet(Common)

-(void)addMenuItem:(CMMMenuItem *)menuItem_ atIndex:(uint)index_{
	if(index_ == NSNotFound || index_ > [self count]) return;
	[itemList insertObject:menuItem_ atIndex:index_];
	[self addChild:menuItem_];
}
-(void)addMenuItem:(CMMMenuItem *)menuItem_{
	[self addMenuItem:menuItem_ atIndex:[self count]];
}

-(void)removeMenuItem:(CMMMenuItem *)menuItem_{
	uint index_ = [self indexOfMenuItem:menuItem_];
	if(index_ == NSNotFound) return;
	[self removeChild:menuItem_ cleanup:NO];
	[itemList removeObjectAtIndex:index_];
}
-(void)removeMenuItemAtInex:(uint)index_{
	[self removeMenuItem:[self menuItemAtIndex:index_]];
}
-(void)removeAllMenuItems{
	ccArray *data_ = itemList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMMenuItem *tMenuItem_ = data_->arr[index_];
		[self removeMenuItem:tMenuItem_];
	}
}

-(CMMMenuItem *)menuItemAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [itemList objectAtIndex:index_];
}

-(uint)indexOfMenuItem:(CMMMenuItem *)menuItem_{
	ccArray *data_ = itemList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMMenuItem *tMenuItem_ = data_->arr[index_];
		if(tMenuItem_ == menuItem_){
			return index_;
		}
	}
	return NSNotFound;
}

@end

@implementation CMMMenuItemSet(Callback)

-(void)callCallback_pushdownWithMenuItem:(CMMMenuItem *)menuItem_{
	if(callback_pushdown){
		callback_pushdown(self, menuItem_);
	}else if(cmmFuncCommon_respondsToSelector(delegate, @selector(menuItemSet:whenMenuItemPushdownWithMenuItem:))){
		[delegate menuItemSet:self whenMenuItemPushdownWithMenuItem:menuItem_];
	}
}
-(void)callCallback_pushupWithMenuItem:(CMMMenuItem *)menuItem_{
	if(callback_pushup){
		callback_pushup(self, menuItem_);
	}else if(cmmFuncCommon_respondsToSelector(delegate, @selector(menuItemSet:whenMenuItemPushupWithMenuItem:))){
		[delegate menuItemSet:self whenMenuItemPushupWithMenuItem:menuItem_];
	}
}

@end