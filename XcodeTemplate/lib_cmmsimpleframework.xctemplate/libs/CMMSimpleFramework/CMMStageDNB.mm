//
//  CMMStageDNB.mm
//  SimpleFramework
//
//  Created by Kim Jazz on 12. 11. 20..
//
//

#import "CMMStageDNB.h"

@implementation CMMSBlockObject
@synthesize blockItem;

@end

@implementation CMMSBlockObject(Box2d)

-(void)buildupBody{
	body = [[stage world] createBody:b2_staticBody point:_position angle:0.0f];
	body->SetUserData(self);
	
	CMMBlockType blockType_ = [blockItem blockType];
	CMMSBlockObjectB2BodyType b2bodyType_ = [blockItem blockB2BodyType];
	CMMSBlockObjectPhysicalSpec physicalSpec_ = [blockItem blockPhysicalSpec];
	b2Vec2 totalSizeVector_ = b2Vec2Div(b2Vec2FromSize_PTM_RATIO(_contentSize),2.0f);
	CGSize blockSize_ = [blockItem blockSize];
	blockSize_.width = _contentSize.width;
	
	b2PolygonShape bodyBox_;
	b2Vec2 targetSize_ = b2Vec2Div(b2Vec2FromSize_PTM_RATIO(blockSize_), 2.0f);
	
	switch(b2bodyType_){
		case CMMSBlockObjectB2BodyType_bar:{
			switch(blockType_){
				case CMMBlockType_filledDown:
				case CMMBlockType_normal:{
					bodyBox_.SetAsBox(targetSize_.x, targetSize_.y, b2Vec2(0.0f,totalSizeVector_.y-targetSize_.y), 0);
					break;
				}
				case CMMBlockType_filledUp:
				case CMMBlockType_filledUpAndCeiling :{
					bodyBox_.SetAsBox(targetSize_.x, targetSize_.y, b2Vec2(0.0f,-totalSizeVector_.y+targetSize_.y), 0);
					break;
				}
				default: break;
			}
			break;
		}
		case CMMSBlockObjectB2BodyType_full:{
			b2Vec2 boxSize_ = b2Vec2FromSize_PTM_RATIO(CGSizeDiv(_contentSize, 2.0f));
			bodyBox_.SetAsBox(boxSize_.x,boxSize_.y);
			break;
		}
		default: break;
	}

	b2FixtureDef fixtureDef_;
	fixtureDef_.shape = &bodyBox_;
	fixtureDef_.density = physicalSpec_.density;
	fixtureDef_.friction = physicalSpec_.friction;
	fixtureDef_.restitution = physicalSpec_.restitution;
	
	body->CreateFixture(&fixtureDef_)->SetUserData(&blockItem->b2CMask);
}

@end

@implementation CMMStageBlockItem
@synthesize groundBlocks,backBlocks,b2CMask,blockType,blockPhysicalSpec,blockB2BodyType,blockObjectZOrder,blockSize,blockCountRange,pickupRatio,blockRandomizeRatio,drawEdge,layoutPatternTexture,layoutPatternBlendFunc,linkBlockItems;

+(id)blockItem{
	return [[[self alloc] init] autorelease];
}

-(id)init{
	if(!(self = [super init])) return self;
	
	groundBlocks = [[CCArray alloc] init];
	backBlocks = [[CCArray alloc] init];
	b2CMask = CMMb2ContactMask(); // must be redefine.
	blockType = CMMBlockType_normal;
	blockPhysicalSpec = CMMSBlockObjectPhysicalSpec(0.4f, 0.3f, 1.0f);
	blockB2BodyType = CMMSBlockObjectB2BodyType_full;
	blockObjectZOrder = 0;
	blockSize = CGSizeZero;
	pickupRatio = 1.0f;
	blockRandomizeRatio = 0.5f;
	blockCountRange = NSRangeMake(5, 15); // block count limit
	drawEdge = NO;
	_layoutPatternSprite = [[CCSprite alloc] init];
	
	[_layoutPatternSprite setIgnoreAnchorPointForPosition:NO];
	[_layoutPatternSprite setAnchorPoint:CGPointZero];
	layoutPatternBlendFunc = (ccBlendFunc){GL_DST_COLOR, GL_SRC_COLOR};
	
	linkBlockItems = [[CCArray alloc] init];
	
	return self;
}

-(void)setLayoutPatternTexture:(CCTexture2D *)layoutPatternTexture_{
	if(layoutPatternTexture == layoutPatternTexture_) return;
	[layoutPatternTexture release];
	layoutPatternTexture = [layoutPatternTexture_ retain];
	if(layoutPatternTexture){
		ccTexParams textureParameter_ = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_CLAMP_TO_EDGE};
		[layoutPatternTexture setTexParameters:&textureParameter_];
		
		[_layoutPatternSprite setTexture:layoutPatternTexture];
	}
}

-(CMMSBlockObject *)createBlockWithTargetHeight:(float)targetHeight_{
	NSAssert([groundBlocks count] > 0, @"[CMMStageBlockItem createBlock] : empty block");
	NSAssert2(blockCountRange.length>0,@"[CMMStageBlockItem createBlock] : blockRange : out of range %d,%d",blockCountRange.location,blockCountRange.length);
	
	uint drawBlockHCount_ = arc4random()%blockCountRange.length + blockCountRange.location;
	uint drawBlockVCount_ = 0;
	
	float targetWidth_ = blockSize.width*(float)drawBlockHCount_;
	
	drawBlockVCount_ = (uint)ceilf(targetHeight_ / blockSize.height);
	targetHeight_ = blockSize.height * drawBlockVCount_;
	
//	CCLOG(@"[CMMStageBlockItem createBlock] : try to create block, count H:%d,V:%d, size W:%1.1f,H:%1.1f",drawBlockHCount_,drawBlockVCount_,targetWidth_,targetHeight_);
	
	CCRenderTexture *blockRender_ = [CCRenderTexture renderTextureWithWidth:targetWidth_ height:targetHeight_];
	
	[blockRender_ begin];
	
	CCSprite *tempDrawSprite_ = [CCSprite node];
	[tempDrawSprite_ setIgnoreAnchorPointForPosition:NO];
	[tempDrawSprite_ setAnchorPoint:CGPointZero];
	
	//draw back
	ccArray *data_ = backBlocks->data;
	uint count_ = data_->num;
	
	BOOL isDrawEdge_ = (drawEdge && count_ > 2);
	uint fixValue_ = (isDrawEdge_ ? 2 : 0);
	uint convertCount_ = count_-fixValue_;
	
	switch(blockType){
		case CMMBlockType_filledDown:
		case CMMBlockType_filledUp:
		case CMMBlockType_filledUpAndCeiling :{
			if(count_ == 0){
				break;
			}
			
			CGPoint targetDrawPoint_;
			for(uint hIndex_=0;hIndex_<drawBlockHCount_;++hIndex_){
				targetDrawPoint_.x = ((float)hIndex_) * blockSize.width;
				for(uint vIndex_=0;vIndex_<drawBlockVCount_;++vIndex_){
					targetDrawPoint_.y = targetHeight_ - (((float)vIndex_) * blockSize.height);
					
					uint targetBlockIndex_ = fixValue_;
					if(((uint)((float)count_) * blockRandomizeRatio) < arc4random()%count_){
						targetBlockIndex_ = arc4random()%convertCount_+fixValue_;
					}
					
					if(isDrawEdge_ && hIndex_ == 0)
						targetBlockIndex_ = 0;
					
					if(isDrawEdge_ && hIndex_ == drawBlockHCount_-1)
						targetBlockIndex_ = 1;
					
					CCSpriteFrame *targetSpriteFrame_ = data_->arr[targetBlockIndex_];
					[tempDrawSprite_ setDisplayFrame:targetSpriteFrame_];
					[tempDrawSprite_ setScaleY:-1.0f];
					[tempDrawSprite_ setPosition:targetDrawPoint_];
					[tempDrawSprite_ visit];
				}
			}
		
			break;
		}
		default: break;
	}
	
	data_ = groundBlocks->data;
	count_ = data_->num;
	isDrawEdge_ = (drawEdge && count_ > 2);
	fixValue_ = (isDrawEdge_ ? 2 : 0);
	convertCount_ = count_-fixValue_;
	
	CGPoint targetDrawPoint_;
	switch(blockType){
		case CMMBlockType_filledDown:
		case CMMBlockType_normal:
			targetDrawPoint_.y = blockSize.height;
			break;
		case CMMBlockType_filledUp:
		case CMMBlockType_filledUpAndCeiling :
			targetDrawPoint_.y = targetHeight_;
			break;
		default: break;
	}
	
	for(uint hIndex_=0;hIndex_<drawBlockHCount_;++hIndex_){
		targetDrawPoint_.x = ((float)hIndex_) * blockSize.width;
		
		uint targetBlockIndex_ = fixValue_;
		if(((uint)((float)count_) * (1.0f-blockRandomizeRatio)) < arc4random()%count_){
			targetBlockIndex_ = arc4random()%convertCount_+fixValue_;
		}
		
		if(isDrawEdge_ && hIndex_ == 0)
			targetBlockIndex_ = 0;
		
		if(isDrawEdge_ && hIndex_ == drawBlockHCount_-1)
			targetBlockIndex_ = 1;
		
		CCSpriteFrame *targetSpriteFrame_ = data_->arr[targetBlockIndex_];
		[tempDrawSprite_ setDisplayFrame:targetSpriteFrame_];
		[tempDrawSprite_ setScaleY:-1.0f];
		[tempDrawSprite_ setPosition:targetDrawPoint_];
		[tempDrawSprite_ visit];
	}
	
#if COCOS2D_DEBUG >= 1
	glLineWidth(2.0f*CC_CONTENT_SCALE_FACTOR());
	ccDrawColor4B(150, 0, 0, 180);
	ccDrawRect(CGPointZero, ccp(targetWidth_,targetHeight_));
#endif
	
	if(layoutPatternTexture){
		[_layoutPatternSprite setBlendFunc:layoutPatternBlendFunc];
		[_layoutPatternSprite setTextureRect:CGRectMake(0.0f, 0.0f, targetWidth_, targetHeight_)];
		[_layoutPatternSprite visit];
		[_layoutPatternSprite setPosition:ccp(0.0f,0.0f)];
	}

	[blockRender_ end];
	
	CMMSBlockObject *blockObject_ = [CMMSBlockObject spriteWithTexture:[[blockRender_ sprite] texture]];
	[blockObject_ setBlockItem:self]; 
	[blockObject_ setZOrder:blockObjectZOrder];
	return blockObject_;
}

-(void)dealloc{
	[backBlocks release];
	[groundBlocks release];
	[_layoutPatternSprite release];
	[layoutPatternTexture release];
	[linkBlockItems release];
	[super dealloc];
}

@end

@implementation CMMStageBlockItem(GroundBlock)

-(void)addGroundBlock:(CCSpriteFrame *)spriteFrame_{
	if([self indexOfGroundBlock:spriteFrame_] != NSNotFound) return;
	[groundBlocks addObject:spriteFrame_];
	
	if([groundBlocks count] == 1){
		[self setBlockSize:[spriteFrame_ rect].size];
	}
}
-(void)addGroundBlockWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_{
	[self addGroundBlock:[CCSpriteFrame frameWithTexture:texture_ rect:rect_]];
}
-(void)addGroundBlockWithFile:(NSString *)spriteFrameFilePath_ spriteFrameFormatter:(NSString *)spriteFrameFormatter_{
	CCSpriteFrameCache *spriteFrameCache_ = [CCSpriteFrameCache sharedSpriteFrameCache];
	[spriteFrameCache_ addSpriteFramesWithFile:spriteFrameFilePath_];
	
	for(uint index_=0;;++index_){
		CCSpriteFrame *spriteFrame_ = [spriteFrameCache_ spriteFrameByName:[NSString stringWithFormat:spriteFrameFormatter_,index_]];
		if(!spriteFrame_) break;
		[self addGroundBlock:spriteFrame_];
	}
}

-(void)removeGroundBlock:(CCSpriteFrame *)spriteFrame_{
	uint index_ = [self indexOfGroundBlock:spriteFrame_];
	if(index_ == NSNotFound) return;
	[groundBlocks removeObjectAtIndex:index_];
}
-(void)removeGroundBlockAtIndex:(uint)index_{
	[self removeGroundBlock:[self groundBlockAtIndex:index_]];
}

-(CCSpriteFrame *)groundBlockAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [groundBlocks objectAtIndex:index_];
}

-(uint)indexOfGroundBlock:(CCSpriteFrame *)spriteFrame_{
	return [groundBlocks indexOfObject:spriteFrame_];
}

@end

@implementation CMMStageBlockItem(BackBlock)

-(void)addBackBlock:(CCSpriteFrame *)spriteFrame_{
	if([self indexOfBackBlock:spriteFrame_] != NSNotFound) return;
	[backBlocks addObject:spriteFrame_];
}
-(void)addBackBlockWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_{
	[self addBackBlock:[CCSpriteFrame frameWithTexture:texture_ rect:rect_]];
}
-(void)addBackBlockWithFile:(NSString *)spriteFrameFilePath_ spriteFrameFormatter:(NSString *)spriteFrameFormatter_{
	CCSpriteFrameCache *spriteFrameCache_ = [CCSpriteFrameCache sharedSpriteFrameCache];
	[spriteFrameCache_ addSpriteFramesWithFile:spriteFrameFilePath_];
	
	for(uint index_=0;;++index_){
		CCSpriteFrame *spriteFrame_ = [spriteFrameCache_ spriteFrameByName:[NSString stringWithFormat:spriteFrameFormatter_,index_]];
		if(!spriteFrame_) break;
		[self addBackBlock:spriteFrame_];
	}
}

-(void)removeBackBlock:(CCSpriteFrame *)spriteFrame_{
	uint index_ = [self indexOfBackBlock:spriteFrame_];
	if(index_ == NSNotFound) return;
	[backBlocks removeObjectAtIndex:index_];
}
-(void)removeBackBlockAtIndex:(uint)index_{
	[self removeBackBlock:[self backBlockAtIndex:index_]];
}

-(CCSpriteFrame *)backBlockAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [backBlocks objectAtIndex:index_];
}

-(uint)indexOfBackBlock:(CCSpriteFrame *)spriteFrame_{
	return [backBlocks indexOfObject:spriteFrame_];
}

@end

@implementation CMMStageBlockItem(Link)

-(void)addLinkBlockItem:(CMMStageBlockItem *)blockItem_{
	if([self indexOfLinkBlockItem:blockItem_] != NSNotFound) return;
	[linkBlockItems addObject:blockItem_];
}

-(void)removeLinkBlockItem:(CMMStageBlockItem *)blockItem_{
	uint index_ = [self indexOfLinkBlockItem:blockItem_];
	if(index_ == NSNotFound) return;
	[linkBlockItems removeObjectAtIndex:index_];
}
-(void)removeLinkBlockItemAtIndex:(uint)index_{
	[self removeLinkBlockItem:[self linkBlockItemAtIndex:index_]];
}

-(CMMStageBlockItem *)linkBlockItemAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [linkBlockItems objectAtIndex:index_];
}
-(uint)indexOfLinkBlockItem:(CMMStageBlockItem *)blockItem_{
	return [linkBlockItems indexOfObject:blockItem_];
}

@end

@interface CMMStageBlock(Private)

-(CMMStageBlockItem *)pickupBlockItem;

@end

@implementation CMMStageBlock(Private)

-(CMMStageBlockItem *)pickupBlockItem{
	ccArray *data_ = itemList->data;
	uint count_ = data_->num;
	
	if(count_ == 0){
		return nil;
	}
	if(count_ == 1 || arc4random()%count_ < (uint)((float)count_)*(1.0f-blockRandomizeRatio)){
		return data_->arr[0];
	}
	
	CMMStageBlockItem *maxBlockItem_ = data_->arr[0];
	float pickupMaxScore_ = 0.0f;
	for(uint index_=0;index_<count_;++index_){
		CMMStageBlockItem *blockItem_ = data_->arr[index_];
		float pickupScore_ = ((float)count_) * [blockItem_ pickupRatio] * CCRANDOM_0_1();
		if(pickupMaxScore_ < pickupScore_){
			maxBlockItem_ = blockItem_;
			pickupMaxScore_ = pickupScore_;
		}
	}
	
	return maxBlockItem_;
}

@end

@implementation CMMStageBlock
@synthesize itemList,count,blockRandomizeRatio;

+(id)blockWithStage:(CMMStageDNB *)stage_{
	return [[[self alloc] initWithStage:stage_] autorelease];
}
-(id)initWithStage:(CMMStageDNB *)stage_{
	if(!(self = [super init])) return self;
	
	stage = stage_;
	itemList = [[CCArray alloc] init];
	blockRandomizeRatio = 0.5f;
	
	return self;
}

-(uint)count{
	return [itemList count];
}

-(void)update:(ccTime)dt_{}

-(void)dealloc{
	[itemList release];
	[super dealloc];
}

@end

@implementation CMMStageBlock(Common)

-(void)addBlockItem:(CMMStageBlockItem *)blockItem_{
	if([self indexOfBlockItem:blockItem_] != NSNotFound) return;
	[itemList addObject:blockItem_];
}

-(void)removeBlockItem:(CMMStageBlockItem *)blockItem_{
	uint index_ = [self indexOfBlockItem:blockItem_];
	if(index_ == NSNotFound) return;
	[itemList removeObjectAtIndex:index_];
}
-(void)removeBlockItemAtIndex:(uint)index_{
	[self removeBlockItem:[self blockItemAtIndex:index_]];
}

-(CMMStageBlockItem *)blockItemAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [itemList objectAtIndex:index_];
}

-(uint)indexOfBlockItem:(CMMStageBlockItem *)blockItem_{
	return [itemList indexOfObject:blockItem_];
}

@end

@implementation CMMStageDNB
@synthesize block,marginPerBlock,blockHeightRange,maxHeightDifferencePerBlock,worldVelocityX,removeObjectOnOutside;
@synthesize callback_whenContactBeganWithObject,callback_whenContactEndedWithObject;

-(id)initWithStageDef:(CMMStageDef)stageDef_{
	
	stageDef_.worldSize = stageDef_.stageSize;
	if(!(self = [super initWithStageDef:stageDef_])) return self;
	
	block = [[CMMStageBlock alloc] initWithStage:self];
	
	marginPerBlock = CMMFloatRange(50.0f, 100.0f);
	blockHeightRange = CMMFloatRange(0.0f, 100.0f);
	maxHeightDifferencePerBlock = 100.0f;
	worldVelocityX = 0.0f;
	removeObjectOnOutside = YES;
	
	_addedWorldPointX = 0.0f;
	_lastCreatePoint = CGPointZero;
	_curMarginPerBlock = -1.0f;
	
	_lazyTargetBlockItems = [[CCArray alloc] init];
	
	return self;
}

-(void)setWorldVelocityX:(float)worldVelocityX_{
	worldVelocityX = ABS(worldVelocityX_);
}

-(void)step:(ccTime)dt_{
	if(_curMarginPerBlock < marginPerBlock.loc){
		_curMarginPerBlock = marginPerBlock.RandomValue();
	}
	
	if(worldVelocityX > 0.0f){
		float worldAddPoint_ = worldVelocityX * dt_;
		_addedWorldPointX += worldAddPoint_;
		
		if(backgroundNode){
			CGPoint backgroundWorldPoint_ = [backgroundNode worldPoint];
			backgroundWorldPoint_.x += worldAddPoint_;
			[backgroundNode setWorldPoint:backgroundWorldPoint_];
		}
		
		CGPoint convertedZeroPoint_ = [self convertToWorldSpace:CGPointZero];
		CGPoint fixedWorldPoint_ = [world convertToNodeSpace:convertedZeroPoint_];
		
		//moving & culling objects.
		ccArray *data_ = [world object_list]->data;
		for(int index_=data_->num-1;index_>=0;--index_){
			CMMSObject *object_ = data_->arr[index_];
			
			if(removeObjectOnOutside || [object_ isKindOfClass:[CMMSBlockObject class]]){
				CGRect objectRect_ = [object_ boundingBox];
				if(objectRect_.origin.x + objectRect_.size.width < fixedWorldPoint_.x){
					[world removeObject:object_];
					continue;
				}
			}
			
			b2Body *objectBody_ = [object_ body];
			if(!objectBody_) continue;
			b2Vec2 objectBodyPoint_ = objectBody_->GetPosition();
			objectBody_->SetTransform(b2Vec2(objectBodyPoint_.x-(worldAddPoint_/PTM_RATIO), objectBodyPoint_.y), 0.0f);
		}
		
		float curWorldPointX_ = _lastCreatePoint.x - _addedWorldPointX;
		BOOL isLazyDraw_ = _lazyTargetBlockItems->data->num > 0;
		if(curWorldPointX_ < _contentSize.width || isLazyDraw_){
			CMMStageBlockItem *mainBlockItem_ = nil;
			
			if(isLazyDraw_){
				mainBlockItem_ = [[[_lazyTargetBlockItems objectAtIndex:0] retain] autorelease];
				[_lazyTargetBlockItems removeObjectAtIndex:0];
			}else{
				mainBlockItem_ = [block pickupBlockItem];
				[_lazyTargetBlockItems addObjectsFromArray:[mainBlockItem_ linkBlockItems]];
			}
			
			isLazyDraw_ = _lazyTargetBlockItems->data->num > 0;

			CGPoint objectCreateZeroPoint_ = ccp(curWorldPointX_,0.0f);
			float orgBlockHeight_ = blockHeightRange.RandomValue();
			float targetBlockHeight_ = orgBlockHeight_;
			
			//normalize block height
			float blockHeightDiff_ = _lastCreatePoint.y - orgBlockHeight_;
			if(maxHeightDifferencePerBlock < ABS(blockHeightDiff_)){
				float fixValue_ = ABS(blockHeightDiff_) - maxHeightDifferencePerBlock;
				orgBlockHeight_ += (blockHeightDiff_>0.0f?fixValue_:-fixValue_);
			}
			
			float objectPointYOffset_ = orgBlockHeight_/2.0f;
			switch([mainBlockItem_ blockType]){
				case CMMBlockType_filledDown:
				case CMMBlockType_normal:
					targetBlockHeight_ = orgBlockHeight_;
					break;
				case CMMBlockType_filledUp:
					targetBlockHeight_ = _contentSize.height - orgBlockHeight_;
					objectPointYOffset_ = _contentSize.height - targetBlockHeight_/2.0f;
					break;
				case CMMBlockType_filledUpAndCeiling :
					objectPointYOffset_ = _contentSize.height - targetBlockHeight_/2.0f;
					break;
				default: break;
			}
			
			CMMSBlockObject *blockObject_ = [mainBlockItem_ createBlockWithTargetHeight:targetBlockHeight_];
			
			CGSize objectSize_ = [blockObject_ contentSize];
			
			[blockObject_ setPosition:ccpAdd([world convertToNodeSpace:objectCreateZeroPoint_], ccp(objectSize_.width/2.0f,objectPointYOffset_))];
			[world addObject:blockObject_];
			
			_addedWorldPointX = 0.0f;
			_lastCreatePoint = ccp(objectCreateZeroPoint_.x+objectSize_.width+(isLazyDraw_?0.0f:_curMarginPerBlock),orgBlockHeight_);
			_curMarginPerBlock = marginPerBlock.loc-1.0f;
		}
	}
	
	[super step:dt_];
	[block update:dt_];
}

-(CMMStageDNBDirection)_getWorldDirectionAtFixture:(CMMb2FixtureType)fixtureType_{
	CMMStageDNBDirection contactDirection_ = CMMStageDNBDirection_none;
	if(fixtureType_ == [world b2CMask_bottom].fixtureType){
		contactDirection_ = CMMStageDNBDirection_bottom;
	}else if(fixtureType_ == [world b2CMask_top].fixtureType){
		contactDirection_ = CMMStageDNBDirection_top;
	}else if(fixtureType_ == [world b2CMask_left].fixtureType){
		contactDirection_ = CMMStageDNBDirection_left;
	}else if(fixtureType_ == [world b2CMask_right].fixtureType){
		contactDirection_ = CMMStageDNBDirection_right;
	}
	return contactDirection_;
}

-(void)whenContactBeganWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{
	if(![otherObject_ isKindOfClass:[CMMSObject class]]) return;
	
	if(callback_whenContactBeganWithObject){
		CMMStageDNBDirection contactDirection_ = [self _getWorldDirectionAtFixture:fixtureType_];
		if(contactDirection_ == CMMStageDNBDirection_none) return;
		callback_whenContactBeganWithObject((CMMSObject *)otherObject_,contactDirection_);
	}
}

-(void)whenContactEndedWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_{
	if(![otherObject_ isKindOfClass:[CMMSObject class]]) return;
	
	if(callback_whenContactEndedWithObject){
		CMMStageDNBDirection contactDirection_ = [self _getWorldDirectionAtFixture:fixtureType_];
		if(contactDirection_ == CMMStageDNBDirection_none) return;
		callback_whenContactEndedWithObject((CMMSObject *)otherObject_,contactDirection_);
	}
}

-(void)cleanup{
	[self setCallback_whenContactBeganWithObject:nil];
	[self setCallback_whenContactEndedWithObject:nil];
	[super cleanup];
}
-(void)dealloc{
	[callback_whenContactBeganWithObject release];
	[callback_whenContactEndedWithObject release];
	[block release];
	[_lazyTargetBlockItems release];
	[super dealloc];
}

@end
