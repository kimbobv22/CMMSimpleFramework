//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingManager.h"
#import "CMMStringUtil.h"
#import "CMMDrawingUtil.h"
#import "CMMFileUtil.h"

#define cmmVarCMMDrawingManagerItem_makeKey(_key_) [NSString stringWithFormat:@"%d",(_key_)]

static CMMDrawingManager *_sharedDrawingManager_ = nil;

@implementation CMMDrawingManagerItem
@synthesize default_barFrames;

-(id)init{
	if(!(self = [super init])) return self;
	
	_otherFrames = [[NSMutableDictionary alloc] init];
	
	return self;
}

-(void)setSpriteFrame:(CCSpriteFrame *)spriteFrame_ forKey:(CMMDrawingManagerItemKey)key_{
	if(!spriteFrame_) return;
	[_otherFrames setObject:spriteFrame_ forKey:cmmVarCMMDrawingManagerItem_makeKey(key_)];
}
-(CCSpriteFrame *)spriteFrameForKey:(CMMDrawingManagerItemKey)key_{
	return [_otherFrames objectForKey:cmmVarCMMDrawingManagerItem_makeKey(key_)];
}

-(void)dealloc{
	[_otherFrames release];
	[default_barFrames release];
	[super dealloc];
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
			CMMDrawingManagerItem *drawItem_ = [[[CMMDrawingManagerItem alloc] init] autorelease];
			
			//add default bar frame
			CCArray *barFrames_ = [CCArray array];
			NSString *barFrameFormatter_ = [frameFileName_ stringByAppendingString:@"_BAR_%02d.png"];
			uint curBarFrameSeq_ = 0;
			while(YES){
				CCSpriteFrame *barFrame_ = [spriteFrameCache_ spriteFrameByName:[NSString stringWithFormat:barFrameFormatter_,curBarFrameSeq_]];
				if(!barFrame_) break;
				
				[barFrames_ addObject:barFrame_];
				curBarFrameSeq_++;
			}
			drawItem_.default_barFrames = barFrames_;
			
			//add default edge frame
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[frameFileName_ stringByAppendingString:@"_EDGE.png"]] forKey:CMMDrawingManagerItemKey_default_edge];
			
			//add default backGround frame
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[frameFileName_ stringByAppendingString:@"_BACK.png"]] forKey:CMMDrawingManagerItemKey_default_back];
			
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
			[drawItem_ setSpriteFrame:[spriteFrameCache_ spriteFrameByName:[textFrameName_ stringByAppendingString:@"_MASK.png"]] forKey:CMMDrawingManagerItemKey_text_mask];
			
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

-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ barYN:(BOOL)barYN_{
	if(!backGroundYN_ && !barYN_) return nil;
	NSString *keyName_ = [NSString stringWithFormat:@"default seq:%d_w:%1.1f_h:%1.1f_bg:%d_b:%d",frameSeq_,size_.width,size_.height,backGroundYN_,barYN_];
	CCTexture2D *texture_ = [cachedFrameTextures objectForKey:keyName_];
	
	if(!texture_){
		CMMDrawingManagerItem *drawingItem_ = [self drawingItemAtIndex:frameSeq_];
		if(!drawingItem_) return nil;
		
		CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:(int)size_.width height:(int)size_.height];
		[render_ begin];
		
		if(backGroundYN_)
			[CMMDrawingUtil drawFill:render_ backSprite:[CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_default_back]]];
		if(barYN_)
			[CMMDrawingUtil drawFrame:render_ barSpriteFrames:drawingItem_.default_barFrames edgeSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_default_edge]];
		
		[render_ end];
		texture_ = render_.sprite.texture;
		[cachedFrameTextures setObject:texture_ forKey:keyName_];
	}
	
	return texture_;
}
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_{
	return [self textureFrameWithFrameSeq:frameSeq_ size:size_ backGroundYN:backGroundYN_ barYN:YES];
}
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_{
	return [self textureFrameWithFrameSeq:frameSeq_ size:size_ backGroundYN:YES];
}

@end
