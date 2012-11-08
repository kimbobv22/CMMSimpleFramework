//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMGLView.h"
#import "CMMScene.h"

@implementation CMMGLView

-(id)initWithFrame:(CGRect)frame pixelFormat:(NSString *)format depthFormat:(GLuint)depth preserveBackbuffer:(BOOL)retained sharegroup:(EAGLSharegroup *)sharegroup multiSampling:(BOOL)sampling numberOfSamples:(unsigned int)nSamples{
	if(!(self = [super initWithFrame:frame pixelFormat:format depthFormat:depth preserveBackbuffer:retained sharegroup:sharegroup multiSampling:sampling numberOfSamples:nSamples])) return self;
	
	[self setMultipleTouchEnabled:YES];
	
	return self;
}

//handling touch directly
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[[CMMScene sharedScene] glView:self whenTouchesBegan:touches event:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[[CMMScene sharedScene] glView:self whenTouchesMoved:touches event:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[[CMMScene sharedScene] glView:self whenTouchesEnded:touches event:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[[CMMScene sharedScene] glView:self whenTouchesCancelled:touches event:event];
}

@end
