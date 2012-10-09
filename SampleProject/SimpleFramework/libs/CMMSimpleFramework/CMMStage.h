//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMMacro.h"
#import "CMMLayer.h"
#import "CMMSoundEngine.h"
#import "CMMSType.h"
#import "CMMSObject.h"
#import "CMMSSpecStage.h"
#import "CMMSObjectSView.h"

@class CMMStage;

class CMMStageContactListener : public b2ContactListener{
public:
	CMMStage *stage;
	
	void BeginContact(b2Contact* contact);
	void EndContact(b2Contact* contact);
};

class CMMStageContactFilter : public b2ContactFilter{
public:
	CMMStage *stage;
	
	bool ShouldCollide(b2Fixture* fixtureA, b2Fixture* fixtureB);
};

@protocol CMMStageDelegate<NSObject>

@optional
-(void)stage:(CMMStage *)stage_ whenAddedObjects:(CCArray *)objects_;
-(void)stage:(CMMStage *)stage_ whenRemovedObjects:(CCArray *)objects_;

@end

//optional protocal
@protocol CMMStageTouchDelegate <NSObject>

@optional
-(void)stage:(CMMStage *)stage_ whenTouchBegan:(UITouch *)touch_ withObject:(CMMSObject *)object_;
-(void)stage:(CMMStage *)stage_ whenTouchMoved:(UITouch *)touch_ withObject:(CMMSObject *)object_;
-(void)stage:(CMMStage *)stage_ whenTouchEnded:(UITouch *)touch_ withObject:(CMMSObject *)object_;
-(void)stage:(CMMStage *)stage_ whenTouchCancelled:(UITouch *)touch_ withObject:(CMMSObject *)object_;

@end

@class CMMStageWorld;

@protocol CMMStageWorldDelegate <NSObject>

//inner rule
@required
-(void)stageWorld:(CMMStageWorld *)world_ whenAddedObject:(CMMSObject *)object_;
-(void)stageWorld:(CMMStageWorld *)world_ whenRemovedObject:(CMMSObject *)object_;

@end

@interface CMMStageWorld : CMMLayer{
	CMMStage *stage;
	
	b2World *world;
	b2Body *worldBody;
	CMMStageContactListener *_contactLintener;
	CMMStageContactFilter *_contactFilter;
	b2Draw *_debugDraw;
	
	CCArray *obatchNode_list,*obatchNode_destroyList;
	CCArray *object_list,*object_createList,*object_destroyList;
	CMMb2ContactMask b2Mask1,b2Mask2,b2Mask3,b2Mask4;
	
	//for performance Touch delegate
	CCArray *_touchedObjects;

	int _OBATCHNODETAG_,_OBJECTTAG_;
}

+(id)worldWithStage:(CMMStage *)stage_ worldSize:(CGSize)worldSize_;
-(id)initWithStage:(CMMStage *)stage_ worldSize:(CGSize)worldSize_;

-(void)update:(ccTime)dt_;

@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readonly) b2World *world;
@property (nonatomic, readonly) b2Body *worldBody;
@property (nonatomic, readonly) CCArray *obatchNode_list,*object_list;
@property (nonatomic, readonly) int count DEPRECATED_ATTRIBUTE;
@property (nonatomic, readonly) int countOfObatchNode,countOfObject;

@end

@interface CMMStageWorld(ObjectBatchNode)

-(void)addObatchNode:(CMMSObjectBatchNode *)obatchNode_;
-(CMMSObjectBatchNode *)addObatchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

-(void)removeObatchNode:(CMMSObjectBatchNode *)obatchNode_;
-(void)removeObatchNodeAtIndex:(int)index_;
-(void)removeObatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

-(CMMSObjectBatchNode *)obatchNodeAtIndex:(int)index_;
-(CMMSObjectBatchNode *)obatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

-(int)indexOfObatchNode:(CMMSObjectBatchNode *)obatchNode_;
-(int)indexOfObatchNodeFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

@end

@interface CMMStageWorld(Common)

-(void)addObject:(CMMSObject *)object_;

-(void)removeObject:(CMMSObject *)object_;
-(void)removeObjectAtIndex:(int)index_;
-(void)removeObjectAtObjectTag:(int)objectTag_;
-(void)removeObjectAtObatchNode:(CMMSObjectBatchNode *)obatchNode_;

-(CMMSObject *)objectAtIndex:(int)index_;
-(CMMSObject *)objectAtObjectTag:(int)objectTag_;
-(CMMSObject *)objectAtTouch:(UITouch *)touch_;

-(int)indexOfObject:(CMMSObject *)object_;
-(int)indexOfObjectTag:(int)objectTag_;

-(CCArray *)objectsInTouched;

@end

@interface CMMStageWorld(Box2d)

-(b2Body *)createBody:(b2BodyType)bodyType_ point:(CGPoint)point_ angle:(float)angle_;

@end

#import "CMMSParticle.h"

@interface CMMStageParticle : CMMLayer{
	CMMStage *stage;
	CCArray *particleList,*_cachedParticles;
}

+(id)particleWithStage:(CMMStage *)stage_;
-(id)initWithStage:(CMMStage *)stage_;

-(void)addParticle:(CMMSParticle *)particle_;

-(void)removeParticle:(CMMSParticle *)particle_;
-(void)removeParticleAtIndex:(int)index_;

-(CMMSParticle *)particleAtIndex:(int)index_;

-(int)indexOfParticle:(CMMSParticle *)particle_;

-(void)update:(ccTime)dt_;

@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readonly) CCArray *particleList;
@property (nonatomic, readonly) int particleCount;

@end

@interface CMMStageParticle(ParticleDefault)

-(CMMSParticle *)addParticleWithName:(NSString *)particleName_ point:(CGPoint)point_;

@end

@interface CMMStageParticle(ParticleFollow)

-(CMMSParticleFollow *)addParticleFollowWithName:(NSString *)particleName_ target:(CMMSObject *)target_;
-(void)removeParticleFollowOfTarget:(CMMSObject *)target_;

@end

@interface CMMStageLight : CCLayer{
	CMMStage *stage;
	CCArray *lightList;
}

+(id)lightWithStage:(CMMStage *)stage_;
-(id)initWithStage:(CMMStage *)stage_;

-(void)update:(ccTime)dt_;

@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readonly) CCArray *lightList;

@end

@interface CMMStageObjectSView : CMMLayer{
	CMMStage *stage;
	CCArray *stateViewList;
}

+(id)stateViewWithStage:(CMMStage *)stage_;
-(id)initWithStage:(CMMStage *)stage_;

-(void)update:(ccTime)dt_;

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

@interface CMMStageBackGround : NSObject{
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

@interface CMMStage : CMMLayer<CMMStageWorldDelegate,CMMSContactProtocol>{
	CMMSSpecStage *spec;

	id<CMMStageDelegate,CMMStageTouchDelegate> delegate;
	
	CMMStageWorld *world;
	CMMStageParticle *particle;
	CMMStageObjectSView *stateView;
	CMMStageBackGround *backGround;
	CMMSoundHandler *sound;
	
	BOOL isAllowTouch;
}

+(id)stageWithStageSpecDef:(CMMStageSpecDef)stageSpecDef_;
-(id)initWithStageSpecDef:(CMMStageSpecDef)stageSpecDef_;

-(void)update:(ccTime)dt_;

@property (nonatomic, retain) CMMSSpecStage *spec;
@property (nonatomic, retain) id<CMMStageDelegate>delegate;
@property (nonatomic, readonly) CMMStageWorld *world;
@property (nonatomic, readonly) CMMStageParticle *particle;
@property (nonatomic, readonly) CMMStageObjectSView *stateView;
@property (nonatomic, readonly) CMMStageBackGround *backGround;
@property (nonatomic, readonly) CMMSoundHandler *sound;
@property (nonatomic, readonly) CGSize worldSize;
@property (nonatomic, readwrite) CGPoint worldPoint;
@property (nonatomic, readwrite) BOOL isAllowTouch;

@end

@interface CMMStage(Point)

-(CGPoint)convertToStageWorldSpace:(CGPoint)worldPoint_;

@end