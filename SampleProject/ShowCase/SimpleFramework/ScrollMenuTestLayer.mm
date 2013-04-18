//  Created by JGroup(kimbobv22@gmail.com)

#import "ScrollMenuTestLayer.h"
#import "HelloWorldLayer.h"

@implementation ScrollMenuTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemL *menuItemButton_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"BACK"];
	menuItemButton_.position = ccp(menuItemButton_.contentSize.width/2+20,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerForKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"SCROLLMENU V"];
	menuItemButton_.position = ccp(_contentSize.width/2.0f-menuItemButton_.contentSize.width/2-10.0f,_contentSize.height/2.0f);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[ScrollMenuTestLayer_V node]];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"SCROLLMENU H"];
	menuItemButton_.position = ccp(_contentSize.width/2.0f+menuItemButton_.contentSize.width/2+10.0f,_contentSize.height/2.0f);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[ScrollMenuTestLayer_H node]];
	};
	[self addChild:menuItemButton_];
	
	return self;
}

@end

@implementation ScrollMenuTestLayer_H

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	scrollMenu = [CMMScrollMenuH scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(320, 200)];
	scrollMenu.index = 0;
	scrollMenu.marginPerItem = 150.0f;
	//scrollMenu.isSnapAtItem = NO;
	scrollMenu.position = cmmFunc_positionIPN(self, scrollMenu);
	[self addChild:scrollMenu];
	
	CMMMenuItemL *menuItemButton_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"BACK"];
	menuItemButton_.position = ccp(menuItemButton_.contentSize.width/2+20,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[ScrollMenuTestLayer node]];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"add"];
	menuItemButton_.position = ccp(self.contentSize.width-menuItemButton_.contentSize.width-menuItemButton_.contentSize.width/2,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		CMMScrollMenuHItem *item_ = [CMMScrollMenuHItem menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake((arc4random()%200 + 200), 150)];
		CMMControlItemSlider *slider_ = [CMMControlItemSlider controlItemSliderWithWidth:180 frameSeq:0];
		slider_.position = cmmFunc_positionIPN(item_, slider_);
		
		[item_ addChild:slider_];
		
		[scrollMenu addItem:item_];
	};
	[self addChild:menuItemButton_];
	
	return self;
}

@end

@implementation ScrollMenuTestLayer_V

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	scrollMenu1 = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(200,220)];
	[scrollMenu1 setFilter_canDragItem:^BOOL(CMMMenuItem *item_) {
		return YES;
	}];
	[scrollMenu1 setSwitchMode:CMMScrollMenuVSwitchMode_move];
	[scrollMenu1 setFilter_canMoveItem:^BOOL(CMMMenuItem *item_, int toIndex_) {
		return YES;
	}];
	[scrollMenu1 setCallback_whenItemMoved:^(CMMMenuItem *item_, int toIndex_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu1 : whenItemMoved : %d",toIndex_]];
	}];
	
	[scrollMenu1 setCallback_whenIndexChanged:^(int index_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu1 : whenIndexChanged : %d",index_]];
	}];
	[scrollMenu1 setCallback_whenItemAdded:^(CMMMenuItem * item_, int index_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu1 : whenItemAdded : %d",index_]];
	}];
	[scrollMenu1 setCallback_whenItemRemoved:^(CMMMenuItem *item_) {
		[self _setDisplayStr:@"scrollMenu1 : whenItemRemoved"];
	}];
	[scrollMenu1 setCallback_whenItemSwitched:^(CMMMenuItem *item_, int toIndex_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu1 : whenItemSwitched : %d",toIndex_]];
	}];
	[scrollMenu1 setCallback_whenItemLinkSwitched:^(CMMMenuItem *item_, CMMScrollMenu *toScrollMenu, int toIndex_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu1 : whenItemLinkSwitched -> scrollMenu2 : %d",toIndex_]];
	}];
	[scrollMenu1 setCallback_whenTapAtIndex:^(int index_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu1 : whenTapAtIndex : %d",index_]];
	}];
	
	for(uint index_=0;index_<10;++index_){
		[self _addItemTo:scrollMenu1];
	}
	
	scrollMenu1.position = ccpSub(cmmFunc_positionIPN(self, scrollMenu1),ccp(scrollMenu1.contentSize.width/2+20,-40));
	[self addChild:scrollMenu1];
	
	scrollMenu2 = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(200,220)];
	[scrollMenu2 setFilter_canDragItem:^BOOL(CMMMenuItem *item_) {
		return YES;
	}];
	[scrollMenu2 setFilter_canSwitchItem:^BOOL(CMMMenuItem *, int) {
		return YES;
	}];
	[scrollMenu2 setFilter_canLinkSwitchItem:^BOOL(CMMMenuItem *, CMMScrollMenu *, int) {
		return YES;
	}];
	[scrollMenu2 setCallback_whenIndexChanged:^(int index_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu2 : whenIndexChanged : %d",index_]];
	}];
	[scrollMenu2 setCallback_whenItemAdded:^(CMMMenuItem * item_, int index_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu2 : whenItemAdded : %d",index_]];
	}];
	[scrollMenu2 setCallback_whenItemRemoved:^(CMMMenuItem *item_) {
		[self _setDisplayStr:@"scrollMenu2 : whenItemRemoved"];
	}];
	[scrollMenu2 setCallback_whenItemSwitched:^(CMMMenuItem *item_, int toIndex_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu2 : whenItemSwitched : %d",toIndex_]];
	}];
	[scrollMenu2 setCallback_whenItemLinkSwitched:^(CMMMenuItem *item_, CMMScrollMenu *toScrollMenu, int toIndex_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu2 : whenItemLinkSwitched -> scrollMenu1 : %d",toIndex_]];
	}];
	[scrollMenu2 setCallback_whenTapAtIndex:^(int index_) {
		[self _setDisplayStr:[NSString stringWithFormat:@"scrollMenu2 : whenTapAtIndex : %d",index_]];
	}];
	
	scrollMenu2.position = ccpAdd(cmmFunc_positionIPN(self, scrollMenu2),ccp(scrollMenu2.contentSize.width/2+20,40));
	[self addChild:scrollMenu2];
	
	CMMMenuItemL *menuItemButton_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"remove"];
	menuItemButton_.position = ccp(self.contentSize.width-menuItemButton_.contentSize.width/2,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[scrollMenu2 removeItemAtIndex:0];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"add"];
	menuItemButton_.position = ccp(self.contentSize.width-menuItemButton_.contentSize.width-menuItemButton_.contentSize.width/2,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[self _addItemTo:scrollMenu2];
	};
	[self addChild:menuItemButton_];
		
	menuItemButton_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"BACK"];
	menuItemButton_.position = ccp(menuItemButton_.contentSize.width/2+20,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[ScrollMenuTestLayer node]];
	};
	[self addChild:menuItemButton_];
	
	labelDisplay = [CMMFontUtil labelWithString:@" "];
	[self addChild:labelDisplay];
	
	return self;
}

-(void)_addItemTo:(CMMScrollMenuV *)menu_{
	CMMMenuItemL *menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake([menu_ contentSize].width,35)];
	[menuItem_ setTitle:[NSString stringWithFormat:@"object %d",[menu_ count]]];
	[menu_ addItem:menuItem_];
}

-(void)_setDisplayStr:(NSString *)str_{
	[labelDisplay setString:str_];
	labelDisplay.position = ccp(self.contentSize.width/2,scrollMenu1.position.y-labelDisplay.contentSize.height/2-10.0f);
}

@end
