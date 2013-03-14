//  Created by JGroup(kimbobv22@gmail.com)

#import "PopupTestLayer.h"
#import "HelloWorldLayer.h"

static int _testPopupCount_ = 1;

@interface TestPopup : CMMPopupLayer{
	CMMMenuItemL *btnPopup,*btnClose;
	CCLabelTTF *testLabel;
}

@end

@implementation TestPopup

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;

	testLabel = [CMMFontUtil labelWithString:[NSString stringWithFormat:@"popup No.%d",_testPopupCount_]];
	testLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
	[self addChild:testLabel];
	
	btnPopup = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[btnPopup setCallback_pushup:^(id) {
		_testPopupCount_++;
		[[CMMScene sharedScene] openPopupAtFirst:[TestPopup node]];
	}];
	[btnPopup setTitle:@"POPUP AGAIN!"];
	btnPopup.position = ccp(MIN(MAX(arc4random()%(int)self.contentSize.width,btnPopup.contentSize.width/2),self.contentSize.width-btnPopup.contentSize.width/2),self.contentSize.height/2+80);
	[self addChild:btnPopup];
	
	btnClose = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[btnClose setCallback_pushup:^(id) {
		[self close];
	}];
	[btnClose setTitle:@"CLOSE"];
	btnClose.position = ccp(self.contentSize.width/2,self.contentSize.height/2-80);
	[self addChild:btnClose];
	
	return self;
}

-(void)onEnter{
	[super onEnter];
	[self stopAllActions];
	[self setScale:0.95f];
	[self runAction:[CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.0f]]];
}

@end

@implementation PopupTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	testLabel = [CMMFontUtil labelWithString:@" "];
	testLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2+80);
	[self addChild:testLabel];
	
	menuItemOpen = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemOpen setTitle:@"OPEN POPUP"];
	[menuItemOpen setCallback_pushup:^(id) {
		[self openTestingPopup];
	}];
	menuItemOpen.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
	[self addChild:menuItemOpen];
	
	menuItemClose = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemClose setTitle:@"BACK"];
	[menuItemClose setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushStaticLayerForKey:_HelloWorldLayer_key_];
	}];
	menuItemClose.position = ccp(menuItemClose.contentSize.width/2+20,menuItemClose.contentSize.height/2);
	[self addChild:menuItemClose];
	
	//[[[[CMMScene sharedScene] popupDispatcher] masterView] setShowOnlyOne:YES];
	/*
	 if you want to show up popup only one, set showOnlyOne to 'YES'
	 */
	
	return self;
}

-(void)openTestingPopup{
	[testLabel setString:@" "];
	_testPopupCount_ = 1;
	TestPopup *popup_ = [TestPopup node];
	
	//when closed
	[popup_ setCallback_didClose:^(CMMPopupLayer *popup_) {
		CCLOG(@"Popup closed!");
		[testLabel setString:[NSString stringWithFormat:@"opened popup total count : %d",_testPopupCount_]];
	}];
	
	//when opened
	[popup_ setCallback_didOpen:^(CMMPopupLayer *popup_) {
		CCLOG(@"Popup opened!");
	}];
	
	//become Head popup
	[popup_ setCallback_becomeHeadPopup:^(CMMPopupLayer *popup_) {
		CCLOG(@"become Head!");
	}];
	
	//resign Head popup
	[popup_ setCallback_resignHeadPopup:^(CMMPopupLayer *popup_) {
		CCLOG(@"resign Head!");
	}];
	
	[[CMMScene sharedScene] openPopup:popup_];
}

@end
