//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSType.h"

typedef uint16 CMMSSpecType;

#define cmmVarCMMSSpec_specType @"m0"

@interface CMMSSpec : NSObject<NSCopying,NSCoding>{
	id target;
	CMMSSpecType specType;
}

+(id)specWithTarget:(id)target_;
-(id)initWithTarget:(id)target_;

@property (nonatomic, assign) id target;
@property (nonatomic, readwrite) CMMSSpecType specType;

@end

@interface CMMSSpec(Handler)

-(SEL)selectorForSetter:(NSString *)variableName_;
-(SEL)selectorForGetter:(NSString *)variableName_;

@end