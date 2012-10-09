//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingUtil.h"

typedef enum{
	CMMDrawingManagerItemKey_switch_button,
	CMMDrawingManagerItemKey_switch_back,
	CMMDrawingManagerItemKey_switch_mask,
	
	CMMDrawingManagerItemKey_slider_bar,
	CMMDrawingManagerItemKey_slider_button,
	CMMDrawingManagerItemKey_slider_mask,
	
	CMMDrawingManagerItemKey_text_bar,
	
	CMMDrawingManagerItemKey_maxCount,
} CMMDrawingManagerItemKey;

@interface CMMDrawingManagerItem : NSObject{
	NSString *fileName;
	CCArray *batchBarFrames;
	NSMutableDictionary *_otherFrames;
}

+(id)drawingItemWithFileName:(NSString *)fileName_;
-(id)initWithFileName:(NSString *)fileName_;

-(void)addBatchBarFrame:(CCSpriteFrame *)spriteFrame_;

-(void)removeBatchBarFrame:(CCSpriteFrame *)spriteFrame_;
-(void)removeBatchBarFrameAtIndex:(uint)index_;
-(void)removeAllBatchBarFrames;

-(CCSpriteFrame *)batchBarFrameAtIndex:(uint)index_;

-(uint)indexOfBatchBarFrame:(CCSpriteFrame *)spriteFrame_;

@property (nonatomic, readonly) NSString *fileName;
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

-(void)addDrawingItem:(CMMDrawingManagerItem *)drawingItem_;
-(CMMDrawingManagerItem *)addDrawingItemWithFileName:(NSString *)fileName_;

-(CMMDrawingManagerItem *)drawingItemAtIndex:(uint)index_;
-(CMMDrawingManagerItem *)drawingItemAtFileName:(NSString *)fileName_;

-(void)removeDrawingItem:(CMMDrawingManagerItem *)drawingItem_;
-(void)removeDrawingItemAtIndex:(uint)index_;
-(void)removeDrawingItemAtFileName:(NSString *)fileName_;
-(void)removeAllDrawingItems;

-(uint)indexOfDrawingItem:(CMMDrawingManagerItem *)drawingItem_;
-(uint)indexOfDrawingItemWithFileName:(NSString *)fileName_;

@property (nonatomic, readonly) CCArray *frameList;
@property (nonatomic, readonly) uint count;

@end

@interface CMMDrawingManager(CachedTexture)

-(CCTexture2D *)textureBatchBarWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ size:(CGSize)size_;

@end