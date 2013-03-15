//  Created by JGroup(kimbobv22@gmail.com)

#import "CCLayer.h"
#import "CMMSType.h"
#import "CMMTouchDispatcher.h"

@class CMMSObject;

@interface CMMSObjectSView : CCNode<CMMTouchDispatcherDelegate>{
	CMMSObject *target;
}

+(id)stateViewWithTarget:(CMMSObject *)target_;
-(id)initWithTarget:(CMMSObject *)target_;

-(void)update:(ccTime)dt_;

@property (nonatomic, retain) CMMSObject *target;

@end
