//
//  CMMStageDNB.h
//  SimpleFramework
//
//  Created by Kim Jazz on 12. 11. 20..
//
//

#import "CMMStage.h"

@class CMMStageDNB;

typedef enum{
	CMMBlockType_normal,
	CMMBlockType_filledDown,
	CMMBlockType_filledUp,
	CMMBlockType_filledUpAndCeiling,
} CMMBlockType;

@class CMMStageBlockItem;

struct CMMSBlockObjectPhysicalSpec{
	float friction,restitution,density;
	
	CMMSBlockObjectPhysicalSpec(float friction_,float restitution_,float density_) : friction(friction_),restitution(restitution_),density(density_){}
	CMMSBlockObjectPhysicalSpec(){
		friction = 0.3f;
		restitution = 0.3f;
		density = 0.3f;
	}
};
typedef CMMSBlockObjectPhysicalSpec CMMSBlockObjectPhysicalSpec;

typedef enum{
	CMMSBlockObjectB2BodyType_full,
	CMMSBlockObjectB2BodyType_bar,
} CMMSBlockObjectB2BodyType;

@interface CMMSBlockObject : CMMSObject{
	CMMStageBlockItem *blockItem;
}

@property (nonatomic, assign) CMMStageBlockItem *blockItem;

@end

@class CMMStageBlock;

/*
	left-end block sprite frame index : 0
	right-end block sprite frame index : 1
 */

@interface CMMStageBlockItem : NSObject{
	CCArray *groundBlocks,*backBlocks;
	CMMBlockType blockType;
	CMMSBlockObjectPhysicalSpec blockPhysicalSpec;
	CMMSBlockObjectB2BodyType blockB2BodyType;
	uint blockObjectZOrder;
	
	CGSize blockSize;
	NSRange blockCountRange;
	float pickupRatio,blockRandomizeRatio;
	BOOL drawEdge;
	
@public
	CMMb2ContactMask b2CMask;
}

+(id)blockItem;

-(CMMSBlockObject *)createBlockWithTargetHeight:(float)targetHeight_;

@property (nonatomic, readonly) CCArray *groundBlocks,*backBlocks;
@property (nonatomic, readwrite) CMMb2ContactMask b2CMask;
@property (nonatomic, readwrite) CMMBlockType blockType;
@property (nonatomic, readwrite) CMMSBlockObjectPhysicalSpec blockPhysicalSpec;
@property (nonatomic, readwrite) CMMSBlockObjectB2BodyType blockB2BodyType;
@property (nonatomic, readwrite) uint blockObjectZOrder;
@property (nonatomic, readwrite) CGSize blockSize;
@property (nonatomic, readwrite) NSRange blockCountRange;
@property (nonatomic, readwrite) float pickupRatio,blockRandomizeRatio;
@property (nonatomic, readwrite, getter = isDrawEdge) BOOL drawEdge;

@end

@interface CMMStageBlockItem(GroundBlock)

-(void)addGroundBlock:(CCSpriteFrame *)spriteFrame_;
-(void)addGroundBlockWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_;
-(void)addGroundBlockWithFile:(NSString *)spriteFrameFilePath_ spriteFrameFormatter:(NSString *)spriteFrameFormatter_;

-(void)removeGroundBlock:(CCSpriteFrame *)spriteFrame_;
-(void)removeGroundBlockAtIndex:(uint)index_;

-(CCSpriteFrame *)groundBlockAtIndex:(uint)index_;

-(uint)indexOfGroundBlock:(CCSpriteFrame *)spriteFrame_;

@end

@interface CMMStageBlockItem(BackBlock)

-(void)addBackBlock:(CCSpriteFrame *)spriteFrame_;
-(void)addBackBlockWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_;
-(void)addBackBlockWithFile:(NSString *)spriteFrameFilePath_ spriteFrameFormatter:(NSString *)spriteFrameFormatter_;

-(void)removeBackBlock:(CCSpriteFrame *)spriteFrame_;
-(void)removeBackBlockAtIndex:(uint)index_;

-(CCSpriteFrame *)backBlockAtIndex:(uint)index_;

-(uint)indexOfBackBlock:(CCSpriteFrame *)spriteFrame_;

@end

@class CMMStageBlock;

@interface CMMStageBlock : NSObject<CMMStageChildProtocol>{
	CMMStageDNB *stage;
	CCArray *itemList;
	
	float blockRandomizeRatio;
}

+(id)blockWithStage:(CMMStageDNB *)stage_;
-(id)initWithStage:(CMMStageDNB *)stage_;

@property (nonatomic, readonly) CCArray *itemList;
@property (nonatomic, readonly) uint count;
@property (nonatomic, readwrite) float blockRandomizeRatio;

@end

@interface CMMStageBlock(Common)

-(void)addBlockItem:(CMMStageBlockItem *)blockItem_;

-(void)removeBlockItem:(CMMStageBlockItem *)blockItem_;
-(void)removeBlockItemAtIndex:(uint)index_;

-(CMMStageBlockItem *)blockItemAtIndex:(uint)index_;

-(uint)indexOfBlockItem:(CMMStageBlockItem *)blockItem_;

@end

typedef enum{
	CMMStageDNBDirection_none,
	
	CMMStageDNBDirection_bottom,
	CMMStageDNBDirection_top,
	CMMStageDNBDirection_left,
	CMMStageDNBDirection_right,
} CMMStageDNBDirection;

@protocol CMMStageDNBDelegate <CMMStageDelegate>

@optional
-(void)stage:(CMMStageDNB *)stage_ didCreateBlockObjects:(CCArray *)createdBlockObjects_;

-(void)stage:(CMMStageDNB *)stage_ whenContactStartedWithObject:(CMMSObject *)object_ AtDirection:(CMMStageDNBDirection)direction_;
-(void)stage:(CMMStageDNB *)stage_ whenContactEndedWithObject:(CMMSObject *)object_ AtDirection:(CMMStageDNBDirection)direction_;
-(void)stage:(CMMStageDNB *)stage_ doContactWithObject:(CMMSObject *)object_ AtDirection:(CMMStageDNBDirection)direction_ interval:(ccTime)interval_;

@end

@interface CMMStageDNBLightSystem : CMMStageLight

@end

//Dynamic Block
@interface CMMStageDNB : CMMStage{
	CMMStageBlock *block;
	
	CMMFloatRange marginPerBlock,blockHeightRange;
	float maxHeightDifferencePerBlock,worldVelocityX;
	BOOL removeObjectOnOutside;
	
	float _addedWorldPointX;
	CGPoint _lastCreatePoint;
	float _curMarginPerBlock;
}

@property (nonatomic, readonly) CMMStageBlock *block;
@property (nonatomic, readwrite) CMMFloatRange marginPerBlock,blockHeightRange;
@property (nonatomic, readwrite, getter = isRemoveObjectOnOutside) BOOL removeObjectOnOutside;
@property (nonatomic, readwrite) float maxHeightDifferencePerBlock,worldVelocityX;

@end
