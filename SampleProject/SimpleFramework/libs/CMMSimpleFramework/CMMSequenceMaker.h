//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMMacro.h"

#define cmmVarCMMSequenceMaker_defaultSequenceFormatter @"sequence%03d"

@class CMMSequenceMaker;

@protocol CMMSequenceMakerDelegate <NSObject>

@optional
-(void)sequenceMakerDidStart:(CMMSequenceMaker *)sequenceMaker_;
-(void)sequenceMakerDidEnd:(CMMSequenceMaker *)sequenceMaker_;

@end

@interface CMMSequenceMaker : NSObject{
	id<CMMSequenceMakerDelegate> delegate;
	
	id _target;
	NSString *sequenceMethodFormatter;
	uint curSequence;
	BOOL isOnProcess;
}

+(id)sequenceMaker;

-(void)startWithTarget:(id)target_;
-(void)start;
-(void)startWithMethodFormatter:(NSString *)methodFormatter_ target:(id)target_;
-(void)startWithMethodFormatter:(NSString *)methodFormatter_;

-(void)doSequenceTo:(uint)sequence_;
-(void)doSequence;

@property (nonatomic, retain) id<CMMSequenceMakerDelegate> delegate;
@property (nonatomic, copy) NSString *sequenceMethodFormatter;
@property (nonatomic, readonly) uint curSequence;
@property (nonatomic, readonly) BOOL isOnProcess;

@end

@interface CMMSequenceMaker(System)

-(void)_doSequence; // do not call from outter class

@end

@interface CMMSequenceMakerAuto : CMMSequenceMaker

@end
