//  Created by JGroup(kimbobv22@gmail.com)

#import "ScrollMenuTestLayer.h"
#import "HelloWorldLayer.h"

@implementation ScrollMenuTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	scrollMenu1 = [CMMScrollMenu scrollMenuWithFrameSeq:1 frameSize:CGSizeMake(200,220)];
	scrollMenu1.delegate = self;
	scrollMenu1.position = ccpSub(cmmFuncCommon_position_center(self, scrollMenu1),ccp(scrollMenu1.contentSize.width/2+20,-40));
	[self addChild:scrollMenu1];
	
	scrollMenu2 = [CMMScrollMenu scrollMenuWithFrameSeq:0 frameSize:CGSizeMake(200,220)];
	scrollMenu2.delegate = self;
	scrollMenu2.position = ccpAdd(cmmFuncCommon_position_center(self, scrollMenu2),ccp(scrollMenu2.contentSize.width/2+20,40));
	[self addChild:scrollMenu2];
	
	CMMMenuItemLabelTTF *menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[menuItemButton_ setTitle:@"remove"];
	menuItemButton_.position = ccp(self.contentSize.width-menuItemButton_.contentSize.width/2,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[scrollMenu2 removeMenuItemAtIndex:0];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[menuItemButton_ setTitle:@"add"];
	menuItemButton_.position = ccp(self.contentSize.width-menuItemButton_.contentSize.width-menuItemButton_.contentSize.width/2,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		CMMMenuItemLabelTTF *menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 frameSize:CGSizeMake(scrollMenu2.contentSize.width,35)];
		[menuItem_ setTitle:[NSString stringWithFormat:@"object %d",scrollMenu2.count]];
		[scrollMenu2 addMenuItem:menuItem_];
	};
	[self addChild:menuItemButton_];
	
	menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[menuItemButton_ setTitle:@"BACK"];
	menuItemButton_.position = ccp(menuItemButton_.contentSize.width/2+20,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[HelloWorldLayer node]];
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

-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanDragMenuItem:(CMMMenuItem *)menuItem_{return YES;}
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanLinkSwitchMenuItem:(CMMMenuItem *)menuItem_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_{return YES;}
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanSwitchMenuItem:(CMMMenuItem *)menuItem_ toIndex:(int)toIndex_{return YES;}

-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenSelectedAtIndex:(int)index_{
	[self _setDisplayStr:[NSString stringWithFormat:@"whenSelectedAtIndex : %d",index_]];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenAddedMenuItem:(CMMMenuItem *)menuItem_ atIndex:(int)index_{
	[self _setDisplayStr:[NSString stringWithFormat:@"whenAddedMenuItem : %d",index_]];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenRemovedMenuItem:(CMMMenuItem *)menuItem_{
	[self _setDisplayStr:@"whenRemovedMenuItem"];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenSwitchedMenuItem:(CMMMenuItem *)menuItem_ toIndex:(int)toIndex_{
	[self _setDisplayStr:[NSString stringWithFormat:@"whenSwitchedMenuItem : %d",toIndex_]];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenLinkSwitchedMenuItem:(CMMMenuItem *)fromMenuItem_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_{
	[self _setDisplayStr:[NSString stringWithFormat:@"whenLinkSwitchedMenuItem : %d",toIndex_]];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushdownWithMenuItem:(CMMMenuItem *)menuItem_{
	[self _setDisplayStr:@"whenPushdownWithMenuItem"];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushupWithMenuItem:(CMMMenuItem *)menuItem_{
	[self _setDisplayStr:@"whenPushupWithMenuItem"];
}
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushcancelWithMenuItem:(CMMMenuItem *)menuItem_{
	[self _setDisplayStr:@"whenPushcancelWithMenuItem"];
}
@end
