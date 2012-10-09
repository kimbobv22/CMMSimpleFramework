//  Created by JGroup(kimbobv22@gmail.com)

#import "CCGLView.h"

@class CMMGLView;
@class CMMScene;

@protocol CMMGLViewTouchDelegate <NSObject>

-(void)glViewTouch:(CMMGLView *)glView_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_;
-(void)glViewTouch:(CMMGLView *)glView_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_;
-(void)glViewTouch:(CMMGLView *)glView_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_;
-(void)glViewTouch:(CMMGLView *)glView_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_;

@end

@interface CMMGLView : CCGLView

@end
