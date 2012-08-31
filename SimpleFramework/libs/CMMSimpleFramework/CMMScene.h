//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMGLView.h"
#import "CMMLayerPopup.h"
#import "CMMTouchDispatcherScene.h"
#import "CMMNoticeDispatcher.h"
#import "CMMLoadingObject.h"

@interface CMMScene : CCScene<CMMGLViewTouchDelegate,CMMLoadingObjectDelegate>{
	CMMLayer *runningLayer;
	
	CCArray *_pushLayerList;
	CCLayerColor *_transitionLayer;
	BOOL isOnTransition;
	ccTime fadeTime;
	
	CMMLoadingObject *_loadingObject;
	CMMTouchDispatcherScene *touchDispatcher;
	CMMPopupDispatcher *popupDispatcher;
	CMMNoticeDispatcher *noticeDispatcher;
}

+(id)sharedScene;

-(void)update:(ccTime)dt_;
-(void)pushLayer:(CMMLayer *)layer_;

@property (nonatomic, readonly) CMMLayer *runningLayer;
@property (nonatomic, readwrite) ccColor3B transitionColor;
@property (nonatomic, readonly) BOOL isOnTransition;
@property (nonatomic, readwrite) ccTime fadeTime;
@property (nonatomic, readonly) CMMTouchDispatcherScene *touchDispatcher;
@property (nonatomic, readonly) CMMPopupDispatcher *popupDispatcher;
@property (nonatomic, readonly) CMMNoticeDispatcher *noticeDispatcher;

@end

@interface CMMScene(Popup)

-(void)openPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_;
-(void)openPopupAtFirst:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_;

-(void)closePopup:(CMMLayerPopup *)popup_ withData:(id)data_;
-(void)closePopup:(CMMLayerPopup *)popup_;

@end