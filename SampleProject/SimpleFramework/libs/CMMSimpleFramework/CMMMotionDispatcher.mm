//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMotionDispatcher.h"

@implementation CMMMotionObserver
@synthesize target,block;

+(id)observerWithTarget:(id)target_ block:(void(^)(CMMMotionState state_))block_{
	return [[[self alloc] initWithTarget:target_ block:block_] autorelease];
}
-(id)initWithTarget:(id)target_ block:(void(^)(CMMMotionState state_))block_{
	if(!(self = [super init])) return self;
	
	[self setTarget:target_];
	[self setBlock:block_];
	
	return self;
}

-(void)dealloc{
	[target release];
	[block release];
	[super dealloc];
}

@end

static CMMMotionDispatcher *_sharedCMMMotionDispatcher_ = nil;

@interface CMMMotionDispatcher(Private)

-(uint)_indexOfTarget:(id)target_;
-(void)_removeObserverAtIndex:(uint)index_;

@end

@implementation CMMMotionDispatcher(Private)

-(uint)_indexOfTarget:(id)target_{
	ccArray *data_ = observerList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMMotionObserver *observer_ = data_->arr[index_];
		if([observer_ target] == target_){
			return index_;
		}
	}
	
	return NSNotFound;
}
-(void)_removeObserverAtIndex:(uint)index_{
	[observerList removeObjectAtIndex:index_];
}

@end

@implementation CMMMotionDispatcher
@synthesize motion,observerList,motionFixState,updateInterval;

+(CMMMotionDispatcher *)sharedDispatcher{
	if(!_sharedCMMMotionDispatcher_){
		_sharedCMMMotionDispatcher_ = [[self alloc] init];
	}
	
	return _sharedCMMMotionDispatcher_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	observerList = [[CCArray alloc] init];
	
	motion = [[CMMotionManager alloc] init];
	if(motion.gyroAvailable){
		[motion startDeviceMotionUpdates];
	}else{
		CCLOG(@"CMMMotionDispatcher : gyro is not available");
		[motion release];
		motion = nil;
	}
	
	motionFixState = CMMMotionState();
	[self setUpdateInterval:1.0f/30.0f];
	
	return self;
}

-(void)addMotionBlockForTarget:(id)target_ block:(void(^)(CMMMotionState motionState_))block_{
	[self removeMotionBlockForTarget:target_];
	[observerList addObject:[CMMMotionObserver observerWithTarget:target_ block:block_]];
}
-(void)removeMotionBlockForTarget:(id)target_{
	uint index_ = [self _indexOfTarget:target_];
	if(index_ != NSNotFound){
		[self _removeObserverAtIndex:index_];
	}
}

-(void)setUpdateInterval:(ccTime)updateInterval_{
	updateInterval = updateInterval_;
	if(!motion) return;
	[motion setDeviceMotionUpdateInterval:updateInterval];
	SEL targetSelector_ = @selector(update);
	CCScheduler *sharedScheduler_ = [[CCDirector sharedDirector] scheduler];
	[sharedScheduler_ unscheduleSelector:targetSelector_ forTarget:self];
	[sharedScheduler_ scheduleSelector:targetSelector_ forTarget:self interval:updateInterval paused:NO];
}

-(void)update{
	CMAttitude *attitude_ = [[motion deviceMotion] attitude];
	_motionState.roll = attitude_.roll+motionFixState.roll;
	_motionState.pitch = attitude_.pitch+motionFixState.pitch;
	_motionState.yaw = attitude_.yaw+motionFixState.yaw;
	
	ccArray *data_ = observerList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMMotionObserver *observer_ = data_->arr[index_];
		[observer_ block](_motionState);
	}
}

-(void)dealloc{
	[observerList release];
	[motion release];
	[super dealloc];
}

@end
