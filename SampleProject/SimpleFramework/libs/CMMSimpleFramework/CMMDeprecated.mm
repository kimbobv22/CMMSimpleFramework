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

@implementation CMMLayerPinchZoom


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
