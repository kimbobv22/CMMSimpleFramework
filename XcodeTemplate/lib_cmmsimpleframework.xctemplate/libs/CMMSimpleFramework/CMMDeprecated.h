//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingManager.h"
#import "CMMSpriteBatchBar.h"
#import "CMMMenuItem.h"
#import "CMMScrollMenu.h"
#import "CMMStage.h"
#import "CMMSObject.h"
#import "CMMSParticle.h"
#import "CMMSimpleCache.h"
#import "CMMScene.h"
#import "CMMLayerMD.h"
#import "CMMSequenceMaker.h"

@interface CMMScene(Deprecated)

@property (nonatomic, readwrite) ccColor3B transitionColor DEPRECATED_ATTRIBUTE;
@property (nonatomic, readwrite) ccTime fadeTime DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @interface CMMLayerMask : CMMLayerM

//use CMMLayerM class

@end

DEPRECATED_ATTRIBUTE typedef CMMLayerMDScrollbar CMMScrollbarDesign;

DEPRECATED_ATTRIBUTE @interface CMMLayerMaskDrag : CMMLayerMD

//use CMMLayerMD class

@end

@class CMMLoadingObject;

DEPRECATED_ATTRIBUTE @protocol CMMLoadingObjectDelegate <CMMSequenceMakerDelegate>

@optional

//use -(void)sequenceMakerDidStart:(CMMSequenceMaker *)sequenceMaker_;
-(void)loadingObject_whenLoadingStart:(CMMLoadingObject *)loadingObject_;
// use -(void)sequenceMakerDidEnd:(CMMSequenceMaker *)sequenceMaker_;
-(void)loadingObject_whenLoadingEnded:(CMMLoadingObject *)loadingObject_;

@end

DEPRECATED_ATTRIBUTE @interface CMMLoadingObject : CMMSequenceMakerAuto

//use CMMSequenceMakerAuto class

+(id)loadingObject;

-(void)startLoadingWithTarget:(id)target_;
-(void)startLoading;
-(void)startLoadingWithMethodFormatter:(NSString *)methodFormatter_ target:(id)target_;
-(void)startLoadingWithMethodFormatter:(NSString *)methodFormatter_;

@property (nonatomic, copy) NSString *loadingMethodFormatter;

@end

/*
 */
@interface CMMDrawingManager(Deprecated)

-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ barYN:(BOOL)barYN_ DEPRECATED_ATTRIBUTE;
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ DEPRECATED_ATTRIBUTE;
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ DEPRECATED_ATTRIBUTE;

@end

/*
 CMMControlItemBatchBar -> CMMSpriteBatchBar
 */
DEPRECATED_ATTRIBUTE @interface CMMControlItemBatchBar : CMMSpriteBatchBar

@end

/*
 */
@interface CMMMenuItem(Deprecated)

+(id)menuItemWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_ DEPRECATED_ATTRIBUTE;
+(id)menuItemWithFrameSeq:(int)frameSeq_ DEPRECATED_ATTRIBUTE;

-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_ DEPRECATED_ATTRIBUTE;
-(id)initWithFrameSeq:(int)frameSeq_ DEPRECATED_ATTRIBUTE;

@end

/*
 */
@interface CMMScrollMenu(Deprecated)

+(id)scrollMenuWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMSObject(Deprecated)

-(void)updateBodyWithPosition:(CGPoint)point_ andRotation:(float)tRotation_ DEPRECATED_ATTRIBUTE;
-(void)updateBodyWithPosition:(CGPoint)point_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMStageWorld(Deprecated)

-(CCArray *)objectsInTouched DEPRECATED_ATTRIBUTE;

@end

DEPRECATED_ATTRIBUTE @interface CMMSParticleFollow : CMMSParticle

@end

@interface CMMStageParticle(Deprecated)

-(CMMSParticle *)addParticleFollowWithName:(NSString *)particleName_ target:(CMMSObject *)target_ DEPRECATED_ATTRIBUTE;
-(void)removeParticleFollowOfTarget:(CMMSObject *)target_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMSimpleCache(Deprecated)

-(void)cacheObject:(id)object_ DEPRECATED_ATTRIBUTE;
-(void)clearCache DEPRECATED_ATTRIBUTE;

@end