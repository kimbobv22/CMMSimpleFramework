//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

enum StageControlType{
	StageControlType_addBox = 0,
	StageControlType_addBall,
	StageControlType_paintMap,
	StageControlType_eraseMap,
	StageControlType_dragMap,
	
	StageControlType_maxCount,
};

@interface StageTestLayer : CMMLayer<CMMStageDelegate,CMMStageTouchDelegate,CMMMenuItemDelegate>{
	CMMStagePXL *stage;
	CCLabelTTF *labelGravity;
	
	BOOL _isOnTouch,_isOnTouchObject;
	CGPoint _curTouchPoint,_beforeTouchPoint;
	CMMSObject *_dragObject;
	
	CMMMenuItemLabelTTF *controlBtn;
	StageControlType stageControlType;
}

-(void)setStageControlType:(StageControlType)controlType_;

-(void)update:(ccTime)dt_;

@end
