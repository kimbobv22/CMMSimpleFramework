//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

enum StageControlType{
	StageControlType_addBox = 0,
	StageControlType_addBall,
	StageControlType_dragMode,
	StageControlType_paintMap,
	StageControlType_eraseMap,
	StageControlType_addLight,
	
	StageControlType_maxCount,
};

@interface StageTestLayer : CMMLayer{
	CMMMenuItemSet *stageSelector;
}

@end

@interface StageTestLayerMaster : CMMLayer<CMMStageDelegate,CMMStageTouchDelegate,CMMScrollMenuDelegate>{
	CMMStage *stage;
	CMMScrollMenuV *controlMenu;
	CMMControlItemSlider *gravitySlider;
	CCLabelTTF *labelGravity;
	CMMMenuItemLabelTTF *backBtn;
	
	BOOL _isOnTouch,_isTouchObject;
	CGPoint _curTouchPoint;
	CMMSObject *_curTouchObject;
	
	StageControlType stageControlType;
}

-(CMMSObject *)addBox:(CGPoint)point_;
-(CMMSBall *)addBall:(CGPoint)point_;

-(void)update:(ccTime)dt_;

@end

@interface StageTestLayerBasic : StageTestLayerMaster

@end

@interface StageTestLayerPixel : StageTestLayerMaster{
	CGPoint _beforeTouchPoint;
}

@end

@interface StageTestLayerTile : StageTestLayerMaster<CMMStageTMXDelegate>

@end
