//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface TilemapTestLayer : CMMLayer<CMMStageTMXDelegate,CMMStageTouchDelegate>{
	CMMStageTMX *tilemapStage;
	BOOL _isOnDrag;
}

@end
