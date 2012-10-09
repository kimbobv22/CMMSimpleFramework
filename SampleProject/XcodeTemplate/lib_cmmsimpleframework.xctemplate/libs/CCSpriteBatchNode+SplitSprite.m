#import "CCSpriteBatchNode+SplitSprite.h"

@implementation CCSpriteBatchNode(SplitSprite)

-(CCSprite *)addSplitSpriteToRect:(CGRect)rect_ blendFunc:(ccBlendFunc)tBlendFunc_{
	CCTexture2D *tTexture_ = textureAtlas_.texture;
	CGSize textureSize_ = tTexture_.contentSize;
	
	CCSprite *backSprite_ = [CCSprite spriteWithTexture:tTexture_ rect:rect_];

	[backSprite_ setBatchNode:self];
	[backSprite_ setBlendFunc:tBlendFunc_];
	[backSprite_.texture setAliasTexParameters];
	backSprite_.anchorPoint = ccp(0,0);
	backSprite_.position = ccp(rect_.origin.x,textureSize_.height-rect_.origin.y-rect_.size.height);
	[self addChild:backSprite_];
	return backSprite_;
}

-(void)addSplitSprite:(CGSize)splitUnit_ blendFunc:(ccBlendFunc)tBlendFunc_{
	CCTexture2D *tTexture_ = textureAtlas_.texture;
	if(!tTexture_) return;
	[tTexture_ setAliasTexParameters];
	
	CGSize backGroundSize_ = tTexture_.contentSize;
	
	float backSliceUnitCol_ = MIN(splitUnit_.width,backGroundSize_.width);
	float backSliceUnitRow_ = MIN(splitUnit_.height,backGroundSize_.height);
	
	uint backCellCountCol_ = floor(backGroundSize_.width/backSliceUnitCol_);
	uint backCellCountRow_ = floor(backGroundSize_.height/backSliceUnitRow_);
	
	float backRemainderCol_ = backGroundSize_.width - (backSliceUnitCol_*(float)backCellCountCol_);
	float backRemainderRow_ = backGroundSize_.height - (backSliceUnitRow_*(float)backCellCountRow_);
	
	//main back;
	for(unsigned int colIndex_ = 0; colIndex_<backCellCountCol_; colIndex_++){
		CGRect targetRect_;
		
		CGPoint targetPoint_ = {colIndex_*backSliceUnitCol_,0};
		CGSize targetSize_ =  {backSliceUnitCol_,0};
		
		for(unsigned int rowIndex_ = 0; rowIndex_<backCellCountRow_; rowIndex_++){
			targetPoint_.y = rowIndex_*backSliceUnitRow_;
			targetSize_.height = backSliceUnitRow_;
			
			targetRect_.origin = targetPoint_;
			targetRect_.size = targetSize_;
			
			[self addSplitSpriteToRect:targetRect_ blendFunc:tBlendFunc_];
		}
	}
	
	//remainder - row
	for(uint colIndex_ = 0; colIndex_<backCellCountCol_ && backRemainderRow_>0; colIndex_++){
		CGRect targetRect_;
		
		CGPoint targetPoint_ = {colIndex_*backSliceUnitCol_,0};
		CGSize targetSize_ =  {backSliceUnitCol_,0};
		
		targetPoint_.y = backGroundSize_.height-backRemainderRow_;
		targetSize_.height = backRemainderRow_;
		
		targetRect_.origin = targetPoint_;
		targetRect_.size = targetSize_;
		
		[self addSplitSpriteToRect:targetRect_ blendFunc:tBlendFunc_];
	}
	
	//remainder - col
	for(uint rowIndex_ = 0; rowIndex_<backCellCountRow_ && backRemainderCol_>0; rowIndex_++){
		CGRect targetRect_;
		
		CGPoint targetPoint_ = {0,rowIndex_*backSliceUnitRow_};
		CGSize targetSize_ =  {0,backSliceUnitRow_};
		
		targetPoint_.x = backGroundSize_.width-backRemainderCol_;
		targetSize_.width = backRemainderCol_;
		
		targetRect_.origin = targetPoint_;
		targetRect_.size = targetSize_;
		
		[self addSplitSpriteToRect:targetRect_ blendFunc:tBlendFunc_];
	}
	
	CGRect remainderRect_ = CGRectZero;
	remainderRect_.origin = ccp(backGroundSize_.width-backSliceUnitCol_,backGroundSize_.height-backSliceUnitRow_);
	remainderRect_.size = CGSizeMake(backSliceUnitCol_, backSliceUnitRow_);
	[self addSplitSpriteToRect:remainderRect_ blendFunc:tBlendFunc_];
}
-(void)addSplitSprite:(CGSize)splitUnit_{
	[self addSplitSprite:splitUnit_ blendFunc:(ccBlendFunc){CC_BLEND_SRC,CC_BLEND_DST}];
}

@end
