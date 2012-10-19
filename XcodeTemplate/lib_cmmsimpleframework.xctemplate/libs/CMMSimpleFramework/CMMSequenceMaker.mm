//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSequenceMaker.h"

@implementation CMMSequenceMaker
@synthesize delegate,sequenceMethodFormatter,curSequence,isOnProcess;

+(id)sequenceMaker{
	return [[[self alloc] init] autorelease];
}

-(id)init{
	if(!(self = [super init])) return self;
	
	delegate = nil;
	sequenceMethodFormatter = cmmVarCMMSequenceMaker_defaultSequenceFormatter;
	curSequence = -1;
	isOnProcess = NO;
	
	return self;
}

-(void)startWithTarget:(id)target_{
	if(!target_) return;
	[[[CCDirector sharedDirector] scheduler] unscheduleAllSelectorsForTarget:self];
	
	_target = target_;
	curSequence = -1;
	isOnProcess = YES;
	
	if(cmmFuncCommon_respondsToSelector(delegate,@selector(sequenceMakerDidStart:)))
		[delegate sequenceMakerDidStart:self];
	[self doSequence];
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

-(void)doSequenceTo:(uint)sequence_{
	curSequence = sequence_;
	[[[CCDirector sharedDirector] scheduler] unscheduleAllSelectorsForTarget:self];
	[[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(_doSequence) forTarget:self interval:0.1f paused:NO];
}
-(void)doSequence{
	[self doSequenceTo:curSequence+1];
}

-(void)dealloc{
	[delegate release];
	[sequenceMethodFormatter release];
	[super dealloc];
}

@end

@implementation CMMSequenceMaker(System)

-(void)_doSequence{
	[[[CCDirector sharedDirector] scheduler] unscheduleAllSelectorsForTarget:self];
	
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
		if(isOnProcess && cmmFuncCommon_respondsToSelector(delegate,@selector(sequenceMakerDidEnd:))){
			[delegate sequenceMakerDidEnd:self];
		}
		isOnProcess = NO;
	}
}

@end

@implementation CMMSequenceMakerAuto

@end

@implementation CMMSequenceMakerAuto(System)

-(void)_doSequence{
	[super _doSequence];
	if(isOnProcess){
		[self doSequence];
	}
}

@end