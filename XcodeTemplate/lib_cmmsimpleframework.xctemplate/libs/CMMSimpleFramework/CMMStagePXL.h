//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMStage.h"
#import "CCMutableTexture2D.h"
#import "CMMFileUtil.h"
#import "CMMStringUtil.h"
#import "CMMSPMapObject.h"

@interface CMMStagePixel : CCSpriteBatchNode{
	CMMStage *stage;
	CCMutableTexture2D *pixelTexture;
	CCArray *mapObjectList;
	
	uint collisionCheckSegOfRadians,collisionCheckSegOfStraight,collisionCheckCountOfStraight;
	float collisionCheckUpdateRateOfDistance,collisionCheckUnitOfRotation; //radians
	float mapFixtureNormalizeLimitDistance;
}

+(id)pixelWithStage:(CMMStage *)stage_ pixelData:(const void *)pixelData_ pixelSize:(CGSize)pixelSize_;
-(id)initWithStage:(CMMStage *)stage_ pixelData:(const void *)pixelData_ pixelSize:(CGSize)pixelSize_;

-(void)restorePixel;

-(void)update:(ccTime)dt_;

@property (nonatomic, assign) CMMStage *stage;
@property (nonatomic, readonly) CCMutableTexture2D *pixelTexture;
@property (nonatomic, readonly) CCArray *mapObjectList;

@property (nonatomic, readwrite) uint collisionCheckSegOfRadians,collisionCheckSegOfStraight,collisionCheckCountOfStraight;
@property (nonatomic, readwrite) float collisionCheckUpdateRateOfDistance,collisionCheckUnitOfRotation;
@property (nonatomic, readwrite) float mapFixtureNormalizeLimitDistance;
@end

@interface CMMStagePixel(Common)

-(void)addMapObject:(CMMSPMapObject *)mapObject_;
-(CMMSPMapObject *)addMapObjectWithTarget:(CMMSObject *)target_;

-(void)removeMapObject:(CMMSPMapObject *)mapObject_;
-(void)removeMapObjectAtIndex:(int)index_;
-(void)removeMapObjectAtTarget:(CMMSObject *)target_;
-(void)removeAllMapObject;

-(CMMSPMapObject *)mapObjectAtIndex:(int)index_;
-(CMMSPMapObject *)mapObjectAtTarget:(CMMSObject *)target_;

-(int)indexOfMapObject:(CMMSPMapObject *)mapObject_;
-(int)indexOfTarget:(CMMSObject *)object_;

@end

@interface CMMStagePixel(PixelCollision)

-(BOOL)isContactAtPoint:(CGPoint)point_;

-(BOOL)isContactFromPoint:(CGPoint)fromPoint_ toPoint:(CGPoint)toPoint_ unitValue:(float)unitValue_;
-(BOOL)isContactFromPoint:(CGPoint)fromPoint_ limitValue:(float)limitValue_ radians:(float)radians_ unitValue:(float)unitValue_;

-(CGPoint)contactPointFromPoint:(CGPoint)fromPoint_ toPoint:(CGPoint)toPoint_ unitValue:(float)unitValue_ isContact:(BOOL *)isContact_ checkLastContact:(BOOL)checkLastContact_;
-(CGPoint)contactPointFromPoint:(CGPoint)fromPoint_ toPoint:(CGPoint)toPoint_ unitValue:(float)unitValue_ isContact:(BOOL *)isContact_;

-(CGPoint)contactPointFromPoint:(CGPoint)fromPoint_ limitValue:(float)limitValue_ radians:(float)radians_ unitValue:(float)unitValue_ isContact:(BOOL *)isContact_ checkLastContact:(BOOL)checkLastContact_;
-(CGPoint)contactPointFromPoint:(CGPoint)fromPoint_ limitValue:(float)limitValue_ radians:(float)radians_ unitValue:(float)unitValue_ isContact:(BOOL *)isContact_;

@end

@interface CMMStagePixel(PixelControl)

-(void)paintMapAtPoint:(CGPoint)point_ color:(ccColor4B)color_ radius:(float)radius_;
-(void)createCraterAtPoint:(CGPoint)point_ radius:(float)radius_;

@end

@interface CMMStagePXL : CMMStage{
	NSString *fileName;
	BOOL inDocument;
	CMMStagePixel *pixel;
}

+(id)stageWithStageDef:(CMMStageDef)stageDef_ fileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;
-(id)initWithStageDef:(CMMStageDef)stageDef_ fileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly, getter = isInDocument) BOOL inDocument;
@property (nonatomic, readonly) CMMStagePixel *pixel;

@end
