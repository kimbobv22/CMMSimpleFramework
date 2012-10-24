//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface HelloWorldLayer : CMMLayer<CMMSceneLoadingProtocol,CMMScrollMenuVDelegate>{
	CMMScrollMenuV *scrollMenu1,*scrollMenu2;
	uint tempCount;
}

-(void)addMenuItem;

@end
