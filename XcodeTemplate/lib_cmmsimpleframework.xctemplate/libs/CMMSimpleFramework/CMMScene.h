//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMType.h"
#import "CMMGLView.h"
#import "CMMLayerPopup.h"
#import "CMMTouchDispatcher.h"
#import "CMMNoticeDispatcher.h"
#import "CMMSequenceMaker.h"

@protocol CMMSceneLoadingProtocol <NSObject>

@optional
-(void)sceneDidStartLoading:(CMMScene *)scene_;
-(void)sceneDidEndLoading:(CMMScene *)scene_;

-(void)sceneLoadingProcess000; //first loading seq

@end

@interface CMMSceneStaticLayerItem : NSObject{
	NSString *key;
	BOOL isFirstLoad;
	CMMLayer<CMMSceneLoadingProtocol> *layer;
}

+(id)staticLayerItemWithLayer:(CMMLayer<CMMSceneLoadingProtocol> *)layer_ key:(NSString *)key_;
-(id)initWithLayer:(CMMLayer<CMMSceneLoadingProtocol> *)layer_ key:(NSString *)key_;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, readwrite) BOOL isFirstLoad;
@property (nonatomic, retain) CMMLayer<CMMSceneLoadingProtocol> *layer;

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

@interface CMMScene : CCScene<CMMGLViewTouchDelegate,CMMSequenceMakerDelegate>{
	CMMLayer<CMMSceneLoadingProtocol> *runningLayer;
	
	CCArray *_pushLayerList;
	CMMSceneTransitionLayer *transitionLayer;
	BOOL isOnTransition;
	
	CCArray *staticLayerItemList;
	
	CMMSequenceMakerAuto *_preSequencer;
	CMMTouchDispatcher *touchDispatcher;
	CMMPopupDispatcher *popupDispatcher;
	CMMNoticeDispatcher *noticeDispatcher;
	
	BOOL isTouchEnable;
}

+(CMMScene *)sharedScene;

-(void)pushLayer:(CMMLayer<CMMSceneLoadingProtocol> *)layer_;

@property (nonatomic, readonly) CMMLayer<CMMSceneLoadingProtocol> *runningLayer;
@property (nonatomic, retain) CMMSceneTransitionLayer *transitionLayer;
@property (nonatomic, readonly) BOOL isOnTransition;
@property (nonatomic, readonly) CCArray *staticLayerItemList;
@property (nonatomic, readonly) uint countOfStaticLayerItem;
@property (nonatomic, readonly) CMMTouchDispatcher *touchDispatcher;
@property (nonatomic, readonly) CMMPopupDispatcher *popupDispatcher;
@property (nonatomic, readonly) CMMNoticeDispatcher *noticeDispatcher;
@property (nonatomic, readwrite) BOOL isTouchEnable;

@end

@interface CMMScene(StaticLayer)

-(void)pushStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_;
-(void)pushStaticLayerItemAtKey:(NSString *)key_;

-(void)addStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_;
-(CMMSceneStaticLayerItem *)addStaticLayerItemWithLayer:(CMMLayer<CMMSceneLoadingProtocol> *)layer_ atKey:(NSString *)key_;

-(void)removeStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_;
-(void)removeStaticLayerItemAtIndex:(uint)index_;
-(void)removeStaticLayerItemAtKey:(NSString *)key_;
-(void)removeAllStaticLayerItems;

-(CMMSceneStaticLayerItem *)staticLayerItemAtIndex:(uint)index_;
-(CMMSceneStaticLayerItem *)staticLayerItemAtKey:(NSString *)key_;
-(CMMSceneStaticLayerItem *)staticLayerItemAtLayer:(CMMLayer<CMMSceneLoadingProtocol> *)layer_;

-(uint)indexOfStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_;
-(uint)indexOfStaticLayerItemWithLayer:(CMMLayer<CMMSceneLoadingProtocol> *)layer_;
-(uint)indexOfStaticLayerItemWithKey:(NSString *)key_;

@end

@interface CMMScene(Popup)

-(void)openPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_;
-(void)openPopupAtFirst:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_;

-(void)closePopup:(CMMLayerPopup *)popup_ withData:(id)data_;
-(void)closePopup:(CMMLayerPopup *)popup_;

@end

@interface CMMScene(ViewController)

-(void)presentViewController:(UIViewController *)viewController_ animated:(BOOL)animated_ completion:(void (^)(void))completion_ NS_AVAILABLE_IOS(5_0);

@end