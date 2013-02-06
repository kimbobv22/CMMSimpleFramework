//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

#define _HelloWorldLayer_key_ @"_HelloWorldLayer_static_key_"

@interface HelloWorldLayer : CMMLayer{
	CMMScrollMenuV *mainMenu;
	CCLabelTTF *connectionStatusLabel;
}

-(void)updateConnectionStatus;

@end
