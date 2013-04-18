##Version 1.3.3
* [FIX] **`CMMLayerMD`** changed
		
		//deprecated
		+(CCSpriteFrame *)defaultScrollbarFrameX;
		+(CCSpriteFrame *)defaultScrollbarFrameY;
		+(CMM9SliceEdgeOffset)defaultScrollbarEdgeX;
		+(CMM9SliceEdgeOffset)defaultScrollbarEdgeY;
		+(GLubyte)defaultScrollbarOpacityX;
		+(GLubyte)defaultScrollbarOpacityY;

* [FIX] **`CMM9SliceBar`** changed

		//deprecated
		+(id)sliceBarWithTargetSprite:(CCSprite *)targetSprite_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_;
		+(id)sliceBarWithTargetSprite:(CCSprite *)targetSprite_;

		-(id)initWithTargetSprite:(CCSprite *)targetSprite_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_;
		-(id)initWithTargetSprite:(CCSprite *)targetSprite_;

		@property (nonatomic, assign) CCSprite *targetSprite;
		
		//replaced by
		+(id)sliceBarWithTexture:(CCTexture2D *)texture_ targetRect:(CGRect)targetRect_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_;
		+(id)sliceBarWithTexture:(CCTexture2D *)texture_ targetRect:(CGRect)targetRect_;
		+(id)sliceBarWithTexture:(CCTexture2D *)texture_;

		-(id)initWithTexture:(CCTexture2D *)texture_ targetRect:(CGRect)targetRect_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_;
		-(id)initWithTexture:(CCTexture2D *)texture_ targetRect:(CGRect)targetRect_;
		-(id)initWithTexture:(CCTexture2D *)texture_;

		-(void)setTexture:(CCTexture2D *)texture_ targetRect:(CGRect)targetRect_;
		-(void)setTextureWithSprite:(CCSprite *)sprite_;
		-(void)setTextureWithFrame:(CCSpriteFrame *)frame_;

		@property (nonatomic, readwrite) CGRect targetRect;
		
* [FIX] **`CMMFontUtil`** improved
		
		//preset added
		@interface CMMFontPreset : NSObject

		@property (nonatomic, readwrite) float fontSize;
		@property (nonatomic, readwrite) CGSize dimensions;
		@property (nonatomic, readwrite) CCTextAlignment hAlignment;
		@property (nonatomic, readwrite) CCVerticalTextAlignment vAlignment;
		@property (nonatomic, readwrite) CCLineBreakMode lineBreakMode;
		@property (nonatomic, copy) NSString *fontName;

		@end
		
		//using preset
		@interface CMMFontUtil(Preset)

		+(NSDictionary *)presetList;

		+(void)setPreset:(CMMFontPreset *)preset_ forKey:(NSString *)key_;
		+(void)removePresetForKey:(NSString *)key_;
		+(CMMFontPreset *)presetForKey:(NSString *)key_;

		+(CCLabelTTF *)labelWithString:(NSString *)string_ withPresetKey:(NSString *)presetKey_;

		@end

		//deprecated
		@interface CMMFontUtil(Deprecated)
	
		+(float)defaultFontSize;
		+(CGSize)defaultDimensions;
		+(CCTextAlignment)defaultHAlignment;
		+(CCVerticalTextAlignment)defaultVAlignment;
		+(CCLineBreakMode)defaultLineBreakMode;
		+(NSString *)defaultFontName;
		
		@end
		
* [FIX] **`CMMMenuItem`** improved
	
		//deprecated
		@property (nonatomic, retain) CCSprite *normalImage,*selectedImage;
		
		//replaced by
		-(void)setNormalFrame:(CCSpriteFrame *)frame_;
		-(void)setNormalFrameWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_;
		-(void)setNormalFrameWithSprite:(CCSprite *)sprite_;

		-(void)setSelectedFrame:(CCSpriteFrame *)frame_;
		-(void)setSelectedFrameWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_;
		-(void)setSelectedFrameWithSprite:(CCSprite *)sprite_;
		
		@property (nonatomic, readonly) CCSpriteFrame *normalFrame,*selectedFrame;
		
* [FIX] **`CMMControlItemSwitch`** changed
	
		//deprecated
		+(id)controlItemSwitchWithMaskSprite:(CCSprite *)maskSprite_ backSprite:(CCSprite *)backSprite_ buttonSprite:(CCSprite *)buttonSprite_;
		-(id)initWithMaskSprite:(CCSprite *)maskSprite_ backSprite:(CCSprite *)backSprite_ buttonSprite:(CCSprite *)buttonSprite_;
		
		//replaced by
		+(id)controlItemSwitchWithMaskFrame:(CCSpriteFrame *)maskFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_;
		-(id)initWithMaskFrame:(CCSpriteFrame *)maskFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_;
		
		+(void)setDefaultBackColorLeft:(ccColor3B)color_;
		+(void)setDefaultBackColorRight:(ccColor3B)color_;

		+(void)setDefaultBackLabelColorLeft:(ccColor3B)color_;
		+(void)setDefaultBackLabelColorRight:(ccColor3B)color_;

		+(void)setDefaultBackLabelOpacityLeft:(GLubyte)opacity_;
		+(void)setDefaultBackLabelOpacityRight:(GLubyte)opacity_;

		+(void)setDefaultBackLabelSizeLeft:(float)size_;
		+(void)setDefaultBackLabelSizeRight:(float)size_;

		+(void)setDefaultBackLabelStringLeft:(NSString *)string_;
		+(void)setDefaultBackLabelStringRight:(NSString *)string_;
		
		@property (nonatomic, readwrite) ccColor3B backColorL,backColorR;
		@property (nonatomic, readwrite) ccColor3B backLabelColorL,backLabelColorR;
		@property (nonatomic, readwrite) GLubyte backLabelOpacityL,backLabelOpacityR;
		@property (nonatomic, readwrite) float backLabelSizeL,backLabelSizeR;
		@property (nonatomic, assign) NSString *backLabelStringL,*backLabelStringR;

* [FIX] **`CMMControlItemSlider`** changed
	
		//deprecated
		+(id)controlItemSliderWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_;
		+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_;
		-(id)initWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_;
		-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_;
		
		-(void)setButtonSprite:(CCSprite *)buttonSprite_;
		
		//replaced by
		+(id)controlItemSliderWithWidth:(float)width_ maskFrame:(CCSpriteFrame *)maskFrame_ barFrame:(CCSpriteFrame *)barFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_;
		+(id)controlItemSliderWithWidth:(float)width_ frameSeq:(uint)frameSeq_;

		-(id)initWithWidth:(float)width_ maskFrame:(CCSpriteFrame *)maskFrame_ barFrame:(CCSpriteFrame *)barFrame_ buttonFrame:(CCSpriteFrame *)buttonFrame_;
		-(id)initWithWidth:(float)width_ frameSeq:(uint)frameSeq_;
		
		-(void)setButtonFrame:(CCSpriteFrame *)frame_;
		-(void)setButtonFrameWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_;
		-(void)setButtonFrameWithSprite:(CCSprite *)sprite_;
		
* [FIX] **`CMMControlItemText`** changed
	
		//deprecated
		+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ frameSize:(CGSize)frameSize_;
		+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_;

		+(id)controlItemTextWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_;
		+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_;

		-(id)initWithBarSprite:(CCSprite *)barSprite_ frameSize:(CGSize)frameSize_;
		-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_;

		-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_;
		-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_;

		-(void)redrawWithBar; 
		
		//replaced by
		+(id)controlItemTextWithFrameSize:(CGSize)frameSize_ barFrame:(CCSpriteFrame *)barFrame_;
		+(id)controlItemTextWithWidth:(float)width_ barFrame:(CCSpriteFrame *)barFrame_;

		+(id)controlItemTextWithFrameSize:(CGSize)frameSize_ frameSeq:(uint)frameSeq_;
		+(id)controlItemTextWithWidth:(float)width_ frameSeq:(uint)frameSeq_;

		-(id)initWithFrameSize:(CGSize)frameSize_ barFrame:(CCSpriteFrame *)barFrame_;
		-(id)initWithWidth:(float)width_ barFrame:(CCSpriteFrame *)barFrame_;

		-(id)initWithFrameSize:(CGSize)frameSize_ frameSeq:(uint)frameSeq_;
		-(id)initWithWidth:(float)width_ frameSeq:(uint)frameSeq_;
		
* [FIX] **`CMMControlItemCheckbox`** changed
	
		//deprecated
		+(id)controlItemCheckboxWithBackSprite:(CCSprite *)backSprite_ checkSprite:(CCSprite *)checkSprite_;
		-(id)initWithBackSprite:(CCSprite *)backSprite_ checkSprite:(CCSprite *)checkSprite_;
		
		//replaced by
		+(id)controlItemCheckboxWithBackFrame:(CCSpriteFrame *)backFrame_ checkFrame:(CCSpriteFrame *)checkFrame_;
		-(id)initWithBackFrame:(CCSpriteFrame *)backSprite_ checkFrame:(CCSpriteFrame *)checkFrame_;
		
* [NEW] **`CMMControlItemCombo`** added
* [FIX] minor bugs fixed
* [FIX] change cocos2d library version


##Version 1.3.2
* [FIX] **`CMMLayerMD`** improved
	
		//deprecated
		+(void)setDefaultScrollbarX:(CCSprite *)scrollbar_;
		+(CCSprite *)defaultScrollbarX;
		+(void)setDefaultScrollbarY:(CCSprite *)scrollbar_;
		+(CCSprite *)defaultScrollbarY;
		
		//replace by
		@interface CMMLayerMD(Configuration)
			+(void)setDefaultScrollbarFrameX:(CCSpriteFrame *)scrollbar_;
			+(void)setDefaultScrollbarFrameY:(CCSpriteFrame *)scrollbar_;
			+(CCSpriteFrame *)defaultScrollbarFrameX;
			+(CCSpriteFrame *)defaultScrollbarFrameY;

			+(void)setDefaultScrollbarEdgeX:(CMM9SliceEdgeOffset)edge_;
			+(void)setDefaultScrollbarEdgeY:(CMM9SliceEdgeOffset)edge_;
			+(CMM9SliceEdgeOffset)defaultScrollbarEdgeX;
			+(CMM9SliceEdgeOffset)defaultScrollbarEdgeY;

			+(void)setDefaultScrollbarOpacityX:(GLubyte)opacity_;
			+(void)setDefaultScrollbarOpacityY:(GLubyte)opacity_;
			+(GLubyte)defaultScrollbarOpacityX;
			+(GLubyte)defaultScrollbarOpacityY;
		@end

##Version 1.3.1
* [NEW] **`CMMGestureDispatcher`** added
	* You can control the gesture
* [DEL] **`CMMPinchState`** is unavailable
		
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
			
* [FIX] **`CMMTouchDispatcher`** updated
	* **variable & property** `CMMPinchState` is unavailable, please refer `CMMGestureDispatcher`
	
			@property (nonatomic, readwrite) kCMMPinchState pinchState UNAVAILABLE_ATTRIBUTE;
			
* [FIX] **`CMMControlItemSlider`** bugs fixed
* [FIX] **`CMMStage`** improved

			//deprecated
			@property (nonatomic, copy) CMMStageObjectBlock callback_whenObjectAdded DEPRECATED_ATTRIBUTE;
			@property (nonatomic, copy) CMMStageObjectBlock callback_whenObjectRemoved DEPRECATED_ATTRIBUTE;
			
			//replace by
			-(void)addObjectCallback:(CMMStageObjectCallback *)callback_;
			-(CMMStageObjectCallback *)addObjectCallbackWithType:(CMMStageObjectCallbackType)type_ callback:(CMMStageObjectBlock)callback_;
			-(void)removeObjectCallbackAtIndex:(uint)index_;
			-(void)removeObjectCallback:(CMMStageObjectCallback *)callback_;
			-(void)removeAllObjectCallbacks;
			-(uint)indexOfObjectCallback:(CMMStageObjectCallback *)callback_;
	

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