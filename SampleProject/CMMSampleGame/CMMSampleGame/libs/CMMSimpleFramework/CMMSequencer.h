//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMMacro.h"

typedef enum{
	CMMSequenceQueueType_main,
	CMMSequenceQueueType_background,
} CMMSequenceQueueType;

@interface CMMSequenceBlock : NSObject{
	CMMSequenceQueueType queueType;
	void (^block)(),(^callback)();
}

+(id)blockWithQueueType:(CMMSequenceQueueType)queueType_ block:(void(^)())block_ callback:(void(^)())callback_;
-(id)initWithQueueType:(CMMSequenceQueueType)queueType_ block:(void(^)())block_ callback:(void(^)())callback_;

@property (nonatomic, readwrite) CMMSequenceQueueType queueType;
@property (nonatomic, copy) void (^block)(),(^callback)();

@end

typedef enum{
	CMMSequencerState_stop,
	CMMSequencerState_onSequence,
	CMMSequencerState_waitingNextSequence,
} CMMSequencerState;

@interface CMMSequencer : NSObject{
	CCArray *sequences;
	CMMSequencerState state;
	int sequenceIndex,_tSequenceIndex;
	BOOL cleanupWhenAllSequencesEnded;
	
	void (^callback_whenStateChanged)();
	void (^callback_whenSequenceIndexChanged)(int currentIndex_, int beforeIndex_);
}

+(CMMSequencer *)sequencer;

-(void)addSequenceForMainQueue:(void(^)())block_ callback:(void(^)())callback_;
-(void)addSequenceForMainQueue:(void(^)())block_;
-(void)addSequenceForBackgroundQueue:(void(^)())block_ callback:(void(^)())callback_;
-(void)addSequenceForBackgroundQueue:(void(^)())block_;
-(void)removeSequenceAtIndex:(int)index_;

-(void)callSequenceAtIndex:(int)index_;
-(void)callSequence;
-(void)reset;

-(void)cleanup;

@property (nonatomic, readonly) CCArray *sequences;
@property (nonatomic, readonly) CMMSequencerState state;
@property (nonatomic, readonly) int sequenceIndex;
@property (nonatomic, readwrite, getter = isCleanupWhenAllSequencesEnded)BOOL cleanupWhenAllSequencesEnded;
@property (nonatomic, readonly) uint count;
@property (nonatomic, copy) void (^callback_whenStateChanged)();
@property (nonatomic, copy) void (^callback_whenSequenceIndexChanged)(int currentIndex_, int beforeIndex_);

-(void)setCallback_whenSequenceIndexChanged:(void (^)(int currentIndex_, int beforeIndex_))block_;

@end

@interface CMMSequencerAuto : CMMSequencer

@end