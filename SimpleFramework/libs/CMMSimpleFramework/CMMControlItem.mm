//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMControlItem.h"

@implementation CMMControlItem
@synthesize delegate,isEnable,userData;

+(id)controlItemWithFrameSize:(CGSize)frameSize_{
	return [[[self alloc] initWithFrameSize:frameSize_] autorelease];
}
-(id)initWithFrameSize:(CGSize)frameSize_{
#if COCOS2D_DEBUG >= 1
	if(!(self = [super initWithColor:ccc4(180.0f, 0.0f, 0.0f, 180.0f) width:frameSize_.width height:frameSize_.height])) return self;
#else
	if(!(self = [super initWithColor:ccc4(0.0f, 0.0f, 0.0f, 0.0f) width:frameSize_.width height:frameSize_.height])) return self;
#endif
	
	
	isEnable = YES;
	userData = nil;
	
	return self;
}

-(void)redraw{}

-(void)dealloc{
	[userData release];
	[super dealloc];
}

@end
