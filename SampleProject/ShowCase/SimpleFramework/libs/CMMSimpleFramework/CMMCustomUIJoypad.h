//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMCustomUI.h"
#import "CMMMenuItem.h"

#define cmmVarCMMCustomUIJoypadButton_maxPushDelayTime 100.0f

@interface CMMCustomUIJoypadButton : CMMMenuItem{
	ccTime _curPushDelayTime,pushDelayTime;
	BOOL _isOnPush,autoPushdown;
}

-(void)update:(ccTime)dt_;

@property (nonatomic, readwrite) ccTime pushDelayTime;
@property (nonatomic, readwrite, getter = isAutoPushdown) BOOL autoPushdown;

@end

@interface CMMCustomUIJoypadStick : CMMLayer{
	CMMMenuItem *_stick;
	CCSprite *_backSprite;
	
	void (^callback_whenStickVectorChanged)(CGPoint vector_);
}

+(id)stickWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_ radius:(float)radius_;
+(id)stickWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_;

-(id)initWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_ radius:(float)radius_;
-(id)initWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_;

-(void)moveStickPositionTo:(CGPoint)worldPoint_;

@property (nonatomic, readwrite) CGPoint stickVector;
@property (nonatomic, copy) void (^callback_whenStickVectorChanged)(CGPoint vector_);

-(void)setCallback_whenStickVectorChanged:(void (^)(CGPoint vector_))block_;

@end

#define cmmVarCMMCustomUIJoypad_positionKey_stick @"stickPos"
#define cmmVarCMMCustomUIJoypad_positionKey_buttonA @"btnA"
#define cmmVarCMMCustomUIJoypad_positionKey_buttonB @"btnB"

@interface CMMCustomUIJoypad : CMMCustomUI{
	CMMCustomUIJoypadStick *stick;
	CMMCustomUIJoypadButton *buttonA,*buttonB;
}

+(id)joypadWithStickSprite:(CCSprite *)stickSprite_ stickBackSprite:(CCSprite *)stickBackSprite_ stickRadius:(float)stickRadius_ buttonASprite:(CCSprite *)buttonASprite_ buttonBSprite:(CCSprite *)buttonBSprite_;
+(id)joypadWithSpriteFrameFileName:(NSString *)fileName_;

-(id)initWithStickSprite:(CCSprite *)stickSprite_ stickBackSprite:(CCSprite *)stickBackSprite_ stickRadius:(float)stickRadius_ buttonASprite:(CCSprite *)buttonASprite_ buttonBSprite:(CCSprite *)buttonBSprite_;
-(id)initWithSpriteFrameFileName:(NSString *)fileName_;

-(void)resetJoypadPositionWithDictionary:(NSDictionary *)dictionary_;
-(void)resetJoypadPosition;

@property (nonatomic, readonly) CMMCustomUIJoypadStick *stick;
@property (nonatomic, readonly) CMMCustomUIJoypadButton *buttonA,*buttonB;

@end
