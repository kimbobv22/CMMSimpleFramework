//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSStateObject.h"

@implementation CMMSStateObject
@synthesize target;

+(id)stateWithTarget:(id)target_{
	return [[[self alloc] initWithTarget:target_] autorelease];
}
-(id)initWithTarget:(id)target_{
	if(!(self = [super init])) return self;
	
	target = target_;
	
	return self;
}

-(void)resetStateWithSpecObject:(CMMSSpecObject *)spec_{}

-(void)update:(ccTime)dt_{}

@end
