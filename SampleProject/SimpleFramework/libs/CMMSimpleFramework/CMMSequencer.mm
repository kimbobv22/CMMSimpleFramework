//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSequencer.h"

@implementation CMMSequenceBlock
@synthesize queueType,block,callback;

+(id)blockWithQueueType:(CMMSequenceQueueType)queueType_ block:(void(^)())block_ callback:(void(^)())callback_{
	return [[[self alloc] initWithQueueType:queueType_ block:block_ callback:callback_] autorelease];
}
-(id)initWithQueueType:(CMMSequenceQueueType)queueType_ block:(void(^)())block_ callback:(void(^)())callback_{
	if(!(self = [super init])) return self;
	
	queueType = queueType_;
	[self setBlock:block_];
	[self setCallback:callback_];
	
	return self;
}

-(void)dealloc{
	[block release];
	[callback release];
	[super dealloc];
}

@end

@interface CMMSequencer(Private)

-(void)_setState:(CMMSequencerState)state_;
-(void)_setSequenceIndex:(int)index_;
-(void)_callbackSequence;

@end

@implementation CMMSequencer(Private)

-(void)_setState:(CMMSequencerState)state_{
	if(state == state_) return;
	state = state_;
	if(callback_whenStateChanged){
		callback_whenStateChanged();
	}
}
-(void)_setSequenceIndex:(int)index_{
	if(sequenceIndex == index_) return;
	int beforeIndex_ = sequenceIndex;
	sequenceIndex = index_;
	if(callback_whenSequenceIndexChanged){
		callback_whenSequenceIndexChanged(sequenceIndex, beforeIndex_);
	}
}
-(void)_callbackSequence{
	++_tSequenceIndex;
	[self _setState:([self count] <= _tSequenceIndex ? CMMSequencerState_stop : CMMSequencerState_waitingNextSequence)];
	
	CMMSequenceBlock *sBlock_ = [sequences objectAtIndex:sequenceIndex];
	if([sBlock_ callback]){
		[sBlock_ callback]();
	}
}

@end

@implementation CMMSequencer
@synthesize sequences,state,sequenceIndex,count;
@synthesize callback_whenStateChanged,callback_whenSequenceIndexChanged;

+(CMMSequencer *)sequencer{
	return [[[self alloc] init] autorelease];
}
-(id)init{
	if(!(self = [super init])) return self;
	
	sequences = [[CCArray alloc] init];
	sequenceIndex = -1;
	_tSequenceIndex = 0;
	
	return self;
}

-(uint)count{
	return [sequences count];
}

-(void)_addSequence:(CMMSequenceBlock *)block_{
	[sequences addObject:block_];
}
-(void)addSequenceForMainQueue:(void(^)())block_ callback:(void(^)())callback_{
	[self _addSequence:[CMMSequenceBlock blockWithQueueType:CMMSequenceQueueType_main block:block_ callback:callback_]];
}
-(void)addSequenceForMainQueue:(void(^)())block_{
	[self addSequenceForMainQueue:block_ callback:nil];
}
-(void)addSequenceForBackgroundQueue:(void(^)())block_ callback:(void (^)())callback_{
	[self _addSequence:[CMMSequenceBlock blockWithQueueType:CMMSequenceQueueType_background block:block_ callback:callback_]];
}
-(void)addSequenceForBackgroundQueue:(void(^)())block_{
	[self addSequenceForBackgroundQueue:block_ callback:nil];
}
-(void)removeSequenceAtIndex:(int)index_{
	[sequences removeObjectAtIndex:index_];
	[self reset];
}

-(void)callSequenceAtIndex:(int)index_{
	if(index_ >= [self count]) return;
	
	_tSequenceIndex = index_;
	[self _setSequenceIndex:index_];
	[self _setState:CMMSequencerState_onSequence];
	CMMSequenceBlock *sBlock_ = [sequences objectAtIndex:sequenceIndex];
	switch([sBlock_ queueType]){
		case CMMSequenceQueueType_background:{
			cmmFuncCallDispatcher_backQueue(^{
				[sBlock_ block]();
				cmmFuncCallDispatcher_mainQueue(^{
					[self _callbackSequence];
				});
			});
			break;
		}
		case CMMSequenceQueueType_main:{
			[sBlock_ block]();
			[self _callbackSequence];
			break;
		}
	}
}
-(void)callSequence{
	[self callSequenceAtIndex:_tSequenceIndex];
}

-(void)reset{
	[self _setSequenceIndex:0];
	[self _setState:CMMSequencerState_stop];
}

-(void)cleanup{
	[sequences removeAllObjects];
	[self setCallback_whenSequenceIndexChanged:nil];
	[self setCallback_whenStateChanged:nil];
	[self reset];
}

-(void)dealloc{
	[sequences release];
	[callback_whenSequenceIndexChanged release];
	[callback_whenStateChanged release];
	[super dealloc];
}

@end

@implementation CMMSequencerAuto(Private)

-(void)_setState:(CMMSequencerState)state_{
	if(state == state_) return;
	[super _setState:state_];
}
-(void)_callbackSequence{
	[super _callbackSequence];
	if(state == CMMSequencerState_waitingNextSequence){
		[self callSequence];
	}
}

@end

@implementation CMMSequencerAuto

@end