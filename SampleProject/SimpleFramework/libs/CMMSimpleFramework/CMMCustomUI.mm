//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMCustomUI.h"

@implementation CMMCustomUI
@synthesize delegate,isEnable;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	isEnable = YES;
	
	return self;
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return isEnable;
}

-(void)update:(ccTime)dt_{}

-(void)dealloc{
	[delegate release];
	[super dealloc];
}

@end
