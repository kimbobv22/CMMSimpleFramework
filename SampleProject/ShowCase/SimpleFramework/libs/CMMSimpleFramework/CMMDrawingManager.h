//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingUtil.h"

extern NSString *const CMMDrawingManagerItemFormatter_BatchBar;
extern NSString *const CMMDrawingManagerItemFormatter_SwitchButton;
extern NSString *const CMMDrawingManagerItemFormatter_SwitchMask;
extern NSString *const CMMDrawingManagerItemFormatter_SlideBar;
extern NSString *const CMMDrawingManagerItemFormatter_SlideButton;
extern NSString *const CMMDrawingManagerItemFormatter_SlideMask;
extern NSString *const CMMDrawingManagerItemFormatter_TextBar;
extern NSString *const CMMDrawingManagerItemFormatter_CheckboxBack;
extern NSString *const CMMDrawingManagerItemFormatter_CheckboxCheck;
extern NSString *const CMMDrawingManagerItemFormatter_ComboFrame;
extern NSString *const CMMDrawingManagerItemFormatter_ComboBack;
extern NSString *const CMMDrawingManagerItemFormatter_ComboCursor;

@interface CMMDrawingManagerItemOtherFrames : NSObject

+(id)otherFramesWithFileName:(NSString *)fileName_;
-(id)initWithFileName:(NSString *)fileName_;

-(void)setSpriteFrame:(CCSpriteFrame *)frame_ forKey:(NSString *)key_;
-(void)removeSpriteFrameForKey:(NSString *)key_;

-(CCSpriteFrame *)spriteFrameForKey:(NSString *)key_;
-(CCSpriteFrame *)spriteFrameForKeyFormatter:(NSString *)keyFormatter_;

@property (nonatomic, readonly) NSDictionary *spriteFrames;

@end

@interface CMMDrawingManagerItem : NSObject{
	NSString *fileName;
	CCArray *batchBarFrames;
	CMMDrawingManagerItemOtherFrames *otherFrames;
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
@property (nonatomic, readonly) CMMDrawingManagerItemOtherFrames *otherFrames;

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