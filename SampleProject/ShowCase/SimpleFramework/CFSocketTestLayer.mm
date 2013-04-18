//
//  CFSocketTestLayer.mm
//  SimpleFramework
//
//  Created by Kim Jazz on 12. 11. 11..
//
//

#import "CFSocketTestLayer.h"
#import "HelloWorldLayer.h"

@implementation CFSocketTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemL *menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"BACK"];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerForKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBtn_];
	
	CMMMenuItemSet *btnSet_ = [CMMMenuItemSet menuItemSetWithMenuSize:CGSizeMake(_contentSize.width*0.7f, _contentSize.height*0.6f)];
	[btnSet_ setPosition:cmmFunc_positionIPN(self, btnSet_)];
	[self addChild:btnSet_];
	
	CMMMenuItemL *serverBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[serverBtn_ setTitle:@"SERVER"];
	[serverBtn_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[CFSocketTestLayer_MasterServer node]];
	}];
	
	CMMMenuItemL *clientBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[clientBtn_ setTitle:@"CLIENT"];
	[clientBtn_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushLayer:[CFSocketTestLayer_MasterClient node]];
	}];
	
	[btnSet_ addMenuItem:serverBtn_];
	[btnSet_ addMenuItem:clientBtn_];
	
	[btnSet_ updateDisplay];
	
	return self;
}

@end

@implementation CFSocketTestLayer_Master

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemL *menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"BACK"];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[CFSocketTestLayer node]];
	};
	[self addChild:menuItemBtn_];
	
	labelDisplay = [CMMFontUtil labelWithString:@" "];
	[self addChild:labelDisplay];

	socketHandler = [[CMMSocketHandler alloc] init];
	[socketHandler setDelegate:self];
	return self;
}

-(void)setDisplayString:(NSString *)str_{
	[labelDisplay setString:str_];
	[labelDisplay setPosition:ccpAdd(cmmFunc_positionIPN(self, labelDisplay), ccp(0,50))];
}

-(void)dealloc{
	[socketHandler closeSocket];
	[socketHandler release];
	[super dealloc];
}

@end

@implementation CFSocketTestLayer_MasterServer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	[self setDisplayString:@"starting Host..."];
	[socketHandler startHostOnPort:7777];
	
	return self;
}

-(void)socketHandler:(CMMSocketHandler *)handler_ didStartWithAddressData:(NSData *)addressData_{
	[self setDisplayString:[NSString stringWithFormat:@"Host is running! :%@ ",[[CMMConnectionMonitor sharedMonitor] IPAddress]]];
}

-(void)socketHandler:(CMMSocketHandler *)handler_ didStopWithError:(NSError *)error_{
	[self setDisplayString:[NSString stringWithFormat:@"Host starting error! :%@ ",error_]];
}

-(void)socketHandler:(CMMSocketHandler *)handler_ didReceivePacketData:(CMMPacketData *)packetData_ fromAddressData:(NSData *)fromAddressData_{
	CMMPacket *packet_ = [packetData_ data];
	[self setDisplayString:[NSString stringWithFormat:@"Client(%@) Connect\nReceived data : %@",cmmFuncCMMSocketHandler_NSStringfromAddressData(fromAddressData_),[packet_ mainData]]];
}

@end

@implementation CFSocketTestLayer_MasterClient

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	hostTextField = [CMMControlItemText controlItemTextWithWidth:_contentSize.width*0.4f frameSeq:0];
	[hostTextField setPosition:ccpAdd(cmmFunc_positionIPN(self, hostTextField), ccp(-50,-50))];
	[hostTextField setTitle:@"Host IP"];
	[self addChild:hostTextField];
	
	connectBtn = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[connectBtn setTitle:@"CONNECT"];
	[connectBtn setPosition:cmmFunc_positionFON(hostTextField, connectBtn, ccp(1.0f,0))];
	[connectBtn setCallback_pushup:^(id) {
		[self connectToHost];
	}];
	[self addChild:connectBtn];
	
	[self connectToHost];
	
	return self;
}

-(void)connectToHost{
	if([[hostTextField itemValue] length] == 0){
		[self setDisplayString:@"Enter Host IP!"];
		return;
	}
	
	[socketHandler connectToHostName:[hostTextField itemValue] port:7777];
}

-(void)socketHandler:(CMMSocketHandler *)handler_ didStartWithAddressData:(NSData *)addressData_{
	[self setDisplayString:[NSString stringWithFormat:@"Success connecting to :%@ ",cmmFuncCMMSocketHandler_NSStringfromAddressData(addressData_)]];
	[connectBtn setEnable:NO];
	
	CMMPacket *testPacket_ = [CMMPacket packet];
	[testPacket_ setMainData:[NSString stringWithFormat:@"Hellow CFSocket %d :)",arc4random()%100]];
	[socketHandler sendPacket:testPacket_];
}

-(void)socketHandler:(CMMSocketHandler *)handler_ didStopWithError:(NSError *)error_{
	[self setDisplayString:[NSString stringWithFormat:@"connecting error! :%@ ",error_]];
}

-(void)socketHandler:(CMMSocketHandler *)handler_ didFailToSendPacketData:(CMMPacketData *)packetData_ toAddressData:(NSData *)toAddressData_ withError:(NSError *)error_{
	CCLOG(@"didFailToSendPacketData : %@",error_);
}

@end