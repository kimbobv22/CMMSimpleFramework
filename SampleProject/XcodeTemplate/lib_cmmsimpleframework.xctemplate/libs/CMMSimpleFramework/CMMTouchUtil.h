//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMMacro.h"

@interface CMMTouchUtil : NSObject

+(CGPoint)pointFromTouch:(UITouch *)touch_;
+(CGPoint)pointFromTouch:(UITouch *)touch_ targetNode:(CCNode *)node_;

+(CGPoint)prepointFromTouch:(UITouch *)touch_;
+(CGPoint)prepointFromTouch:(UITouch *)touch_ targetNode:(CCNode *)node_;

@end

@interface CMMTouchUtil(Check)

+(BOOL)isRectInPoint:(CGRect)rect_ point:(CGPoint)point_ margin:(float)margin_;
+(BOOL)isRectInPoint:(CGRect)rect_ point:(CGPoint)point_;

+(BOOL)isNodeInPoint:(CCNode *)node_ point:(CGPoint)point_ margin:(float)margin_;
+(BOOL)isNodeInPoint:(CCNode *)node_ point:(CGPoint)point_;

+(BOOL)isNodeInTouch:(CCNode *)node_ touch:(UITouch *)touch_ margin:(float)margin_;
+(BOOL)isNodeInTouch:(CCNode *)node_ touch:(UITouch *)touch_;

@end
