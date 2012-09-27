//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingUtil.h"

typedef enum{
	CMMDrawingManagerItemKey_switch_button,
	CMMDrawingManagerItemKey_switch_back,
	CMMDrawingManagerItemKey_switch_mask,
	
	CMMDrawingManagerItemKey_slider_bar,
	CMMDrawingManagerItemKey_slider_button,
	CMMDrawingManagerItemKey_slider_backLeft,
	CMMDrawingManagerItemKey_slider_backRight,
	CMMDrawingManagerItemKey_slider_mask,
	
	CMMDrawingManagerItemKey_text_bar,
	
	CMMDrawingManagerItemKey_maxCount,
} CMMDrawingManagerItemKey;

@interface CMMDrawingManagerItem : NSObject{
	CCArray *batchBarFrames;
	NSMutableDictionary *_otherFrames;
}

+(id)drawingItem;

-(void)addBatchBarFrame:(CCSpriteFrame *)spriteFrame_;

-(void)removeBatchBarFrame:(CCSpriteFrame *)spriteFrame_;
-(void)removeBatchBarFrameAtIndex:(uint)index_;
-(void)removeAllBatchBarFrames;

-(CCSpriteFrame *)batchBarFrameAtIndex:(uint)index_;

-(uint)indexOfBatchBarFrame:(CCSpriteFrame *)spriteFrame_;

@property (nonatomic, retain) CCArray *batchBarFrames;
@property (nonatomic, readonly) uint countOfBatchBar;

@end

@interface CMMDrawingManagerItem(Other)

-(void)setSpriteFrame:(CCSpriteFrame *)spriteFrame_ forKey:(CMMDrawingManagerItemKey)key_;
-(CCSpriteFrame *)spriteFrameForKey:(CMMDrawingManagerItemKey)key_;

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

-(CCTexture2D *)textureBatchBarWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ size:(CGSize)size_;

@end