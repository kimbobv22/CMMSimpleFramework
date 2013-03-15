//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSprite.h"

@implementation CMMSprite
@synthesize touchCancelDistance,touchDispatcher;

-(void)initializeTouchDispatcher{ //lazy alloc
	if(touchDispatcher) return;
	touchDispatcher = [[CMMTouchDispatcher alloc] initWithTarget:self];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	if(touchDispatcher) [touchDispatcher whenTouchBegan:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	if(touchDispatcher){
		[touchDispatcher whenTouchMoved:touch_ event:event_];
		if([touchDispatcher touchCount]>0){
			return;
		}
	}
	
	if(![CMMTouchUtil isNodeInTouch:self touch:touch_ margin:touchCancelDistance]){
		[touchDispatcher_ cancelTouchAtTouch:touch_];
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	if(touchDispatcher) [touchDispatcher whenTouchEnded:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	if(touchDispatcher) [touchDispatcher whenTouchCancelled:touch_ event:event_];
}

-(void)dealloc{
	[touchDispatcher release];
	[super dealloc];
}

@end
