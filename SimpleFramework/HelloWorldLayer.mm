#import "HelloWorldLayer.h"

#import "CMMMenuItem.h"

#import "MenuItemTestLayer.h"
#import "DragLayerTestLayer.h"
#import "PinchZoomTestLayer.h"
#import "StageTestLayer.h"
#import "LoadingTestLayer.h"
#import "SoundTestLayer.h"
#import "PopupTestLayer.h"
#import "GyroTestLayer.h"
#import "ScrollMenuTestLayer.h"
#import "TilemapTestLayer.h"
#import "ControlItemTestLayer.h"
#import "CustomUITestLayer.h"

@implementation HelloWorldLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	mainMenu = [CMMScrollMenuV scrollMenuWithFrameSeq:0 frameSize:CGSizeMake(250, 300)];
	mainMenu.position = cmmFuncCommon_position_center(self, mainMenu);
	[self addChild:mainMenu];
	
	CGSize menuItemSize_ = CGSizeMake(mainMenu.contentSize.width, 55);
	
	CMMMenuItemLabelTTF *menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:1 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[MenuItemTestLayer node]];};
	[menuItem_ setTitle:@"MenuItem Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[DragLayerTestLayer node]];};
	[menuItem_ setTitle:@"DragLayer Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:1 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[PinchZoomTestLayer node]];};
	[menuItem_ setTitle:@"PinchZoom Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[StageTestLayer node]];};
	[menuItem_ setTitle:@"Stage Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:1 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[LoadingTestLayer node]];};
	[menuItem_ setTitle:@"Loading Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[SoundTestLayer node]];};
	[menuItem_ setTitle:@"SoundHandler Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:1 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[PopupTestLayer node]];};
	[menuItem_ setTitle:@"Popup Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[GyroTestLayer node]];};
	[menuItem_ setTitle:@"Gyro Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:1 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[ScrollMenuTestLayer node]];};
	[menuItem_ setTitle:@"ScrollMenu Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[TilemapTestLayer node]];};
	[menuItem_ setTitle:@"Tilemap Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:1 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[ControlItemTestLayer node]];};
	[menuItem_ setTitle:@"Control Item Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[CustomUITestLayer node]];};
	[menuItem_ setTitle:@"CustomUI(Joypad) Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:1 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){
		[[[CMMScene sharedScene] noticeDispatcher] addNoticeItemWithTitle:@"Hello world :)" subject:@"Welcome to CMMSimpleFramework!"];
	};
	[menuItem_ setTitle:@"Notice Test"];
	[mainMenu addItem:menuItem_];
	
	
	
	return self;
}

@end