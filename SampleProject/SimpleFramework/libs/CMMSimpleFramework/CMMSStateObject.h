//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMSSpecObject.h"

/*
 this is empty class for Extension of CMSObject
 for example, if you need object with 'HP' Attribute, inheritance this, and add variable named 'HP'
 
 Refer the example At CMMSObject_Test.h
 */

@interface CMMSStateObject : NSObject{
	id target;
}

+(id)stateWithTarget:(id)target_;
-(id)initWithTarget:(id)target_;

-(void)resetStateWithSpecObject:(CMMSSpecObject *)spec_;

-(void)update:(ccTime)dt_;

@property (nonatomic, assign) id target;

@end