//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSequenceMaker.h"

@implementation CMMSequenceMaker
@synthesize delegate,sequenceMethodFormatter,curSequence,sequenceState,sequenceTimeInterval;

+(id)sequenceMaker{
	return [[[self alloc] init] autorelease];
}

-(id)init{
	if(!(self = [super init])) return self;
	
	delegate = nil;
	sequenceMethodFormatter = cmmVarCMMSequenceMaker_defaultSequenceFormatter;
	curSequence = -1;
	sequenceState = CMMSequenceMakerState_stop;
	sequenceTimeInterval = 0.1f;
	
	return self;
}

-(void)setSequenceState:(CMMSequenceMakerState)sequenceState_{
	BOOL didChangeState_ = sequenceState != sequenceState_;
	sequenceState = sequenceState_;
	CCScheduler *tempScheduler_ = [[CCDirector sharedDirector] scheduler];
	[tempScheduler_ unscheduleAllSelectorsForTarget:self];
	
	switch(sequenceState){
		case CMMSequenceMakerState_stop:
			curSequence = -1;
			break;
		case CMMSequenceMakerState_pause:
			break;
		case CMMSequenceMakerState_waitingNextSequence:
			break;
		case CMMSequenceMakerState_onSequence:
			[tempScheduler_ scheduleSelector:@selector(_doSequence) forTarget:self interval:sequenceTimeInterval paused:NO];
			break;
		default: break;
	}
	
	if(didChangeState_ && cmmFuncCommon_respondsToSelector(delegate, @selector(sequenceMaker:didChangeState:))){
		[delegate sequenceMaker:self didChangeState:sequenceState];
	}
}

-(void)startWithTarget:(id)target_{
	if(!target_) return;
	
	[self setSequenceState:CMMSequenceMakerState_stop];
	_target = target_;
	
	if(cmmFuncCommon_respondsToSelector(delegate,@selector(sequenceMakerDidStart:)))
		[delegate sequenceMakerDidStart:self];
	[self stepSequence];
}
-(void)start{
	[self startWithTarget:delegate];
}
-(void)startWithMethodFormatter:(NSString *)methodFormatter_ target:(id)target_{
	[self setSequenceMethodFormatter:methodFormatter_];
	[self startWithTarget:target_];
}
-(void)startWithMethodFormatter:(NSString *)methodFormatter_{
	[self startWithMethodFormatter:methodFormatter_ target:delegate];
}

-(void)stepSequenceTo:(uint)sequence_{
	curSequence = sequence_;
	[self setSequenceState:CMMSequenceMakerState_onSequence];
}
-(void)stepSequence{
	[self stepSequenceTo:curSequence+1];
}

-(void)dealloc{
	[[[CCDirector sharedDirector] scheduler] unscheduleAllSelectorsForTarget:self];
	[delegate release];
	[sequenceMethodFormatter release];
	[super dealloc];
}

@end

@implementation CMMSequenceMaker(System)

-(void)_doSequence{
	BOOL isEnd_ = NO;
	if(!sequenceMethodFormatter){
		isEnd_ = YES;
	}else{
		SEL targetSelector_ = NSSelectorFromString([NSString stringWithFormat:sequenceMethodFormatter,curSequence]);
		if(cmmFuncCommon_respondsToSelector(_target,targetSelector_))
			[_target performSelector:targetSelector_];
		else isEnd_ = YES;
	}
	
	if(isEnd_){
		[self setSequenceState:CMMSequenceMakerState_stop];
		if(CMMSequenceMakerState_onSequence && cmmFuncCommon_respondsToSelector(delegate,@selector(sequenceMakerDidEnd:))){
			[delegate sequenceMakerDidEnd:self];
		}
		return;
	}
	
	[self setSequenceState:CMMSequenceMakerState_waitingNextSequence];
}

@end

@implementation CMMSequenceMakerAuto

@end

@implementation CMMSequenceMakerAuto(System)

-(void)_doSequence{
	[super _doSequence];
	if(sequenceState == CMMSequenceMakerState_waitingNextSequence){
		[self stepSequence];
	}
}

@end