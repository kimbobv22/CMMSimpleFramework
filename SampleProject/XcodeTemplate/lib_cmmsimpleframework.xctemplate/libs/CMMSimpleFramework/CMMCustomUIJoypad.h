//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMCustomUI.h"
#import "CMMMenuItem.h"

#define cmmVarCMMCustomUIJoypadButton_maxPushDelayTime 100.0f

@interface CMMCustomUIJoypadButton : CMMMenuItem{
	ccTime _curPushDelayTime,pushDelayTime;
	BOOL _isOnPush,isAutoPushdown;
}

-(void)update:(ccTime)dt_;

@property (nonatomic, readwrite) ccTime pushDelayTime;
@property (nonatomic, readwrite) BOOL isAutoPushdown;

@end

@class CMMCustomUIJoypadStick;

@protocol CMMCustomUIJoypadStickDelegate <NSObject>

@required
-(void)customUIJoypadStick:(CMMCustomUIJoypadStick *)stick_ whenChangedStickVector:(CGPoint)vector_;

@end

@interface CMMCustomUIJoypadStick : CMMLayer{
	id<CMMCustomUIJoypadStickDelegate> delegate;
	CMMMenuItem *_stick;
	CCSprite *_backSprite;
}

+(id)stickWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_ radius:(float)radius_;
+(id)stickWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_;

-(id)initWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_ radius:(float)radius_;
-(id)initWithStickSprite:(CCSprite *)stickSprite_ backSprite:(CCSprite *)backSprite_;

-(void)moveStickPositionTo:(CGPoint)worldPoint_;

@property (nonatomic, retain) id<CMMCustomUIJoypadStickDelegate> delegate;
@property (nonatomic, readwrite) CGPoint stickVector;

@end

@class CMMCustomUIJoypad;

@protocol CMMCustomUIJoypadDelegate <CMMCustomUIDelegate>

@optional
-(void)customUIJoypad:(CMMCustomUIJoypad *)joypad_ whenChangedStickVector:(CGPoint)vector_;

@end

#define cmmVarCMMCustomUIJoypad_positionKey_stick @"stickPos"
#define cmmVarCMMCustomUIJoypad_positionKey_buttonA @"btnA"
#define cmmVarCMMCustomUIJoypad_positionKey_buttonB @"btnB"

@interface CMMCustomUIJoypad : CMMCustomUI<CMMCustomUIJoypadStickDelegate>{
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
