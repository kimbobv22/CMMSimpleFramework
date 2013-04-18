//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingManager.h"
#import "CMMStringUtil.h"
#import "CMMDrawingUtil.h"
#import "CMMFileUtil.h"
#import "CMM9SliceBar.h"

NSString *const CMMDrawingManagerItemFormatter_BatchBar = @"%@_BATCHBAR_%02d.png";
NSString *const CMMDrawingManagerItemFormatter_SwitchButton = @"%@_SWITCH_BTN.png";
NSString *const CMMDrawingManagerItemFormatter_SwitchMask = @"%@_SWITCH_MASK.png";
NSString *const CMMDrawingManagerItemFormatter_SlideBar = @"%@_SLIDE_BAR.png";
NSString *const CMMDrawingManagerItemFormatter_SlideButton = @"%@_SLIDE_BTN.png";
NSString *const CMMDrawingManagerItemFormatter_SlideMask = @"%@_SLIDE_MASK.png";
NSString *const CMMDrawingManagerItemFormatter_TextBar = @"%@_TEXT_BAR.png";
NSString *const CMMDrawingManagerItemFormatter_CheckboxBack = @"%@_CHECKBOX_BACK.png";
NSString *const CMMDrawingManagerItemFormatter_CheckboxCheck = @"%@_CHECKBOX_CHECK.png";
NSString *const CMMDrawingManagerItemFormatter_ComboFrame = @"%@_COMBO_FRAME.png";
NSString *const CMMDrawingManagerItemFormatter_ComboBack = @"%@_COMBO_BACK.png";
NSString *const CMMDrawingManagerItemFormatter_ComboCursor = @"%@_COMBO_CURSOR.png";

static CMMDrawingManager *_sharedDrawingManager_ = nil;
static CMM9SliceBar *_cachedCMMSpriteBatchBar_ = nil;

@interface CMMDrawingManagerItemOtherFrames(Private)

-(void)_setSpriteFrame:(CCSpriteFrame *)frame_ keyFormatter:(NSString *)keyFormatter_;

@end

@implementation CMMDrawingManagerItemOtherFrames{
	NSString *_fileName;
	NSMutableDictionary *_spriteFrames;
}
@synthesize spriteFrames;

+(id)otherFramesWithFileName:(NSString *)fileName_{
	return [[[self alloc] initWithFileName:fileName_] autorelease];
}
-(id)initWithFileName:(NSString *)fileName_{
	if(!(self = [super init])) return self;
	
	_fileName = [fileName_ copy];
	_spriteFrames = [[NSMutableDictionary alloc] init];
	
	return self;
}

-(NSDictionary *)spriteFrames{
	return [NSDictionary dictionaryWithDictionary:_spriteFrames];
}

-(void)setSpriteFrame:(CCSpriteFrame *)frame_ forKey:(NSString *)key_{
	[_spriteFrames setObject:frame_ forKey:key_];
}
-(void)removeSpriteFrameForKey:(NSString *)key_{
	[_spriteFrames removeObjectForKey:key_];
}

-(CCSpriteFrame *)spriteFrameForKey:(NSString *)key_{
	return [_spriteFrames objectForKey:key_];
}
-(CCSpriteFrame *)spriteFrameForKeyFormatter:(NSString *)keyFormatter_{
	return [self spriteFrameForKey:[[NSFileManager defaultManager] displayNameAtPath:[NSString stringWithFormat:keyFormatter_,_fileName]]];
}

-(void)dealloc{
	[_fileName release];
	[_spriteFrames release];
	[super dealloc];
}

@end

@implementation CMMDrawingManagerItemOtherFrames(Private)

-(void)_setSpriteFrame:(CCSpriteFrame *)frame_ keyFormatter:(NSString *)keyFormatter_{
	[self setSpriteFrame:frame_ forKey:[NSString stringWithFormat:keyFormatter_,_fileName]];
}

@end

@implementation CMMDrawingManagerItem
@synthesize fileName,batchBarFrames,countOfBatchBar,otherFrames;

+(id)drawingItemWithFileName:(NSString *)fileName_{
	return [[[self alloc] initWithFileName:fileName_] autorelease];
}
-(id)initWithFileName:(NSString *)fileName_{
	if(!(self = [super init])) return self;
	
	if(!fileName_){
		[self release];
		return nil;
	}
	
	batchBarFrames = [[CCArray alloc] init];
	otherFrames = [[CMMDrawingManagerItemOtherFrames alloc] initWithFileName:fileName_];
	fileName = [fileName_ copy];
	
	NSString *realFileName_ = fileName;
	if(![realFileName_ isAbsolutePath]){
		realFileName_ = [CMMStringUtil stringPathOfResoruce:realFileName_ extension:@"png"];
		realFileName_ = [realFileName_ stringByDeletingPathExtension];
	}
	
	CCSpriteFrameCache *spriteFrameCache_ = [CCSpriteFrameCache sharedSpriteFrameCache];
	NSDictionary *spriteFrameInfoDic_ = [NSDictionary dictionaryWithContentsOfFile:[realFileName_ stringByAppendingPathExtension:@"plist"]];
	NSMutableDictionary *spriteFrameListDic_ = [NSMutableDictionary dictionaryWithDictionary:[spriteFrameInfoDic_ objectForKey:@"frames"]];
	
	//add default bar frames
	NSString *targetFileName_ = [fileName lastPathComponent];
	uint curBarFrameSeq_ = 0;
	while(YES){
		NSString *spriteFrameName_ = [NSString stringWithFormat:CMMDrawingManagerItemFormatter_BatchBar,targetFileName_,curBarFrameSeq_];
		CCSpriteFrame *barFrame_ = [spriteFrameCache_ spriteFrameByName:spriteFrameName_];
		if(!barFrame_) break;
		[self addBatchBarFrame:barFrame_];
		++curBarFrameSeq_;
		[spriteFrameListDic_ removeObjectForKey:spriteFrameName_];
	}
	
	//add other frames
	NSArray *allKeys_ = [spriteFrameListDic_ allKeys];
	for(NSString *key_ in allKeys_){
		CCSpriteFrame *spriteFrame_ = [spriteFrameCache_ spriteFrameByName:key_];
		[otherFrames setSpriteFrame:spriteFrame_ forKey:key_];
	}
	
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
	[otherFrames release];
	[batchBarFrames release];
	[super dealloc];
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
			_cachedCMMSpriteBatchBar_ = [[CMM9SliceBar alloc] initWithTexture:[batchBarSprite_ texture] targetRect:[batchBarSprite_ textureRect]];
		}
		
		[_cachedCMMSpriteBatchBar_ setTextureWithSprite:batchBarSprite_];
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
