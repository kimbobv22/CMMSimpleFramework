//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMotionDispatcher.h"

static CMMMotionDispatcher *_sharedCMMMotionDispatcher_ = nil;

@implementation CMMMotionDispatcher
@synthesize motion,targetList,motionFixState,updateInterval;

+(CMMMotionDispatcher *)sharedDispatcher{
	if(!_sharedCMMMotionDispatcher_){
		_sharedCMMMotionDispatcher_ = [[self alloc] init];
	}
	
	return _sharedCMMMotionDispatcher_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	targetList = [[CCArray alloc] init];
	
	motion = [[CMMotionManager alloc] init];
	if(motion.gyroAvailable){
		[motion startDeviceMotionUpdates];
	}else{
		CCLOG(@"gyro is not available");
		[motion release];
		motion = nil;
	}
	
	motionFixState = CMMMotionState();
	[self setUpdateInterval:1.0f/30.0f];
	
	return self;
}

-(void)setUpdateInterval:(ccTime)updateInterval_{
	updateInterval = updateInterval_;
	if(!motion) return;
	motion.deviceMotionUpdateInterval = updateInterval;
	[[CCDirector sharedDirector].scheduler scheduleSelector:@selector(update) forTarget:self interval:updateInterval paused:NO];
}

-(void)addTarget:(id<CMMMotionDispatcherDelegate>)target_{
	if([self indexOfTarget:target_] != NSNotFound) return;
	[targetList addObject:target_];
}

-(void)removeTarget:(id<CMMMotionDispatcherDelegate>)target_{
	if(!target_) return;
	[targetList removeObject:target_];
}
-(void)removeTargetAtIndex:(int)index_{
	[self removeTarget:[self targetAtIndex:index_]];
}

-(id<CMMMotionDispatcherDelegate>)targetAtIndex:(int)index_{
	if(index_ == NSNotFound) return nil;
	return [targetList objectAtIndex:index_];
}

-(int)indexOfTarget:(id<CMMMotionDispatcherDelegate>)target_{
	ccArray *data_ = targetList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		id<CMMMotionDispatcherDelegate> oTarget_ = data_->arr[index_];
		if(target_ == oTarget_)
			return index_;
	}
	
	return NSNotFound;
}

-(void)update{
	CMAttitude *attitude_ = motion.deviceMotion.attitude;
	_motionState.roll = attitude_.roll+motionFixState.roll;
	_motionState.pitch = attitude_.pitch+motionFixState.pitch;
	_motionState.yaw = attitude_.yaw+motionFixState.yaw;
	
	ccArray *data_ = targetList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		id<CMMMotionDispatcherDelegate> target_ = data_->arr[index_];
		
		if(cmmFuncCommon_respondsToSelector(target_, @selector(motionDispatcher:updateMotion:)))
			[target_ motionDispatcher:self updateMotion:_motionState];
	}
}

-(void)dealloc{
	[targetList release];
	[motion release];
	[super dealloc];
}

@end
