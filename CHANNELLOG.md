##Version 1.2.3
// todo

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