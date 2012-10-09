//  Created by JGroup(kimbobv22@gmail.com)

#import "PopupTestLayer.h"
#import "HelloWorldLayer.h"

static int _testPopupCount_ = 1;

@interface TestPopup : CMMLayerPopup<CMMMenuItemDelegate>{
	CMMMenuItemLabelTTF *btnPopup,*btnClose;
	CCLabelTTF *testLabel;
}

@end

@implementation TestPopup

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;

	testLabel = [CMMFontUtil labelWithstring:[NSString stringWithFormat:@"popup No.%d",_testPopupCount_]];
	testLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
	[self addChild:testLabel];
	
	btnPopup = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	btnPopup.delegate = self;
	[btnPopup setTitle:@"POPUP AGAIN!"];
	btnPopup.position = ccp(MIN(MAX(arc4random()%(int)self.contentSize.width,btnPopup.contentSize.width/2),self.contentSize.width-btnPopup.contentSize.width/2),self.contentSize.height/2+80);
	[self addChild:btnPopup];
	
	btnClose = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	btnClose.delegate = self;
	[btnClose setTitle:@"CLOSE"];
	btnClose.position = ccp(self.contentSize.width/2,self.contentSize.height/2-80);
	[self addChild:btnClose];
	
	return self;
}

-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_{
	if(menuItem_ == btnPopup){
		_testPopupCount_++;
		[[CMMScene sharedScene] openPopupAtFirst:[TestPopup node] delegate:nil];
	}else if(menuItem_ == btnClose)
		[self closeWithSendData:[NSString stringWithFormat:@"test value total popup Count.%d",_testPopupCount_]];
}

@end

@implementation PopupTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	testLabel = [CMMFontUtil labelWithstring:@" "];
	testLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2+80);
	[self addChild:testLabel];
	
	menuItemOpen = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemOpen setTitle:@"OPEN POPUP"];
	menuItemOpen.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
	menuItemOpen.delegate = self;
	[self addChild:menuItemOpen];
	
	menuItemClose = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemClose setTitle:@"BACK"];
	menuItemClose.position = ccp(menuItemClose.contentSize.width/2+20,menuItemClose.contentSize.height/2);
	menuItemClose.delegate = self;
	[self addChild:menuItemClose];
	
	return self;
}

-(void)popupDispatcher:(CMMPopupDispatcherItem *)popupItem_ whenClosedWithReceivedData:(id)data_{
	[testLabel setString:data_];
}

-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_{
	if(menuItem_ == menuItemOpen){
	
		//popup test
		[testLabel setString:@" "];
		_testPopupCount_ = 1;
		TestPopup *popup_ = [TestPopup node];
		[[CMMScene sharedScene] openPopup:popup_ delegate:self];
		
	}else if(menuItem_ == menuItemClose)
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
}

@end
