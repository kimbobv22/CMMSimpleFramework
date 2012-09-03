//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingUtil.h"

typedef enum{
	CMMDrawingManagerItemKey_default_edge,
	CMMDrawingManagerItemKey_default_back,
	
	CMMDrawingManagerItemKey_switch_button,
	CMMDrawingManagerItemKey_switch_back,
	CMMDrawingManagerItemKey_switch_mask,
	
	CMMDrawingManagerItemKey_slider_bar,
	CMMDrawingManagerItemKey_slider_button,
	CMMDrawingManagerItemKey_slider_backLeft,
	CMMDrawingManagerItemKey_slider_backRight,
	CMMDrawingManagerItemKey_slider_mask,
	
	CMMDrawingManagerItemKey_text_bar,
	CMMDrawingManagerItemKey_text_mask,
	
	CMMDrawingManagerItemKey_maxCount,
} CMMDrawingManagerItemKey;

@interface CMMDrawingManagerItem : NSObject{
	CCArray *default_barFrames;
	//frames
	NSMutableDictionary *_otherFrames;
}

-(void)setSpriteFrame:(CCSpriteFrame *)spriteFrame_ forKey:(CMMDrawingManagerItemKey)key_;
-(CCSpriteFrame *)spriteFrameForKey:(CMMDrawingManagerItemKey)key_;

@property (nonatomic, retain) CCArray *default_barFrames;

@end

@interface CMMDrawingManager : NSObject{
	CCArray *frameList;
	NSMutableDictionary *cachedFrameTextures;
}

+(CMMDrawingManager *)sharedManager;

-(CMMDrawingManagerItem *)drawingItemAtIndex:(int)index_;

@property (nonatomic, readonly) CCArray *frameList;

@end

@interface CMMDrawingManager(CachedTexture)

-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ barYN:(BOOL)barYN_;
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_;
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_;

@end