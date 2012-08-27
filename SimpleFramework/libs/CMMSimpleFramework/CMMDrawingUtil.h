//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMMacro.h"

@interface CMMDrawingUtil : NSObject

@end

@interface CMMDrawingUtil(Line)

+(void)drawLineP2P:(CCRenderTexture *)targetRender_ spriteFrames:(CCArray *)spriteFrames_ point1:(CGPoint)point1_ point2:(CGPoint)point2_;
+(void)drawLineP2P:(CCRenderTexture *)targetRender_ spriteFrame:(CCSpriteFrame *)spriteFrame_ point1:(CGPoint)point1_ point2:(CGPoint)point2_;

+(CCTexture2D *)textureLineP2PWithFrameSize:(CGSize)frameSize_ spriteFrames:(CCArray *)spriteFrames_ point1:(CGPoint)point1_ point2:(CGPoint)point2_;
+(CCTexture2D *)textureLineP2PWithFrameSize:(CGSize)frameSize_ spriteFrame:(CCSpriteFrame *)spriteFrame_ point1:(CGPoint)point1_ point2:(CGPoint)point2_;

+(void)drawLineP2P:(CCRenderTexture *)targetRender_ frameSeq:(int)frameSeq_ point1:(CGPoint)point1_ point2:(CGPoint)point2_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMDrawingUtil(Fill)

+(void)drawFill:(CCRenderTexture *)targetRender_ backSprite:(CCSprite *)backSprite_ rect:(CGRect)rect_;
+(void)drawFill:(CCRenderTexture *)targetRender_ backSprite:(CCSprite *)backSprite_;

+(CCTexture2D *)textureFillWithFrameSize:(CGSize)frameSize_ backSprite:(CCSprite *)backSprite_ rect:(CGRect)rect_;
+(CCTexture2D *)textureFillWithFrameSize:(CGSize)frameSize_ backSprite:(CCSprite *)backSprite_;

@end

@interface CMMDrawingUtil(Frame)

+(void)drawFrame:(CCRenderTexture *)targetRender_ barSpriteFrames:(CCArray *)barSpriteFrames_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_ rect:(CGRect)rect_;
+(void)drawFrame:(CCRenderTexture *)targetRender_ barSpriteFrames:(CCArray *)barSpriteFrames_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_;

+(void)drawFrame:(CCRenderTexture *)targetRender_ barSpriteFrame:(CCSpriteFrame *)barSpriteFrame_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_ rect:(CGRect)rect_;
+(void)drawFrame:(CCRenderTexture *)targetRender_ barSpriteFrame:(CCSpriteFrame *)barSpriteFrame_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_;

+(CCTexture2D *)textureFrameWithFrameSize:(CGSize)frameSize_ barSpriteFrames:(CCArray *)barSpriteFrames_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_ rect:(CGRect)rect_;
+(CCTexture2D *)textureFrameWithFrameSize:(CGSize)frameSize_ barSpriteFrames:(CCArray *)barSpriteFrames_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_;

+(CCTexture2D *)textureFrameWithFrameSize:(CGSize)frameSize_ barSpriteFrame:(CCSpriteFrame *)barSpriteFrame_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_ rect:(CGRect)rect_;
+(CCTexture2D *)textureFrameWithFrameSize:(CGSize)frameSize_ barSpriteFrame:(CCSpriteFrame *)barSpriteFrame_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_;

@end

@interface CMMDrawingUtil(Deprecated)

+(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ barYN:(BOOL)barYN_ DEPRECATED_ATTRIBUTE;
+(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ DEPRECATED_ATTRIBUTE;
+(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ DEPRECATED_ATTRIBUTE;

@end

@interface CMMDrawingUtil(Mask)

+(void)drawMask:(CCRenderTexture *)targetRender_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_ isReverse:(BOOL)isReverse_;
+(void)drawMask:(CCRenderTexture *)targetRender_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_;

+(CCTexture2D *)textureMaskWithFrameSize:(CGSize)frameSize_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_ isReverse:(BOOL)isReverse_;
+(CCTexture2D *)textureMaskWithFrameSize:(CGSize)frameSize_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_;

@end

@interface CMMDrawingUtil(BatchBar)

+(void)drawBar:(CCRenderTexture *)targetRender_ edgeSprite:(CCSprite *)edgeSprite_ barCropWidth:(float)barCropWidth_ startPoint:(CGPoint)startPoint_ width:(float)width_;
+(CCTexture2D *)textureBarWithFrameSize:(CGSize)frameSize_ edgeSprite:(CCSprite *)edgeSprite_ barCropWidth:(float)barCropWidth_ startPoint:(CGPoint)startPoint_ width:(float)width_;

@end

@interface CMMDrawingUtil(Capture)

+(CCTexture2D *)captureFromNode:(CCNode *)node_;

@end