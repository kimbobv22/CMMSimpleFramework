//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

enum StageControlType{
	StageControlType_addBox = 0,
	StageControlType_addBall,
	StageControlType_paintMap,
	StageControlType_eraseMap,
	StageControlType_drawImage,
	StageControlType_addLight,
	
	StageControlType_maxCount,
};

@interface StageTestLayer : CMMLayer{
	CMMMenuItemSet *stageSelector;
}

@end

@interface StageTestLayerMaster : CMMLayer{
	CMMStage *stage;
	CMMScrollMenuV *controlMenu;
	CMMControlItemSlider *gravitySlider;
	CCLabelTTF *labelGravity;
	CMMMenuItemL *backBtn;
	
	BOOL _isOnTouch,_isTouchObject,_isOnDrag;
	CGPoint _curTouchPoint;
	CMMSObject *_curTouchObject;
	
	StageControlType stageControlType;
}

-(void)buildupStage;

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

@interface StageTestLayerTile : StageTestLayerMaster

@end

@interface TestHero : CMMSObject{
	CGPoint velocity;
	CMMb2ContactMask b2CMask_leg;
	BOOL _canJump;
}

-(void)jump;

@property (nonatomic, readwrite) CGPoint velocity;

@end

@interface StageTestLayerDynamicBlock : CMMLayer{
	CMMStageDNB *stage;
	TestHero *targetObject;
	CMMCustomUIJoypad *ui;
	b2Vec2 _targetObjectAccel;
	
	CCLabelTTF *worldVelocityLabel;
	ccTime _curStackTime;
}

@end
