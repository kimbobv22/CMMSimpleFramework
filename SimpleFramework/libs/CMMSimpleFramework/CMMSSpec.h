//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

typedef enum{
	CMMSSpecType_none,
	CMMSSpecType_object,
	CMMSSpecType_stage,
	
	//add more..
} CMMSSpecType;

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