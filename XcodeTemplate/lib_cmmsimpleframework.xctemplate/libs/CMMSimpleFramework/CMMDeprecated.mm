//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDeprecated.h"

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

-(void)closePopup:(CMMPopupLayer *)popup_ withData:(id)data_{
	[popup_ closeWithSendData:data_];
}
-(void)closePopup:(CMMPopupLayer *)popup_{
	[self closePopup:popup_ withData:nil];
}

@end

@implementation CMMTouchDispatcher(Deprecated)

+(void)setAllTouchDispatcherEnable:(BOOL)enable_{
	[[CMMScene sharedScene] setIsTouchEnable:enable_];
}
+(BOOL)isAllTouchDispatcherEnable{
	return [[CMMScene sharedScene] isTouchEnable];
}

@end

@implementation CMMTouchDispatcherScene

@end

@implementation CMMPopupDispatcherTemplate

-(void)startPopupWithPopupLayer:(CMMPopupLayer *)popupLayer_{}
-(void)endPopupWithPopupLayer:(CMMPopupLayer *)popupLayer_ callbackAction:(CCCallBlock *)callbackAction_{}

@end

@implementation CMMPopupDispatcherTemplate_FadeInOut

@end

@implementation CMMPopupDispatcher(Deprecated)

+(id)popupDispatcherWithScene:(CMMScene *)scene_{
	return [self popupDispatcherWithTarget:scene_];
}
-(id)initWithScene:(CMMScene *)scene_{
	return [self initWithTarget:scene_];
}

-(void)setScene:(CMMScene *)scene_{
	[self setTarget:scene_];
}
-(CMMScene *)scene{
	return (id)[self target];
}

-(CMMPopupLayer *)curPopup{
	return [self headPopup];
}

-(void)setPopupTemplate:(id)popupTemplate_{}
-(id)popupTemplate{return nil;};

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

@end

@implementation CMMLayerPinchZoom

@end

@implementation CMMLayerPopup

@end

@implementation CMMSpriteBatchBar(Deprecated)

+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_ barCropWidth:(float)barCropWidth_{
	return [self batchBarWithTargetSprite:targetSprite_ batchBarSize:batchBarSize_ edgeSize:edgeSize_];
}
-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_ barCropWidth:(float)barCropWidth_{
	return [self initWithTargetSprite:targetSprite_ batchBarSize:batchBarSize_ edgeSize:edgeSize_];
}

-(void)setBarCropWidth:(float)barCropWidth{}
-(float)barCropWidth{
	return 0.0f;
}

@end

@implementation CMMLoadingObject

+(id)loadingObject{
	return [self sequenceMaker];
}

-(void)startLoadingWithTarget:(id)target_{
	return [self startWithTarget:target_];
}
-(void)startLoading{
	return [self start];
}
-(void)startLoadingWithMethodFormatter:(NSString *)methodFormatter_ target:(id)target_{
	return [self startWithMethodFormatter:methodFormatter_ target:target_];
}
-(void)startLoadingWithMethodFormatter:(NSString *)methodFormatter_{
	return [self startWithMethodFormatter:methodFormatter_];
}

-(void)setLoadingMethodFormatter:(NSString *)loadingMethodFormatter_{
	[self setSequenceMethodFormatter:loadingMethodFormatter_];
}
-(NSString *)loadingMethodFormatter{
	return [self sequenceMethodFormatter];
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

@implementation CMMControlItemText(Deprecated)

+(id)controlItemTextWithWidth:(float)width_ barSprite:(CCSprite *)barSprite_{
	return [self controlItemTextWithBarSprite:barSprite_ width:width_];
}
-(id)initWithWidth:(float)width_ barSprite:(CCSprite *)barSprite_{
	return [self initWithBarSprite:barSprite_ width:width_];
}

@end

@implementation CMMControlItemBatchBar

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

-(BOOL)_isEnable{
	return [self isEnable];
}
-(void)setIsEnable:(BOOL)isEnable_{
	[self setEnable:isEnable_];
}

@end

@implementation CMMMenuItemLabelTTF

@end

@implementation CMMMenuItemSet(Deprecated)

-(void)setIsEnable:(BOOL)isEnable_{
	[self setEnable:isEnable_];
}
-(BOOL)_isEnable{
	return [self isEnable];
}

@end

@implementation CMMScrollMenu(Deprecated)

+(id)scrollMenuWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [self scrollMenuWithFrameSeq:frameSeq_ batchBarSeq:0 frameSize:frameSize_];
}

@end

@implementation CMMSObject(Deprecated)

-(void)updateBodyWithPosition:(CGPoint)point_ andRotation:(float)tRotation_{
	[self updateBodyPosition:point_ rotation:tRotation_];
}
-(void)updateBodyWithPosition:(CGPoint)point_{
	[self updateBodyPosition:point_];
}

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

-(void)setIsAllowTouch:(BOOL)isAllowTouch_{
	[self setIsTouchEnabled:isAllowTouch_];
}
-(BOOL)isAllowTouch{
	return [self isTouchEnabled];
}
-(id)backGround{
	return nil;
}

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
	return [self objectsInTouches];
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

@end

@implementation CCSpriteBatchNode(Deprecated)

-(CCSprite *)addSplitSpriteToRect:(CGRect)rect_ blendFunc:(ccBlendFunc)tBlendFunc_{
	return [self addSplitSpriteToRect:rect_];
}
-(void)addSplitSprite:(CGSize)splitUnit_ blendFunc:(ccBlendFunc)tBlendFunc_{
	return [self addSplitSprite:splitUnit_];
}

@end
