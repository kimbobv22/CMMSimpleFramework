//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMCustomUI.h"

@implementation CMMCustomUI
@synthesize enable;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	enable = YES;
	
	return self;
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return enable;
}

-(void)update:(ccTime)dt_{}

@end
