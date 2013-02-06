//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMType.h"
#import "CMMGLView.h"
#import "CMMTouchDispatcher.h"
#import "CMMPopupView.h"
#import "CMMNoticeDispatcher.h"

@interface CMMSceneStaticLayerItem : NSObject{
	NSString *key;
	CMMLayer *layer;
}

+(id)staticLayerItemWithLayer:(CMMLayer *)layer_ key:(NSString *)key_;
-(id)initWithLayer:(CMMLayer *)layer_ key:(NSString *)key_;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, retain) CMMLayer *layer;

@end

@interface CMMSceneTransitionLayer : CCLayerColor

-(void)startFadeInTransitionWithTarget:(id)target_ callbackSelector:(SEL)selector_;
-(void)startFadeOutTransitionWithTarget:(id)target_ callbackSelector:(SEL)selector_;

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
	
	CCArray *_pushLayerList;
	CMMSceneTransitionLayer *transitionLayer;
	BOOL isOnTransition;
	
	CCArray *staticLayerItemList;
	
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
@property (nonatomic, readonly) BOOL isOnTransition;
@property (nonatomic, readonly) CCArray *staticLayerItemList;
@property (nonatomic, readonly) uint countOfStaticLayerItem;
@property (nonatomic, readonly) CMMTouchDispatcher *touchDispatcher;
@property (nonatomic, readonly) CMMPopupView *popupView;
@property (nonatomic, readonly) CMMNoticeDispatcher *noticeDispatcher;
@property (nonatomic, readwrite, getter = isTouchEnable) BOOL touchEnable;
@property (nonatomic, assign) CCNode *defaultBackGroundNode;
@property (nonatomic, readonly) CMMSceneFrontLayer *frontLayer;

@end

@interface CMMScene(StaticLayer)

-(void)pushStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_;
-(void)pushStaticLayerItemAtKey:(NSString *)key_;

-(void)addStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_;
-(CMMSceneStaticLayerItem *)addStaticLayerItemWithLayer:(CMMLayer *)layer_ atKey:(NSString *)key_;

-(void)removeStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_;
-(void)removeStaticLayerItemAtIndex:(uint)index_;
-(void)removeStaticLayerItemAtKey:(NSString *)key_;
-(void)removeAllStaticLayerItems;

-(CMMSceneStaticLayerItem *)staticLayerItemAtIndex:(uint)index_;
-(CMMSceneStaticLayerItem *)staticLayerItemAtKey:(NSString *)key_;
-(CMMSceneStaticLayerItem *)staticLayerItemAtLayer:(CMMLayer *)layer_;

-(uint)indexOfStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_;
-(uint)indexOfStaticLayerItemWithLayer:(CMMLayer *)layer_;
-(uint)indexOfStaticLayerItemWithKey:(NSString *)key_;

@end

@interface CMMScene(Popup)

-(void)openPopup:(CMMPopupLayer *)popup_;
-(void)openPopupAtFirst:(CMMPopupLayer *)popup_;

@end

@interface CMMScene(ViewController)

-(void)presentViewController:(UIViewController *)viewController_ animated:(BOOL)animated_ completion:(void (^)(void))completion_ NS_AVAILABLE_IOS(5_0);

@end