//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMViewController.h"

@implementation CMMViewController

-(NSUInteger)supportedInterfaceOrientations{
	UIApplication *application_ = [UIApplication sharedApplication];
	return [application_ supportedInterfaceOrientationsForWindow:[application_ keyWindow]];
}
-(BOOL)shouldAutorotate{
	return YES;
}

@end
