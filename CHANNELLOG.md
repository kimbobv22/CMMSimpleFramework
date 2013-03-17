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