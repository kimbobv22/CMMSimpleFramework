//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItem.h"

@implementation CMMControlItem{
	ccTime _redrawDelayTime;
	BOOL _doRedraw;
}
@synthesize enable,disabledColor,doRedraw = _doRedraw;

+(id)controlItemWithFrameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithFrameSize:frameSize_] autorelease];
}
-(id)initWithFrameSize:(CGSize)frameSize_{
	if(!(self = [super initWithColor:ccc4(0, 0, 0, 255) width:frameSize_.width height:frameSize_.height])) return self;
	
	enable = YES;
	disabledColor = ccc3(180, 180, 180);
	_doRedraw = NO;
	
	[self scheduleUpdate];
	
	return self;
}


-(void)draw{
	[super draw];
	if(_doRedraw && _redrawDelayTime >= cmmVarCMMControlItem_redrawDelayTime)
		[self redraw];
#if COCOS2D_DEBUG >= 1
	ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	ccDrawColor4B(0, 255, 0, 180);
	glLineWidth(1.0f);
	ccDrawRect(CGPointZero, ccpFromSize(_contentSize));
#endif
}

-(void)redraw{
	_doRedraw = NO;
	_redrawDelayTime = 0.0f;
}
-(void)update:(ccTime)dt_{
	_redrawDelayTime = MIN(_redrawDelayTime+dt_,cmmVarCMMControlItem_redrawDelayTime);
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return enable;
}

@end
