//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMStagePXL.h"
#import "CMMSimpleCache.h"
#import "CCSpriteBatchNode+SplitSprite.h"

#define cmmFuncCMMStagePixel_GetRadiansUnitOfSegment(_segment_) (M_PI*2.0f)/(float)((_segment_)-1)

static CMMSimpleCache *_CMMStagePixelObjectCache_ = nil;

@implementation CMMStagePixel
@synthesize stage,pixelTexture,mapObjectList,collisionCheckSegOfRadians,collisionCheckSegOfStraight,collisionCheckCountOfStraight,collisionCheckUpdateRateOfDistance,collisionCheckUnitOfRotation,mapFixtureNormalizeLimitDistance;

+(id)pixelWithStage:(CMMStage *)stage_ pixelData:(const void *)pixelData_ pixelSize:(CGSize)pixelSize_{
	return [[[self alloc] initWithStage:stage_ pixelData:pixelData_ pixelSize:pixelSize_] autorelease];
}
-(id)initWithStage:(CMMStage *)stage_ pixelData:(const void *)pixelData_ pixelSize:(CGSize)pixelSize_{

	stage = stage_;
	
	NSInteger pixelWidth_ = (NSUInteger)pixelSize_.width;
	NSInteger pixelHeight_ = (NSUInteger)pixelSize_.height;

	pixelTexture = [[CCMutableTexture2D alloc] initWithData:pixelData_ pixelFormat:[CCTexture2D defaultAlphaPixelFormat] pixelsWide:pixelWidth_ pixelsHigh:pixelHeight_ contentSize:pixelSize_];
	
	if(!(self = [super initWithTexture:pixelTexture capacity:50])) return self;
	
	[self addSplitSprite:CGSizeMake(50.0f, 50.0f) blendFunc:(ccBlendFunc){GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA}];
	[self restorePixel];
	
	mapObjectList = [[CCArray alloc] init];

	collisionCheckSegOfRadians = 16;
	collisionCheckSegOfStraight = 4;
	collisionCheckCountOfStraight = 4;
	collisionCheckUpdateRateOfDistance = 0.1f;
	collisionCheckUnitOfRotation = CC_DEGREES_TO_RADIANS(30.0f); //to radians
	mapFixtureNormalizeLimitDistance = 10.0f;
	
	if(!_CMMStagePixelObjectCache_)
		_CMMStagePixelObjectCache_ = [[CMMSimpleCache alloc] init];
	
	return self;
}

-(void)restorePixel{
	[pixelTexture restore];
}

-(void)update:(ccTime)dt_{
	CMMSSpecStage *specStage_ = (CMMSSpecStage *)[stage spec];
	
	ccArray *tempData_ = mapObjectList->data;
	uint count_ = tempData_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSPMapObject *mapObject_ = tempData_->arr[index_];
		CMMSObject *target_ = [mapObject_ target];
		b2Body *mapBody_ = mapObject_->mapBody;
		
		CGPoint lastGenPoint_ = [mapObject_ lastGenPoint];
		float lastRotate_ = [mapObject_ lastRotate];
		
		CGPoint targetPoint_ = [target_ position];
		CGSize targetSize_ = [target_ contentSize];
		float targetSizeLength_ = CGSizeLength(targetSize_);
		float targetRotate_ = [target_ body]->GetAngle();
		
		float targetMoveDistance_ = ccpDistance(lastGenPoint_, targetPoint_);
		float collisionCheckRotateDiff_ = ABS(cmmFuncCommon_fixRadians(cmmFuncCommon_fixRadians(lastRotate_)-cmmFuncCommon_fixRadians(targetRotate_)));
		
		if(![mapObject_ doRecreate] && targetMoveDistance_ <= targetSizeLength_ * collisionCheckUpdateRateOfDistance && collisionCheckRotateDiff_ <= collisionCheckUnitOfRotation) continue;
		
		[mapObject_ setDoRecreate:NO];
		[mapObject_ setLastGenPoint:targetPoint_];
		
		if(collisionCheckRotateDiff_ >= collisionCheckRotateDiff_)
			[mapObject_ setLastRotate:targetRotate_];
		
		float coef_ = cmmFuncCMMStagePixel_GetRadiansUnitOfSegment(collisionCheckSegOfRadians);
		b2Vec2 collisionBeforeVector_ = b2Vec2(-1,-1);
		BOOL isBeforeContact_ = NO;
		
		for(int segIndex_=0;segIndex_<collisionCheckSegOfRadians;++segIndex_){
			float curRadians_ = segIndex_*coef_;
			
			//check exists fixture
			CMMSPMapObjectFixture *mapFixtureItem_ = [mapObject_ fixtureAtRadians:curRadians_];
			if(mapFixtureItem_->fixture){
				BOOL isOnContacting_ = NO;
				for(b2ContactEdge *contactEdge_ = mapBody_->GetContactList();contactEdge_;contactEdge_=contactEdge_->next){
					b2Contact *contact_ = contactEdge_->contact;
					if(!contact_->IsTouching()) continue;
					b2Fixture *contactFixture_ = contact_->GetFixtureA();
					if(contactFixture_->GetBody() != mapBody_)
						contactFixture_ = contact_->GetFixtureB();
					
					if(contactFixture_ != mapFixtureItem_->fixture) continue;
					
					b2EdgeShape *tempShape_ = (b2EdgeShape *)contactFixture_->GetShape();
					b2Vec2 tempCollisionVector_ = collisionBeforeVector_ = tempShape_->m_vertex2;
					
					if(![self isContactAtPoint:cmmFuncCMMStage_GetContactPoint(contact_)])
						break;
					
					isOnContacting_ = isBeforeContact_ = YES;
					collisionBeforeVector_ = tempCollisionVector_;
					break;
				}
				
				if(isOnContacting_) continue;
				
				mapBody_->DestroyFixture(mapFixtureItem_->fixture);
				mapFixtureItem_->fixture = nil;
			}
			
			//check collision from straight
			float collisionMinCheckLength_ = targetMoveDistance_+(targetSizeLength_*1.5f);
			BOOL isTargetContact_ = NO;
			CGPoint collisionTargetPoint_ = targetPoint_;
			for(uint strtIndex_=0;strtIndex_<collisionCheckSegOfStraight;++strtIndex_){
				BOOL isContactAtStraight_ = NO;
				CGPoint collisionStraightPoint_ = [self contactPointFromPoint:targetPoint_ limitValue:collisionMinCheckLength_ radians:curRadians_ unitValue:collisionMinCheckLength_/(float)collisionCheckCountOfStraight isContact:&isContactAtStraight_ checkLastContact:NO];
				
				collisionMinCheckLength_ = MIN(collisionMinCheckLength_ * 0.5f,ccpDistance(targetPoint_, collisionStraightPoint_));
				
				if(isContactAtStraight_){
					collisionTargetPoint_ = collisionStraightPoint_;
					isTargetContact_ = YES;
				}
			}
			
			if(isTargetContact_){
				BOOL isFixed_ = NO;
				CGPoint fixPoint_ = [self contactPointFromPoint:collisionTargetPoint_ limitValue:10.0f radians:curRadians_+M_PI unitValue:1.0f isContact:&isFixed_ checkLastContact:YES];
				
				if(isFixed_){
					collisionTargetPoint_ = fixPoint_;
				}
			}
			
			b2Vec2 collisionTargetVector_ = b2Vec2Fromccp_PTM_RATIO(collisionTargetPoint_);
			
			if(isBeforeContact_ && isTargetContact_){
				
				//normalizing collision point
				if((collisionTargetVector_-collisionBeforeVector_).Length() <= mapFixtureNormalizeLimitDistance/PTM_RATIO){
					continue;
				}
				
				b2EdgeShape tempBox_;
				tempBox_.Set(collisionBeforeVector_,collisionTargetVector_);
				b2Fixture *mapFixture_ = mapBody_->CreateFixture(&tempBox_,0.3f);
				mapFixture_->SetFriction([specStage_ friction]);
				mapFixture_->SetRestitution([specStage_ restitution]);
				mapFixture_->SetDensity([specStage_ density]);
				mapFixture_->SetUserData(&mapObject_->b2CMask);
				mapFixtureItem_->fixture = mapFixture_;
			}
			
			collisionBeforeVector_ = collisionTargetVector_;
			isBeforeContact_ = isTargetContact_;
		}
	}
}

-(void)dealloc{
	[mapObjectList release];
	[pixelTexture release];
	[super dealloc];
}

@end

@implementation CMMStagePixel(Common)

-(void)addMapObject:(CMMSPMapObject *)mapObject_{
	if([self indexOfMapObject:mapObject_] != NSNotFound) return;
	
	[mapObjectList addObject:mapObject_];
	
	mapObject_->mapBody = [[stage world] createBody:b2_staticBody point:CGPointZero angle:0];
	mapObject_->mapBody->SetUserData(stage);
	
	CMMb2ContactMask targetCMask_ = b2CMaskMake(0x3009, [[mapObject_ target] objectTag], -1, 1);
	targetCMask_.isNegative = true;
	mapObject_->b2CMask = targetCMask_;
	
	[mapObject_ setDoRecreate:YES];
	[mapObject_ setLastGenPoint:[[mapObject_ target] position]];
	[mapObject_ removeAllFixtures];
	
	float coef_ = cmmFuncCMMStagePixel_GetRadiansUnitOfSegment(collisionCheckSegOfRadians);
	for(int segIndex_=0;segIndex_<collisionCheckSegOfRadians;++segIndex_){
		float curRadians_ = segIndex_*coef_;
		[mapObject_ addFixtureWithRadians:curRadians_ fixture:nil];
	}
}
-(CMMSPMapObject *)addMapObjectWithTarget:(CMMSObject *)target_{
	if([self indexOfTarget:target_] != NSNotFound) return nil;
	
	CMMSPMapObject *mapObject_ = [_CMMStagePixelObjectCache_ cachedObject];
	
	if(!mapObject_)
		mapObject_ = [CMMSPMapObject pixelmapObjectWithTarget:nil];
	
	[mapObject_ setTarget:target_];
	[self addMapObject:mapObject_];
	return mapObject_;
}

-(void)removeMapObject:(CMMSPMapObject *)mapObject_{
	NSUInteger index_ = [self indexOfMapObject:mapObject_];
	if(index_ == NSNotFound) return;
	
	[_CMMStagePixelObjectCache_ cacheObject:mapObject_];
	[mapObjectList removeObjectAtIndex:index_];
	[mapObject_ removeAllFixtures];
	[[stage world] world]->DestroyBody(mapObject_->mapBody);
	mapObject_->mapBody = NULL;
}
-(void)removeMapObjectAtIndex:(int)index_{
	return [self removeMapObject:[self mapObjectAtIndex:index_]];
}
-(void)removeMapObjectAtTarget:(CMMSObject *)target_{
	[self removeMapObjectAtIndex:[self indexOfTarget:target_]];
}
-(void)removeAllMapObject{
	ccArray *tempData_ = mapObjectList->data;
	NSUInteger count_ = tempData_->num;
	for(NSUInteger index_=0;index_<count_;++index_){
		CMMSPMapObject *mapObject_ = tempData_->arr[index_];
		[self removeMapObject:mapObject_];
	}
}

-(CMMSPMapObject *)mapObjectAtIndex:(int)index_{
	if(index_ == NSNotFound) return nil;
	return [mapObjectList objectAtIndex:index_];
}
-(CMMSPMapObject *)mapObjectAtTarget:(CMMSObject *)target_{
	return [self mapObjectAtIndex:[self indexOfTarget:target_]];
}

-(int)indexOfMapObject:(CMMSPMapObject *)mapObject_{
	return [mapObjectList indexOfObject:mapObject_];
}
-(int)indexOfTarget:(CMMSObject *)target_{
	ccArray *tempData_ = mapObjectList->data;
	NSUInteger count_ = tempData_->num;
	for(NSUInteger index_=0;index_<count_;++index_){
		CMMSPMapObject *mapObject_ = tempData_->arr[index_];
		if(mapObject_.target == target_)
			return index_;
	}
	
	return NSNotFound;
}

@end

@implementation CMMStagePixel(PixelCollision)

-(BOOL)isContactAtPoint:(CGPoint)point_{
	point_ = ccpMult(point_, CC_CONTENT_SCALE_FACTOR());
	ccColor4B pixelInfo_ = [pixelTexture pixelAtPoint:point_];
	return (pixelInfo_.a == 255);
}

-(BOOL)isContactFromPoint:(CGPoint)fromPoint_ toPoint:(CGPoint)toPoint_ unitValue:(float)unitValue_{
	BOOL isContact_ = NO;
	[self contactPointFromPoint:fromPoint_ toPoint:toPoint_ unitValue:unitValue_ isContact:&isContact_ checkLastContact:NO];
	return isContact_;
}
-(BOOL)isContactFromPoint:(CGPoint)fromPoint_ limitValue:(float)limitValue_ radians:(float)radians_ unitValue:(float)unitValue_{
	return [self isContactFromPoint:fromPoint_ toPoint:ccpOffset(fromPoint_, radians_, limitValue_) unitValue:unitValue_];
}

-(CGPoint)contactPointFromPoint:(CGPoint)fromPoint_ toPoint:(CGPoint)toPoint_ unitValue:(float)unitValue_ isContact:(BOOL *)isContact_ checkLastContact:(BOOL)checkLastContact_{
	BOOL isTargetContact_ = NO;
	CGPoint targetPoint_ = toPoint_;
	CGPoint diffPoint_ = ccpSub(toPoint_,fromPoint_);
	float limitValue_ = ccpLength(diffPoint_);
	float radians_ = ccpToAngle(diffPoint_);
	for(float collisionStep_=unitValue_;collisionStep_<=limitValue_;collisionStep_+=unitValue_){
		CGPoint tempPoint_ = ccpOffset(fromPoint_, radians_, collisionStep_);
		
		if([self isContactAtPoint:tempPoint_]){
			isTargetContact_ = YES;
			targetPoint_ = tempPoint_;
			if(!checkLastContact_) break;
		}
	}
	
	if(isContact_) *isContact_ = isTargetContact_;
	
	return targetPoint_;
}
-(CGPoint)contactPointFromPoint:(CGPoint)fromPoint_ toPoint:(CGPoint)toPoint_ unitValue:(float)unitValue_ isContact:(BOOL *)isContact_{
	return [self contactPointFromPoint:fromPoint_ toPoint:toPoint_ unitValue:unitValue_ isContact:isContact_ checkLastContact:NO];
}

-(CGPoint)contactPointFromPoint:(CGPoint)fromPoint_ limitValue:(float)limitValue_ radians:(float)radians_ unitValue:(float)unitValue_ isContact:(BOOL *)isContact_ checkLastContact:(BOOL)checkLastContact_{
	return [self contactPointFromPoint:fromPoint_ toPoint:ccpOffset(fromPoint_, radians_, limitValue_) unitValue:unitValue_ isContact:isContact_ checkLastContact:checkLastContact_];
}
-(CGPoint)contactPointFromPoint:(CGPoint)fromPoint_ limitValue:(float)limitValue_ radians:(float)radians_ unitValue:(float)unitValue_ isContact:(BOOL *)isContact_{
	return [self contactPointFromPoint:fromPoint_ limitValue:limitValue_ radians:radians_ unitValue:unitValue_ isContact:isContact_ checkLastContact:NO];
}

@end

@implementation CMMStagePixel(PixelControl)

-(void)paintMapAtPoint:(CGPoint)point_ color:(ccColor4B)color_ radius:(float)radius_{
	CGPoint convertPoint_ = ccpMult(point_, CC_CONTENT_SCALE_FACTOR());
	[pixelTexture setPixelCircleAtPoint:convertPoint_ radius:radius_ pixel:color_];
	CGRect applyRect_ = CGRectMake(convertPoint_.x-radius_, convertPoint_.y-radius_, radius_*2.0f, radius_*2.0f);
	[pixelTexture applyPixelAtRect:applyRect_];
	
	radius_ *= 2.0f; //check multiply distance
	CGRect targetRect_ = CGRectMake(point_.x-radius_, point_.y-radius_, radius_*2.0f, radius_*2.0f);
	ccArray *data_ = mapObjectList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSPMapObject *mapObject_ = data_->arr[index_];
		if(CGRectIntersectsRect(targetRect_, [[mapObject_ target] boundingBox])){
			[mapObject_ setDoRecreate:YES];
		}
	}
}

-(void)createCraterAtPoint:(CGPoint)point_ radius:(float)radius_{
	[self paintMapAtPoint:point_ color:ccc4(0, 0, 0,0) radius:radius_];
}

@end

@implementation CMMStagePXL
@synthesize fileName,isInDocument,pixel;

+(id)stageWithStageSpecDef:(CMMStageSpecDef)stageSpecDef_ fileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	return [[[self alloc] initWithStageSpecDef:stageSpecDef_ fileName:fileName_ isInDocument:isInDocument_] autorelease];
}

-(id)initWithStageSpecDef:(CMMStageSpecDef)stageSpecDef_{
	[self release];
	return self;
}
-(id)initWithStageSpecDef:(CMMStageSpecDef)stageSpecDef_ fileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_{
	fileName = [fileName_ copy];
	isInDocument = isInDocument_;
	
	//not supports HD image
	NSData *data_ = [CMMFileUtil dataWithFileName:fileName isInDocument:isInDocument];
	if(!data_){
		[self release];
		CCLOG(@"CMMStagePXL : PixelData doesn't to be nil");
		return self;
	}
	
	CCLOG(@"CMMStagePXL : load pixel data : length->%d",[data_ length]);

	UIImage *pixelImage_ = [UIImage imageWithData:data_];
	CGSize pixelSize_ = [pixelImage_ size];
	
	void *pixelData_ = [CMMFileUtil imageDataWithCGImage:[pixelImage_ CGImage]];
	pixel = [CMMStagePixel pixelWithStage:self pixelData:pixelData_ pixelSize:pixelSize_];
	
	stageSpecDef_.worldSize = CGSizeDiv(pixelSize_, CC_CONTENT_SCALE_FACTOR());
	if(!(self = [super initWithStageSpecDef:stageSpecDef_])) return self;
	
	[self addChild:pixel z:2];
	
	return self;
}

-(void)setWorldPoint:(CGPoint)worldPoint_{
	[super setWorldPoint:worldPoint_];
	[pixel setPosition:[world position]];
}

-(void)step:(ccTime)dt_{
	[pixel update:dt_];
	[super step:dt_];
}

-(void)whenContactBeganWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{
	[super whenContactBeganWithFixtureType:fixtureType_ otherObject:otherObject_ otherFixtureType:otherFixtureType_ contactPoint:contactPoint_];
	
}
-(void)whenContactEndedWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{
	[super whenContactEndedWithFixtureType:fixtureType_ otherObject:otherObject_ otherFixtureType:otherFixtureType_ contactPoint:contactPoint_];
}

-(void)stageWorld:(CMMStageWorld *)world_ whenAddedObject:(CMMSObject *)object_{
	[super stageWorld:world_ whenAddedObject:object_];
	[pixel addMapObjectWithTarget:object_];
}
-(void)stageWorld:(CMMStageWorld *)world_ whenRemovedObject:(CMMSObject *)object_{
	[super stageWorld:world_ whenRemovedObject:object_];
	[pixel removeMapObjectAtTarget:object_];
}

@end
