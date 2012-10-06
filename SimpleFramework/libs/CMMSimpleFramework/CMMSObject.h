//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSType.h"
#import "CMMSprite.h"
#import "CMMSSpecObject.h"
#import "CMMSStateObject.h"
#import "CMMSObjectSView.h"

@class CMMStage;
@class CMMSObject;

#define cmmVarCMMSObjectBatchNode_defaultCapacity 10

@interface CMMSObjectBatchNode : CCSpriteBatchNode{
	int obatchNodeTag;
	CMMStage *stage;
	
	Class objectClass;
	NSString *fileName;
	BOOL isInDocument;
	
	CMMSimpleCache *_cachedObjects;
}

+(id)batchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;
-(id)initWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

-(CMMSObject *)createObjectWithRect:(CGRect)rect_;
-(CMMSObject *)createObjectWithSpriteFrame:(CCSpriteFrame *)spriteFrame_;
-(CMMSObject *)createObject;

@property (nonatomic, readwrite) int obatchNodeTag;
@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readwrite) Class objectClass;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, readwrite) BOOL isInDocument;
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

@end

@interface CMMSObject(Box2d)

-(void)buildupBody;

-(void)updateBodyWithPosition:(CGPoint)point_ andRotation:(float)tRotation_;
-(void)updateBodyWithPosition:(CGPoint)point_;

@end

@interface CMMSObject(Stage)

-(void)whenAddedToStage;
-(void)whenRemovedToStage;

@end