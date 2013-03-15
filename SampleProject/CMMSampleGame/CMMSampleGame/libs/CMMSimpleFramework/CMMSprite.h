//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMTouchDispatcher.h"
#import "CMMTouchUtil.h"

@interface CMMSprite : CCSprite<CMMTouchDispatcherDelegate>{
	float touchCancelDistance;
	CMMTouchDispatcher *touchDispatcher;
}

-(void)initializeTouchDispatcher;

@property (nonatomic, readwrite) float touchCancelDistance;
@property (nonatomic, readonly) CMMTouchDispatcher *touchDispatcher;

@end
