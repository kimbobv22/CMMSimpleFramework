//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingManager.h"
#import "CMMStringUtil.h"
#import "CMMDrawingUtil.h"
#import "CMMFileUtil.h"
#import "CMM9SliceBar.h"

#define cmmVarCMMDrawingManagerItem_makeKey(_key_) [NSString stringWithFormat:@"%d",(_key_)]

static CMMDrawingManager *_sharedDrawingManager_ = nil;
static CMM9SliceBar *_cachedCMMSpriteBatchBar_ = nil;

@implementation CMMDrawingManagerItem
@synthesize fileName,batchBarFrames,countOfBatchBar;

+(id)drawingItemWithFileName:(NSString *)fileName_{
	return [[[self alloc] initWithFileName:fileName_] autorelease];
}

-(id)init{
	[self release];
	return nil;
}

-(id)initWithFileName:(NSString *)fileName_{
	if(!(self = [super init])) return self;
	
	_otherFrames = [[NSMutableDictionary alloc] init];
	batchBarFrames = [[CCArray alloc] init];
	
	if(!fileName_){
		[self release];
		return nil;
	}
	
	CCSpriteFrameCache *spriteFrameCache_ = [CCSpriteFrameCache sharedSpriteFrameCache];
	fileName = [fileName_ copy];
	
	NSString *lastFileName_ = [fileName lastPathComponent];
	
	//add default bar frame
	NSString *barFrameFormatter_ = [lastFileName_ stringByAppendingString:@"_BATCHBAR_%02d.png"];
	uint curBarFrameSeq_ = 0;
	while(YES){
		CCSpriteFrame *barFrame_ = [spriteFrameCache_ spriteFrameByName:[NSString stringWithFormat:barFrameFormatter_,curBarFrameSeq_]];
		if(!barFrame_) break;
		
		[self addBatchBarFrame:barFrame_];
		++curBarFrameSeq_;
	}
	
	//add control frame - switch
	NSString *switchFrameName_ = [lastFileName_ stringByAppendingString:@"_SWITCH"];
	[self setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[switchFrameName_ stringByAppendingString:@"_BTN.png"]] forKey:CMMDrawingManagerItemKey_switch_button];
	[self setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[switchFrameName_ stringByAppendingString:@"_BACK.png"]] forKey:CMMDrawingManagerItemKey_switch_back];
	[self setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[switchFrameName_ stringByAppendingString:@"_MASK.png"]] forKey:CMMDrawingManagerItemKey_switch_mask];
	
	//add control frame - slider
	NSString *sliderFrameName_ = [lastFileName_ stringByAppendingString:@"_SLIDE"];
	[self setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[sliderFrameName_ stringByAppendingString:@"_BAR.png"]] forKey:CMMDrawingManagerItemKey_slider_bar];
	[self setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[sliderFrameName_ stringByAppendingString:@"_BTN.png"]] forKey:CMMDrawingManagerItemKey_slider_button];
	[self setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[sliderFrameName_ stringByAppendingString:@"_MASK.png"]] forKey:CMMDrawingManagerItemKey_slider_mask];
	
	//add control frame - text
	NSString *textFrameName_ = [lastFileName_ stringByAppendingString:@"_TEXT"];
	[self setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[textFrameName_ stringByAppendingString:@"_BAR.png"]] forKey:CMMDrawingManagerItemKey_text_bar];
	
	//add control frame - checkbox
	NSString *checkboxFrameName_ = [lastFileName_ stringByAppendingString:@"_CHECKBOX"];
	[self setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[checkboxFrameName_ stringByAppendingString:@"_BACK.png"]] forKey:CMMDrawingManagerItemKey_checkbox_back];
	[self setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[checkboxFrameName_ stringByAppendingString:@"_CHECK.png"]] forKey:CMMDrawingManagerItemKey_checkbox_check];
	
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
	[fileName release];
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
@synthesize frameList,count;

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
		
	return self;
}

-(uint)count{
	return [frameList count];
}

-(void)addDrawingItem:(CMMDrawingManagerItem *)drawingItem_{
	[frameList addObject:drawingItem_];
}
-(CMMDrawingManagerItem *)addDrawingItemWithFileName:(NSString *)fileName_{
	NSString *fixedFileName_ = [[fileName_ stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];
	NSString *frameFilePath_ = [CMMStringUtil stringPathOfResoruce:fixedFileName_ extension:nil];
	
	if(![CMMFileUtil isExistWithFilePath:frameFilePath_]){
		NSAssert(NO, @"CMMDrawingManager : addDrawingItemWithFileName -> file not exists.");
		return nil;
	}
	
	if([self indexOfDrawingItemWithFileName:fileName_] != NSNotFound){
		return nil;
	}
	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fixedFileName_]; //only for resoruce
	CMMDrawingManagerItem *drawingItem_ = [CMMDrawingManagerItem drawingItemWithFileName:fileName_];
	[self addDrawingItem:drawingItem_];
	return drawingItem_;
}

-(CMMDrawingManagerItem *)drawingItemAtIndex:(uint)index_{
	if(index_ == NSNotFound || [self count] <= index_) return nil;
	return [frameList objectAtIndex:index_];
}
-(CMMDrawingManagerItem *)drawingItemAtFileName:(NSString *)fileName_{
	return [self drawingItemAtIndex:[self indexOfDrawingItemWithFileName:fileName_]];
}

-(void)removeDrawingItem:(CMMDrawingManagerItem *)drawingItem_{
	uint index_ = [self indexOfDrawingItem:drawingItem_];
	if(index_ == NSNotFound) return;
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:[[drawingItem_ fileName] stringByAppendingPathExtension:@"plist"]];
	[frameList removeObjectAtIndex:index_];
}
-(void)removeDrawingItemAtIndex:(uint)index_{
	[self removeDrawingItem:[self drawingItemAtIndex:index_]];
}
-(void)removeDrawingItemAtFileName:(NSString *)fileName_{
	[self removeDrawingItem:[self drawingItemAtFileName:fileName_]];
}
-(void)removeAllDrawingItems{
	ccArray *data_ = frameList->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMDrawingManagerItem *drawingItem_ = data_->arr[index_];
		[self removeDrawingItem:drawingItem_];
	}
}

-(uint)indexOfDrawingItem:(CMMDrawingManagerItem *)drawingItem_{
	return [frameList indexOfObject:drawingItem_];
}
-(uint)indexOfDrawingItemWithFileName:(NSString *)fileName_{
	ccArray *data_ = frameList->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMDrawingManagerItem *drawingItem_ = data_->arr[index_];
		if([[drawingItem_ fileName] isEqualToString:fileName_]){
			return index_;
		}
	}
	return NSNotFound;
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
			_cachedCMMSpriteBatchBar_ = [[CMM9SliceBar alloc] initWithTargetSprite:batchBarSprite_];
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
