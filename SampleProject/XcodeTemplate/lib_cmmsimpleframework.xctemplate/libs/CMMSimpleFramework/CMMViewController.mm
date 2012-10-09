//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMViewController.h"

@implementation CMMViewController

-(NSUInteger)supportedInterfaceOrientations{
	return [[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:[[[CCDirector sharedDirector] view] window]];
}
-(BOOL)shouldAutorotate{
	return YES;
}

@end
