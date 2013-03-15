//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSType.h"
#import "CMMSprite.h"
#import "CMMSSpecObject.h"
#import "CMMSStateObject.h"
#import "CMMSObjectSView.h"

@class CMMStage;
@class CMMStageWorld;
@class CMMSObject;

@interface CMMSObjectBatchNode : CCSpriteBatchNode{
	int obatchNodeTag;
	CMMStage *stage;
	CMMSimpleCache *_cachedObjects;
}

@property (nonatomic, readwrite) int obatchNodeTag;
@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readonly) int count;

@end

@interface CMMSObjectBatchNode(Cache)

-(CMMSObject *)cachedObject;
-(void)cacheObject:(CMMSObject *)object_;

@end

@interface CMMSObject : CMMSprite<CMMSContactProtocol>{
	int objectTag;
	
	CMMSSpecObject *spec;
	CMMSStateObject *state;
	
	b2Body *body;
	CMMb2ContactMask b2CMask;
	CMMStage *stage;
	
	CMMSObjectBatchNode *obatchNode;
	
	void (^callback_whenAddedToStage)(CMMSObject *object_, CMMStage *stage_),(^callback_whenRemovedToStage)(CMMSObject *object_, CMMStage *stage_);
}

+(id)spriteWithObatchNode:(CMMSObjectBatchNode *)obatchNode_ rect:(CGRect)rect_;
-(id)initWithObatchNode:(CMMSObjectBatchNode *)obatchNode_ rect:(CGRect)rect_;

-(void)buildupObject;
-(void)resetObject;

-(void)update:(ccTime)dt_;

@property (nonatomic, readwrite) int objectTag;
@property (nonatomic, retain) CMMSSpecObject *spec;
@property (nonatomic, retain) CMMSStateObject *state;
@property (nonatomic, readwrite) b2Body *body;
@property (nonatomic, readwrite) CMMb2ContactMask b2CMask;
@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, assign) CMMSObjectBatchNode *obatchNode;
@property (nonatomic, copy) void (^callback_whenAddedToStage)(CMMSObject *object_, CMMStage *stage_),(^callback_whenRemovedToStage)(CMMSObject *object_, CMMStage *stage_);

@end

@interface CMMSObject(Box2d)

-(void)buildupBodyWithWorld:(CMMStageWorld *)world_;

-(void)updateBodyPosition:(CGPoint)point_ rotation:(float)tRotation_;
-(void)updateBodyPosition:(CGPoint)point_;

-(void)updateBodyLinearVelocity:(b2Vec2)linearVelocity angularVelocity:(float)angularVelocity_;
-(void)updateBodyLinearVelocity:(b2Vec2)linearVelocity;

@end

@interface CMMSObject(Stage)

-(void)whenAddedToStage;
-(void)whenRemovedToStage;

@end