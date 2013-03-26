#import "HelloWorldLayer.h"

#import "CMMMenuItem.h"

#import "TransitionTestLayer.h"
#import "MenuItemTestLayer.h"
#import "MenuItemSetTestLayer.h"
#import "DragLayerTestLayer.h"
#import "GestureTestLayer.h"
#import "StageTestLayer.h"
#import "SequenceMakerTestLayer.h"
#import "SoundTestLayer.h"
#import "PopupTestLayer.h"
#import "GyroTestLayer.h"
#import "ScrollMenuTestLayer.h"
#import "ControlItemTestLayer.h"
#import "CustomUITestLayer.h"
#import "NoticeTestLayer.h"
#import "LeaderBoardTestLayer.h"
#import "AchievementsTestLayer.h"
#import "GameCenterTestLayer.h"
#import "CameraTestLayer.h"
#import "InAppPurchaseTestLayer.h"
#import "CFSocketTestLayer.h"

@implementation HelloWorldLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	mainMenu = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(_contentSize.width * 0.5f, _contentSize.height * 0.8f)];
	[mainMenu setPosition:ccpAdd(cmmFunc_positionIPN(self, mainMenu), ccp(0,-10.0f))];
	[self addChild:mainMenu];
	
	connectionStatusLabel = [CMMFontUtil labelWithString:@" "];
	[self addChild:connectionStatusLabel];
	
	[[CMMConnectionMonitor sharedMonitor] addObserverForConnectionStatus:self selector:@selector(updateConnectionStatus)];
	[self updateConnectionStatus];
	
	CGSize menuItemSize_ = CGSizeMake(mainMenu.contentSize.width, 55);
	
	CMMMenuItemL *menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[TransitionTestLayer node]];};
	[menuItem_ setTitle:@"Transition Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[MenuItemTestLayer node]];};
	[menuItem_ setTitle:@"MenuItem Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[MenuItemSetTestLayer node]];};
	[menuItem_ setTitle:@"MenuItemSet Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[DragLayerTestLayer node]];};
	[menuItem_ setTitle:@"DragLayer Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[GestureTestLayer node]];};
	[menuItem_ setTitle:@"Gesture Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[StageTestLayer node]];};
	[menuItem_ setTitle:@"Stage Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[SequenceMakerTestLayer node]];};
	[menuItem_ setTitle:@"Sequencer Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[SoundTestLayer node]];};
	[menuItem_ setTitle:@"SoundHandler Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[PopupTestLayer node]];};
	[menuItem_ setTitle:@"Popup Test"];
 	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[GyroTestLayer node]];};
	[menuItem_ setTitle:@"Gyro Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[ScrollMenuTestLayer node]];};
	[menuItem_ setTitle:@"ScrollMenu Test"];
	[mainMenu addItem:menuItem_];

	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[ControlItemTestLayer node]];};
	[menuItem_ setTitle:@"Control Item Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[CustomUITestLayer node]];};
	[menuItem_ setTitle:@"CustomUI(Joypad) Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[NoticeTestLayer node]];};
	[menuItem_ setTitle:@"Notice Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[LeaderBoardTestLayer node]];};
	[menuItem_ setTitle:@"LeaderBoard Test"];
	[mainMenu addItem:menuItem_];

	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[AchievementsTestLayer node]];};
	[menuItem_ setTitle:@"Achievements Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[GameCenterTestLayer node]];};
	[menuItem_ setTitle:@"Game Center(Match,Session) Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[CameraTestLayer node]];};
	[menuItem_ setTitle:@"Camera Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[InAppPurchaseTestLayer node]];};
	[menuItem_ setTitle:@"In-App Purchase Test"];
	[mainMenu addItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){[[CMMScene sharedScene] pushLayer:[CFSocketTestLayer node]];};
	[menuItem_ setTitle:@"CFSocket Test"];
	[mainMenu addItem:menuItem_];

	return self;
}

-(void)sceneDidEndTransition:(CMMScene *)scene_{
//	[[CMMScene sharedScene] pushLayer:[DragLayerTestLayer node]];
}

-(void)updateConnectionStatus{
	NSString *connectionStatusStr_ = nil;
	CMMConnectionStatus connectionStatus_ = [[CMMConnectionMonitor sharedMonitor] connectionStatus];
	switch(connectionStatus_){
		case CMMConnectionStatus_WiFi:
			connectionStatusStr_ = @"connected as WiFi";
			break;
		case CMMConnectionStatus_WWAN:
			connectionStatusStr_ = @"connected as WWAN";
			break;
		case CMMConnectionStatus_noConnection:
		default:
			connectionStatusStr_ = @"no connection";
			break;
	}
	
	[connectionStatusLabel setString:connectionStatusStr_];
	[connectionStatusLabel setPosition:cmmFunc_positionFON(mainMenu, connectionStatusLabel, ccp(0,1.0f), ccp(0,5.0f))];
}

@end