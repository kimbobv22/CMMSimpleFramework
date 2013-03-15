//  Created by JGroup(kimbobv22@gmail.com)

#import "GameCenterTestLayer.h"
#import "HelloWorldLayer.h"

@implementation TestPacketType2
@synthesize msg;

-(id)initWithCoder:(NSCoder *)decoder_{
	if(!(self = [super initWithCoder:decoder_])) return self;
	
	[self setMsg:[decoder_ decodeObjectForKey:TestPacketType2_name_msg]];
	
	return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder_{
	[super encodeWithCoder:encoder_];
	[encoder_ encodeObject:msg forKey:TestPacketType2_name_msg];
}
-(id)copyWithZone:(NSZone *)zone_{
	TestPacketType2 *copy_ = [super copyWithZone:zone_];
	[copy_ setMsg:msg];
	return copy_;
}

@end

@implementation TestPacketDataHandlerItem1

-(BOOL)shouldReceivePacketData:(CMMPacketData *)packetData_{
	return [packetData_ type] == CMMPacketDataType_bytes;
}

-(void)receivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_{
	GameCenterTestLayerMaster *target_ = [handler owner];
	TestPacketType1 *packet_ = (TestPacketType1 *)[[packetData_ data] bytes];

	CMMSObject *opponent_ = [target_ opponent];
	[opponent_ updateBodyPosition:packet_->point rotation:packet_->rotation];
	[opponent_ updateBodyLinearVelocity:packet_->linearVelocity angularVelocity:packet_->angularVelocity];
}

@end

@implementation TestPacketDataHandlerItem2

-(BOOL)shouldReceivePacketData:(CMMPacketData *)packetData_{
	return [packetData_ type] == CMMPacketDataType_packet;
}

-(void)receivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_{
	GameCenterTestLayerMaster *target_ = [handler owner];
	TestPacketType2 *packet_ = (TestPacketType2 *)[packetData_ data];
	[target_ setDisplayStr:[NSString stringWithFormat:@"Opponent says : %@",[packet_ msg]]];
}

@end

@implementation GameCenterTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	menuSelector = [CMMMenuItemSet menuItemSetWithMenuSize:CGSizeMake(_contentSize.width*0.7f, _contentSize.height*0.5f)];
	[menuSelector setAlignType:CMMMenuItemSetAlignType_horizontal];
	[menuSelector setPosition:cmmFunc_positionIPN(self, menuSelector)];
	[self addChild:menuSelector];
	
	CMMMenuItemL *menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"Match"];
	[menuItem_ setCallback_pushup:^(id sender_){
		[[CMMScene sharedScene] pushLayer:[GameCenterTestLayerMatch node]];
	}];
	
	[menuSelector addMenuItem:menuItem_];
	
	menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"Session"];
	[menuItem_ setCallback_pushup:^(id sender_){
		[[CMMScene sharedScene] pushLayer:[GameCenterTestLayerSession node]];
	}];
	
	[menuSelector addMenuItem:menuItem_];
	[menuSelector updateDisplay];
	
	if([[CMMConnectionMonitor sharedMonitor] connectionStatus] != CMMConnectionStatus_WiFi){
		CCLabelTTF *tempDisplayLabel_ = [CMMFontUtil labelWithString:@"Game Center must required connection as WiFi"];
		[tempDisplayLabel_ setPosition:ccp(_contentSize.width*0.5f,menuSelector.position.y+menuSelector.contentSize.height+tempDisplayLabel_.contentSize.height*0.5f + 10.0f)];
		[self addChild:tempDisplayLabel_];
		//[menuSelector setIsEnable:NO];
	}
	
	CMMMenuItemL *menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"BACK"];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerForKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBtn_];
	
	return self;
}

@end

@implementation GameCenterTestLayerMaster
@synthesize opponent;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemL *menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"BACK"];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,_contentSize.height-menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[GameCenterTestLayer node]];
	};
	[self addChild:menuItemBtn_];
	
	//adding stage
	CGSize stageSize_ = CGSizeMake(_contentSize.width, _contentSize.height-60.0f);
	stage = [CMMStage stageWithStageDef:CMMStageDefMake(stageSize_, stageSize_, CGPointZero)];
	[stage setPosition:ccp(0,_contentSize.height-stage.contentSize.height)];
	[self addChild:stage z:1];
	
	//adding player & opponent
	
	player = [CMMSObject spriteWithFile:@"Icon-Small.png"];
	opponent = [CMMSObject spriteWithFile:@"Icon-Small.png"];
	[opponent setColor:ccc3(100, 100, 255)];
	
	[player setPosition:ccp(_contentSize.width*0.5f-50.0f,_contentSize.height*0.5f)];
	[opponent setPosition:ccp(_contentSize.width*0.5f+50.0f,_contentSize.height*0.5f)];
	
	[stage.world addObject:player];
	[stage.world addObject:opponent];
	
	//custom UI
	NSString *joypadSpriteFrameFileName_ = @"IMG_JOYPAD_000.plist";
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:joypadSpriteFrameFileName_];
	joypad = [CMMCustomUIJoypad joypadWithSpriteFrameFileName:joypadSpriteFrameFileName_];
	[joypad setOpacity:100];
	[joypad setEnable:NO];
	[self addChild:joypad z:2];
	
	//packet handler
	packetDataHandler = [[CMMPacketDataHandler alloc] initWithOwner:self];
	
	displayLabel = [CMMFontUtil labelWithString:@" "];
	[self addChild:displayLabel z:3];
	
	reportingTime = _curReportingTime = 0.0f;
	
	return self;
}

-(void)setDisplayStr:(NSString *)str_{
	[displayLabel setString:str_];
	CGPoint targetPoint_ = cmmFunc_positionIPN(self, displayLabel);
	targetPoint_.y += 50.0f;
	[displayLabel setPosition:targetPoint_];
	[displayLabel stopAllActions];
	[displayLabel runAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:0.1f scale:1.3] two:[CCScaleTo actionWithDuration:0.1f scale:1.0]]];
}
-(void)sendMessageToOpponent:(NSString *)msg_{
	TestPacketType2 *packet_ = [TestPacketType2 packet];
	[packet_ setMsg:msg_];
	[gameKitHandler sendPacketToAll:packet_];
}

-(void)playGame{
	[joypad setEnable:YES];
	[self scheduleUpdate];
}

-(void)update:(ccTime)dt_{
	[joypad update:dt_];
	[stage update:dt_];
	
	_curReportingTime += dt_;
	if(reportingTime <= _curReportingTime){
		_curReportingTime = 0;
		
		if(![player body]) return;
		
		TestPacketType1 packet_;
		packet_.point = [player position];
		packet_.rotation = [player rotation];
		packet_.linearVelocity = [player body]->GetLinearVelocity();
		packet_.angularVelocity = [player body]->GetAngularVelocity();
		[gameKitHandler sendBytesToAll:&packet_ length:sizeof(packet_)];
	}
}

-(void)gameKitHandler:(CMMGameKitHandler *)gameKitHandler_ whenReceivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_{
	[packetDataHandler receivePacketData:packetData_ fromID:fromID_];
}

-(void)dealloc{
	[gameKitHandler release];
	[packetDataHandler release];
	[super dealloc];
}

-(void)cleanup{
	//must set delegate & owner to nil in cleanup method.
	[gameKitHandler setDelegate:nil];
	[packetDataHandler setOwner:nil];
	[super cleanup];
}

@end

@implementation GameCenterTestLayerMatch

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
		
	gameKitHandler = [[CMMGameKitHandlerMatch alloc] init];
	[gameKitHandler setDelegate:self];
	
	[((CMMGameKitHandlerMatch *)gameKitHandler) findMatch:2];
	[self setDisplayStr:@"finding Match..."];
	
	return self;
}

-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ whenFoundMatch:(GKMatch *)match_ withRequest:(GKMatchRequest *)request_{
	[self setDisplayStr:@"found Match... trying connect to Match..."];
	[gameKitHandler_ connectToMatch:match_ withRequest:request_];
}
-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ whenFailedFindingMatchWithError:(NSError *)error_{
	[self setDisplayStr:@"found no Match..."];
}

-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ whenConnectedToMatch:(GKMatch *)match_{
	[self setDisplayStr:@"connected Match... lets play :)"];
}
-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ whenFailedConnetingToMatch:(GKMatch *)match_ withError:(NSError *)error_{
	[self setDisplayStr:@"failed connecting match... :("];
}

-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ playerID:(NSString *)playerID_ didChangeState:(GKPlayerConnectionState)state_{
	switch(state_){
		case GKPlayerStateConnected:
			CCLOG(@"test : me : %@, other : %@",[gameKitHandler myIdentifier],playerID_);
			break;
		default: break;
	}
}
-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ whenMatchFailedWithError:(NSError *)error_{
	CCLOG(@"whenMatchFailedWithError %@",[error_ debugDescription]);
}
-(BOOL)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ shouldReinvitePlayer:(NSString *)playerID_{
	return YES;
}

@end

@implementation GameCenterTestLayerSession

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	gameKitHandler = [[CMMGameKitHandlerSession alloc] init];
	[gameKitHandler setDelegate:self];
	
	NSString *sessionID_ = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
	CCLOG(@"Session test - SessionID : %@",sessionID_);
	[((CMMGameKitHandlerSession *)gameKitHandler) openGameSessionWithSessionID:sessionID_ displayName:@"Test Game" sessionMode:GKSessionModePeer];
	[self setDisplayStr:@"finding connection..."];
	
	return self;
}

-(void)gameKitHandlerSession:(CMMGameKitHandlerSession *)gameKitHandler_ whenFoundConnectionWithPeer:(NSString *)peerID_{
	[self setDisplayStr:@"found connection... trying connect to connection..."];
	[gameKitHandler_ connectToPeer:peerID_];
}
-(void)gameKitHandlerSession:(CMMGameKitHandlerSession *)gameKitHandler_ whenFailedConnectionWithPeer:(NSString *)peerID_ withError:(NSError *)error_{
	
}
-(void)gameKitHandlerSession:(CMMGameKitHandlerSession *)gameKitHandler_ whenSessionFailedWithError:(NSError *)error_{
	
}

-(void)gameKitHandlerSession:(CMMGameKitHandlerSession *)gameKitHandler_ peer:(NSString *)peerID_ didChangeState:(GKPeerConnectionState)state_{
}

@end
