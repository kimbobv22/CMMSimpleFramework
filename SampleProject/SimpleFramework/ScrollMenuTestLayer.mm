//  Created by JGroup(kimbobv22@gmail.com)

#import "ScrollMenuTestLayer.h"
#import "HelloWorldLayer.h"

@implementation ScrollMenuTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemLabelTTF *menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"BACK"];
	menuItemButton_.position = ccp(menuItemButton_.contentSize.width/2+20,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"SCROLLMENU V"];
	menuItemButton_.position = ccp(contentSize_.width/2.0f-menuItemButton_.contentSize.width/2-10.0f,contentSize_.height/2.0f);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[ScrollMenuTestLayer_V node]];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"SCROLLMENU H"];
	menuItemButton_.position = ccp(contentSize_.width/2.0f+menuItemButton_.contentSize.width/2+10.0f,contentSize_.height/2.0f);
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
	scrollMenu.position = cmmFuncCommon_positionInParent(self, scrollMenu);
	[self addChild:scrollMenu];
	
	CMMMenuItemLabelTTF *menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"BACK"];
	menuItemButton_.position = ccp(menuItemButton_.contentSize.width/2+20,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[ScrollMenuTestLayer node]];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"add"];
	menuItemButton_.position = ccp(self.contentSize.width-menuItemButton_.contentSize.width-menuItemButton_.contentSize.width/2,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		CMMScrollMenuHItem *item_ = [CMMScrollMenuHItem menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake((arc4random()%200 + 200), 150)];
		CMMControlItemSlider *slider_ = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:180];
		slider_.position = cmmFuncCommon_positionInParent(item_, slider_);
		
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
	scrollMenu1.delegate = self;
	scrollMenu1.position = ccpSub(cmmFuncCommon_positionInParent(self, scrollMenu1),ccp(scrollMenu1.contentSize.width/2+20,-40));
	[self addChild:scrollMenu1];
	
	scrollMenu2 = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(200,220)];
	scrollMenu2.delegate = self;
	scrollMenu2.position = ccpAdd(cmmFuncCommon_positionInParent(self, scrollMenu2),ccp(scrollMenu2.contentSize.width/2+20,40));
	[self addChild:scrollMenu2];
	
	CMMMenuItemLabelTTF *menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"remove"];
	menuItemButton_.position = ccp(self.contentSize.width-menuItemButton_.contentSize.width/2,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[scrollMenu2 removeItemAtIndex:0];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"add"];
	menuItemButton_.position = ccp(self.contentSize.width-menuItemButton_.contentSize.width-menuItemButton_.contentSize.width/2,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		CMMMenuItemLabelTTF *menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(scrollMenu2.contentSize.width,35)];
		[menuItem_ setTitle:[NSString stringWithFormat:@"object %d",scrollMenu2.count]];
		[scrollMenu2 addItem:menuItem_];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"BACK"];
	menuItemButton_.position = ccp(menuItemButton_.contentSize.width/2+20,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[ScrollMenuTestLayer node]];
	};
	[self addChild:menuItemButton_];
	
	labelDisplay = [CMMFontUtil labelWithstring:@" "];
	[self addChild:labelDisplay];
	
	return self;
}

-(void)_setDisplayStr:(NSString *)str_{
	[labelDisplay setString:str_];
	labelDisplay.position = ccp(self.contentSize.width/2,scrollMenu1.position.y-labelDisplay.contentSize.height/2-10.0f);
}

-(BOOL)scrollMenu:(CMMScrollMenuV *)scrollMenu_ isCanDragItem:(CMMMenuItem *)item_{return YES;}
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanLinkSwitchItem:(CMMMenuItem *)item_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_{return YES;}
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanSwitchItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_{return YES;}

-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenSelectedAtIndex:(int)index_{
	[self _setDisplayStr:[NSString stringWithFormat:@"whenSelectedAtIndex : %d",index_]];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenAddedItem:(CMMMenuItem *)item_ atIndex:(int)index_{
	[self _setDisplayStr:[NSString stringWithFormat:@"whenAddedItem : %d",index_]];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenRemovedItem:(CMMMenuItem *)item_{
	[self _setDisplayStr:@"whenRemovedItem"];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenSwitchedItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_{
	[self _setDisplayStr:[NSString stringWithFormat:@"whenSwitchedItem : %d",toIndex_]];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenLinkSwitchedItem:(CMMMenuItem *)fromItem_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_{
	[self _setDisplayStr:[NSString stringWithFormat:@"whenLinkSwitchedItem : %d",toIndex_]];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushdownWithItem:(CMMMenuItem *)item_{
	[self _setDisplayStr:@"whenPushdownWithItem"];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushupWithItem:(CMMMenuItem *)item_{
	[self _setDisplayStr:@"whenPushupWithItem"];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushcancelWithItem:(CMMMenuItem *)item_{
	[self _setDisplayStr:@"whenPushcancelWithItem"];
}

@end
