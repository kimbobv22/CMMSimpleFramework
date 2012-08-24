//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface StageTestLayer : CMMLayer<CMMStageDelegate,CMMStageTouchDelegate,CMMMenuItemDelegate>{
	CMMStage *stage;
	CCLabelTTF *labelGravity;
	
	BOOL _isOnDrag,_isOnDragObject;
	CGPoint _curTouchPoint;
	CMMSObject *_dragObject;
}

-(void)update:(ccTime)dt_;

@end
