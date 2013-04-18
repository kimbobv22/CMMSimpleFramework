//  Created by JGroup(kimbobv22@gmail.com)

#pragma mark - basic macro

#import "CMMMacro.h"

DEPRECATED_ATTRIBUTE inline static float cmmFuncCommon_fixRadians(float radians_){
	return cmmFunc_fixRadians(radians_);
}
DEPRECATED_ATTRIBUTE inline static float cmmFuncCommon_fixDegrees(float degrees_){
	return cmmFunc_fixDegrees(degrees_);
}

DEPRECATED_ATTRIBUTE inline static inline CGPoint cmmFuncCommon_position_center(CGRect parentRect_,CGRect targetRect_,CGPoint targetAPoint_){
	return cmmFunc_positionIPN(parentRect_, targetRect_, targetAPoint_, ccp(0.5f,0.5f));
}
DEPRECATED_ATTRIBUTE inline static inline CGPoint cmmFuncCommon_position_center(CCNode *parent_,CCNode *target_){
	return cmmFunc_positionIPN(parent_, target_, ccp(0.5f,0.5f));
}

DEPRECATED_ATTRIBUTE inline static CGRect cmmFuncCommon_nodeToworldRect(CCNode *node_){
	return cmmFunc_nodeToWorldRect(node_);
}

DEPRECATED_ATTRIBUTE inline static CGPoint cmmFuncCommon_positionInParent(CGRect sourceRect_,CGRect targetRect_,CGPoint targetAPoint_,CGPoint ratio_, CGPoint offset_){
	return cmmFunc_positionIPN(sourceRect_, targetRect_, targetAPoint_, ratio_, offset_);
}
DEPRECATED_ATTRIBUTE inline static CGPoint cmmFuncCommon_positionInParent(CGRect sourceRect_,CGRect targetRect_,CGPoint targetAPoint_,CGPoint ratio_){
	return cmmFunc_positionIPN(sourceRect_,targetRect_,targetAPoint_,ratio_);
}
DEPRECATED_ATTRIBUTE inline static CGPoint cmmFuncCommon_positionInParent(CCNode *parentNode_,CCNode *targetNode_,CGPoint ratio_,CGPoint offset_){
	return cmmFunc_positionIPN(parentNode_,targetNode_,ratio_,offset_);
}
DEPRECATED_ATTRIBUTE inline static CGPoint cmmFuncCommon_positionInParent(CCNode *parentNode_,CCNode *targetNode_,CGPoint ratio_){
	return cmmFunc_positionIPN(parentNode_, targetNode_, ratio_);
}
DEPRECATED_ATTRIBUTE inline static CGPoint cmmFuncCommon_positionInParent(CCNode *parentNode_,CCNode *targetNode_){
	return cmmFunc_positionIPN(parentNode_,targetNode_);
}
DEPRECATED_ATTRIBUTE inline static CGPoint cmmFuncCommon_positionFromOtherNode(CCNode *otherNode_,CCNode *targetNode_,CGPoint ratio_,CGPoint offset_){
	return cmmFunc_positionFON(otherNode_,targetNode_,ratio_,offset_);
}
DEPRECATED_ATTRIBUTE inline static CGPoint cmmFuncCommon_positionFromOtherNode(CCNode *otherNode_,CCNode *targetNode_,CGPoint ratio_){
	return cmmFunc_positionFON(otherNode_,targetNode_,ratio_);
}

DEPRECATED_ATTRIBUTE inline static BOOL cmmFuncCommon_respondsToSelector(id target_,SEL selector_){
	return cmmFunc_respondsToSelector(target_, selector_);
}
DEPRECATED_ATTRIBUTE inline static void cmmFuncCallDispatcher_mainQueue(void(^block_)()){
	cmmFunc_callMainQueue(block_);
}
DEPRECATED_ATTRIBUTE inline static void cmmFuncCallDispatcher_backQueue(dispatch_queue_priority_t priority_,void(^block_)()){
	cmmFunc_callBackQueue(priority_, block_);
}
DEPRECATED_ATTRIBUTE inline static void cmmFuncCallDispatcher_backQueue(void(^block_)()){
	cmmFunc_callBackQueue(block_);
}

#pragma mark - common view

#import "CMMScene.h"
#import "CMMLayer.h"
#import "CMMLayerM.h"
#import "CMMLayerMD.h"
#import "CCSpriteBatchNode+SplitSprite.h"
#import "CMM9SliceBar.h"
#import "CMMDrawingManager.h"

DEPRECATED_ATTRIBUTE @protocol CMMGLViewTouchDelegate <NSObject>

-(void)glView:(id)glView_ whenTouchesBegan:(NSSet *)touches_ event:(UIEvent *)event_ DEPRECATED_ATTRIBUTE;
-(void)glView:(id)glView_ whenTouchesMoved:(NSSet *)touches_ event:(UIEvent *)event_ DEPRECATED_ATTRIBUTE;
-(void)glView:(id)glView_ whenTouchesEnded:(NSSet *)touches_ event:(UIEvent *)event_ DEPRECATED_ATTRIBUTE;
-(void)glView:(id)glView_ whenTouchesCancelled:(NSSet *)touches_ event:(UIEvent *)event_ DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @interface CMMGLView : CCGLView

@end

DEPRECATED_ATTRIBUTE @interface CMMViewController : UIViewController

/*
 Please use freely produced.
 */

@end

@interface CMMScene(Deprecated)

@property (nonatomic, readwrite) ccColor3B transitionColor DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite) ccTime fadeTime DEPRECATED_ATTRIBUTE;
@property (nonatomic, readonly) id popupDispatcher DEPRECATED_ATTRIBUTE;
@property (nonatomic, readonly, getter = _isOnTransition) BOOL isOnTransition DEPRECATED_ATTRIBUTE;
@property (nonatomic, readonly) CCArray *staticLayerItemList UNAVAILABLE_ATTRIBUTE;
@property (nonatomic, readonly) uint countOfStaticLayerItem DEPRECATED_ATTRIBUTE;

-(void)setIsTouchEnable:(BOOL)isTouchEnable_ DEPRECATED_ATTRIBUTE;

-(void)closePopup:(CMMPopupLayer *)popup_ withData:(id)data_ DEPRECATED_ATTRIBUTE;
-(void)closePopup:(CMMPopupLayer *)popup_ DEPRECATED_ATTRIBUTE;

-(void)openPopup:(CMMPopupLayer *)popup_ delegate:(id)delegate_ DEPRECATED_ATTRIBUTE;
-(void)openPopupAtFirst:(CMMPopupLayer *)popup_ delegate:(id)delegate_ DEPRECATED_ATTRIBUTE;

/////////////////static layer/////////////////////

-(void)pushStaticLayerItem:(id)staticLayerItem_ UNAVAILABLE_ATTRIBUTE;
-(void)pushStaticLayerItemAtKey:(NSString *)key_ DEPRECATED_ATTRIBUTE;

-(void)addStaticLayerItem:(id)staticLayerItem_ UNAVAILABLE_ATTRIBUTE;
-(id)addStaticLayerItemWithLayer:(CMMLayer *)layer_ atKey:(NSString *)key_ DEPRECATED_ATTRIBUTE;

-(void)removeStaticLayerItem:(id)staticLayerItem_ UNAVAILABLE_ATTRIBUTE;
-(void)removeStaticLayerItemAtIndex:(uint)index_ UNAVAILABLE_ATTRIBUTE;
-(void)removeStaticLayerItemAtKey:(NSString *)key_ DEPRECATED_ATTRIBUTE;
-(void)removeAllStaticLayerItems DEPRECATED_ATTRIBUTE;

-(id)staticLayerItemAtIndex:(uint)index_ UNAVAILABLE_ATTRIBUTE;
-(id)staticLayerItemAtKey:(NSString *)key_ DEPRECATED_ATTRIBUTE;
-(id)staticLayerItemAtLayer:(CMMLayer *)layer_ UNAVAILABLE_ATTRIBUTE;

-(uint)indexOfStaticLayerItem:(id)staticLayerItem_ UNAVAILABLE_ATTRIBUTE;
-(uint)indexOfStaticLayerItemWithLayer:(CMMLayer *)layer_ UNAVAILABLE_ATTRIBUTE;
-(uint)indexOfStaticLayerItemWithKey:(NSString *)key_ UNAVAILABLE_ATTRIBUTE;

@end

UNAVAILABLE_ATTRIBUTE @interface CMMSceneStaticLayerItem : NSObject{
	NSString *key;
	CMMLayer *layer;
}

+(id)staticLayerItemWithLayer:(CMMLayer *)layer_ key:(NSString *)key_ DEPRECATED_ATTRIBUTE;
-(id)initWithLayer:(CMMLayer *)layer_ key:(NSString *)key_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, copy) NSString *key DEPRECATED_ATTRIBUTE;
@property (nonatomic, retain) CMMLayer *layer DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite) BOOL isFirstLoad DEPRECATED_ATTRIBUTE;

@end

UNAVAILABLE_ATTRIBUTE @protocol CMMSceneLoadingProtocol <NSObject>

@optional
-(void)sceneDidStartLoading:(CMMScene *)scene_ DEPRECATED_ATTRIBUTE;
-(void)sceneDidEndLoading:(CMMScene *)scene_ DEPRECATED_ATTRIBUTE;

-(void)scene:(CMMScene *)scene_ didChangeLoadingSequence:(uint)curSequence_ sequenceCount:(uint)sequenceCount_ DEPRECATED_ATTRIBUTE;

-(void)sceneLoadingProcess000 DEPRECATED_ATTRIBUTE;

@end


@interface CMMSceneTransitionLayer(Deprecated)

-(void)startFadeInTransitionWithTarget:(id)target_ callbackSelector:(SEL)selector_ DEPRECATED_ATTRIBUTE;
-(void)startFadeOutTransitionWithTarget:(id)target_ callbackSelector:(SEL)selector_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMLayer(Deprecated)

//delegate method
-(void)loadingProcess000 UNAVAILABLE_ATTRIBUTE;
-(void)whenLoadingEnded UNAVAILABLE_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @interface CMMLayerMask : CMMLayerM

//use CMMLayerM class

@end

DEPRECATED_ATTRIBUTE @interface CMMLayerMaskDrag : CMMLayerMD

//use CMMLayerMD class

@end

struct CMMLayerMDScrollbar{
	CMMLayerMDScrollbar(){
		colorX = colorY = ccc4(255, 255, 255, 145);
		widthX = widthY = 2.0f;
		distanceX = distanceY = 4.0f;
	}
	
	ccColor4B colorX,colorY;
	float widthX,widthY,distanceX,distanceY;
} DEPRECATED_ATTRIBUTE;

DEPRECATED_ATTRIBUTE typedef CMMLayerMDScrollbar CMMScrollbarDesign;

@interface CMMLayerMD(Deprecated)

+(void)setDefaultScrollbarX:(CCSprite *)scrollbar_ DEPRECATED_ATTRIBUTE;
+(CCSprite *)defaultScrollbarX DEPRECATED_ATTRIBUTE;

+(void)setDefaultScrollbarY:(CCSprite *)scrollbar_ DEPRECATED_ATTRIBUTE;
+(CCSprite *)defaultScrollbarY DEPRECATED_ATTRIBUTE;

+(CCSpriteFrame *)defaultScrollbarFrameX DEPRECATED_ATTRIBUTE;
+(CCSpriteFrame *)defaultScrollbarFrameY DEPRECATED_ATTRIBUTE;
+(CMM9SliceEdgeOffset)defaultScrollbarEdgeX DEPRECATED_ATTRIBUTE;
+(CMM9SliceEdgeOffset)defaultScrollbarEdgeY DEPRECATED_ATTRIBUTE;
+(GLubyte)defaultScrollbarOpacityX DEPRECATED_ATTRIBUTE;
+(GLubyte)defaultScrollbarOpacityY DEPRECATED_ATTRIBUTE;

@property (nonatomic, readwrite, getter = _isCanDragX) BOOL isCanDragX DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite, getter = _isCanDragY) BOOL isCanDragY DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite, getter = _isAlwaysShowScrollbar) BOOL isAlwaysShowScrollbar DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite) CMMLayerMDScrollbar scrollbar DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite) float dragSpeed DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite) int touchState DEPRECATED_ATTRIBUTE;

@end

UNAVAILABLE_ATTRIBUTE @interface CMMLayerPinchZoom : CMMLayer

@end

@interface CCSpriteBatchNode(Deprecated)

-(CCSprite *)addSplitSpriteToRect:(CGRect)rect_ blendFunc:(ccBlendFunc)tBlendFunc_ DEPRECATED_ATTRIBUTE;
-(void)addSplitSprite:(CGSize)splitUnit_ blendFunc:(ccBlendFunc)tBlendFunc_ DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @interface CMMSpriteBatchBar : CMM9SliceBar<CMMTouchDispatcherDelegate>

+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_;
+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_;

-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_;
-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_;

@property (nonatomic, readwrite) CGSize edgeSize;

@end

@interface CMM9SliceBar(Deprecated)

+(id)sliceBarWithTargetSprite:(CCSprite *)targetSprite_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_ DEPRECATED_ATTRIBUTE;
+(id)sliceBarWithTargetSprite:(CCSprite *)targetSprite_ DEPRECATED_ATTRIBUTE;

-(id)initWithTargetSprite:(CCSprite *)targetSprite_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_ DEPRECATED_ATTRIBUTE;
-(id)initWithTargetSprite:(CCSprite *)targetSprite_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, assign) CCSprite *targetSprite DEPRECATED_ATTRIBUTE;

@end

#pragma mark - util

#import "CMMFontUtil.h"
#import "CMMSequencer.h"
#import "CMMSimpleCache.h"
#import "CMMSoundEngine.h"
#import "CMMTimeIntervalArray.h"
#import "CMMMotionDispatcher.h"

@interface CMMFontUtil(Deprecated)

+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ fontName:(NSString*)fontName_ DEPRECATED_ATTRIBUTE;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ DEPRECATED_ATTRIBUTE;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ DEPRECATED_ATTRIBUTE;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ DEPRECATED_ATTRIBUTE;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ DEPRECATED_ATTRIBUTE;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ DEPRECATED_ATTRIBUTE;
+(CCLabelTTF *)labelWithstring:(NSString *)string_ DEPRECATED_ATTRIBUTE;

+(float)defaultFontSize DEPRECATED_ATTRIBUTE;
+(CGSize)defaultDimensions DEPRECATED_ATTRIBUTE;
+(CCTextAlignment)defaultHAlignment DEPRECATED_ATTRIBUTE;
+(CCVerticalTextAlignment)defaultVAlignment DEPRECATED_ATTRIBUTE;
+(CCLineBreakMode)defaultLineBreakMode DEPRECATED_ATTRIBUTE;
+(NSString *)defaultFontName DEPRECATED_ATTRIBUTE;

@end

UNAVAILABLE_ATTRIBUTE @interface CMMLoadingObject : CMMSequencer

@end

DEPRECATED_ATTRIBUTE @protocol CMMLoadingObjectDelegate

@optional

-(void)loadingObject_whenLoadingStart:(id)loadingObject_;
-(void)loadingObject_whenLoadingEnded:(id)loadingObject_;

@end

#define cmmVarCMMSequenceMaker_defaultSequenceFormatter @"sequence%03d"

typedef enum{
	CMMSequenceMakerState_stop UNAVAILABLE_ATTRIBUTE,
	CMMSequenceMakerState_onSequence UNAVAILABLE_ATTRIBUTE,
	CMMSequenceMakerState_waitingNextSequence UNAVAILABLE_ATTRIBUTE,
	CMMSequenceMakerState_pause UNAVAILABLE_ATTRIBUTE,
} CMMSequenceMakerState;

UNAVAILABLE_ATTRIBUTE @interface CMMSequenceMaker : CMMSequencer{
}

+(id)sequenceMaker;

@property (nonatomic, assign) id delegate;
@property (nonatomic, copy) NSString *sequenceMethodFormatter;
@property (nonatomic, readonly) uint curSequence,sequenceCount;
@property (nonatomic, readwrite) CMMSequenceMakerState sequenceState;
@property (nonatomic, readwrite) ccTime sequenceTimeInterval;

@end

DEPRECATED_ATTRIBUTE @interface CMMSequenceMakerAuto : CMMSequencerAuto

+(id)sequenceMaker;

@end

UNAVAILABLE_ATTRIBUTE @protocol CMMSequenceMakerDelegate <NSObject>

@optional
-(void)sequenceMakerDidStart:(id)sequenceMaker_;
-(void)sequenceMakerDidEnd:(id)sequenceMaker_;

-(void)sequenceMaker:(id)sequenceMaker_ didChangeState:(CMMSequenceMakerState)state_;
-(void)sequenceMaker:(id)sequenceMaker_ didChangeSequence:(uint)curSequence_ sequenceCount:(uint)sequenceCount_;

@end

typedef enum{
	CMMDrawingManagerItemKey_switch_button DEPRECATED_ATTRIBUTE = 0,
	CMMDrawingManagerItemKey_switch_back DEPRECATED_ATTRIBUTE = 1,
	CMMDrawingManagerItemKey_switch_mask DEPRECATED_ATTRIBUTE = 2,
	
	CMMDrawingManagerItemKey_slider_bar DEPRECATED_ATTRIBUTE = 3,
	CMMDrawingManagerItemKey_slider_button DEPRECATED_ATTRIBUTE = 4,
	CMMDrawingManagerItemKey_slider_mask DEPRECATED_ATTRIBUTE = 5,
	
	CMMDrawingManagerItemKey_text_bar DEPRECATED_ATTRIBUTE = 6,
	
	CMMDrawingManagerItemKey_checkbox_back DEPRECATED_ATTRIBUTE = 7,
	CMMDrawingManagerItemKey_checkbox_check DEPRECATED_ATTRIBUTE = 8,
	
	CMMDrawingManagerItemKey_maxCount DEPRECATED_ATTRIBUTE = 9,
} CMMDrawingManagerItemKey;

extern NSString *const CMMDrawingManagerItemFormatter_SwitchBack DEPRECATED_ATTRIBUTE;

@interface CMMDrawingManagerItem(Deprecated)

-(void)setSpriteFrame:(CCSpriteFrame *)spriteFrame_ forKey:(CMMDrawingManagerItemKey)key_ UNAVAILABLE_ATTRIBUTE;
-(CCSpriteFrame *)spriteFrameForKey:(CMMDrawingManagerItemKey)key_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMDrawingManager(Deprecated)

-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ barYN:(BOOL)barYN_ DEPRECATED_ATTRIBUTE;
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ DEPRECATED_ATTRIBUTE;
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMSimpleCache(Deprecated)

-(void)cacheObject:(id)object_ DEPRECATED_ATTRIBUTE;
-(void)clearCache DEPRECATED_ATTRIBUTE;

@end

typedef CMMSoundID SoundID DEPRECATED_ATTRIBUTE;

typedef enum{
	CMMSoundHandlerItemType_default DEPRECATED_ATTRIBUTE,
	CMMSoundHandlerItemType_follow DEPRECATED_ATTRIBUTE,
} CMMSoundHandlerItemType;

@interface CMMSoundHandlerItem(Deprecated)

@property (nonatomic, readwrite) CMMSoundHandlerItemType type DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @interface CMMSoundHandlerItemFollow : CMMSoundHandlerItem

+(id)itemWithSoundSource:(CDSoundSource *)soundSource_ trackNode:(CCNode *)trackNode_;
-(id)initWithSoundSource:(CDSoundSource *)soundSource_ trackNode:(CCNode *)trackNode_;

@end

@interface CMMSoundHandler(Deprecated)

-(CMMSoundHandlerItem *)addSoundItem:(NSString*)soundPath_ soundPoint:(CGPoint)soundPoint_ DEPRECATED_ATTRIBUTE;
-(CMMSoundHandlerItem *)addSoundItem:(NSString*)soundPath_ DEPRECATED_ATTRIBUTE;

-(CMMSoundHandlerItemFollow *)addSoundItemFollow:(NSString*)soundPath_ trackNode:(CCNode *)trackNode_ DEPRECATED_ATTRIBUTE;
-(CMMSoundHandlerItem *)cachedSoundItem:(CMMSoundHandlerItemType)soundItemType_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMTimeIntervalArray(Deprecated)

@property (nonatomic, assign) void (^filter_whenAddedObject)(id object_) UNAVAILABLE_ATTRIBUTE,(^filter_whenRemovedObject)(id object_) UNAVAILABLE_ATTRIBUTE;
@property (nonatomic, assign) void (^callback_whenAddedObject)(CCArray *objects_) DEPRECATED_ATTRIBUTE,(^callback_whenRemovedObject)(CCArray *objects_) DEPRECATED_ATTRIBUTE;

@end

#pragma mark - dispatcher

typedef struct{
	float scale,lastScale;
	float distance,lastDistance,firstDistance;
	float radians,lastRadians,firstRadians;
	
	UITouch *touch1,*touch2;
} kCMMPinchState;

typedef kCMMPinchState CMMPinchState UNAVAILABLE_ATTRIBUTE;

UNAVAILABLE_ATTRIBUTE static inline kCMMPinchState CMMPinchStateMake(float distance_,float radians_){
	return kCMMPinchState();
}

typedef enum{
	CMMTouchState_none DEPRECATED_ATTRIBUTE,
	CMMTouchState_onTouchChild DEPRECATED_ATTRIBUTE,
	CMMTouchState_onFixed DEPRECATED_ATTRIBUTE,
	CMMTouchState_onScroll DEPRECATED_ATTRIBUTE,
	CMMTouchState_onDrag DEPRECATED_ATTRIBUTE,
} CMMTouchState DEPRECATED_ATTRIBUTE;

@interface CMMTouchDispatcher(Deprecated)

+(void)setAllTouchDispatcherEnable:(BOOL)enable_ DEPRECATED_ATTRIBUTE;
+(BOOL)isAllTouchDispatcherEnable DEPRECATED_ATTRIBUTE;

@property (nonatomic, readwrite) kCMMPinchState pinchState UNAVAILABLE_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @interface CMMTouchDispatcherScene : CMMTouchDispatcher

@end

DEPRECATED_ATTRIBUTE @interface CMMPopupDispatcher : CMMPopupView

@end

UNAVAILABLE_ATTRIBUTE @interface CMMPopupDispatcherItem : NSObject{
}

+(id)popupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id)delegate_;
-(id)initWithPopup:(CMMPopupLayer *)popup_ delegate:(id)delegate_;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id popupDispatcher;
@property (nonatomic, retain) CMMPopupLayer *popup;

@end

DEPRECATED_ATTRIBUTE @interface CMMPopupDispatcherTemplate : NSObject

-(void)startPopupWithPopupLayer:(CMMPopupLayer *)popupLayer_ DEPRECATED_ATTRIBUTE;
-(void)endPopupWithPopupLayer:(CMMPopupLayer *)popupLayer_ callbackAction:(CCCallBlock *)callbackAction_ DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @interface CMMPopupDispatcherTemplate_FadeInOut : NSObject{
	GLubyte _orginalOpacity;
	BOOL _orginalTouchEnable;
}

@end

@interface CMMPopupView(Deprecated)

+(id)popupDispatcherWithScene:(CMMScene *)scene_ DEPRECATED_ATTRIBUTE;
+(id)popupDispatcherWithTarget:(CCNode *)target_ DEPRECATED_ATTRIBUTE;
-(id)initWithScene:(CMMScene *)scene_ DEPRECATED_ATTRIBUTE;
-(id)initWithTarget:(CCNode *)target_ DEPRECATED_ATTRIBUTE;

-(void)addPopupItem:(id)popupItem_ atIndex:(int)index_ UNAVAILABLE_ATTRIBUTE;
-(id)addPopupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id)delegate_ atIndex:(int)index_ UNAVAILABLE_ATTRIBUTE;
-(id)addPopupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id)delegate_ UNAVAILABLE_ATTRIBUTE;

-(void)removePopupItem:(id)popupItem_ withData:(id)data_ UNAVAILABLE_ATTRIBUTE;
-(void)removePopupItem:(id)popupItem_ UNAVAILABLE_ATTRIBUTE;
-(void)removePopupItemAtIndex:(int)index_ withData:(id)data_ UNAVAILABLE_ATTRIBUTE;
-(void)removePopupItemAtIndex:(int)index_ UNAVAILABLE_ATTRIBUTE;
-(void)removePopupItemAtPopup:(CMMPopupLayer *)popup_ withData:(id)data_ UNAVAILABLE_ATTRIBUTE;
-(void)removePopupItemAtPopup:(CMMPopupLayer *)popup_ UNAVAILABLE_ATTRIBUTE;

-(id)popupItemAtIndex:(int)index_ UNAVAILABLE_ATTRIBUTE;

-(int)indexOfPopupItem:(id)popupItem_ UNAVAILABLE_ATTRIBUTE;

@property (nonatomic, assign) CMMScene *scene DEPRECATED_ATTRIBUTE;
@property (nonatomic, readonly) CMMPopupLayer *curPopup DEPRECATED_ATTRIBUTE;
@property (nonatomic, retain) id popupTemplate DEPRECATED_ATTRIBUTE;
@property (nonatomic, readonly) uint popupCount;

@end

UNAVAILABLE_ATTRIBUTE @interface CMMPopupMasterView : CMMLayer

+(id)viewWithPopupDispatcher:(id)popupDispatcher_;
-(id)initWithPopupDispatcher:(id)popupDispatcher_;

@end

DEPRECATED_ATTRIBUTE @interface CMMLayerPopup : CMMPopupLayer

@end

@interface CMMPopupLayer(Deprecated)

-(void)closeWithSendData:(id)data_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, assign) id popupDispatcherItem DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMPopupLayerDelegate <NSObject>

-(void)popup:(CMMPopupLayer *)popup_ didCloseWithReceivedData:(id)data_;

@end

DEPRECATED_ATTRIBUTE @protocol CMMPopupDispatcherDelegate<NSObject>

@optional
-(void)popupDispatcher:(CMMPopupDispatcher *)popupDispatcher_ didOpenPopup:(CMMPopupLayer *)popup_;
-(void)popupDispatcher:(CMMPopupDispatcher *)popupDispatcher_ didClosePopup:(CMMPopupLayer *)popup_ withReceivedData:(id)data_;

-(void)popupDispatcher:(id)popupItem_ whenClosedWithReceivedData:(id)data_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMMotionDispatcher(Deprecated)

-(void)addTarget:(id)target_ DEPRECATED_ATTRIBUTE;
-(void)removeTarget:(id)target_ DEPRECATED_ATTRIBUTE;

-(void)removeTargetAtIndex:(int)index_ UNAVAILABLE_ATTRIBUTE;
-(id)targetAtIndex:(int)index_ UNAVAILABLE_ATTRIBUTE;
-(int)indexOfTarget:(id)target_ UNAVAILABLE_ATTRIBUTE;

@property (nonatomic, readonly) CCArray *targetList UNAVAILABLE_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMMotionDispatcherDelegate <NSObject>

@optional
-(void)motionDispatcher:(CMMMotionDispatcher *)motionDispatcher_ updateMotion:(CMMMotionState)state_;

@end

#pragma mark - component(view)

#import "CMMMenuItem.h"
#import "CMMMenuItemSet.h"
#import "CMMScrollMenu.h"
#import "CMMScrollMenuV.h"
#import "CMMScrollMenuH.h"
#import "CMMControlItemSwitch.h"
#import "CMMControlItemSlider.h"
#import "CMMControlItemText.h"
#import "CMMControlItemCheckbox.h"
#import "CMMCustomUI.h"
#import "CMMCustomUIJoypad.h"

@interface CMMMenuItem(Deprecated)

+(id)menuItemWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_ DEPRECATED_ATTRIBUTE;
+(id)menuItemWithFrameSeq:(int)frameSeq_ DEPRECATED_ATTRIBUTE;

-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_ DEPRECATED_ATTRIBUTE;
-(id)initWithFrameSeq:(int)frameSeq_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, assign) id delegate DEPRECATED_ATTRIBUTE;
@property (nonatomic, getter = _isEnable) BOOL isEnable DEPRECATED_ATTRIBUTE;
@property (nonatomic, retain) CCSprite *normalImage,*selectedImage DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @interface CMMMenuItemLabelTTF : CMMMenuItemL

@end

DEPRECATED_ATTRIBUTE @protocol CMMMenuItemDelegate<NSObject>

@optional
-(void)menuItem_whenPushdown:(CMMMenuItem *)menuItem_;
-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_;
-(void)menuItem_whenPushcancel:(CMMMenuItem *)menuItem_;

@end

@interface CMMMenuItemSet(Deprecated)

@property (nonatomic, assign) id delegate DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite, getter = _isEnable) BOOL isEnable DEPRECATED_ATTRIBUTE;
@property (nonatomic, assign) void (^callback_pushdown)(id sender_,CMMMenuItem *menuItem_) DEPRECATED_ATTRIBUTE,(^callback_pushup)(id sender_,CMMMenuItem *menuItem_) DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMMenuItemSetDelegate<NSObject>

@optional
-(void)menuItemSet:(CMMMenuItemSet *)menuItemSet_ whenMenuItemPushdownWithMenuItem:(CMMMenuItem *)menuItem_;
-(void)menuItemSet:(CMMMenuItemSet *)menuItemSet_ whenMenuItemPushupWithMenuItem:(CMMMenuItem *)menuItem_;

@end

@interface CMMScrollMenu(Deprecated)

+(id)scrollMenuWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, assign) id delegate DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite, getter = _isCanSelectItem) BOOL isCanSelectItem DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite, getter = isCanSelectItem) BOOL canSelectItem DEPRECATED_ATTRIBUTE;

@end

@interface CMMScrollMenuVItemDragView(Deprecated)

-(void)setTextureWithMenuItem:(CMMMenuItem *)menuItem_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, readwrite) int targetIndex UNAVAILABLE_ATTRIBUTE;

@end

@interface CMMScrollMenuV(Deprecated)

+(void)setDefaultFilter_offsetOfDraggedItem:(CGPoint (^)(CGPoint orginalPoint_, CGPoint targetPoint_,ccTime dt_))block_ DEPRECATED_ATTRIBUTE;
+(void)setDefaultAction_itemDragViewCancelled:(CCFiniteTimeAction *(^)(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_))block_ UNAVAILABLE_ATTRIBUTE;

@property (nonatomic, copy) CCFiniteTimeAction * (^action_itemDragViewCancelled)(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_) UNAVAILABLE_ATTRIBUTE;
@property (nonatomic, copy) CGPoint(^filter_offsetOfDraggedItem)(CGPoint orginalPoint_, CGPoint targetPoint_,ccTime dt_) DEPRECATED_ATTRIBUTE;

@end

@interface CMMScrollMenuH(Deprecated)

@property (nonatomic, readwrite) float fouceItemScale UNAVAILABLE_ATTRIBUTE,nonefouceItemScale UNAVAILABLE_ATTRIBUTE;
@property (nonatomic, readwrite) float minScrollAccelToSnap DEPRECATED_ATTRIBUTE;

@end

@protocol CMMScrollMenuDelegate<NSObject>

@optional
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanSelectAtIndex:(int)index_ DEPRECATED_ATTRIBUTE;
//filter_canChangeIndex
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenSelectedAtIndex:(int)index_ DEPRECATED_ATTRIBUTE;
//callback_whenIndexChanged

-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanAddItem:(CMMMenuItem *)item_ atIndex:(int)index_ DEPRECATED_ATTRIBUTE;
//filter_canAddItem
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanRemoveItem:(CMMMenuItem *)item_ DEPRECATED_ATTRIBUTE;
//filter_canRemoveItem
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanSwitchItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_ DEPRECATED_ATTRIBUTE;
//filter_canSwitchItem
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanLinkSwitchItem:(CMMMenuItem *)item_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_ DEPRECATED_ATTRIBUTE;
//filter_canLinkSwitchItem

-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenAddedItem:(CMMMenuItem *)item_ atIndex:(int)index_ DEPRECATED_ATTRIBUTE;
//callback_whenItemAdded
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenRemovedItem:(CMMMenuItem *)item_ DEPRECATED_ATTRIBUTE;
//callback_whenItemRemoved
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenSwitchedItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_ DEPRECATED_ATTRIBUTE;
//callback_whenItemSwitched
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenLinkSwitchedItem:(CMMMenuItem *)fromItem_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_ DEPRECATED_ATTRIBUTE;
//callback_whenItemLinkSwitched

-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushdownWithItem:(CMMMenuItem *)item_ UNAVAILABLE_ATTRIBUTE;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushupWithItem:(CMMMenuItem *)item_ DEPRECATED_ATTRIBUTE;
//callback_whenTapAtIndex
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushcancelWithItem:(CMMMenuItem *)item_ UNAVAILABLE_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMScrollMenuVDelegate

@optional
-(BOOL)scrollMenu:(CMMScrollMenuV *)scrollMenu_ isCanDragItem:(CMMMenuItem *)item_ DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMScrollMenuHDelegate

@optional

@end

DEPRECATED_ATTRIBUTE @interface CMMControlItemBatchBar : CMM9SliceBar

@end

@interface CMMControlItem(Deprecated)

@property (nonatomic, assign) id delegate DEPRECATED_ATTRIBUTE;
@property (nonatomic, getter = _isEnable) BOOL isEnable DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMControlItemDelegate <NSObject>
@end

@interface CMMControlItemSwitch(Deprecated)

+(id)controlItemSwitchWithMaskSprite:(CCSprite *)maskSprite_ backSprite:(CCSprite *)backSprite_ buttonSprite:(CCSprite *)buttonSprite_ DEPRECATED_ATTRIBUTE;
-(id)initWithMaskSprite:(CCSprite *)maskSprite_ backSprite:(CCSprite *)backSprite_ buttonSprite:(CCSprite *)buttonSprite_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, assign) void (^callback_whenChangedItemVale)(id sender_,BOOL itemValue_) DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMControlItemSwitchDelegate

@optional
-(void)controlItemSwitch:(CMMControlItemSwitch *)controlItem_ whenChangedItemValue:(BOOL)itemValue_;

@end

@interface CMMControlItemSlider(Deprecated)

+(id)controlItemSliderWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_ DEPRECATED_ATTRIBUTE;
+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ DEPRECATED_ATTRIBUTE;
-(id)initWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_ DEPRECATED_ATTRIBUTE;
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ DEPRECATED_ATTRIBUTE;

-(void)setButtonSprite:(CCSprite *)buttonSprite_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, assign) void (^callback_whenChangedItemVale)(id sender_,float itemValue_, float beforeItemValue_) DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite) float minValue DEPRECATED_ATTRIBUTE,maxValue DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMControlItemSliderDelegate

@optional
-(void)controlItemSlider:(CMMControlItemSlider *)controlItem_ whenChangedItemValue:(float)itemValue_ beforeItemValue:(float)beforeItemValue_;

@end

@interface CMMControlItemText(Deprecated)

//2013.04.10
+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ frameSize:(CGSize)frameSize_ DEPRECATED_ATTRIBUTE;
+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_ DEPRECATED_ATTRIBUTE;

+(id)controlItemTextWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_ DEPRECATED_ATTRIBUTE;
+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_ DEPRECATED_ATTRIBUTE;

-(id)initWithBarSprite:(CCSprite *)barSprite_ frameSize:(CGSize)frameSize_ DEPRECATED_ATTRIBUTE;
-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_ DEPRECATED_ATTRIBUTE;

-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_ DEPRECATED_ATTRIBUTE;
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ DEPRECATED_ATTRIBUTE;

-(void)redrawWithBar DEPRECATED_ATTRIBUTE; 

//before
+(id)controlItemTextWithWidth:(float)width_ barSprite:(CCSprite *)barSprite_ DEPRECATED_ATTRIBUTE;
-(id)initWithWidth:(float)width_ barSprite:(CCSprite *)barSprite_ DEPRECATED_ATTRIBUTE;

+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_ height:(float)height_ DEPRECATED_ATTRIBUTE;
+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_ height:(float)height_ DEPRECATED_ATTRIBUTE;
-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_ height:(float)height_ DEPRECATED_ATTRIBUTE;
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ height:(float)height_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, assign) void (^callback_whenChangedItemVale)(id sender_,NSString *itemValue_) DEPRECATED_ATTRIBUTE;
@property (nonatomic, assign) NSString *itemTitle DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMControlItemTextDelegate

@optional
-(void)controlItemText:(CMMControlItemText *)controlItem_ whenChangedItemValue:(NSString *)itemValue_;

-(BOOL)controlItemTextShouldShow:(CMMControlItemText *)controlItem_;
-(BOOL)controlItemTextShouldHide:(CMMControlItemText *)controlItem_;

@end

@interface CMMControlItemCheckbox(Deprecated)

+(id)controlItemCheckboxWithBackSprite:(CCSprite *)backSprite_ checkSprite:(CCSprite *)checkSprite_ DEPRECATED_ATTRIBUTE;
-(id)initWithBackSprite:(CCSprite *)backSprite_ checkSprite:(CCSprite *)checkSprite_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMCustomUI(Deprecated)

@property (nonatomic, assign) id delegate DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite, getter = _isEnable) BOOL isEnable DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMCustomUIDelegate <NSObject>

@end

@interface CMMCustomUIJoypadButton(Deprecated)

@property (nonatomic, readwrite, getter = _isAutoPushdown) BOOL isAutoPushdown DEPRECATED_ATTRIBUTE;

@end

@interface CMMCustomUIJoypadStick(Deprecated)

@property (nonatomic, assign) id delegate DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMCustomUIJoypadStickDelegate <NSObject>

-(void)customUIJoypadStick:(CMMCustomUIJoypadStick *)stick_ whenChangedStickVector:(CGPoint)vector_;
//callback_whenStickVectorChanged

@end

DEPRECATED_ATTRIBUTE @protocol CMMCustomUIJoypadDelegate

@optional
-(void)customUIJoypad:(CMMCustomUIJoypad *)joypad_ whenChangedStickVector:(CGPoint)vector_;

@end

#pragma mark - component(stage)

#import "CMMSType.h"
#import "CMMStage.h"
#import "CMMStageTMX.h"
#import "CMMStagePXL.h"
#import "CMMStageDNB.h"
#import "CMMSObject.h"
#import "CMMSParticle.h"

DEPRECATED_ATTRIBUTE typedef CMMStageDef CMMStageSpecDef;

DEPRECATED_ATTRIBUTE static inline CMMStageDef CMMStageSpecDefMake(CGSize stageSize_, CGSize worldSize_, CGPoint gravity_){
	return CMMStageDefMake(stageSize_,worldSize_,gravity_);
}

DEPRECATED_ATTRIBUTE static inline CMMb2ContactMask b2CMaskMake(CMMb2FixtureType fixtureType_, cmmMaskBit maskBit1_, cmmMaskBit maskBit2_, cmmMaskBit checkBit_){
	return CMMb2ContactMaskMake(fixtureType_, maskBit1_, maskBit2_, checkBit_);
}

DEPRECATED_ATTRIBUTE @interface CMMStageBackGround : NSObject{
	CMMStage *stage;
	CCNode *backGroundNode;
	float distanceRate;
}

+(id)backGroundWithStage:(CMMStage *)stage_ distanceRate:(float)distanceRate_;
-(id)initWithStage:(CMMStage *)stage_ distanceRate:(float)distanceRate_;

-(void)updatePosition;

@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, retain) CCNode *backGroundNode;
@property (nonatomic, readwrite) float distanceRate;

@end

@interface CMMStage(Deprecated)

+(id)stageWithStageSpecDef:(CMMStageDef)stageSpecDef_ DEPRECATED_ATTRIBUTE;
-(id)initWithStageSpecDef:(CMMStageDef)stageSpecDef_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, assign) id delegate DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite) BOOL isAllowTouch DEPRECATED_ATTRIBUTE;
@property (nonatomic, readonly) id backGround DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) CMMStageObjectBlock callback_whenObjectAdded DEPRECATED_ATTRIBUTE, callback_whenObjectRemoved DEPRECATED_ATTRIBUTE;

-(void)setCallback_whenObjectAdded:(CMMStageObjectBlock)block_ DEPRECATED_ATTRIBUTE;
-(void)setCallback_whenObjectRemoved:(CMMStageObjectBlock)block_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMStageLightItem(Deprecated)

@property (nonatomic, readwrite, getter = _isBlendColor) BOOL isBlendColor DEPRECATED_ATTRIBUTE;

@end

@interface CMMStageWorld(Deprecated)

-(CCArray *)objectsInTouched DEPRECATED_ATTRIBUTE;
-(CCArray *)objectsInTouches DEPRECATED_ATTRIBUTE;

-(CMMSObjectBatchNode *)addObatchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ DEPRECATED_ATTRIBUTE;
-(void)removeObatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ DEPRECATED_ATTRIBUTE;
-(CMMSObjectBatchNode *)obatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ DEPRECATED_ATTRIBUTE;
-(int)indexOfObatchNodeFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @interface CMMSParticleFollow : CMMSParticle

@end

@interface CMMStageParticle(Deprecated)

-(CMMSParticle *)addParticleFollowWithName:(NSString *)particleName_ target:(CMMSObject *)target_ DEPRECATED_ATTRIBUTE;
-(void)removeParticleFollowOfTarget:(CMMSObject *)target_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMStageTMX(Deprecated)

+(id)stageWithStageSpecDef:(CMMStageDef)stageSpecDef_ tmxFileName:(NSString *)tmxFileName_ isInDocument:(BOOL)isInDocument_ DEPRECATED_ATTRIBUTE;
-(id)initWithStageSpecDef:(CMMStageDef)stageSpecDef_ tmxFileName:(NSString *)tmxFileName_ isInDocument:(BOOL)isInDocument_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, readonly, getter = _isTilemapBuiltup) BOOL isTilemapBuiltup;

@end

@interface CMMStagePXL(Deprecated)

+(id)stageWithStageSpecDef:(CMMStageDef)stageSpecDef_ fileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ DEPRECATED_ATTRIBUTE;
-(id)initWithStageSpecDef:(CMMStageDef)stageSpecDef_ fileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, readwrite, getter = _isInDocument) BOOL isInDocument DEPRECATED_ATTRIBUTE;

@end

@interface CMMSSpecStage(Deprecated)

+(id)specWithTarget:(id)target_ withStageSpecDef:(CMMStageDef)stageSpecDef_ DEPRECATED_ATTRIBUTE;
-(id)initWithTarget:(id)target_ withStageSpecDef:(CMMStageDef)stageSpecDef_ DEPRECATED_ATTRIBUTE;

-(void)applyWithStageSpecDef:(CMMStageDef)stageSpecDef_ DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMStageDelegate<NSObject>

@optional
-(void)stage:(CMMStage *)stage_ whenAddedObjects:(CCArray *)objects_;
-(void)stage:(CMMStage *)stage_ whenRemovedObjects:(CCArray *)objects_;

@end

DEPRECATED_ATTRIBUTE @protocol CMMStageTouchDelegate <NSObject>

@optional
-(void)stage:(CMMStage *)stage_ whenTouchBegan:(UITouch *)touch_ withObject:(CMMSObject *)object_;
-(void)stage:(CMMStage *)stage_ whenTouchMoved:(UITouch *)touch_ withObject:(CMMSObject *)object_;
-(void)stage:(CMMStage *)stage_ whenTouchEnded:(UITouch *)touch_ withObject:(CMMSObject *)object_;
-(void)stage:(CMMStage *)stage_ whenTouchCancelled:(UITouch *)touch_ withObject:(CMMSObject *)object_;

@end

DEPRECATED_ATTRIBUTE @protocol CMMStageTMXDelegate <NSObject>

@optional
-(BOOL)tilemapStage:(CMMStageTMX *)stage_ isSingleTileAtTMXLayer:(CCTMXLayer *)tmxLayer_ tile:(CCSprite *)tile_ xIndex:(float)xIndex_ yIndex:(float)yIndex_;
-(void)tilemapStage:(CMMStageTMX *)stage_ whenTileBuiltupAtTMXLayer:(CCTMXLayer *)tmxLayer_ fromXIndex:(float)fromXIndex_ toXIndex:(float)toXIndex_ yIndex:(float)yIndex_ tileFixture:(b2Fixture *)tileFixture_;

@end

DEPRECATED_ATTRIBUTE @protocol CMMStageDNBDelegate

@optional

-(void)stage:(CMMStageDNB *)stage_ whenContactStartedWithObject:(CMMSObject *)object_ AtDirection:(CMMStageDNBDirection)direction_;
-(void)stage:(CMMStageDNB *)stage_ whenContactEndedWithObject:(CMMSObject *)object_ AtDirection:(CMMStageDNBDirection)direction_;
-(void)stage:(CMMStageDNB *)stage_ doContactWithObject:(CMMSObject *)object_ AtDirection:(CMMStageDNBDirection)direction_ interval:(ccTime)interval_;

@end

@interface CMMSObjectBatchNode(Deprecated_Nonfunctional)

-(CMMSObject *)createObjectWithRect:(CGRect)rect_ DEPRECATED_ATTRIBUTE;
-(CMMSObject *)createObjectWithSpriteFrame:(CCSpriteFrame *)spriteFrame_ DEPRECATED_ATTRIBUTE;
-(CMMSObject *)createObject DEPRECATED_ATTRIBUTE;

+(id)batchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ DEPRECATED_ATTRIBUTE;
-(id)initWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, copy) NSString *fileName DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite) BOOL isInDocument DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite) Class objectClass DEPRECATED_ATTRIBUTE;

@end

@interface CMMSObject(Deprecated)

-(void)buildupBody DEPRECATED_ATTRIBUTE;

-(void)updateBodyWithPosition:(CGPoint)point_ andRotation:(float)tRotation_ DEPRECATED_ATTRIBUTE;
-(void)updateBodyWithPosition:(CGPoint)point_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, readwrite, getter = isAddToBatchNode) BOOL addToBatchNode DEPRECATED_ATTRIBUTE;

@end

#pragma mark - component(util)

#import "CMMGameKit.h"

@interface CMMGameKitPA(Deprecated)

@property (nonatomic, assign) id delegate DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMGameKitPADelegate<NSObject>

@optional
//Authentication
-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenChangedAuthenticationWithBOOL:(BOOL)isAuthenticated_;

-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenTryAuthenticationWithViewController:(UIViewController *)viewController_;
-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenCompletedAuthenticationWithLocalPlayer:(GKPlayer *)localPlayer_;
-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenFailedAuthenticationWithError:(NSError *)error_;

@end

@interface CMMGameKitLeaderBoard(Deprecated)

-(void)loadCategory DEPRECATED_ATTRIBUTE;

-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_ playerScope:(GKLeaderboardPlayerScope)playerScope_ DEPRECATED_ATTRIBUTE;
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_ DEPRECATED_ATTRIBUTE;
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ DEPRECATED_ATTRIBUTE;

-(void)reportScore:(int64_t)score_ category:(NSString*)category_ DEPRECATED_ATTRIBUTE;

@property (nonatomic, assign) id delegate DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMGameKitLeaderBoardDelegate <NSObject>

@optional
-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenReceiveCategory:(NSArray *)category_ withTitle:(NSArray *)title_;
-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenFailedReceivingCategoryWithError:(NSError *)error_;

-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenReceiveLeaderBoard:(GKLeaderboard *)leaderBoard_;
-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenFailedReceivingLeaderBoard:(GKLeaderboard *)leaderBoard_ withError:(NSError *)error_;

-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenCompletedSendingScore:(GKScore *)score_;
-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenFailedSendingScore:(GKScore *)score_ withError:(NSError *)error_;

@end

@interface CMMGameKitAchievements(Deprecated)

-(CMMGameKitAchievement *)reportedAchievementAtIdentifier:(NSString *)identifier_ UNAVAILABLE_ATTRIBUTE;
-(CMMGameKitAchievement *)cachedAchievementAtIdentifier:(NSString *)identifier_ UNAVAILABLE_ATTRIBUTE;

-(id)reportedAchievementAtIndex:(uint)index_ UNAVAILABLE_ATTRIBUTE;
-(uint)indexOfReportedAchievement:(id)achievement_ UNAVAILABLE_ATTRIBUTE;
-(uint)indexOfReportedAchievementWithIdentifier_:(NSString *)identifier_ UNAVAILABLE_ATTRIBUTE;

-(id)cachedAchievementAtIndex:(uint)index_ UNAVAILABLE_ATTRIBUTE;
-(uint)indexOfCachedAchievement:(id)achievement_ UNAVAILABLE_ATTRIBUTE;
-(uint)indexOfCachedAchievementWithIdentifier_:(NSString *)identifier_ UNAVAILABLE_ATTRIBUTE;

-(void)writeCachedAchievements DEPRECATED_ATTRIBUTE;

@property (nonatomic, assign) id delegate DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @protocol CMMGameKitAchievementsDelegate <NSObject>

@optional
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenCompletedReportingAchievements:(NSArray *)reportedAchievements_;
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedReportingAchievementsWithError:(NSError *)error_;

-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenReceiveAchievements:(NSArray *)achievements_;
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedReceivingAchievementsWithError:(NSError *)error_;

-(void)gameKitAchievements_whenCompletedResettingAchievements:(CMMGameKitAchievements *)gameKitAchievements_;
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedResettingAchievementsWithError:(NSError *)error_;

@end

#pragma mark - etc

UNAVAILABLE_ATTRIBUTE @protocol CMMApplicationProtocol <NSObject>

@optional
-(void)applicationDidBecomeActive;
-(void)applicationWillResignActive;

-(void)applicationWillTerminate;
-(void)applicationDidEnterBackground;
-(void)applicationWillEnterForeground;

-(void)applicationDidReceiveMemoryWarning;

@end