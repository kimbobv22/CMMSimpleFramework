//  Created by JGroup(kimbobv22@gmail.com)

#import "CCGLView.h"

@class CMMGLView;
@class CMMScene;

@protocol CMMGLViewTouchDelegate <NSObject>

-(void)glView:(CMMGLView *)glView_ whenTouchesBegan:(NSSet *)touches_ event:(UIEvent *)event_;
-(void)glView:(CMMGLView *)glView_ whenTouchesMoved:(NSSet *)touches_ event:(UIEvent *)event_;
-(void)glView:(CMMGLView *)glView_ whenTouchesEnded:(NSSet *)touches_ event:(UIEvent *)event_;
-(void)glView:(CMMGLView *)glView_ whenTouchesCancelled:(NSSet *)touches_ event:(UIEvent *)event_;

@end

@interface CMMGLView : CCGLView{}

@end
