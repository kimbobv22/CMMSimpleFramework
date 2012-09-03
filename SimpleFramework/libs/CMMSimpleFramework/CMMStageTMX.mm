//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMTilemapStage.h"
#import "CMMStringUtil.h"

@implementation CMMTilemapStage
@synthesize tilemap,groundTMXLayers,isTilemapBuiltup;

+(id)stageWithCMMStageSpecDef:(CMMStageSpecDef)stageSpecDef_ tmxFileName:(NSString *)tmxFileName_ isInDocument:(BOOL)isInDocument_{
	return [[[self alloc] initWithCMMStageSpecDef:stageSpecDef_ tmxFileName:tmxFileName_ isInDocument:isInDocument_] autorelease];
}

-(id)initWithCMMStageSpecDef:(CMMStageSpecDef)stageSpecDef_{
	//do not use for init
	[self release];
	return nil;
}
-(id)initWithCMMStageSpecDef:(CMMStageSpecDef)stageSpecDef_ tmxFileName:(NSString *)tmxFileName_ isInDocument:(BOOL)isInDocument_{
	tilemap = [CCTMXTiledMap tiledMapWithTMXFile:[CMMStringUtil stringPathWithFileName:tmxFileName_ isInDocument:isInDocument_]];
	
	//only support Orthogonal orientation
	if(tilemap.mapOrientation != CCTMXOrientationOrtho){
		[self release];
		return nil;
	}

	stageSpecDef_.worldSize = tilemap.contentSize;
	
	if(!(self = [super initWithCMMStageSpecDef:stageSpecDef_])) return self;
	[self addChild:tilemap z:1];
	
	groundTMXLayers = [[CCArray alloc] init];
	isTilemapBuiltup = NO;
	
	b2MaskTile = CMMb2ContactMask(CMMb2FixtureType_stageTile,-1,-1,1);
	
	return self;
}

-(void)setWorldPoint:(CGPoint)worldPoint_{
	[super setWorldPoint:worldPoint_];
	[tilemap setPosition:world.position];
}

-(void)update:(ccTime)dt_{
	if(!isTilemapBuiltup) return;
	[super update:dt_];
}

-(void)dealloc{
	[groundTMXLayers release];
	[super dealloc];
}

@end

@implementation CMMTilemapStage(Tilemap)

-(void)addGroundTMXLayerAtLayerName:(NSString *)tmxLayerName_{
	if(isTilemapBuiltup) return;
	
	CCTMXLayer *tmxLayer_ = [tilemap layerNamed:tmxLayerName_];
	if([groundTMXLayers indexOfObject:tmxLayer_] != NSNotFound) return;
	[groundTMXLayers addObject:tmxLayer_];
}
-(void)removeGroundTMXLayerAtLayerName:(NSString *)tmxLayerName_{
	if(isTilemapBuiltup) return;
	
	CCTMXLayer *tmxLayer_ = [tilemap layerNamed:tmxLayerName_];
	if([groundTMXLayers indexOfObject:tmxLayer_] == NSNotFound) return;
	[groundTMXLayers removeObject:groundTMXLayers];
}

-(void)buildupTilemap{
	if(isTilemapBuiltup){
		CCLOG(@"tilemap is already been built up!");
		return;
	}
	
	b2Body *worldBody_ = world.worldBody;
	ccArray *groundData_ = groundTMXLayers->data;
	int count_ = groundData_->num;
	for(uint index_=0;index_<count_;index_++){
		CCTMXLayer *tmxLayer_ = groundData_->arr[index_];
		
		CGSize tileLayerSize_ = tmxLayer_.layerSize;
		uint totalTileLength_ = (int)tileLayerSize_.width*tileLayerSize_.height;
		b2Vec2 tileSizeUint_ = b2Vec2Fromccp((tmxLayer_.mapTileSize.width/CC_CONTENT_SCALE_FACTOR())/2.0f, (tmxLayer_.mapTileSize.height/CC_CONTENT_SCALE_FACTOR())/2.0f);
		
		float startXIndex_ = -1;
		float startYIndex_ = -1;
		BOOL doDraw_ = NO;
		
		for(int tileIndex_=0; tileIndex_<totalTileLength_;tileIndex_++){			
			float curYIndex_ = cmmFuncCMMTilemapStage_tileYIndex(tileIndex_,tileLayerSize_.width);
			float curXIndex_ = cmmFuncCMMTilemapStage_tileXIndex(tileIndex_,tileLayerSize_.width,curYIndex_);
			
			CCSprite *tile_ = [tmxLayer_ tileAt:ccp(curXIndex_,(tileLayerSize_.height-1.0f)-curYIndex_)];
	//		u_int32_t tile_ = [tmxLayer_ tileGIDAt:ccp(curXIndex_,(tileLayerSize_.height-1.0f)-curYIndex_)];
			if(tile_){
				if(startXIndex_<0){
					startXIndex_ = curXIndex_;
					startYIndex_ = curYIndex_;
					doDraw_ = NO;
				}
				
				float nextYIndex_ = cmmFuncCMMTilemapStage_tileYIndex(tileIndex_+1.0f,tileLayerSize_.width);
				if(nextYIndex_ != curYIndex_){
					curXIndex_++; //issue
					doDraw_ = YES;
				}else doDraw_ = NO;
				
				if(!doDraw_ && cmmFuncCommon_respondsToSelector(delegate, @selector(tilemapStage:isSingleTileAtTMXLayer:tile:xIndex:yIndex:))){
					if([((id<CMMTilemapStageDelegate>)delegate) tilemapStage:self isSingleTileAtTMXLayer:tmxLayer_ tile:tile_ xIndex:curXIndex_ yIndex:curYIndex_]){
						curXIndex_++;
						doDraw_ = YES;
					}
				}
				
			}else if(startXIndex_>=0) doDraw_ = YES;
			
			if(doDraw_){	
				b2Vec2 tileSize_ = b2Vec2(tileSizeUint_.x*(curXIndex_-startXIndex_),tileSizeUint_.y);
				b2Vec2 tilePoint_ = b2Vec2((tileSizeUint_.x*2.0f*startXIndex_)+tileSize_.x,(tileSizeUint_.y*2.0f*startYIndex_)+tileSize_.y);
				
				b2PolygonShape blockShape_;
				blockShape_.SetAsBox(tileSize_.x, tileSize_.y, tilePoint_, 0);
			
				b2FixtureDef fixtureDef_;
				fixtureDef_.density = 0.7f;
				fixtureDef_.friction = spec.friction;
				fixtureDef_.restitution = spec.restitution;
				fixtureDef_.shape = &blockShape_;
				b2Fixture *tileFixture_ = worldBody_->CreateFixture(&fixtureDef_);
				tileFixture_->SetUserData(&b2MaskTile);
				
				if(cmmFuncCommon_respondsToSelector(delegate, @selector(tilemapStage:whenTileBuiltupAtTMXLayer:fromXIndex:toXIndex:yIndex:tileFixture:)))
					[((id<CMMTilemapStageDelegate>)delegate) tilemapStage:self whenTileBuiltupAtTMXLayer:tmxLayer_ fromXIndex:startXIndex_ toXIndex:curXIndex_ yIndex:curXIndex_-1.0f tileFixture:tileFixture_];
			
				doDraw_ = NO;
				startXIndex_ = startYIndex_ = -1;
			}
		}
	}
	isTilemapBuiltup = YES;
}

@end
