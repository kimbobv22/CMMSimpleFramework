//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMTouchDispatcher.h"
#import "CMMTouchUtil.h"

@interface CMMSprite : CCSprite<CMMTouchDispatcherDelegate>{
	float touchCancelDistance;
}

@property (nonatomic, readwrite) float touchCancelDistance;

@end
