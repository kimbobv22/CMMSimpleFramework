//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMConfig.h"
#import "CMMMacro.h"
#import "CMMSimpleCache.h"

#define cmmVarCMMTouchDispather_defaultCacheCount 20

typedef enum{
	CMMTouchState_none,
	CMMTouchState_onTouchChild,
	CMMTouchState_onDrag,
	CMMTouchState_onScroll, //none touch state
	CMMTouchState_onFixed,
} CMMTouchState;

typedef struct{
	float scale,lastScale;
	float distance,lastDistance,firstDistance;
	float radians,lastRadians,firstRadians;
	
	UITouch *touch1,*touch2;
} CMMPinchState;

static inline CMMPinchState CMMPinchStateMake(float distance_,float radians_){
	CMMPinchState pinchState_;
	pinchState_.scale = pinchState_.lastScale = 1.0f;
	pinchState_.distance = pinchState_.lastDistance = pinchState_.firstDistance = distance_;
	pinchState_.radians = pinchState_.lastRadians = pinchState_.firstRadians = radians_;
	pinchState_.touch1 = pinchState_.touch2 = nil;
	return pinchState_;
}

@class CMMTouchDispatcher;

@protocol CMMTouchDispatcherDelegate<NSObject>

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_;
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_;
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_;
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_;

@optional
-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ shouldAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_;

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchBegan:(CMMPinchState)pinchState_;
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchMoved:(CMMPinchState)pinchState_;
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchEnded:(CMMPinchState)pinchState_;
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenPinchCancelled:(CMMPinchState)pinchState_;

@end

@interface CMMTouchDispatcherItem : NSObject{
	UITouch *touch;
	CCNode<CMMTouchDispatcherDelegate> *node;
}

+(id)touchItemWithTouch:(UITouch *)touch_ node:(CCNode<CMMTouchDispatcherDelegate> *)node_;
-(id)initWithTouch:(UITouch *)touch_ node:(CCNode<CMMTouchDispatcherDelegate> *)node_;

@property (nonatomic, retain) UITouch *touch;
@property (nonatomic, retain) CCNode<CMMTouchDispatcherDelegate> *node;

@end

typedef enum{
	CMMTouchSelectorID_TouchShouldAllow,
	CMMTouchSelectorID_TouchBegan,
	CMMTouchSelectorID_TouchMoved,
	CMMTouchSelectorID_TouchEnded,
	CMMTouchSelectorID_TouchCancelled,
	
	CMMTouchSelectorID_PinchBegan,
	CMMTouchSelectorID_PinchMoved,
	CMMTouchSelectorID_PinchEnded,
	CMMTouchSelectorID_PinchCancelled,
	
	CMMTouchSelectorID_maxCount,
} CMMTouchSelectorID;

@interface CMMTouchDispatcher : NSObject<NSFastEnumeration>{
	CCArray *touchList;
	CCNode *target;
	
	uint maxMultiTouchCount;
	CMMPinchState pinchState;
}

+(id)touchDispatherWithTarget:(CCNode *)target_;
-(id)initWithTarget:(CCNode *)target_;

@property (nonatomic, readonly) CCArray *touchList;
@property (nonatomic, readonly) CCNode *target;
@property (nonatomic, readonly) int touchCount;
@property (nonatomic, readwrite) uint maxMultiTouchCount;
@property (nonatomic, readonly) CMMPinchState pinchState;

@end

@interface CMMTouchDispatcher(TouchHandler)

-(void)whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_;
-(void)whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_;
-(void)whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_;
-(void)whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_;

@end

@interface CMMTouchDispatcher(PinchHandler)

-(void)whenPinchBeganWithPinchState:(CMMPinchState)pinchState_;
-(void)whenPinchMovedWithPinchState:(CMMPinchState)pinchState_;
-(void)whenPinchEndedWithPinchState:(CMMPinchState)pinchState_;
-(void)whenPinchCancelledWithPinchState:(CMMPinchState)pinchState_;

@end

@interface CMMTouchDispatcher(CMMSceneExtension)

-(void)whenTouchesBeganFromScene:(NSSet *)touches_ event:(UIEvent *)event_;
-(void)whenTouchesMovedFromScene:(NSSet *)touches_ event:(UIEvent *)event_;
-(void)whenTouchesEndedFromScene:(NSSet *)touches_ event:(UIEvent *)event_;
-(void)whenTouchesCancelledFromScene:(NSSet *)touches_ event:(UIEvent *)event_;

@end

@interface CMMTouchDispatcher(Common)

-(CMMTouchDispatcherItem *)touchItemAtIndex:(int)index_;
-(CMMTouchDispatcherItem *)touchItemAtTouch:(UITouch *)touch_;
-(CMMTouchDispatcherItem *)touchItemAtNode:(CCNode<CMMTouchDispatcherDelegate> *)node_;

-(void)addTouchItem:(CMMTouchDispatcherItem *)touchItem_;
-(CMMTouchDispatcherItem *)addTouchItemWithTouch:(UITouch *)touch_ node:(CCNode<CMMTouchDispatcherDelegate> *)node_;

-(void)removeTouchItem:(CMMTouchDispatcherItem *)touchItem_;
-(void)removeTouchItemAtTouch:(UITouch *)touch_;
-(void)removeTouchItemAtNode:(CCNode<CMMTouchDispatcherDelegate> *)node_;

-(int)indexOfTouch:(UITouch *)touch_;
-(int)indexOfNode:(CCNode<CMMTouchDispatcherDelegate> *)node_;

-(void)cancelTouch:(CMMTouchDispatcherItem *)touchItem_;
-(void)cancelTouchAtTouch:(UITouch *)touch_;
-(void)cancelTouchAtNode:(CCNode<CMMTouchDispatcherDelegate> *)node_;

@end

@interface CMMTouchDispatcher(Shared)

+(SEL)touchSelectorAtTouchSelectID:(CMMTouchSelectorID)touchSelectorID_;

@end