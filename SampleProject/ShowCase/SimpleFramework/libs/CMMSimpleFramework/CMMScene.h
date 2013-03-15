//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMType.h"
#import "CMMGLView.h"
#import "CMMTouchDispatcher.h"
#import "CMMPopupView.h"
#import "CMMNoticeDispatcher.h"

@class CMMScene;

typedef void(^CMMSceneTransitionBlock)(void);

@protocol CMMSceneTransitionLayerProtocol <NSObject>

@required
-(void)scene:(CMMScene *)scene_ didStartTransitionWithCallbackAction:(CCCallFunc *)callbackAction_;
-(void)scene:(CMMScene *)scene_ didEndTransitionWithCallbackAction:(CCCallFunc *)callbackAction_;

@end

@interface CMMSceneTransitionLayer : CCLayerColor<CMMSceneTransitionLayerProtocol>

@end

@interface CMMSceneTransitionLayer_FadeInOut : CMMSceneTransitionLayer{
	ccTime fadeTime;
}

@property (nonatomic, readwrite) ccTime fadeTime;

@end

@interface CMMLayer(SceneDelegate)

-(void)sceneDidEndTransition:(CMMScene *)scene_;

@end

@interface CMMSceneFrontLayer : CCLayer{
	void (^filter_sceneDidChangeLayer)(CMMScene *scene_);
}

@property (nonatomic, copy) void (^filter_sceneDidChangeLayer)(CMMScene *scene_);

-(void)setFilter_sceneDidChangeLayer:(void (^)(CMMScene *scene_))block_;

@end

#define cmmVarCMMScene_frontLayerZOrder NSIntegerMax
#define cmmVarCMMScene_popupViewZOrder (cmmVarCMMScene_frontLayerZOrder-1)

@interface CMMScene : CCScene<CMMGLViewTouchDelegate>{
	CMMLayer *runningLayer;
	
	CMMSceneTransitionLayer *transitionLayer;
	BOOL onTransition;
	
	CMMTouchDispatcher *touchDispatcher;
	CMMPopupView *popupView;
	CMMNoticeDispatcher *noticeDispatcher;
	
	BOOL touchEnable;
	
	CCNode *defaultBackGroundNode;
	CMMSceneFrontLayer *frontLayer;
}

+(CMMScene *)sharedScene;

-(void)pushLayer:(CMMLayer *)layer_;

@property (nonatomic, readonly) CMMLayer *runningLayer;
@property (nonatomic, retain) CMMSceneTransitionLayer *transitionLayer;
@property (nonatomic, readonly, getter = isOnTransition) BOOL onTransition;
@property (nonatomic, readonly) NSDictionary *staticLayers;
@property (nonatomic, readonly) uint countOfStaticLayers;
@property (nonatomic, readonly) CMMTouchDispatcher *touchDispatcher;
@property (nonatomic, readonly) CMMPopupView *popupView;
@property (nonatomic, readonly) CMMNoticeDispatcher *noticeDispatcher;
@property (nonatomic, readwrite, getter = isTouchEnable) BOOL touchEnable;
@property (nonatomic, assign) CCNode *defaultBackGroundNode;
@property (nonatomic, readonly) CMMSceneFrontLayer *frontLayer;

@end

@interface CMMScene(StaticLayer)

-(void)setStaticLayer:(CMMLayer *)layer_ forKey:(NSString *)key_;

-(void)removeStaticLayerForKey:(NSString *)key_;
-(void)removeAllStaticLayers;

-(CMMLayer *)staticLayerForKey:(NSString *)key_;

-(void)pushStaticLayerForKey:(NSString *)key_;

@end

@interface CMMScene(Popup)

-(void)openPopup:(CMMPopupLayer *)popup_;
-(void)openPopupAtFirst:(CMMPopupLayer *)popup_;

@end

@interface CMMScene(ViewController)

-(void)presentViewController:(UIViewController *)viewController_ animated:(BOOL)animated_ completion:(void (^)(void))completion_ NS_AVAILABLE_IOS(5_0);

@end