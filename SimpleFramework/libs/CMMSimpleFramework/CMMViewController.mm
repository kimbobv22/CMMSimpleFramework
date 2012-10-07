//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMViewController.h"

@implementation CMMViewController

-(NSUInteger)supportedInterfaceOrientations{	
	return cmmVarConfig_supportedUIInterfaceOrientationMask;
}
-(BOOL)shouldAutorotate{
	return YES;
}

@end
