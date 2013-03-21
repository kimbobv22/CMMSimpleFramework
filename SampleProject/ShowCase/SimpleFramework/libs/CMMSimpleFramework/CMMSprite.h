//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMTouchDispatcher.h"
#import "CMMTouchUtil.h"

@interface CMMSprite : CCSprite<CMMTouchDispatcherDelegate>{
	CMMTouchDispatcher *touchDispatcher;
	float touchCancelDistance;
}

-(void)initializeTouchDispatcher;

@property (nonatomic, readonly) CMMTouchDispatcher *touchDispatcher;

@end
