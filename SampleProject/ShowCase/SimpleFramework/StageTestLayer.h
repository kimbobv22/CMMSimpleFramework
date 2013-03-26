//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

enum StageControlType{
	StageControlType_addBox = 0,
	StageControlType_addBall,
	StageControlType_addLight,
	StageControlType_paintMap,
	StageControlType_eraseMap,
	StageControlType_drawImage,
	
	StageControlType_maxCount,
};

@interface StageTestLayer : CMMLayer{
	CMMMenuItemSet *stageSelector;
}

@end

@interface ViewStageTest : CMMLayer<CMMGestureDelegate>{
	CMMStage *stage;
	CMMScrollMenuV *controlMenu;
	
	CMMControlItemSlider *_gravitySlider;
	StageControlType _stageControlType;
}

+(id)stage;
+(id)layerWithStage:(CMMStage *)stage_;
-(id)initWithStage:(CMMStage *)stage_;

-(CMMSObject *)addBoxAtPoint:(CGPoint)point_;
-(CMMSBall *)addBallAtPoint:(CGPoint)point_;
-(void)addLightAtPoint:(CGPoint)point_;

@property (nonatomic, readonly) CMMScrollMenuV *controlMenu;

@end

@interface ViewStageTestBasic : ViewStageTest

@end

@interface ViewStageTestPixel : ViewStageTest

@end

@interface ViewStageTestTile : ViewStageTest

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
