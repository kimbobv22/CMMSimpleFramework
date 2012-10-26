//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMMacro.h"

#define cmmVarCMMSequenceMaker_defaultSequenceFormatter @"sequence%03d"

@class CMMSequenceMaker;

typedef enum{
	CMMSequenceMakerState_stop,
	CMMSequenceMakerState_onSequence,
	CMMSequenceMakerState_waitingNextSequence,
	CMMSequenceMakerState_pause,
} CMMSequenceMakerState;

@protocol CMMSequenceMakerDelegate <NSObject>

@optional
-(void)sequenceMakerDidStart:(CMMSequenceMaker *)sequenceMaker_;
-(void)sequenceMakerDidEnd:(CMMSequenceMaker *)sequenceMaker_;

-(void)sequenceMaker:(CMMSequenceMaker *)sequenceMaker_ didChangeState:(CMMSequenceMakerState)state_;

@end

@interface CMMSequenceMaker : NSObject{
	id<CMMSequenceMakerDelegate> delegate;
	
	id _target;
	NSString *sequenceMethodFormatter;
	uint curSequence,sequenceCount;
	CMMSequenceMakerState sequenceState;
	ccTime sequenceTimeInterval;
}

+(id)sequenceMaker;

-(void)startWithTarget:(id)target_;
-(void)start;
-(void)startWithMethodFormatter:(NSString *)methodFormatter_ target:(id)target_;
-(void)startWithMethodFormatter:(NSString *)methodFormatter_;

-(void)stepSequenceTo:(uint)sequence_;
-(void)stepSequence;

@property (nonatomic, assign) id<CMMSequenceMakerDelegate> delegate;
@property (nonatomic, copy) NSString *sequenceMethodFormatter;
@property (nonatomic, readonly) uint curSequence,sequenceCount;
@property (nonatomic, readwrite) CMMSequenceMakerState sequenceState;
@property (nonatomic, readwrite) ccTime sequenceTimeInterval;

@end

@interface CMMSequenceMaker(System)

-(void)_doSequence; // do not call from outter class

@end

@interface CMMSequenceMakerAuto : CMMSequenceMaker

@end
