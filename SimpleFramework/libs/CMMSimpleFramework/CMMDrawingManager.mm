//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingManager.h"
#import "CMMStringUtil.h"
#import "CMMDrawingUtil.h"
#import "CMMFileUtil.h"
#import "CMMSpriteBatchBar.h"

#define cmmVarCMMDrawingManagerItem_makeKey(_key_) [NSString stringWithFormat:@"%d",(_key_)]

static CMMDrawingManager *_sharedDrawingManager_ = nil;
static CMMSpriteBatchBar *_cachedCMMSpriteBatchBar_ = nil;

@implementation CMMDrawingManagerItem
@synthesize batchBarFrames,countOfBatchBar;

+(id)drawingItem{
	return [[[self alloc] init] autorelease];
}

-(id)init{
	if(!(self = [super init])) return self;
	
	_otherFrames = [[NSMutableDictionary alloc] init];
	batchBarFrames = [[CCArray alloc] init];
	
	return self;
}

-(uint)countOfBatchBar{
	return [batchBarFrames count];
}

-(void)addBatchBarFrame:(CCSpriteFrame *)spriteFrame_{
	if([self indexOfBatchBarFrame:spriteFrame_] != NSNotFound) return;
	[batchBarFrames addObject:spriteFrame_];
}

-(void)removeBatchBarFrame:(CCSpriteFrame *)spriteFrame_{
	uint index_ = [self indexOfBatchBarFrame:spriteFrame_];
	if(index_ == NSNotFound) return;
	[batchBarFrames removeObjectAtIndex:index_];
}
-(void)removeBatchBarFrameAtIndex:(uint)index_{
	[self removeBatchBarFrame:[self batchBarFrameAtIndex:index_]];
}
-(void)removeAllBatchBarFrames{
	ccArray *data_ = batchBarFrames->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CCSpriteFrame *spriteFrame_ = data_->arr[index_];
		[self removeBatchBarFrame:spriteFrame_];
	}
}

-(CCSpriteFrame *)batchBarFrameAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [batchBarFrames objectAtIndex:index_];
}

-(uint)indexOfBatchBarFrame:(CCSpriteFrame *)spriteFrame_{
	return [batchBarFrames indexOfObject:spriteFrame_];
}

-(void)dealloc{
	[_otherFrames release];
	[batchBarFrames release];
	[super dealloc];
}

@end

@implementation CMMDrawingManagerItem(Other)

-(void)setSpriteFrame:(CCSpriteFrame *)spriteFrame_ forKey:(CMMDrawingManagerItemKey)key_{
	if(!spriteFrame_) return;
	[_otherFrames setObject:spriteFrame_ forKey:cmmVarCMMDrawingManagerItem_makeKey(key_)];
}
-(CCSpriteFrame *)spriteFrameForKey:(CMMDrawingManagerItemKey)key_{
	return [_otherFrames objectForKey:cmmVarCMMDrawingManagerItem_makeKey(key_)];
}

@end

@implementation CMMDrawingManager
@synthesize frameList;

+(CMMDrawingManager *)sharedManager{
	if(!_sharedDrawingManager_){
		_sharedDrawingManager_ = [[CMMDrawingManager alloc] init];
	}
	
	return _sharedDrawingManager_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	frameList = [[CCArray alloc] init];
	cachedFrameTextures = [[NSMutableDictionary alloc] init];
	
	//load frame list;
	CCSpriteFrameCache *spriteFrameCache_ = [CCSpriteFrameCache sharedSpriteFrameCache];
	NSString *frameFormatter_ = @"IMG_CMN_BFRAME_%03d";
	int curFrameSeq_ = 0;
	while(YES){
		NSString *frameFileName_ = [NSString stringWithFormat:frameFormatter_,curFrameSeq_];
		NSString *frameFilePath_ = [CMMStringUtil stringPathOfResoruce:frameFileName_ extension:@"plist"];
		
		if([CMMFileUtil isExistWithFilePath:frameFilePath_]){
			[spriteFrameCache_ addSpriteFramesWithFile:frameFilePath_];
			CMMDrawingManagerItem *drawItem_ = [CMMDrawingManagerItem drawingItem];
			
			//add default bar frame
			NSString *barFrameFormatter_ = [frameFileName_ stringByAppendingString:@"_BATCHBAR_%02d.png"];
			uint curBarFrameSeq_ = 0;
			while(YES){
				CCSpriteFrame *barFrame_ = [spriteFrameCache_ spriteFrameByName:[NSString stringWithFormat:barFrameFormatter_,curBarFrameSeq_]];
				if(!barFrame_) break;
				
				[drawItem_ addBatchBarFrame:barFrame_];
				++curBarFrameSeq_;
			}
			
			//add control frame - switch
			NSString *switchFrameName_ = [frameFileName_ stringByAppendingString:@"_SWITCH"];
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[switchFrameName_ stringByAppendingString:@"_BTN.png"]] forKey:CMMDrawingManagerItemKey_switch_button];
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[switchFrameName_ stringByAppendingString:@"_BACK.png"]] forKey:CMMDrawingManagerItemKey_switch_back];
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[switchFrameName_ stringByAppendingString:@"_MASK.png"]] forKey:CMMDrawingManagerItemKey_switch_mask];
			
			//add control frame - slider
			NSString *sliderFrameName_ = [frameFileName_ stringByAppendingString:@"_SLIDE"];
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[sliderFrameName_ stringByAppendingString:@"_BAR.png"]] forKey:CMMDrawingManagerItemKey_slider_bar];
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[sliderFrameName_ stringByAppendingString:@"_BTN.png"]] forKey:CMMDrawingManagerItemKey_slider_button];
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[sliderFrameName_ stringByAppendingString:@"_BACK_L.png"]] forKey:CMMDrawingManagerItemKey_slider_backLeft];
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[sliderFrameName_ stringByAppendingString:@"_BACK_R.png"]] forKey:CMMDrawingManagerItemKey_slider_backRight];
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[sliderFrameName_ stringByAppendingString:@"_MASK.png"]] forKey:CMMDrawingManagerItemKey_slider_mask];
			
			//add control frame - text
			NSString *textFrameName_ = [frameFileName_ stringByAppendingString:@"_TEXT"];
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[textFrameName_ stringByAppendingString:@"_BAR.png"]] forKey:CMMDrawingManagerItemKey_text_bar];
			
			[frameList addObject:drawItem_];
			curFrameSeq_++;
		}else break;
	}
	
	return self;
}

-(CMMDrawingManagerItem *)drawingItemAtIndex:(int)index_{
	if(index_ == NSNotFound || index_>=frameList.count) return nil;
	return [frameList objectAtIndex:index_];
}

-(void)dealloc{
	[cachedFrameTextures release];
	[frameList release];
	[super dealloc];
}

@end

@implementation CMMDrawingManager(CachedTexture)

-(CCTexture2D *)textureBatchBarWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ size:(CGSize)size_{
	NSString *keyName_ = [NSString stringWithFormat:@"batchBar fseq:%d_bseq:%d_w:%1.1f_h:%1.1f",frameSeq_,batchBarSeq_,size_.width,size_.height];
	CCTexture2D *texture_ = [cachedFrameTextures objectForKey:keyName_];
	
	if(!texture_){
		CMMDrawingManagerItem *drawingItem_ = [self drawingItemAtIndex:frameSeq_];
		if(!drawingItem_) return nil;
		
		CCSpriteFrame *batchBarSpriteFrame_ = [drawingItem_ batchBarFrameAtIndex:batchBarSeq_];
		if(!batchBarSpriteFrame_) return nil;
		
		CCSprite *batchBarSprite_ = [CCSprite spriteWithSpriteFrame:batchBarSpriteFrame_];
		
		if(!_cachedCMMSpriteBatchBar_){
			_cachedCMMSpriteBatchBar_ = [[CMMSpriteBatchBar alloc] initWithTargetSprite:batchBarSprite_ batchBarSize:size_];
		}
		
		[_cachedCMMSpriteBatchBar_ setTargetSprite:batchBarSprite_];
		[_cachedCMMSpriteBatchBar_ setContentSize:size_];
		
		CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:(uint)size_.width height:(uint)size_.height];
		[render_ begin];
		
		[render_ addChild:_cachedCMMSpriteBatchBar_];
		[_cachedCMMSpriteBatchBar_ setScaleY:-1];
		[_cachedCMMSpriteBatchBar_ setPosition:ccp(0,size_.height)];
		[_cachedCMMSpriteBatchBar_ visit];
		[render_ removeChild:_cachedCMMSpriteBatchBar_ cleanup:YES];
		
		[render_ end];
		texture_ = [[render_ sprite] texture];
		[cachedFrameTextures setObject:texture_ forKey:keyName_];
	}
	
	return texture_;
}

@end
