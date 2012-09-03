//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"
#import "CMMSObject.h"
#import "CMMSSpecStage.h"
#import "CMMSoundEngine.h"
#import "CMMMacro.h"

#import "CMMSType.h"

@class CMMStage;

static CGPoint getContactPoint(b2Contact* contact);

class CMMStageContactListener : public b2ContactListener{
public:
	CMMStage *stage;
	
	void BeginContact(b2Contact* contact);
	void EndContact(b2Contact* contact){}
	
	void PreSolve(b2Contact* contact, const b2Manifold* oldManifold){
		b2ContactListener::PreSolve(contact, oldManifold);
	}
	void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse){
		b2ContactListener::PostSolve(contact, impulse);
	}
};

class CMMStageContactFilter : public b2ContactFilter{
public:
	CMMStage *stage;
	
	bool ShouldCollide(b2Fixture* fixtureA, b2Fixture* fixtureB);
};

struct CMMStageSpecDef{
	CMMStageSpecDef(){
		stageSize = worldSize = CGSizeZero;
		gravity = CGPointZero;
		friction = 0.3f;
		restitution = 0.3f;
	}
	CMMStageSpecDef(CGSize stageSize_, CGSize worldSize_, CGPoint gravity_, float friction_, float restitution_):stageSize(stageSize_),worldSize(worldSize_),gravity(gravity_),friction(friction_),restitution(restitution_){}
	CMMStageSpecDef(CGSize stageSize_, CGSize worldSize_, CGPoint gravity_):stageSize(stageSize_),worldSize(worldSize_),gravity(gravity_),friction(0.3f),restitution(0.3f){}
	
	CMMStageSpecDef Clone(){
		return CMMStageSpecDef(stageSize,worldSize,gravity,friction,restitution);
	}
	
	CGSize stageSize,worldSize;
	CGPoint gravity;
	float friction,restitution;
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

@interface CMMStageWorld : CMMLayer{
	CMMStage *stage;
	
	b2World *world;
	b2Body *worldBody;
	CMMStageContactListener *_contactLintener;
	CMMStageContactFilter *_contactFilter;
	b2Draw *_debugDraw;
	
	CCArray *object_list,*object_createList,*object_destroyList;
	CMMb2ContactMask b2Mask1,b2Mask2,b2Mask3,b2Mask4;
	
	//for performance Touch delegate
	CCArray *_touchedObjects;
	
	int _OBJECTTAG_;
}

+(id)worldWithStage:(CMMStage *)stage_ worldSize:(CGSize)worldSize_;
-(id)initWithStage:(CMMStage *)stage_ worldSize:(CGSize)worldSize_;

-(void)update:(ccTime)dt_;

@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readonly) b2World *world;
@property (nonatomic, readonly) b2Body *worldBody;
@property (nonatomic, readonly) CCArray *object_list;

@end

@interface CMMStageWorld(Common)

-(void)addObject:(CMMSObject *)object_;

-(void)removeObject:(CMMSObject *)object_;
-(void)removeObjectAtObjectTag:(int)objectTag_;

-(CMMSObject *)objectAtObjectTag:(int)objectTag_;
-(CMMSObject *)objectAtTouch:(UITouch *)touch_;

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

@interface CMMStage : CMMLayer<CMMSContactProtocol>{
	CMMSSpecStage *spec;

	id<CMMStageDelegate,CMMStageTouchDelegate> delegate;
	
	CMMStageWorld *world;
	CMMStageParticle *particle;
	CMMStageBackGround *backGround;
	CMMSoundHandler *sound;
	
	BOOL isAllowTouch;
}

+(id)stageWithStageSpecDef:(CMMStageSpecDef)stageSpecDef_;
-(id)initWithStageSpecDef:(CMMStageSpecDef)stageSpecDef_;

-(CGPoint)convertToStageWorldSpace:(CGPoint)worldPoint_;

-(void)update:(ccTime)dt_;

@property (nonatomic, retain) CMMSSpecStage *spec;
@property (nonatomic, assign) id<CMMStageDelegate>delegate;
@property (nonatomic, readonly) CMMStageWorld *world;
@property (nonatomic, readonly) CMMStageParticle *particle;
@property (nonatomic, readonly) CMMStageBackGround *backGround;
@property (nonatomic, readonly) CMMSoundHandler *sound;
@property (nonatomic, readonly) CGSize worldSize;
@property (nonatomic, readwrite) CGPoint worldPoint;
@property (nonatomic, readwrite) BOOL isAllowTouch;

@end