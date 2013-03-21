##Version 1.3.0
###*---Please be careful before update!!!---*<br/>most of the features of the `CMMTouchDispatcher`,`CMMSprite`,`CMMLayerMD`,`CMMScrollMenuV`,`CMMScrollMenuH` has been changed & updated
* [FIX] macro name has changed
	* `cmmFuncCommon_fixRadians` -> `cmmFunc_fixRadians`
	* `cmmFuncCommon_fixDegrees` -> `cmmFunc_fixDegrees`
	* `cmmFunc_MINMAX(arg1,arg2,arg3)` added
* [FIX] **`CMMFloatRange`** method added
	* **method** `float Length();` added
* [DEL] **`CMMTouchState`** deprecated, do not use anymore
* [NEW] enum **`CMMTouchCancelMode`** added
* [FIX] **`CMMTouchDispatcherDelegate`**
	* **property** `(CMMTouchCancelMode)touchCancelMode` added
	* **property** `(float)touchCancelDistance` added
* [FIX]  **`CMMTouchDispatcherItem`** improved
	* **property**  `(CGPoint)firstTouchPoint` added
* [FIX] **`CMMTouchSelectorID`** item added
	* `CMMTouchSelectorID_TouchCancelModeGetter` added
	* `CMMTouchSelectorID_TouchCancelDistanceSetter` added
	* `CMMTouchSelectorID_TouchCancelDistanceGetter` added
* [FIX] **`CMMSprite`** improved
* [DEL] **`CMMLayerMDScrollbar`** deprecated, do not use anymore
* [FIX] **`CMMLayerMD`** classes & methods has been changed, scrolling process improved (*you need to migrate your source*)
	* **variable & property** `(CMMLayerMDScrollbar)scrollbar` deprecated, do not use anymore
	* **variable & property** `(float)dragSpeed` deprecated, replaced by `(float)scrollSpeed`
	* **variable & property** `(CMMLayerMDScrollbar)scrollbar` deprecated, do not use anymore
	* **variable & property** `(CMM9SliceBar *)scrollbarX` added
	* **variable & property** `(CMM9SliceBar *)scrollbarY` added
	* **variable & property** `(float)scrollbarOffsetX` added
	* **variable & property** `(float)scrollbarOffsetY` added
	* **variable & property** `(float)scrollResistance` added
	* **property** `(float)currentScrollSpeedX` added
	* **property** `(float)currentScrollSpeedY` added
	* **method** `+(void)setDefaultScrollbarX:(CCSprite *)scrollbar_;` added
	* **method** `+(CCSprite *)defaultScrollbarX;` added
	* **method** `+(void)setDefaultScrollbarY:(CCSprite *)scrollbar_;` added
	* **method** `+(CCSprite *)defaultScrollbarY;` added
	* **method** `-(void)setInnerPosition:(CGPoint)point_ applyScrolling:(BOOL)applyScrolling_;` added
	* **method** `-(void)setInnerPosition:(CGPoint)point_;` added
* [FIX] **`CMMScrollMenu`** process improved
* [FIX] **`CMMScrollMenuV`** process improved
* [FIX] **`CMMScrollMenuH`** process improved
	* **variable & property** `(float)fouceItemScale` is unavailable
	* **variable & property** `(float)nonefouceItemScale` is unavailable
	* **variable & property** `(float)minScrollAccelToSnap` deprecated, do not use anymore
	* **variable & property** `(float)targetScrollSpeedToPass` added
* [FIX] **`CMMMenuItem`** fixed bugs on the animation of the button
* [FIX] **`CMMControlItemSlider`** properties has been changed
	* **variable & property** `(float)minValue`,`(float)maxValue` deprecated, replaced by `(CMMFloatRange)itemValueRange`
	* **variable & property** `(BOOL)snappable` added (default NO)

##Version 1.2.6
* [FIX] **`CMMDrawingManagerItem`** improved
	* **method** `-(void)setSpriteFrame:forKey:` deprecated
	* **method** `-(CCSpriteFrame *)spriteFrameForKey:` is unavailable
	* **variable** `(CMMDrawingManagerItemOtherFrames *)otherFrames` added
* [NEW] **`CMMDrawingManagerItemOtherFrames`** added
* [NEW] **`CMMPopupView`** improved
	* **method** `-(void)removeAllPopups` added
* [DEL] **`CMMGLView`** deprecated, replaced by `CCGLView` (*you need to migrate your source, please refer to SampleProject*)

##Version 1.2.5
* [NEW] **`CMMScrollMenuV`** improved ([**Jeff Lawton**](https://github.com/Zarkwizard)'s ideas)
	* **[variable]** `switchMode` added

##Version 1.2.4
* [FIX] **CMMScene** - `isOnTransition` variable name has changed `onTransition`
* [FIX] **CMMScene** - classes & methods has been changed (*you need to migrate your source*)
	* **[variable]** `staticLayerItemList` is unavailable
	* **[variable]** `countOfStaticLayerItem` deprecated, replaced by `countOfStaticLayers`
	* **[method]** `-(void)pushStaticLayerItem:` is unavailable
	* **[method]** `-(void)pushStaticLayerItemAtKey:` deprecated, replaced by `-(void)pushStaticLayerForKey:(NSString *)key_`
	* **[method]** `-(void)addStaticLayerItem:` is unavailable
	* **[method]** `-(id)addStaticLayerItemWithLayer:atKey:` deprecated, replaced by `-(void)setStaticLayer:forKey:`
	* **[method]** `-(void)removeStaticLayerItem:` is unavailable
	* **[method]** `-(void)removeStaticLayerItemAtIndex:` is unavailable
	* **[method]** `-(void)removeStaticLayerItemAtKey:` deprecated, replaced by `-(void)removeStaticLayerForKey:`
	* **[method]** `-(void)removeAllStaticLayerItems` deprecated, replaced by `-(void)removeAllStaticLayers`
	* **[method]** `-(id)staticLayerItemAtIndex:` is unavailable
	* **[method]** `-(id)staticLayerItemAtKey:` deprecated, replaced by `-(CMMLayer *)staticLayerForKey:`
	* **[method]** `-(id)staticLayerItemAtLayer:` is unavailable
	
	* **[method]** `-(uint)indexOfStaticLayerItem:` is unavailable
	* **[method]** `-(uint)indexOfStaticLayerItemWithLayer:` is unavailable
	* **[method]** `-(uint)indexOfStaticLayerItemWithKey:` is unavailable
* [DEL] **CMMSceneStaticLayerItem** is unavailable
* [FIX] **CMMSceneTransitionLayer** - methods has been changed (*you need to migrate your source*)
	* **[method]** `-(void)startFadeInTransitionWithTarget:callbackSelector:` deprecated, replaced by `-(void)scene:didStartTransitionWithCallbackAction:`
	* **[method]** `-(void)startFadeOutTransitionWithTarget:callbackSelector:` deprecated, replaced by `-(void)scene:didEndTransitionWithCallbackAction:`
* [FIX] **CMMScrollMenuV** - classes & methods has been changed (*you need to migrate your source*)
	* **[variable]** `filter_offsetOfDraggedItem` deprecated, replaced by `filter_itemDragViewOffset`
	* **[variable]** `action_itemDragViewCancelled` is unavailable, replaced by `callback_itemDragViewDisappeared`
	* **[variable,NEW]** `callback_itemDragViewAppeared` added
	* **[method]** `+(void)setDefaultFilter_offsetOfDraggedItem:` deprecated, replaced by `+(void)setDefaultFilter_itemDragViewOffset:`
	* **[method]** `+(void)setDefaultAction_itemDragViewCancelled:` is unavailable, replaced by `+(void)setDefaultCallback_itemDragViewDisappeared:`
	* **[method,NEW]** `+(void)setDefaultCallback_itemDragViewAppeared:` added

##Version 1.2.3 - Emergency patch
* [FIX] fixed a bug(rotation) in the CMMScene (thanks to [**Jeff Lawton**](https://github.com/Zarkwizard))

##Version 1.2.2
* [FIX] fix an issue that caused the file path in the `CMMDrawingManager`
* [FIX] change the name of the macro.
	* `cmmFuncCommon_nodeToworldRect` -> `cmmFunc_nodeToWorldRect`
	* `cmmFuncCommon_positionInParent` -> `cmmFunc_positionIPN`
	* `cmmFuncCommon_positionFromOtherNode` -> `cmmFunc_positionFON`
	* `cmmFuncCallDispatcher_mainQueue` -> `cmmFunc_callMainQueue`
	* `cmmFuncCallDispatcher_backQueue` -> `cmmFunc_callBackQueue`
* [FIX] `CMMSpriteBatchBar` deprecated, replaced by `CMM9SliceBar`
* [NEW] `CMMCameraManager` improved
* [FIX] fixed bugs in `CMMPopupView`
* [NEW] add variable `disabledColor` of `CMMControlItem`
* [FIX] fixed a bug(about place holder) in `CMMControlItemText`
* [FIX] variable `disableColor` of `CMMControlItemText` deprecated
* [NEW] add class `CMMControlItemCheckbox`
* [FIX] minor bugs have been fixed

##Version 1.2.1
* [FIX] add default block variable to `CMMScrollMenuV`
* [NEW] add variable `cleanupWhenAllSequencesEnded` to `CMMSequencer`
* [FIX] update `CMMSObjectBatchNode`
	* deprecated method `-(CMMSObject *)createObjectWithRect:(CGRect)rect_`
	* deprecated method `-(CMMSObject *)createObjectWithSpriteFrame:(CCSpriteFrame *)spriteFrame_`
	* deprecated method `-(CMMSObject *)createObject`
	* deprecated method `+(id)batchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* deprecated method `-(id)initWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* deprecated variable `fileName`
	* deprecated variable `isInDocument`
	* deprecated variable `objectClass`
* [FIX] update `CMMSObject`
	* change method `-(void)buildupBody` to `-(void)buildupBodyWithWorld:(CMMStageWorld *)world_`
	* deprecated variable `addToBatchNode`
* [FIX] update `CMMStageWorld`
	* deprecated method `-(CMMSObjectBatchNode *)addObatchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* deprecated method `-(void)removeObatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* deprecated method `-(CMMSObjectBatchNode *)obatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* deprecated method `-(int)indexOfObatchNodeFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* add method `-(void)addObject:(CMMSObject *)object_ buildInObatchNode:(BOOL)buildInObatchNode_`
* [FIX] `CMMSPlanet` class file merged to `CMMSObject_test` class file