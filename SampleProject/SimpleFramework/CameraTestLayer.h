//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface CameraTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMCaremaManagerDelegate,CMMMotionDispatcherDelegate>{
	CMMStage *stage;
}

@end
