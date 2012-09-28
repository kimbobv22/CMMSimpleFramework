//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSprite.h"

@implementation CMMSprite
@synthesize touchCancelDistance;

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	if(![CMMTouchUtil isNodeInTouch:self touch:touch_ margin:touchCancelDistance]){
		[touchDispatcher_ cancelTouchAtTouch:touch_];
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{}

@end
