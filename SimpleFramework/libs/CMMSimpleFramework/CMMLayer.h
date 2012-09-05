//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMacro.h"
#import "CMMTouchUtil.h"
#import "CMMTouchDispatcher.h"
#import "CMMPopupDispatcher.h"
#import "CMMMotionDispatcher.h"

@interface CMMLayer : CCLayerColor<CMMTouchDispatcherDelegate,CMMPopupDispatcherDelegate,CMMMotionDispatcherDelegate>{
	CMMTouchDispatcher *touchDispatcher;
	BOOL isAvailableMotion;
}

-(void)loadingProcess000; //first loading seq
-(void)whenLoadingEnded;

@property (nonatomic, readonly) CMMTouchDispatcher *touchDispatcher;
@property (nonatomic, readwrite) BOOL isAvailableMotion;

@end

