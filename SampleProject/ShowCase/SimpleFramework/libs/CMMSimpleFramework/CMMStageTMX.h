//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMStage.h"

#define cmmFuncCMMStageTMX_tileYIndex(_curIndex_,_totalTileWidth_) floorf((_curIndex_)/(_totalTileWidth_))
#define cmmFuncCMMStageTMX_tileXIndex(_curIndex_,_totalTileWidth_,_yIndex_) (_curIndex_) - ((_totalTileWidth_)*(_yIndex_))

@class CMMStageTMX;

@interface CMMStageTMX : CMMStage{
	CCTMXTiledMap *tilemap;
	CCArray *groundTMXLayers;
	CMMb2ContactMask b2MaskTile;
	
	BOOL tilemapBuiltup;
	
	void (^callback_tileBuiltup)(CCTMXLayer *tmxLayer_,float fromXIndex_,float toXIndex_,float yIndex_,b2Fixture *tileFixture_);
	BOOL (^filter_isSingleTile)(CCTMXLayer *tmxLayer_,CCSprite *tile_,float xIndex_,float yIndex_);
}

+(id)stageWithStageDef:(CMMStageDef)stageDef_ tmxFileName:(NSString *)tmxFileName_ isInDocument:(BOOL)isInDocument_;
-(id)initWithStageDef:(CMMStageDef)stageDef_ tmxFileName:(NSString *)tmxFileName_ isInDocument:(BOOL)isInDocument_;

@property (nonatomic, readonly) CCTMXTiledMap *tilemap;
@property (nonatomic, readonly) CCArray *groundTMXLayers;
@property (nonatomic, readonly, getter = isTilemapBuiltup) BOOL tilemapBuiltup;

@property (nonatomic, copy) void (^callback_tileBuiltup)(CCTMXLayer *tmxLayer_,float fromXIndex_,float toXIndex_,float yIndex_,b2Fixture *tileFixture_);
@property (nonatomic, copy) BOOL (^filter_isSingleTile)(CCTMXLayer *tmxLayer_,CCSprite *tile_,float xIndex_,float yIndex_);

-(void)setFilter_isSingleTile:(BOOL(^)(CCTMXLayer *tmxLayer_,CCSprite *tile_,float xIndex_,float yIndex_))block_;
-(void)setCallback_tileBuiltup:(void(^)(CCTMXLayer *tmxLayer_,float fromXIndex_,float toXIndex_,float yIndex_,b2Fixture *tileFixture_))block_;

@end

@interface CMMStageTMX(Tilemap)

-(void)addGroundTMXLayerAtLayerName:(NSString *)tmxLayerName_;
-(void)removeGroundTMXLayerAtLayerName:(NSString *)tmxLayerName_;

-(void)buildupTilemapWithBlock:(void(^)())block_;
-(void)buildupTilemap;

@end