//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMacro.h"
#import "CMMLayer.h"
#import "CMMSoundEngine.h"
#import "CMMSType.h"
#import "CMMSObject.h"
#import "CMMSSpecStage.h"
#import "CMMSObjectSView.h"
#import "CMMTimeIntervalArray.h"

@class CMMStage;

class CMMStageWorldContactListener : public b2ContactListener{
public:
	CMMStage *stage;
	
	void BeginContact(b2Contact* contact);
	void EndContact(b2Contact* contact);
};

class CMMStageWorldContactFilter : public b2ContactFilter{
public:
	CMMStage *stage;
	
	bool ShouldCollide(b2Fixture* fixtureA, b2Fixture* fixtureB);
};


@protocol CMMStageChildProtocol <NSObject>

-(void)update:(ccTime)dt_;

@end

@class CMMStageWorld;

@protocol CMMStageWorldDelegate <NSObject>

//inner rule
@required
-(void)stageWorld:(CMMStageWorld *)world_ whenAddedObject:(CMMSObject *)object_;
-(void)stageWorld:(CMMStageWorld *)world_ whenRemovedObject:(CMMSObject *)object_;

@end

@interface CMMStageWorld : CMMLayer<NSFastEnumeration,CMMStageChildProtocol>{
	CMMStage *stage;
	
	b2World *world;
	b2Body *worldBody;
	
	CCArray *obatchNode_list,*obatchNode_destroyList;
	CMMTimeIntervalArray *object_list;
	CMMb2ContactMask b2CMask_bottom,b2CMask_top,b2CMask_left,b2CMask_right;
	
	int32 velocityIterations, positionIterations;
}

+(id)worldWithStage:(CMMStage *)stage_ worldSize:(CGSize)worldSize_;
-(id)initWithStage:(CMMStage *)stage_ worldSize:(CGSize)worldSize_;

@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readonly) b2World *world;
@property (nonatomic, readonly) b2Body *worldBody;
@property (nonatomic, readonly) CCArray *obatchNode_list,*object_list;
@property (nonatomic, readwrite) CMMb2ContactMask b2CMask_bottom,b2CMask_top,b2CMask_left,b2CMask_right;
@property (nonatomic, readwrite) int32 velocityIterations, positionIterations;
@property (nonatomic, readonly) int countOfObatchNode,countOfObject;

@end

@interface CMMStageWorld(ObjectBatchNode)

-(void)addObatchNode:(CMMSObjectBatchNode *)obatchNode_;

-(void)removeObatchNode:(CMMSObjectBatchNode *)obatchNode_;
-(void)removeObatchNodeAtIndex:(int)index_;
-(void)removeObatchNodeAtTexture:(CCTexture2D *)texture_;

-(CMMSObjectBatchNode *)obatchNodeAtIndex:(int)index_;
-(CMMSObjectBatchNode *)obatchNodeAtTexture:(CCTexture2D *)texture_;

-(int)indexOfObatchNode:(CMMSObjectBatchNode *)obatchNode_;
-(int)indexOfObatchNodeWithTexture:(CCTexture2D *)texture_;

@end

@interface CMMStageWorld(Common)

-(void)addObject:(CMMSObject *)object_ buildInObatchNode:(BOOL)buildInObatchNode_;
-(void)addObject:(CMMSObject *)object_;

-(void)removeObject:(CMMSObject *)object_;
-(void)removeObjectAtIndex:(int)index_;
-(void)removeObjectAtObjectTag:(int)objectTag_;
-(void)removeObjectAtObatchNode:(CMMSObjectBatchNode *)obatchNode_;

-(CMMSObject *)objectAtIndex:(int)index_;
-(CMMSObject *)objectAtObjectTag:(int)objectTag_;
-(CMMSObject *)objectAtTouch:(UITouch *)touch_;
-(CMMSObject *)touchedObject;

-(int)indexOfObject:(CMMSObject *)object_;
-(int)indexOfObjectTag:(int)objectTag_;

@end

@interface CMMStageWorld(Box2d)

-(b2Body *)createBody:(b2BodyType)bodyType_ point:(CGPoint)point_ angle:(float)angle_;

@end

#import "CMMSParticle.h"

@interface CMMStageParticle : CCNode<CMMStageChildProtocol>{
	CMMStage *stage;
	CMMTimeIntervalArray *particleList;
	CMMSimpleCache *_cachedParticles;
}

+(id)particleWithStage:(CMMStage *)stage_;
-(id)initWithStage:(CMMStage *)stage_;

@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readonly) CMMTimeIntervalArray *particleList;
@property (nonatomic, readonly) int particleCount;

@end

@interface CMMStageParticle(Particle)

-(void)addParticle:(CMMSParticle *)particle_;
-(CMMSParticle *)addParticleWithName:(NSString *)particleName_ point:(CGPoint)point_ particleClass:(Class)particleClass_;
-(CMMSParticle *)addParticleWithName:(NSString *)particleName_ point:(CGPoint)point_;

-(void)removeParticle:(CMMSParticle *)particle_;
-(void)removeParticleAtIndex:(int)index_;
-(void)removeParticleOfTarget:(CMMSObject *)target_;

-(CMMSParticle *)particleAtIndex:(int)index_;

-(int)indexOfParticle:(CMMSParticle *)particle_;

@end

@class CMMStageLight;

@interface CMMStageLightItem : NSObject{
	CMMStageLight *stageLight;
	
	CGPoint point;
	float brightness,radius;
	ccTime duration,_curDuration;
	
	ccColor3B color;
	BOOL blendColor;
	
	CMMSObject *target;
}

+(id)lightItemWithStageLight:(CMMStageLight *)stageLight_ point:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_ duration:(ccTime)duration_;
-(id)initWithStageLight:(CMMStageLight *)stageLight_ point:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_ duration:(ccTime)duration_;

-(void)update:(ccTime)dt_;
-(void)reset;

@property (nonatomic, retain) CMMStageLight *stageLight;
@property (nonatomic, readwrite) CGPoint point;
@property (nonatomic, readwrite) float brightness,radius;
@property (nonatomic, readwrite) ccTime duration;
@property (nonatomic, readwrite) ccColor3B color;
@property (nonatomic, readwrite, getter = isBlendColor) BOOL blendColor;
@property (nonatomic, retain) CMMSObject *target;

@end

typedef enum{
	CMMStageLightItemFadeInOutState_none,
	CMMStageLightItemFadeInOutState_fadeIn,
	CMMStageLightItemFadeInOutState_fadeOut,
	CMMStageLightItemFadeInOutState_endedFade,
} CMMStageLightItemFadeInOutState;

@interface CMMStageLightItemFadeInOut : CMMStageLightItem{
	ccTime fadeTime,_curFadeTime;
	float _orginalRadius,_orginalBrightness;
	
	CMMStageLightItemFadeInOutState _fadeInOutState;
}

@property (nonatomic, readwrite) ccTime fadeTime;

@end

@interface CMMStageLight : CCNode<CMMStageChildProtocol>{
	CMMStage *stage;
	CMMTimeIntervalArray *lightList;
	
	Class defaultLightItemClass;
	
	BOOL useLights,useCulling;
	uint segmentOfLights;
	
	CCRenderTexture *_lightRender;
	CMMSimpleCache *_cachedlightItems;
}

+(id)lightWithStage:(CMMStage *)stage_;
-(id)initWithStage:(CMMStage *)stage_;

@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readonly) CMMTimeIntervalArray *lightList;
@property (nonatomic, readonly) uint count;
@property (nonatomic, readwrite, getter = isUseLights) BOOL useLights;
@property (nonatomic, readwrite, getter = isUseCulling) BOOL useCulling;
@property (nonatomic, readwrite) uint segmentOfLights;
@property (nonatomic, readwrite) ccBlendFunc lightBlendFunc;

@end

@interface CMMStageLight(Common)

-(void)addLightItem:(CMMStageLightItem *)lightItem_;
-(CMMStageLightItem *)addLightItemAtPoint:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_ duration:(ccTime)duration_ lightItemClass:(Class)lightItemClass_;
-(CMMStageLightItem *)addLightItemAtPoint:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_ duration:(ccTime)duration_;
-(CMMStageLightItem *)addLightItemAtPoint:(CGPoint)point_ brightness:(float)brightness_ radius:(float)radius_;
-(CMMStageLightItem *)addLightItemAtPoint:(CGPoint)point_ brightness:(float)brightness_;
-(CMMStageLightItem *)addLightItemAtPoint:(CGPoint)point_;

-(void)removeLightItem:(CMMStageLightItem *)lightItem_;
-(void)removeLightItemAtIndex:(uint)index_;
-(void)removeLightItemsAtTarget:(CMMSObject *)target_;

-(CMMStageLightItem *)lightItemAtIndex:(uint)index_;

-(uint)indexOfLightItem:(CMMStageLightItem *)lightItem_;

@end

@interface CMMStageObjectSView : CMMLayer<CMMStageChildProtocol>{
	CMMStage *stage;
	CCArray *stateViewList;
}

+(id)stateViewWithStage:(CMMStage *)stage_;
-(id)initWithStage:(CMMStage *)stage_;

@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readonly) CCArray *stateViewList;
@property (nonatomic, readonly) int count;

@end

@interface CMMStageObjectSView(Common)

-(void)addStateView:(CMMSObjectSView *)stateView_;

-(void)removeStateView:(CMMSObjectSView *)stateView_;
-(void)removeStateViewAtIndex:(int)index_;
-(void)removeStateViewAtTarget:(CMMSObject *)target_;
-(void)removeAllStateView;

-(CMMSObjectSView *)stateViewAtIndex:(int)index_;
-(CCArray *)stateViewListAtTarget:(CMMSObject *)target_;

-(int)indexOfStateView:(CMMSObjectSView *)stateView_;

@end

@protocol CMMStageBackgroundProtocol <CMMStageChildProtocol>

@property (nonatomic, readwrite) CGPoint worldPoint;

@end

typedef void(^CMMStageObjectBlock)(CMMSObject *object_);
typedef void(^CMMStageTouchBlock)(UITouch *touch_, CMMSObject *object_);

typedef enum{
	CMMStageObjectCallbackType_added,
	CMMStageObjectCallbackType_removed,
} CMMStageObjectCallbackType;

@interface CMMStageObjectCallback : NSObject{
	CMMStageObjectCallbackType type;
	CMMStageObjectBlock callback;
}

+(id)callbackWithType:(CMMStageObjectCallbackType)type_ callback:(CMMStageObjectBlock)callback_;
-(id)initWithType:(CMMStageObjectCallbackType)type_ callback:(CMMStageObjectBlock)callback_;

@property (nonatomic, readwrite) CMMStageObjectCallbackType type;
@property (nonatomic, copy) CMMStageObjectBlock callback;

-(void)setCallback:(CMMStageObjectBlock)callback_;

@end

@interface CMMStage : CMMLayer<CMMStageWorldDelegate,CMMSContactProtocol>{
	CMMSSpecStage *spec;
	
	CMMStageWorld *world;
	CMMStageParticle *particle;
	CMMStageObjectSView *stateView;
	CMMStageLight *light;
	CMMSoundHandler *sound;
	CCNode<CMMStageBackgroundProtocol> *backgroundNode;
	
	ccTime timeInterval,_stackTime;
	uint maxTimeIntervalProcessCount;
	
	CMMStageTouchBlock callback_whenTouchBegan,callback_whenTouchMoved,callback_whenTouchEnded,callback_whenTouchCancelled;
}

+(id)stageWithStageDef:(CMMStageDef)stageDef_;
-(id)initWithStageDef:(CMMStageDef)stageDef_;

-(void)step:(ccTime)dt_; //single update
-(void)afterStep:(ccTime)dt_;
-(void)update:(ccTime)dt_; //update per stack time

-(void)initializeLightSystem;

@property (nonatomic, retain) CMMSSpecStage *spec;
@property (nonatomic, readonly) CMMStageWorld *world;
@property (nonatomic, readonly) CMMStageParticle *particle;
@property (nonatomic, readonly) CMMStageObjectSView *stateView;
@property (nonatomic, readonly) CMMStageLight *light;
@property (nonatomic, readonly) CMMSoundHandler *sound;
@property (nonatomic, retain,setter = addBackgroundNode:) CCNode<CMMStageBackgroundProtocol> *backgroundNode;
@property (nonatomic, readonly) CGSize worldSize;
@property (nonatomic, readwrite) CGPoint worldPoint;
@property (nonatomic, readwrite) float worldScale;
@property (nonatomic, readwrite) ccTime timeInterval;
@property (nonatomic, readwrite) uint maxTimeIntervalProcessCount;
@property (nonatomic, copy) CMMStageTouchBlock callback_whenTouchBegan,callback_whenTouchMoved,callback_whenTouchEnded,callback_whenTouchCancelled;

-(void)setCallback_whenTouchBegan:(CMMStageTouchBlock)block_;
-(void)setCallback_whenTouchMoved:(CMMStageTouchBlock)block_;
-(void)setCallback_whenTouchEnded:(CMMStageTouchBlock)block_;
-(void)setCallback_whenTouchCancelled:(CMMStageTouchBlock)block_;

@end

@interface CMMStage(Point)

-(CGPoint)convertToStageWorldSpace:(CGPoint)worldPoint_;

@end

@interface CMMStage(Callback)

-(void)addObjectCallback:(CMMStageObjectCallback *)callback_;
-(CMMStageObjectCallback *)addObjectCallbackWithType:(CMMStageObjectCallbackType)type_ callback:(CMMStageObjectBlock)callback_;

-(void)removeObjectCallbackAtIndex:(uint)index_;
-(void)removeObjectCallback:(CMMStageObjectCallback *)callback_;
-(void)removeAllObjectCallbacks;

-(uint)indexOfObjectCallback:(CMMStageObjectCallback *)callback_;

@end