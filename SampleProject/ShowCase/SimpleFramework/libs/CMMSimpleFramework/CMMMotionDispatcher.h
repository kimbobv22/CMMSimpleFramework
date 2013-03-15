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

@interface CMMMotionObserver : NSObject{
	id target;
	void (^block)(CMMMotionState state_);
}

+(id)observerWithTarget:(id)target_ block:(void(^)(CMMMotionState state_))block_;
-(id)initWithTarget:(id)target_ block:(void(^)(CMMMotionState state_))block_;

@property (nonatomic, retain) id target;
@property (nonatomic, copy) void (^block)(CMMMotionState state_);

@end

@interface CMMMotionDispatcher : NSObject{
	CMMotionManager *motion;
	CCArray *observerList;
	CMMMotionState _motionState,motionFixState;
	ccTime updateInterval;
}

+(CMMMotionDispatcher *)sharedDispatcher;

-(void)addMotionBlockForTarget:(id)target_ block:(void(^)(CMMMotionState motionState_))block_;
-(void)removeMotionBlockForTarget:(id)target_;

@property (nonatomic, readonly) CMMotionManager *motion;
@property (nonatomic, readonly) CCArray *observerList;
@property (nonatomic, readwrite) CMMMotionState motionFixState;
@property (nonatomic, readwrite) ccTime updateInterval;

@end
