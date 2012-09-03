//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSSpecObject.h"

@implementation CMMSSpecObject

-(id)initWithTarget:(id)target_{
	if(!(self = [super initWithTarget:target_])) return self;
	
	specType = 0x1001;
	
	return self;
}

@end
