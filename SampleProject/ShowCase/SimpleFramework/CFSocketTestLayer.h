//
//  CFSocketTestLayer.h
//  SimpleFramework
//
//  Created by Kim Jazz on 12. 11. 11..
//
//

#import "CMMHeader.h"

@interface CFSocketTestLayer : CMMLayer

@end

@interface CFSocketTestLayer_Master : CMMLayer<CMMSocketHandlerDelegate>{
	CMMSocketHandler *socketHandler;
	CCLabelTTF *labelDisplay;
}

-(void)setDisplayString:(NSString *)str_;

@end

@interface CFSocketTestLayer_MasterServer : CFSocketTestLayer_Master

@end

@interface CFSocketTestLayer_MasterClient : CFSocketTestLayer_Master{
	CMMControlItemText *hostTextField;
	CMMMenuItemL *connectBtn;
}

-(void)connectToHost;

@end
