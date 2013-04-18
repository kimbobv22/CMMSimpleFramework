//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDeprecated.h"

@implementation CMMGLView

@end

@implementation CMMViewController

-(NSUInteger)supportedInterfaceOrientations{
	UIApplication *application_ = [UIApplication sharedApplication];
	return [application_ supportedInterfaceOrientationsForWindow:[application_ keyWindow]];
}
-(BOOL)shouldAutorotate{
	return YES;
}

@end

@implementation CMMScene(Deprecated)

-(ccTime)fadeTime{
	return 0.0f;
}
-(void)setFadeTime:(ccTime)fadeTime{}

-(ccColor3B)transitionColor{
	return ccc3(0, 0, 0);
}
-(void)setTransitionColor:(ccColor3B)transitionColor{}

-(void)setIsTouchEnable:(BOOL)isTouchEnable_{
	[self setTouchEnable:isTouchEnable_];
}
-(id)popupDispatcher{return [self popupView];}
-(BOOL)_isOnTransition{
	return [self isOnTransition];
}
-(CCArray *)staticLayerItemList{return nil;}
-(uint)countOfStaticLayerItem{
	return [self countOfStaticLayers];
}

-(void)closePopup:(CMMPopupLayer *)popup_ withData:(id)data_{
	[popup_ close];
}
-(void)closePopup:(CMMPopupLayer *)popup_{
	[popup_ close];
}

-(void)openPopup:(CMMPopupLayer *)popup_ delegate:(id)delegate_{
	[self openPopup:popup_];
}
-(void)openPopupAtFirst:(CMMPopupLayer *)popup_ delegate:(id)delegate_{
	[self openPopupAtFirst:popup_];
}

-(void)pushStaticLayerItem:(id)staticLayerItem_{}
-(void)pushStaticLayerItemAtKey:(NSString *)key_{
	[self pushStaticLayerForKey:key_];
}

-(void)addStaticLayerItem:(id)staticLayerItem_{}
-(id)addStaticLayerItemWithLayer:(CMMLayer *)layer_ atKey:(NSString *)key_{
	[self setStaticLayer:layer_ forKey:key_];
	return layer_;
}

-(void)removeStaticLayerItem:(id)staticLayerItem_{}
-(void)removeStaticLayerItemAtIndex:(uint)index_{}
-(void)removeStaticLayerItemAtKey:(NSString *)key_{
	[self removeStaticLayerForKey:key_];
}
-(void)removeAllStaticLayerItems{
	[self removeAllStaticLayers];
}

-(id)staticLayerItemAtIndex:(uint)index_{return nil;}
-(id)staticLayerItemAtKey:(NSString *)key_{
	return [self staticLayerForKey:key_];
}
-(id)staticLayerItemAtLayer:(CMMLayer *)layer_{return nil;}

-(uint)indexOfStaticLayerItem:(id)staticLayerItem_{return NSNotFound;}
-(uint)indexOfStaticLayerItemWithLayer:(CMMLayer *)layer_{return NSNotFound;}
-(uint)indexOfStaticLayerItemWithKey:(NSString *)key_{return NSNotFound;}

-(void)sceneDidStartLoading:(CMMScene *)scene_{
	NSAssert(FALSE, @"CMMSceneLoadingProtocol has been UNAVAILABLE");
}
-(void)sceneDidEndLoading:(CMMScene *)scene_{
	NSAssert(FALSE, @"CMMSceneLoadingProtocol has been UNAVAILABLE");
}
-(void)scene:(CMMScene *)scene_ didChangeLoadingSequence:(uint)curSequence_ sequenceCount:(uint)sequenceCount_{
	NSAssert(FALSE, @"CMMSceneLoadingProtocol has been UNAVAILABLE");
}
-(void)sceneLoadingProcess000{
	NSAssert(FALSE, @"CMMSceneLoadingProtocol has been UNAVAILABLE");
}

@end

@implementation CMMSceneStaticLayerItem
@synthesize key,layer;

+(id)staticLayerItemWithLayer:(CMMLayer *)layer_ key:(NSString *)key_{
	return [[[self alloc] initWithLayer:layer_ key:key_] autorelease];
}
-(id)initWithLayer:(CMMLayer *)layer_ key:(NSString *)key_{
	if(!(self = [super init])) return self;
	
	[self setKey:key_];
	[self setLayer:layer_];
	
	return self;
}
-(void)setIsFirstLoad:(BOOL)isFirstLoad{}
-(BOOL)isFirstLoad{return NO;}

-(void)dealloc{
	[key release];
	[layer release];
	[super dealloc];
}

@end

@implementation CMMSceneTransitionLayer(Deprecated)

-(void)startFadeInTransitionWithTarget:(id)target_ callbackSelector:(SEL)selector_{}
-(void)startFadeOutTransitionWithTarget:(id)target_ callbackSelector:(SEL)selector_{}

@end

@implementation CMMLayer(Deprecated)

-(void)loadingProcess000{
	// change to protocol -> CMMSceneLoadingProtocol
}
-(void)whenLoadingEnded{
	// change to protocol -> CMMSceneLoadingProtocol
}

@end

@implementation CMMLayerMask

@end

@implementation CMMLayerMaskDrag

@end

@implementation CMMLayerMD(Deprecated)

+(void)setDefaultScrollbarX:(CCSprite *)scrollbar_{
	[self setDefaultScrollbarFrameX:[CCSpriteFrame frameWithTexture:[scrollbar_ texture] rect:[scrollbar_ textureRect]]];
}
+(CCSprite *)defaultScrollbarX{
	return [CCSprite spriteWithSpriteFrame:[self defaultScrollbarFrameX]];
}

+(void)setDefaultScrollbarY:(CCSprite *)scrollbar_{
	[self setDefaultScrollbarFrameY:[CCSpriteFrame frameWithTexture:[scrollbar_ texture] rect:[scrollbar_ textureRect]]];
}
+(CCSprite *)defaultScrollbarY{
	return [CCSprite spriteWithSpriteFrame:[self defaultScrollbarFrameY]];
}

+(CCSpriteFrame *)defaultScrollbarFrameX{
	return CMMLayerMDScrollbarFrameX;
}
+(CCSpriteFrame *)defaultScrollbarFrameY{
	return CMMLayerMDScrollbarFrameY;
}
+(CMM9SliceEdgeOffset)defaultScrollbarEdgeX{
	return CMMLayerMDScrollbarEdgeX;
}
+(CMM9SliceEdgeOffset)defaultScrollbarEdgeY{
	return CMMLayerMDScrollbarEdgeY;
}
+(GLubyte)defaultScrollbarOpacityX{
	return CMMLayerMDScrollbarOpacityX;
}
+(GLubyte)defaultScrollbarOpacityY{
	return CMMLayerMDScrollbarOpacityY;
}

-(void)setIsAlwaysShowScrollbar:(BOOL)isAlwaysShowScrollbar_{
	[self setAlwaysShowScrollbar:isAlwaysShowScrollbar_];
}
-(BOOL)_isAlwaysShowScrollbar{
	return [self isAlwaysShowScrollbar];
}
-(void)setIsCanDragX:(BOOL)isCanDragX_{
	[self setCanDragX:isCanDragX_];
}
-(BOOL)_isCanDragX{
	return [self isCanDragX];
}
-(void)setIsCanDragY:(BOOL)isCanDragY_{
	[self setCanDragY:isCanDragY_];
}
-(BOOL)_isCanDragY{
	return [self isCanDragY];
}
-(void)setScrollbar:(CMMLayerMDScrollbar)scrollbar{}
-(CMMLayerMDScrollbar)scrollbar{return CMMLayerMDScrollbar();}

-(void)setDragSpeed:(float)dragSpeed_{
	[self setScrollSpeed:dragSpeed_];
}
-(float)dragSpeed{
	return [self scrollSpeed];
}
-(void)setTouchState:(int)touchState{}
-(int)touchState{return (CMMTouchState)0;};

@end

@implementation CMMLayerPinchZoom

@end

@implementation CCSpriteBatchNode(Deprecated)

-(CCSprite *)addSplitSpriteToRect:(CGRect)rect_ blendFunc:(ccBlendFunc)tBlendFunc_{
	return [self addSplitSpriteToRect:rect_];
}
-(void)addSplitSprite:(CGSize)splitUnit_ blendFunc:(ccBlendFunc)tBlendFunc_{
	return [self addSplitSprite:splitUnit_];
}

@end

@implementation CMMSpriteBatchBar
@synthesize edgeSize;

+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_{
	return [self sliceBarWithTexture:[targetSprite_ texture] targetRect:[targetSprite_ textureRect] edgeOffset:CMM9SliceEdgeOffset(edgeSize_)];
}
+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_{
	return [self sliceBarWithTexture:[targetSprite_ texture] targetRect:[targetSprite_ textureRect]];
}

-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_{
	return [self initWithTexture:[targetSprite_ texture] targetRect:[targetSprite_ textureRect] edgeOffset:CMM9SliceEdgeOffset(edgeSize_)];
}
-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_{
	return [self initWithTexture:[targetSprite_ texture] targetRect:[targetSprite_ textureRect]];
}

-(void)setEdgeSize:(CGSize)edgeSize_{
	[self setEdgeOffset:CMM9SliceEdgeOffset(edgeSize_)];
}
-(CGSize)edgeSize{
	return CGSizeMake(edgeOffset.left, edgeOffset.bottom);
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{}

@end

@implementation CMM9SliceBar(Deprecated)

+(id)sliceBarWithTargetSprite:(CCSprite *)targetSprite_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_{
	return [self sliceBarWithTexture:[targetSprite_ texture] targetRect:[targetSprite_ textureRect]];
}
+(id)sliceBarWithTargetSprite:(CCSprite *)targetSprite_{
	return [self sliceBarWithTexture:[targetSprite_ texture]];
}

-(id)initWithTargetSprite:(CCSprite *)targetSprite_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_{
	return [self initWithTexture:[targetSprite_ texture] targetRect:[targetSprite_ textureRect]];
}
-(id)initWithTargetSprite:(CCSprite *)targetSprite_{
	return [self initWithTexture:[targetSprite_ texture]];
}

-(void)setTargetSprite:(CCSprite *)targetSprite_{
	[self setTexture:[targetSprite_ texture] targetRect:[targetSprite_ textureRect]];
}
-(CCSprite *)targetSprite{
	return [CCSprite spriteWithTexture:[self texture] rect:[self targetRect]];
}

@end

@implementation CMMFontUtil(Deprecated)

+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_ fontName:(NSString*)fontName_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_ fontName:fontName_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_ lineBreakMode:(CCLineBreakMode)lineBreakMode_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_ lineBreakMode:lineBreakMode_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_ vAlignment:(CCVerticalTextAlignment)vAlignment_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_ vAlignment:vAlignment_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_ hAlignment:(CCTextAlignment)hAlignment_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_ hAlignment:hAlignment_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_ dimensions:(CGSize)dimensions_{
	return [self labelWithString:string_ fontSize:fontSize_ dimensions:dimensions_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_ fontSize:(float)fontSize_{
	return [self labelWithString:string_ fontSize:fontSize_];
}
+(CCLabelTTF *)labelWithstring:(NSString *)string_{
	return [self labelWithString:string_];
}

+(float)defaultFontSize{
	return CMMFontUtilDefaultFontSize;
}
+(CGSize)defaultDimensions{
	return CMMFontUtilDefaultDimensions;
}
+(CCTextAlignment)defaultHAlignment{
	return CMMFontUtilDefaultHAlignment;
}
+(CCVerticalTextAlignment)defaultVAlignment{
	return CMMFontUtilDefaultVAlignment;
}
+(CCLineBreakMode)defaultLineBreakMode{
	return CMMFontUtilDefaultLineBreakMode;
}
+(NSString *)defaultFontName{
	return CMMFontUtilDefaultFontName;
}

@end

@implementation CMMLoadingObject

@end

@implementation CMMSequenceMaker
@synthesize delegate,sequenceMethodFormatter,curSequence,sequenceCount,sequenceState,sequenceTimeInterval;

+(id)sequenceMaker{
	return [self sequencer];
}

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}
-(void)setSequenceMethodFormatter:(NSString *)sequenceMethodFormatter{}
-(NSString *)sequenceMethodFormatter{return nil;}
-(uint)curSequence{return 0;}
-(uint)sequenceCount{return 0;}
-(void)setSequenceState:(CMMSequenceMakerState)sequenceState{}
-(CMMSequenceMakerState)sequenceState{return (CMMSequenceMakerState)0;}
-(void)setSequenceTimeInterval:(ccTime)sequenceTimeInterval{}
-(ccTime)sequenceTimeInterval{return 0.0f;};

@end

@implementation CMMSequenceMakerAuto

+(id)sequenceMaker{
	return [self sequencer];
}

@end

NSString *const CMMDrawingManagerItemFormatter_SwitchBack = @"%@_SWITCH_BACK.png";

@implementation CMMDrawingManagerItem(Deprecated)

//for reference
-(NSString *)_keyFormatterForCMMDrawingManagerItemKey:(int)key_{
	NSString *result_ = nil;
	switch(key_){
		case 0:
			result_ = CMMDrawingManagerItemFormatter_SwitchButton;
			break;
		/*case 1:
			result_ = CMMDrawingManagerItemFormatter_SwitchBack;
			break;*/
		case 2:
			result_ = CMMDrawingManagerItemFormatter_SwitchMask;
			break;
		case 3:
			result_ = CMMDrawingManagerItemFormatter_SlideBar;
			break;
		case 4:
			result_ = CMMDrawingManagerItemFormatter_SlideButton;
			break;
		case 5:
			result_ = CMMDrawingManagerItemFormatter_SlideMask;
			break;
		case 6:
			result_ = CMMDrawingManagerItemFormatter_TextBar;
			break;
		case 7:
			result_ = CMMDrawingManagerItemFormatter_CheckboxBack;
			break;
		case 8:
			result_ = CMMDrawingManagerItemFormatter_CheckboxCheck;
			break;
		case 9:
		default:{break;}
	}
	
	return result_;
}

-(void)setSpriteFrame:(CCSpriteFrame *)spriteFrame_ forKey:(CMMDrawingManagerItemKey)key_{}
-(CCSpriteFrame *)spriteFrameForKey:(CMMDrawingManagerItemKey)key_{
	return [[self otherFrames] spriteFrameForKeyFormatter:[self _keyFormatterForCMMDrawingManagerItemKey:key_]];
}

@end

@implementation CMMDrawingManager(Deprecated)

-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ barYN:(BOOL)barYN_{
	return [self textureBatchBarWithFrameSeq:frameSeq_ batchBarSeq:0 size:size_];
}
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_{
	return [self textureBatchBarWithFrameSeq:frameSeq_ batchBarSeq:0 size:size_];
}
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_{
	return [self textureBatchBarWithFrameSeq:frameSeq_ batchBarSeq:0 size:size_];
}

@end

@implementation CMMSimpleCache(Deprecated)

-(void)cacheObject:(id)object_{
	[self addObject:object_];
}
-(void)clearCache{
	[self removeAllObjects];
}

@end

@implementation CMMSoundHandlerItem(Deprecated)

-(CMMSoundHandlerItemType)type{
	return (CMMSoundHandlerItemType)0;
}
-(void)setType:(CMMSoundHandlerItemType)type_{}

@end

@implementation CMMSoundHandlerItemFollow

+(id)itemWithSoundSource:(CDSoundSource *)soundSource_ trackNode:(CCNode *)trackNode_{
	return [[[self alloc] initWithSoundSource:soundSource_ trackNode:trackNode_] autorelease];
}

-(id)initWithSoundSource:(CDSoundSource *)soundSource_ trackNode:(CCNode *)trackNode_{
	if(!(self = [self initWithSoundSource:soundSource_ soundPoint:CGPointZero])) return self;
	
	[self setTrackNode:trackNode_];
	
	return self;
}

@end

@implementation CMMSoundHandler(Deprecated)

-(CMMSoundHandlerItem *)addSoundItem:(NSString*)soundPath_ soundPoint:(CGPoint)soundPoint_{
	return [self addSoundItemWithSoundPath:soundPath_ soundPoint:soundPoint_];
}
-(CMMSoundHandlerItem *)addSoundItem:(NSString*)soundPath_{
	return [self addSoundItemWithSoundPath:soundPath_];
}

-(CMMSoundHandlerItem *)addSoundItemFollow:(NSString*)soundPath_ trackNode:(CCNode *)trackNode_{
	CMMSoundHandlerItem *soundItem_ = [self addSoundItem:soundPath_ soundPoint:CGPointZero];
	soundItem_.trackNode = trackNode_;
	return soundItem_;
}

-(CMMSoundHandlerItem *)cachedSoundItem:(CMMSoundHandlerItemType)soundItemType_{
	return [_cachedElements cachedObject];
}

@end

@implementation CMMTimeIntervalArray(Deprecated)

-(void)setCallback_whenAddedObject:(void (^)(CCArray *))block_{
	[self setCallback_whenObjectsAdded:block_];
}
-(void(^)(CCArray *))callback_whenAddedObject{return [self callback_whenObjectsAdded];}

-(void)setCallback_whenRemovedObject:(void (^)(CCArray *))block_{
	[self setCallback_whenObjectsRemoved:block_];
}
-(void(^)(CCArray *))callback_whenRemovedObject{return [self callback_whenObjectsRemoved];}

-(void)setFilter_whenAddedObject:(void (^)(id))filter_whenAddedObject{
	NSAssert(FALSE, @"using 'setCallback_whenObjectsAdded:'");
}
-(void(^)(id))filter_whenAddedObject{return nil;}

-(void)setFilter_whenRemovedObject:(void (^)(id))filter_whenRemovedObject{
	NSAssert(FALSE, @"using 'setCallback_whenObjectsRemoved:'");
}
-(void(^)(id))filter_whenRemovedObject{return nil;}

@end

@implementation CMMTouchDispatcher(Deprecated)

+(void)setAllTouchDispatcherEnable:(BOOL)enable_{
	[[CMMScene sharedScene] setIsTouchEnable:enable_];
}
+(BOOL)isAllTouchDispatcherEnable{
	return [[CMMScene sharedScene] isTouchEnable];
}
-(void)setPinchState:(kCMMPinchState)pinchState{}
-(kCMMPinchState)pinchState{return kCMMPinchState();}

@end

@implementation CMMTouchDispatcherScene

@end

@implementation CMMPopupDispatcher

@end

@implementation CMMPopupDispatcherItem
@synthesize delegate,popupDispatcher,popup;

+(id)popupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id)delegate_{
	return [[[self alloc] initWithPopup:popup_ delegate:delegate_] autorelease];
}
-(id)initWithPopup:(CMMPopupLayer *)popup_ delegate:(id)delegate_{
	[self release];
	NSAssert(NO, @"CMMPopupDispatcherItem class has UNAVAILABLE!");
	return self;
}

-(void)setPopup:(CMMPopupLayer *)popup_{}
-(CMMPopupLayer *)popup{return nil;}
-(void)setPopupDispatcher:(id)popupDispatcher{};
-(id)popupDispatcher{return nil;}
-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}

-(void)popup:(CMMPopupLayer *)popup_ didCloseWithReceivedData:(id)data_{}

@end

@implementation CMMPopupDispatcherTemplate

-(void)startPopupWithPopupLayer:(CMMPopupLayer *)popupLayer_{}
-(void)endPopupWithPopupLayer:(CMMPopupLayer *)popupLayer_ callbackAction:(CCCallBlock *)callbackAction_{}

@end

@implementation CMMPopupDispatcherTemplate_FadeInOut

@end

@implementation CMMPopupView(Deprecated)

+(id)popupDispatcherWithScene:(CMMScene *)scene_{
	return [self popupDispatcherWithTarget:scene_];
}
+(id)popupDispatcherWithTarget:(CCNode *)target_{
	return [self popupView];
}
-(id)initWithTarget:(CCNode *)target_{
	return [self init];
}
-(id)initWithScene:(CMMScene *)scene_{
	return [self init];
}


-(void)addPopupItem:(id)popupItem_ atIndex:(int)index_{}
-(id)addPopupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id)delegate_ atIndex:(int)index_{return nil;}
-(id)addPopupItemWithPopup:(CMMPopupLayer *)popup_ delegate:(id)delegate_{return nil;}

-(void)removePopupItem:(id)popupItem_ withData:(id)data_{}
-(void)removePopupItem:(id)popupItem_{}
-(void)removePopupItemAtIndex:(int)index_ withData:(id)data_{}
-(void)removePopupItemAtIndex:(int)index_{}
-(void)removePopupItemAtPopup:(CMMPopupLayer *)popup_ withData:(id)data_{}
-(void)removePopupItemAtPopup:(CMMPopupLayer *)popup_{}

-(id)popupItemAtIndex:(int)index_{return nil;}

-(int)indexOfPopupItem:(id)popupItem_{return NSNotFound;}

-(void)setScene:(CMMScene *)scene_{}
-(CMMScene *)scene{return nil;}
-(CMMPopupLayer *)curPopup{
	return [self headPopup];
}
-(void)setPopupTemplate:(id)popupTemplate_{}
-(id)popupTemplate{return nil;};
-(uint)popupCount{
	return [self count];
}

@end

@implementation CMMPopupMasterView

+(id)viewWithPopupDispatcher:(id)popupDispatcher_{
	return nil;
}
-(id)initWithPopupDispatcher:(id)popupDispatcher_{
	[self release];
	NSAssert(NO, @"CMMPopupMasterView has UNAVAILABLE");
	return self;
}

@end

@implementation CMMPopupLayer(Deprecated)

-(void)closeWithSendData:(id)data_{
	[self close];
}
-(void)setPopupDispatcherItem:(id)popupDispatcherItem{}
-(id)popupDispatcherItem{
	return nil;
}

@end

@implementation CMMLayerPopup

@end

@implementation CMMMotionDispatcher(Deprecated)

-(void)addTarget:(id)target_{
	NSAssert(FALSE, @"using 'addMotionBlockForTarget:block:'");
}

-(void)removeTarget:(id)target_{
	NSAssert(FALSE, @"using 'removeMotionBlockForTarget:'");
}

-(void)removeTargetAtIndex:(int)index_{}
-(id)targetAtIndex:(int)index_{return nil;}
-(int)indexOfTarget:(id)target_{return NSNotFound;}
-(CCArray *)targetList{return nil;}

@end

@implementation CMMMenuItem(Deprecated)

+(id)menuItemWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [self menuItemWithFrameSeq:frameSeq_ batchBarSeq:0 frameSize:frameSize_];
}
+(id)menuItemWithFrameSeq:(int)frameSeq_{
	return [self menuItemWithFrameSeq:frameSeq_ batchBarSeq:0];
}
-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [self initWithFrameSeq:frameSeq_ batchBarSeq:0 frameSize:frameSize_];
}
-(id)initWithFrameSeq:(int)frameSeq_{
	return [self initWithFrameSeq:frameSeq_ batchBarSeq:0];
}

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}
-(void)setIsEnable:(BOOL)isEnable_{
	[self setEnable:isEnable_];
}
-(BOOL)_isEnable{
	return [self isEnable];
}

-(void)setNormalImage:(CCSprite *)normalImage_{
	[self setNormalFrameWithSprite:normalImage_];
}
-(CCSprite *)normalImage{return nil;}
-(void)setSelectedImage:(CCSprite *)selectedImage_{
	[self setSelectedFrameWithSprite:selectedImage_];
}
-(CCSprite *)selectedImage{return nil;}

@end

@implementation CMMMenuItemLabelTTF

@end

@implementation CMMMenuItemSet(Deprecated)

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}
-(void)setIsEnable:(BOOL)isEnable_{
	[self setEnable:isEnable_];
}
-(BOOL)_isEnable{
	return [self isEnable];
}

-(void)setCallback_pushup:(void (^)(id, CMMMenuItem *))block_{
	[self setCallback_whenItemPushup:^(CMMMenuItem *item_) {
		block_(self,item_);
	}];
}
-(void(^)(id,CMMMenuItem *))callback_pushdown{return nil;}
-(void(^)(id,CMMMenuItem *))callback_pushup{return nil;}
-(void)setCallback_pushdown:(void (^)(id, CMMMenuItem *))block_{
	[self setCallback_whenItemPushdown:^(CMMMenuItem *item_) {
		block_(self,item_);
	}];
}

@end

@implementation CMMScrollMenu(Deprecated)

+(id)scrollMenuWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [self scrollMenuWithFrameSeq:frameSeq_ batchBarSeq:0 frameSize:frameSize_];
}

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}
-(void)setIsCanSelectItem:(BOOL)isCanSelectItem_{
	[self setInnerLayerTouchEnable:isCanSelectItem_];
}
-(BOOL)_isCanSelectItem{
	return [self isInnerLayerTouchEnable];
}
-(void)setCanSelectItem:(BOOL)canSelectItem_{
	[self setInnerLayerTouchEnable:canSelectItem_];
}
-(BOOL)isCanSelectItem{
	return [self isInnerLayerTouchEnable];
}

@end

@implementation CMMScrollMenuVItemDragView(Deprecated)

-(void)setTextureWithMenuItem:(CMMMenuItem *)menuItem_{
	[self setTargetItem:menuItem_];
}
-(void)setTargetIndex:(int)targetIndex_{}
-(int)targetIndex{return -1;};

@end

@implementation CMMScrollMenuV(Deprecated)

+(void)setDefaultFilter_offsetOfDraggedItem:(CGPoint (^)(CGPoint orginalPoint_, CGPoint targetPoint_,ccTime dt_))block_{
	[self setDefaultFilter_itemDragViewOffset:block_];
}
+(void)setDefaultAction_itemDragViewCancelled:(CCFiniteTimeAction *(^)(CMMScrollMenuVItemDragView *itemDragView_, CGPoint targetPoint_))block_{
	//refer to
	//	[self setDefaultCallback_itemDragViewDisappeared:block_];
}

-(void)setAction_itemDragViewCancelled:(CCFiniteTimeAction *(^)(CMMScrollMenuVItemDragView *, CGPoint))action_itemDragViewCancelled{}
-(CCFiniteTimeAction *(^)(CMMScrollMenuVItemDragView *, CGPoint))action_itemDragViewCancelled{return nil;}
-(void)setFilter_offsetOfDraggedItem:(CGPoint (^)(CGPoint, CGPoint, ccTime))block_{
	[self setFilter_itemDragViewOffset:block_];
}
-(CGPoint (^)(CGPoint, CGPoint, ccTime))filter_offsetOfDraggedItem{
	return [self filter_itemDragViewOffset];
}

@end

@implementation CMMScrollMenuH(Deprecated)

-(void)setFouceItemScale:(float)fouceItemScale{}
-(float)fouceItemScale{return 1.0f;}
-(void)setNonefouceItemScale:(float)nonefouceItemScale{}
-(float)nonefouceItemScale{return 1.0f;}
-(void)setMinScrollAccelToSnap:(float)value_{}
-(float)minScrollAccelToSnap{return 0.0f;}

@end

@implementation CMMControlItemBatchBar

@end

@implementation CMMControlItem(Deprecated)

-(void)setDelegate:(id)delegate_{}
-(id)delegate{return nil;}
-(void)setIsEnable:(BOOL)isEnable_{
	[self setEnable:isEnable_];
}
-(BOOL)_isEnable{
	return [self isEnable];
}

@end

@implementation CMMControlItemSwitch(Deprecated)

+(id)controlItemSwitchWithMaskSprite:(CCSprite *)maskSprite_ backSprite:(CCSprite *)backSprite_ buttonSprite:(CCSprite *)buttonSprite_{
	return [self controlItemSwitchWithMaskFrame:[CCSpriteFrame frameWithTexture:[maskSprite_ texture] rect:[maskSprite_ textureRect]] buttonFrame:[CCSpriteFrame frameWithTexture:[buttonSprite_ texture] rect:[buttonSprite_ textureRect]]];
}
-(id)initWithMaskSprite:(CCSprite *)maskSprite_ backSprite:(CCSprite *)backSprite_ buttonSprite:(CCSprite *)buttonSprite_{
	return [self initWithMaskFrame:[CCSpriteFrame frameWithTexture:[maskSprite_ texture] rect:[maskSprite_ textureRect]] buttonFrame:[CCSpriteFrame frameWithTexture:[buttonSprite_ texture] rect:[buttonSprite_ textureRect]]];
}

-(void)setCallback_whenChangedItemVale:(void (^)(id, BOOL))callback_whenChangedItemVale_{
	[self setCallback_whenItemValueChanged:^(BOOL itemValue_) {
		callback_whenChangedItemVale_(self,itemValue_);
	}];
}
-(void(^)(id,BOOL))callback_whenChangedItemVale{
	return nil;
}

@end

@implementation CMMControlItemSlider(Deprecated)

+(id)controlItemSliderWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_{
	
	CCSpriteFrame *maskFrame_ = [CCSpriteFrame frameWithTexture:[maskSprite_ texture] rect:[maskSprite_ textureRect]];
	CCSpriteFrame *barFrame_ = [CCSpriteFrame frameWithTexture:[barSprite_ texture] rect:[barSprite_ textureRect]];
	CCSpriteFrame *buttonFrame_ = [CCSpriteFrame frameWithTexture:[buttonSprite_ texture] rect:[buttonSprite_ textureRect]];
	
	CMMControlItemSlider *slider_ = [self controlItemSliderWithWidth:width_ maskFrame:maskFrame_ barFrame:barFrame_ buttonFrame:buttonFrame_];
	[slider_ setBackColorL:backColorL_];
	[slider_ setBackColorR:backColorR_];
	
	return slider_;
}
+(id)controlItemSliderWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_{
	CMMControlItemSlider *slider_ = [self controlItemSliderWithWidth:width_ frameSeq:frameSeq_];
	[slider_ setBackColorL:backColorL_];
	[slider_ setBackColorR:backColorR_];
	return slider_;
}
-(id)initWithWidth:(float)width_ maskSprite:(CCSprite *)maskSprite_ barSprite:(CCSprite *)barSprite_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_ buttonSprite:(CCSprite *)buttonSprite_{
	CCSpriteFrame *maskFrame_ = [CCSpriteFrame frameWithTexture:[maskSprite_ texture] rect:[maskSprite_ textureRect]];
	CCSpriteFrame *barFrame_ = [CCSpriteFrame frameWithTexture:[barSprite_ texture] rect:[barSprite_ textureRect]];
	CCSpriteFrame *buttonFrame_ = [CCSpriteFrame frameWithTexture:[buttonSprite_ texture] rect:[buttonSprite_ textureRect]];
	
	if(!(self = [self initWithWidth:width_ maskFrame:maskFrame_ barFrame:barFrame_ buttonFrame:buttonFrame_])) return self;
	
	[self setBackColorL:backColorL_];
	[self setBackColorR:backColorR_];

	return self;
}
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ backColorL:(ccColor3B)backColorL_ backColorR:(ccColor3B)backColorR_{
	if(!(self = [self initWithWidth:width_ frameSeq:frameSeq_])) return self;
	
	[self setBackColorL:backColorL_];
	[self setBackColorR:backColorR_];
	
	return self;
}

-(void)setButtonSprite:(CCSprite *)buttonSprite_{
	[self setButtonFrameWithSprite:buttonSprite_];
}

-(void)setCallback_whenChangedItemVale:(void (^)(id, float, float))callback_whenChangedItemVale_{
	[self setCallback_whenItemValueChanged:^(float itemValue_, float beforeItemValue_) {
		callback_whenChangedItemVale_(self,itemValue_,beforeItemValue_);
	}];
}
-(void(^)(id,float,float))callback_whenChangedItemVale{
	return nil;
}
-(void)setMinValue:(float)minValue_{
	[self setItemValueRange:CMMFloatRange(minValue_,[self itemValueRange].len)];
}
-(float)minValue{
	return [self itemValueRange].loc;
}
-(void)setMaxValue:(float)maxValue_{
	[self setItemValueRange:CMMFloatRange([self itemValueRange].loc,maxValue_)];
}
-(float)maxValue{
	return [self itemValueRange].len;
}

@end

@implementation CMMControlItemText(Deprecated)

+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ frameSize:(CGSize)frameSize_{
	return [self controlItemTextWithFrameSize:frameSize_ barFrame:[CCSpriteFrame frameWithTexture:[barSprite_ texture] rect:[barSprite_ textureRect]]];
}
+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_{
	return [self controlItemTextWithWidth:width_ barFrame:[CCSpriteFrame frameWithTexture:[barSprite_ texture] rect:[barSprite_ textureRect]]];
}

+(id)controlItemTextWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [self controlItemTextWithFrameSize:frameSize_ frameSeq:frameSeq_];
}
+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [self controlItemTextWithWidth:width_ frameSeq:frameSeq_];
}

-(id)initWithBarSprite:(CCSprite *)barSprite_ frameSize:(CGSize)frameSize_{
	return [self initWithFrameSize:frameSize_ barFrame:[CCSpriteFrame frameWithTexture:[barSprite_ texture] rect:[barSprite_ textureRect]]];
}
-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_{
	return [self initWithWidth:width_ barFrame:[CCSpriteFrame frameWithTexture:[barSprite_ texture] rect:[barSprite_ textureRect]]];
}

-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [self initWithFrameSize:frameSize_ frameSeq:frameSeq_];
}
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_{
	return [self initWithWidth:width_ frameSeq:frameSeq_];
}

-(void)redrawWithBar{
	[self setDoRedraw:YES];
}

+(id)controlItemTextWithWidth:(float)width_ barSprite:(CCSprite *)barSprite_{
	return [self controlItemTextWithBarSprite:barSprite_ width:width_];
}
-(id)initWithWidth:(float)width_ barSprite:(CCSprite *)barSprite_{
	return [self initWithBarSprite:barSprite_ width:width_];
}

+(id)controlItemTextWithBarSprite:(CCSprite *)barSprite_ width:(float)width_ height:(float)height_{
	return [self controlItemTextWithBarSprite:barSprite_ frameSize:CGSizeMake(width_, height_)];
}
+(id)controlItemTextWithFrameSeq:(int)frameSeq_ width:(float)width_ height:(float)height_{
	return [self controlItemTextWithFrameSeq:frameSeq_ frameSize:CGSizeMake(width_, height_)];
}
-(id)initWithBarSprite:(CCSprite *)barSprite_ width:(float)width_ height:(float)height_{
	return [self initWithBarSprite:barSprite_ frameSize:CGSizeMake(width_, height_)];
}
-(id)initWithFrameSeq:(int)frameSeq_ width:(float)width_ height:(float)height_{
	return [self initWithFrameSeq:frameSeq_ frameSize:CGSizeMake(width_, height_)];
}

-(void)setCallback_whenChangedItemVale:(void (^)(id, NSString *))callback_whenChangedItemVale_{
	[self setCallback_whenItemValueChanged:^(NSString *itemValue_) {
		callback_whenChangedItemVale_(self,itemValue_);
	}];
}
-(void(^)(id,NSString *))callback_whenChangedItemVale{
	return nil;
}
-(void)setItemTitle:(NSString *)itemTitle_{
	[self setTitle:itemTitle_];
}
-(NSString *)itemTitle{
	return [self title];
}

@end

@implementation CMMControlItemCheckbox(Deprecated)

+(id)controlItemCheckboxWithBackSprite:(CCSprite *)backSprite_ checkSprite:(CCSprite *)checkSprite_{
	CCSpriteFrame *backFrame_ = [CCSpriteFrame frameWithTexture:[backSprite_ texture] rect:[backSprite_ textureRect]];
	CCSpriteFrame *checkFrame_ = [CCSpriteFrame frameWithTexture:[checkSprite_ texture] rect:[checkSprite_ textureRect]];
	return [self controlItemCheckboxWithBackFrame:backFrame_ checkFrame:checkFrame_];
}
-(id)initWithBackSprite:(CCSprite *)backSprite_ checkSprite:(CCSprite *)checkSprite_{
	CCSpriteFrame *backFrame_ = [CCSpriteFrame frameWithTexture:[backSprite_ texture] rect:[backSprite_ textureRect]];
	CCSpriteFrame *checkFrame_ = [CCSpriteFrame frameWithTexture:[checkSprite_ texture] rect:[checkSprite_ textureRect]];
	return [self initWithBackFrame:backFrame_ checkFrame:checkFrame_];
}

@end

@implementation CMMCustomUI(Deprecated)

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}
-(void)setIsEnable:(BOOL)isEnable_{
	[self setEnable:isEnable_];
}
-(BOOL)_isEnable{
	return [self isEnable];
}

@end

@implementation CMMCustomUIJoypadButton(Deprecated)

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}
-(void)setIsAutoPushdown:(BOOL)isAutoPushdown_{
	[self setAutoPushdown:isAutoPushdown_];
}
-(BOOL)_isAutoPushdown{
	return [self isAutoPushdown];
}

@end

@implementation CMMCustomUIJoypadStick(Deprecated)

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}

@end

@implementation CMMStageBackGround
@synthesize stage,backGroundNode,distanceRate;

+(id)backGroundWithStage:(CMMStage *)stage_ distanceRate:(float)distanceRate_{
	return [[[self alloc] initWithStage:stage_ distanceRate:distanceRate_] autorelease];
}
-(id)initWithStage:(CMMStage *)stage_ distanceRate:(float)distanceRate_{
	if(!(self = [super init])) return self;
	
	stage = stage_;
	distanceRate = distanceRate_;
	backGroundNode = nil;
	
	return self;
}

-(void)setBackGroundNode:(CCNode *)backGroundNode_{
	if(backGroundNode == backGroundNode_) return;
	[backGroundNode removeFromParentAndCleanup:YES];
	backGroundNode = backGroundNode_;
	
	if(backGroundNode){
		[self updatePosition];
		[stage addChild:backGroundNode z:-1];
	}
}
-(void)setDistanceRate:(float)distanceRate_{
	distanceRate = distanceRate_;
	[self updatePosition];
}

-(void)updatePosition{
	if(!backGroundNode) return;
	
	CGPoint worldPoint_ = [stage worldPoint];
	CGPoint targetPoint_ = ccpMult(worldPoint_, distanceRate);
	[backGroundNode setPosition:ccpMult(targetPoint_, -1.0f)];
	
	float worldScale_ = [stage worldScale];
	[backGroundNode setScale:1.0f - ((1.0f - worldScale_) * distanceRate)];
}

@end

@implementation CMMStage(Deprecated)

+(id)stageWithStageSpecDef:(CMMStageDef)stageSpecDef_{
	return [self stageWithStageDef:stageSpecDef_];
}
-(id)initWithStageSpecDef:(CMMStageDef)stageSpecDef_{
	return [self initWithStageDef:stageSpecDef_];
}

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}
-(void)setIsAllowTouch:(BOOL)isAllowTouch_{
	[self setIsTouchEnabled:isAllowTouch_];
}
-(BOOL)isAllowTouch{
	return [self isTouchEnabled];
}
-(id)backGround{
	return nil;
}

-(void)setCallback_whenObjectAdded:(CMMStageObjectBlock)block_{
	[self addObjectCallbackWithType:CMMStageObjectCallbackType_added callback:block_];
}
-(CMMStageObjectBlock)callback_whenObjectAdded{return nil;}
-(void)setCallback_whenObjectRemoved:(CMMStageObjectBlock)block_{
	[self addObjectCallbackWithType:CMMStageObjectCallbackType_removed callback:block_];
}
-(CMMStageObjectBlock)callback_whenObjectRemoved{return nil;}

@end

@implementation CMMStageLightItem(Deprecated)

-(void)setIsBlendColor:(BOOL)isBlendColor_{
	[self setBlendColor:isBlendColor_];
}
-(BOOL)_isBlendColor{
	return [self isBlendColor];
}

@end

@implementation CMMStageWorld(Deprecated)

-(CCArray *)objectsInTouched{
	CCArray *array_ = [CCArray array];
	[array_ addObject:[self touchedObject]];
	return array_;
}
-(CCArray *)objectsInTouches{
	CCArray *array_ = [CCArray array];
	[array_ addObject:[self touchedObject]];
	return array_;
}

-(CMMSObjectBatchNode *)addObatchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	[self addObatchNode:[CMMSObjectBatchNode batchNodeWithFile:fileName_]];
	return nil;
}
-(void)removeObatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{}
-(CMMSObjectBatchNode *)obatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return nil;
}
-(int)indexOfObatchNodeFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return NSNotFound;
}

@end

@implementation CMMStageParticle(Deprecated)

-(CMMSParticle *)addParticleFollowWithName:(NSString *)particleName_ target:(CMMSObject *)target_{
	CMMSParticle *particle_ = [self addParticleWithName:particleName_ point:CGPointZero];
	[particle_ setTarget:target_];
	return particle_;
}
-(void)removeParticleFollowOfTarget:(CMMSObject *)target_{
	[self removeParticleOfTarget:target_];
}

@end

@implementation CMMStageTMX(Deprecated)

+(id)stageWithStageSpecDef:(CMMStageDef)stageSpecDef_ tmxFileName:(NSString *)tmxFileName_ isInDocument:(BOOL)isInDocument_{
	return [self stageWithStageDef:stageSpecDef_ tmxFileName:tmxFileName_ isInDocument:isInDocument_];
}
-(id)initWithStageSpecDef:(CMMStageDef)stageSpecDef_ tmxFileName:(NSString *)tmxFileName_ isInDocument:(BOOL)isInDocument_{
	return [self initWithStageDef:stageSpecDef_ tmxFileName:tmxFileName_ isInDocument:isInDocument_];
}

-(BOOL)_isTilemapBuiltup{
	return [self isTilemapBuiltup];
}

@end

@implementation CMMStagePXL(Deprecated)

+(id)stageWithStageSpecDef:(CMMStageDef)stageSpecDef_ fileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self stageWithStageDef:stageSpecDef_ fileName:fileName_ isInDocument:isInDocument_];
}
-(id)initWithStageSpecDef:(CMMStageDef)stageSpecDef_ fileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self initWithStageDef:stageSpecDef_ fileName:fileName_ isInDocument:isInDocument_];
}

-(void)setIsInDocument:(BOOL)isInDocument_{}
-(BOOL)_isInDocument{
	return [self isInDocument];
}

@end

@implementation CMMSSpecStage(Deprecated)

+(id)specWithTarget:(id)target_ withStageSpecDef:(CMMStageDef)stageSpecDef_{
	return [self specWithTarget:target_ withStageDef:stageSpecDef_];
}
-(id)initWithTarget:(id)target_ withStageSpecDef:(CMMStageDef)stageSpecDef_{
	return [self initWithTarget:target_ withStageDef:stageSpecDef_];
}

-(void)applyWithStageSpecDef:(CMMStageDef)stageSpecDef_{
	[self applyWithStageDef:stageSpecDef_];
}

@end

@implementation CMMSObjectBatchNode(Deprecated_Nonfunctional)

-(CMMSObject *)createObjectWithRect:(CGRect)rect_{
	CMMSObject *object_ = [CMMSObject spriteWithTexture:[self texture] rect:rect_];
	return object_;
}
-(CMMSObject *)createObjectWithSpriteFrame:(CCSpriteFrame *)spriteFrame_{
	CMMSObject *object_ = [CMMSObject spriteWithSpriteFrame:spriteFrame_];
	return object_;
}
-(CMMSObject *)createObject{
	CMMSObject *object_ = [CMMSObject spriteWithTexture:[self texture]];
	return object_;
}

+(id)batchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self batchNodeWithFile:fileName_];
}
-(id)initWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [self initWithFile:fileName_ capacity:10];
}

-(void)setFileName:(NSString *)fileName_{}
-(NSString *)fileName{return nil;}
-(void)setIsInDocument:(BOOL)isInDocument{}
-(BOOL)isInDocument{return NO;}
-(void)setObjectClass:(Class)objectClass{}
-(Class)objectClass{return nil;}

@end

@implementation CMMSObject(Deprecated)

-(void)buildupBody{
	[self buildupBodyWithWorld:[stage world]];
}

-(void)updateBodyWithPosition:(CGPoint)point_ andRotation:(float)tRotation_{
	[self updateBodyPosition:point_ rotation:tRotation_];
}
-(void)updateBodyWithPosition:(CGPoint)point_{
	[self updateBodyPosition:point_];
}

-(void)setAddToBatchNode:(BOOL)addToBatchNode{}
-(BOOL)isAddToBatchNode{return NO;}

@end

@implementation CMMGameKitPA(Deprecated)

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}

@end

@implementation CMMGameKitLeaderBoard(Deprecated)

-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_ playerScope:(GKLeaderboardPlayerScope)playerScope_{
	[self loadLeaderBoardWithCategory:category_ range:range_ timeScope:timeScope_ playerScope:playerScope_ block:^(GKLeaderboard *leaderboard_, NSError *error_) {}];
}
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_{
	[self loadLeaderBoardWithCategory:category_ range:range_ timeScope:timeScope_ block:^(GKLeaderboard *leaderboard_, NSError *error_) {}];
}
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_{
	[self loadLeaderBoardWithCategory:category_ range:range_ block:^(GKLeaderboard *leaderboard_, NSError *error_) {}];
}

-(void)reportScore:(int64_t)score_ category:(NSString *)category_{
	[self reportScore:score_ category:category_ block:^(GKScore *score_, NSError *error_) {}];
}

-(void)loadCategory{
	[self loadedCategories];
}

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}

@end

@implementation CMMGameKitAchievements(Deprecated)

-(CMMGameKitAchievement *)reportedAchievementAtIdentifier:(NSString *)identifier_{
	return [self achievementForIdentifier:identifier_];
}
-(CMMGameKitAchievement *)cachedAchievementAtIdentifier:(NSString *)identifier_{
	return [self achievementForIdentifier:identifier_];
}

-(id)reportedAchievementAtIndex:(uint)index_{return nil;}
-(uint)indexOfReportedAchievement:(id)achievement_{return NSNotFound;}
-(uint)indexOfReportedAchievementWithIdentifier_:(NSString *)identifier_{return NSNotFound;}

-(id)cachedAchievementAtIndex:(uint)index_{return nil;}
-(uint)indexOfCachedAchievement:(id)achievement_{return NSNotFound;}
-(uint)indexOfCachedAchievementWithIdentifier_:(NSString *)identifier_{return NSNotFound;}

-(void)setDelegate:(id)delegate{}
-(id)delegate{return nil;}

-(void)writeCachedAchievements{
	[self writeCachedAchievementsToFile];
}

@end