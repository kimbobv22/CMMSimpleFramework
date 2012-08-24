//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface TilemapTestLayer : CMMLayer<CMMTilemapStageDelegate,CMMStageTouchDelegate>{
	CMMTilemapStage *tilemapStage;
	BOOL _isOnDrag;
}

@end
