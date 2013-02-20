#import "HelloWorldLayer.h"

@implementation HelloWorldLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	//preload batch bar frame(just one time)
	[[CMMDrawingManager sharedManager] addDrawingItemWithFileName:@"barFrame000"];
	
	CGSize scrollSize_ = CGSizeMake(_contentSize.width * 0.4f, _contentSize.height * 0.7f);
	scrollMenu1 = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:scrollSize_];
	[scrollMenu1 setFilter_canDragItem:^BOOL(CMMMenuItem *item_) {
		return YES;
	}];
	[scrollMenu1 setFilter_canSwitchItem:^BOOL(CMMMenuItem *item_, int index_) {
		return YES;
	}];
	[scrollMenu1 setFilter_canLinkSwitchItem:^BOOL(CMMMenuItem *item_, CMMScrollMenu *toScrollMenu_, int toIndex_) {
		[item_ setCallback_pushup:^(id item_) {
			[self removeMenuItem:item_];
		}];
		return YES;
	}];
	
	[scrollMenu1 setPosition:cmmFuncCommon_positionInParent(self, scrollMenu1,ccp(0.5f,0.6f),ccp(scrollSize_.width*0.5f+5.0f,0.0f))];
	
	scrollMenu2 = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:scrollSize_];
	[scrollMenu2 setPosition:cmmFuncCommon_positionInParent(self, scrollMenu1,ccp(0.5f,0.6f),ccp(-scrollSize_.width*0.5f-5.0f,0.0f))];
	
	[self addChild:scrollMenu1 z:1];
	[self addChild:scrollMenu2 z:0];
	
	CMMMenuItemL *btnAdd_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[btnAdd_ setTitle:@"ADD"];
	[btnAdd_ setCallback_pushup:^(id item_) {
		[self addMenuItem];
	}];
	CMMMenuItemL *btnRemove_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[btnRemove_ setTitle:@"REMOVE"];
	[btnRemove_ setCallback_pushup:^(id item_) {
		[self removeMenuItem:[scrollMenu2 itemAtIndex:0]];
	}];
	
	[btnAdd_ setPosition:cmmFuncCommon_positionFromOtherNode(scrollMenu1, btnAdd_, ccp(0.0f,-1.0f),ccp(0.0f,-10.0f))];
	[btnRemove_ setPosition:cmmFuncCommon_positionFromOtherNode(scrollMenu2, btnRemove_, ccp(0.0f,-1.0f),ccp(0.0f,-10.0f))];
	
	[self addChild:btnAdd_];
	[self addChild:btnRemove_];
	
	[self addMenuItem];
	
	return self;
}

-(void)addMenuItem{
	++tempCount;
	
	CGSize menuItemSize_ = CGSizeMake(scrollMenu1.contentSize.width, 55);

	CMMMenuItemL *menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	[menuItem_ setCallback_pushup:^(id item_) {
		[self addMenuItem];
	}];
	[menuItem_ setTitle:[NSString stringWithFormat:@"Hello world :) [%d]",tempCount]];
 	[scrollMenu1 addItem:menuItem_];
}
-(void)removeMenuItem:(CMMMenuItem *)item_{
	if(!item_) return;
	[scrollMenu2 removeItem:item_];
}

@end