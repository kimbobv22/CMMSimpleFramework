//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMMacro.h"
#import <CoreMotion/CoreMotion.h>

@class CMMMotionDispatcher;

struct CMMMotionState{
	CMMMotionState(){
		roll = pitch = yaw = 0;
	}
	CMMMotionState(double roll_,double pitch_,double yaw_):roll(roll_),pitch(pitch_),yaw(yaw_){}
	
	ccTime timestamp;
	double roll,pitch,yaw;
};

@protocol CMMMotionDispatcherDelegate <NSObject>

@optional
-(void)motionDispatcher:(CMMMotionDispatcher *)motionDispatcher_ updateMotion:(CMMMotionState)state_;

@end

@interface CMMMotionDispatcher : NSObject{
	CMMotionManager *motion;
	CCArray *targetList;
	CMMMotionState _motionState,motionFixState;
	ccTime updateInterval;
}

+(id)sharedDispatcher;

-(void)addTarget:(id<CMMMotionDispatcherDelegate>)target_;

-(void)removeTarget:(id<CMMMotionDispatcherDelegate>)target_;
-(void)removeTargetAtIndex:(int)index_;

-(id<CMMMotionDispatcherDelegate>)targetAtIndex:(int)index_;

-(int)indexOfTarget:(id<CMMMotionDispatcherDelegate>)target_;

@property (nonatomic, readonly) CMMotionManager *motion;
@property (nonatomic, readonly) CCArray *targetList;
@property (nonatomic, readwrite) CMMMotionState motionFixState;
@property (nonatomic, readwrite) ccTime updateInterval;

@end
