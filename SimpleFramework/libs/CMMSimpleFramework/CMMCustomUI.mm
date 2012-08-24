//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMCustomUI.h"

@implementation CMMCustomUI
@synthesize delegate;

-(void)update:(ccTime)dt_{}

-(void)dealloc{
	[delegate release];
	[super dealloc];
}

@end
