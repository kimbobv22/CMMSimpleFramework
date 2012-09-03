//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSSpec.h"

@implementation CMMSSpec
@synthesize target,specType;

+(id)specWithTarget:(id)target_{
	return [[[self alloc] initWithTarget:target_] autorelease];
}
-(id)initWithTarget:(id)target_{
	if(!(self = [super init])) return self;
	
	target = target_;
	specType = 0x0000;
	
	return self;
}

-(id)initWithCoder:(NSCoder *)decoder_{
	if(!(self = [self initWithTarget:nil])) return self;
	
	specType = (CMMSSpecType)[decoder_ decodeIntForKey:cmmVarCMMSSpec_specType];
	
	return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder_{
	[encoder_ encodeInt:specType forKey:cmmVarCMMSSpec_specType];
}
-(id)copyWithZone:(NSZone *)zone_{
	CMMSSpec *copy_ = [[[self class] allocWithZone:zone_] initWithTarget:nil];
	copy_.specType = specType;
	return copy_;
}

@end

@implementation CMMSSpec(Handler)

-(SEL)selectorForSetter:(NSString *)variableName_{
	return NSSelectorFromString([@"set" stringByAppendingFormat:@"%@:",[variableName_ stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[variableName_ substringToIndex:1] capitalizedString]]]);
}
-(SEL)selectorForGetter:(NSString *)variableName_{
	return NSSelectorFromString(variableName_);
}


@end