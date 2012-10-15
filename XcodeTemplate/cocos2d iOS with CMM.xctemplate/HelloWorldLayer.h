//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface HelloWorldLayer : CMMLayer<CMMScrollMenuVDelegate>{
	CMMScrollMenuV *scrollMenu1,*scrollMenu2;
	uint tempCount;
}

-(void)addMenuItem;

@end
