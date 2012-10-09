//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMMacro.h"

@interface CMMDrawingUtil : NSObject
@end

@interface CMMDrawingUtil(Mask)

+(void)drawMask:(CCRenderTexture *)targetRender_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_ isReverse:(BOOL)isReverse_;
+(void)drawMask:(CCRenderTexture *)targetRender_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_;

+(CCTexture2D *)textureMaskWithFrameSize:(CGSize)frameSize_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_ isReverse:(BOOL)isReverse_;
+(CCTexture2D *)textureMaskWithFrameSize:(CGSize)frameSize_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_;

@end

@interface CMMDrawingUtil(Capture)

+(CCTexture2D *)captureFromNode:(CCNode *)node_;

@end