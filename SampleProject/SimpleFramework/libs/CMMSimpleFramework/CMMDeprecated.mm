//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDeprecated.h"

@implementation CMMScene(Deprecated)

-(ccTime)fadeTime{
	return 0.0f;
}
-(void)setFadeTime:(ccTime)fadeTime{}

-(ccColor3B)transitionColor{
	return ccc3(0, 0, 0);
}
-(void)setTransitionColor:(ccColor3B)transitionColor{}

@end

@implementation CMMLayerMask

@end

@implementation CMMLayerMaskDrag

@end

@implementation CMMDrawingManager(Deprecated)

-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ barYN:(BOOL)barYN_{
	return [self textureBatchBarWithFrameSeq:frameSeq_ batchBarSeq:0 size:size_];
}
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_{
	return [self textureBatchBarWithFrameSeq:frameSeq_ batchBarSeq:0 size:size_];
}
-(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_{
	return [self textureBatchBarWithFrameSeq:frameSeq_ batchBarSeq:0 size:size_];
}

@end

@implementation CMMControlItemBatchBar

@end

@implementation CMMMenuItem(Deprecated)

+(id)menuItemWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [self menuItemWithFrameSeq:frameSeq_ batchBarSeq:0 frameSize:frameSize_];
}
+(id)menuItemWithFrameSeq:(int)frameSeq_{
	return [self menuItemWithFrameSeq:frameSeq_ batchBarSeq:0];
}
-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [self initWithFrameSeq:frameSeq_ batchBarSeq:0 frameSize:frameSize_];
}
-(id)initWithFrameSeq:(int)frameSeq_{
	return [self initWithFrameSeq:frameSeq_ batchBarSeq:0];
}

@end

@implementation CMMScrollMenu(Deprecated)

+(id)scrollMenuWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_{
	return [self scrollMenuWithFrameSeq:frameSeq_ batchBarSeq:0 frameSize:frameSize_];
}

@end

@implementation CMMSObject(Deprecated)

-(void)updateBodyWithPosition:(CGPoint)point_ andRotation:(float)tRotation_{
	[self updateBodyPosition:point_ rotation:tRotation_];
}
-(void)updateBodyWithPosition:(CGPoint)point_{
	[self updateBodyPosition:point_];
}

@end

@implementation CMMStageWorld(Deprecated)

-(CCArray *)objectsInTouched{
	return [self objectsInTouches];
}

@end

@implementation CMMStageParticle(Deprecated)

-(CMMSParticle *)addParticleFollowWithName:(NSString *)particleName_ target:(CMMSObject *)target_{
	CMMSParticle *particle_ = [self addParticleWithName:particleName_ point:CGPointZero];
	[particle_ setTarget:target_];
	return particle_;
}
-(void)removeParticleFollowOfTarget:(CMMSObject *)target_{
	[self removeParticleOfTarget:target_];
}

@end

@implementation CMMSimpleCache(Deprecated)

-(void)cacheObject:(id)object_{
	[self addObject:object_];
}
-(void)clearCache{
	[self removeAllObjects];
}

@end
