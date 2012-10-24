//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

struct TestPacketType1{
	CGPoint point;
	float rotation;
	b2Vec2 linearVelocity;
	float32 angularVelocity;
};

#define TestPacketType2_name_msg @"p0"

@interface TestPacketType2 : CMMPacket{
	NSString *msg;
}

@property (nonatomic, copy) NSString *msg;

@end

@interface TestPacketDataHandlerItem1 : CMMPacketDataHandlerItem

@end

@interface TestPacketDataHandlerItem2 : CMMPacketDataHandlerItem

@end

@interface GameCenterTestLayer : CMMLayer<CMMSceneLoadingProtocol>{
	CMMMenuItemSet *menuSelector;
}

@end

@interface GameCenterTestLayerMaster : CMMLayer<CMMSceneLoadingProtocol,CMMGameKitHandlerDelegate>{
	CMMGameKitHandler *gameKitHandler;
	CMMStage *stage;
	CMMSObject *player,*opponent;
	CMMCustomUIJoypad *joypad;
	CMMPacketDataHandler *packetDataHandler;
	
	CCLabelTTF *displayLabel;
	ccTime reportingTime,_curReportingTime;
}

-(void)setDisplayStr:(NSString *)str_;
-(void)sendMessageToOpponent:(NSString *)msg_;

@property (nonatomic, readonly) CMMSObject *opponent;

@end

@interface GameCenterTestLayerMatch : GameCenterTestLayerMaster<CMMGameKitHandlerMatchDelegate>{
}

@end

@interface GameCenterTestLayerSession : GameCenterTestLayerMaster<CMMGameKitHandlerSessionDelegate>{
}

@end