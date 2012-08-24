//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSSpecObject.h"

@implementation CMMSSpecObject

-(id)initWithTarget:(id)target_{
	if(!(self = [super initWithTarget:target_])) return self;
	
	specType = CMMSSpecType_object;
	
	return self;
}

@end
