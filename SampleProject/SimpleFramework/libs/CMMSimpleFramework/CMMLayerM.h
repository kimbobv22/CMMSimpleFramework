//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"

@interface CMMLayerM : CMMLayer{
	CMMLayer *innerLayer;
	CMMTouchDispatcher *innerTouchDispatcher;
}

@property (nonatomic, readonly) CMMLayer *innerLayer;
@property (nonatomic, readonly) CMMTouchDispatcher *innerTouchDispatcher;

@end
