//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"

@implementation CMMLayer
@synthesize touchDispatcher;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	[self setAnchorPoint:CGPointZero];
	[self setIgnoreAnchorPointForPosition:NO];
	[self setTouchEnabled:YES];
	
	touchDispatcher = [[CMMTouchDispatcher alloc] initWithTarget:self];
	
	return self;
}

-(void)registerWithTouchDispatcher{} // do not use CCTouchDispatcher

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return _touchEnabled;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchBegan:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchMoved:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchEnded:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchCancelled:touch_ event:event_];
}

-(void)dealloc{
	[touchDispatcher release];
	[super dealloc];
}

@end
