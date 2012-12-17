//  Created by JGroup(kimbobv22@gmail.com)

#import "PinchZoomTestLayer.h"
#import "HelloWorldLayer.h"

@implementation PinchZoomTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	tempSprite = [CCSprite spriteWithFile:@"Default.png"];
	[tempSprite setPosition:cmmFuncCommon_positionInParent(self, tempSprite)];
	[tempSprite setScale:0.5];
	[self addChild:tempSprite];
	
	CMMMenuItemL *menuItemBack_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2+20);
	[menuItemBack_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	}];
	[self addChild:menuItemBack_];
	
	return self;
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchBegan:(CMMPinchState)pinchState_{
	CCLOG(@"pinch start %1.1f / %1.1f ",pinchState_.scale,pinchState_.distance);
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchMoved:(CMMPinchState)pinchState_{
	float curScale_ = [tempSprite scale];
	[tempSprite setScale:curScale_ - (curScale_ * (pinchState_.lastScale - pinchState_.scale))];
	CCLOG(@"pinch change %1.1f / %1.1f ",pinchState_.scale,pinchState_.distance);
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchEnded:(CMMPinchState)pinchState_{
	CCLOG(@"pinch ended %1.1f / %1.1f ",pinchState_.scale,pinchState_.distance);
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchCancelled:(CMMPinchState)pinchState_{
	CCLOG(@"pinch cancelled %1.1f / %1.1f ",pinchState_.scale,pinchState_.distance);
}

@end
