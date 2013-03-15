//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSObjectSView.h"
#import "CMMSObject.h"

@implementation CMMSObjectSView
@synthesize target;

+(id)stateViewWithTarget:(CMMSObject *)target_{
	return [[[self alloc] initWithTarget:target_] autorelease];
}
-(id)initWithTarget:(CMMSObject *)target_{
	if(!(self = [super init])) return self;
	[self setIgnoreAnchorPointForPosition:NO];
	[self setAnchorPoint:CGPointZero];
	
	target = [target_ retain];
	
	return self;
}

-(void)update:(ccTime)dt_{
	if(target) [self setPosition:[target position]];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{}

-(void)dealloc{
	[target release];
	[super dealloc];
}

@end
