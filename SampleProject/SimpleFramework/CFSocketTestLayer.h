//
//  CFSocketTestLayer.h
//  SimpleFramework
//
//  Created by Kim Jazz on 12. 11. 11..
//
//

#import "CMMHeader.h"

@interface CFSocketTestLayer : CMMLayer<CMMSceneLoadingProtocol>

@end

@interface CFSocketTestLayer_Master : CMMLayer<CMMSceneLoadingProtocol,CMMSocketHandlerDelegate>{
	CMMSocketHandler *socketHandler;
	CCLabelTTF *labelDisplay;
}

-(void)setDisplayString:(NSString *)str_;

@end

@interface CFSocketTestLayer_MasterServer : CFSocketTestLayer_Master

@end

@interface CFSocketTestLayer_MasterClient : CFSocketTestLayer_Master{
	CMMControlItemText *hostTextField;
	CMMMenuItemLabelTTF *connectBtn;
}

-(void)connectToHost;

@end
