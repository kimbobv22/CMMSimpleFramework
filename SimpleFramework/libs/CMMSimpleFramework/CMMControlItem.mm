//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItem.h"

@implementation CMMControlItem
@synthesize delegate,isEnable,userData;

+(id)controlItemWithFrameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithFrameSize:frameSize_] autorelease];
}
-(id)initWithFrameSize:(CGSize)frameSize_{
	if(!(self = [super initWithColor:ccc4(0.0f, 0.0f, 0.0f, 0.0f) width:frameSize_.width height:frameSize_.height])) return self;
	
	isEnable = YES;
	userData = nil;
	_doRedraw = YES;
	
	return self;
}

#if COCOS2D_DEBUG >= 1
-(void)draw{
	ccDrawColor4B(0, 255, 0, 180);
	glLineWidth(1.0f);
	ccDrawRect(CGPointZero, ccp(contentSize_.width,contentSize_.height));
	[super draw];
}
#endif

-(void)redraw{
	_doRedraw = NO;
	_redrawDelayTime = 0.0f;
}
-(void)update:(ccTime)dt_{
	_redrawDelayTime = MIN(_redrawDelayTime+dt_,cmmVarCMMControlItem_redrawDelayTime);
	if(_doRedraw && _redrawDelayTime >= cmmVarCMMControlItem_redrawDelayTime)
		[self redraw];
}

-(void)dealloc{
	[userData release];
	[super dealloc];
}

@end
