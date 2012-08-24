//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMGLView.h"
#import "CMMScene.h"

@implementation CMMGLView

-(id)initWithFrame:(CGRect)frame pixelFormat:(NSString *)format depthFormat:(GLuint)depth preserveBackbuffer:(BOOL)retained sharegroup:(EAGLSharegroup *)sharegroup multiSampling:(BOOL)sampling numberOfSamples:(unsigned int)nSamples{
	if(!(self = [super initWithFrame:frame pixelFormat:format depthFormat:depth preserveBackbuffer:retained sharegroup:sharegroup multiSampling:sampling numberOfSamples:nSamples])) return self;
	
	self.multipleTouchEnabled = YES;
	
	return self;
}

//handling touch directly
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	for(UITouch *touch_ in touches)
		[[CMMScene sharedScene] glViewTouch:self whenTouchBegan:touch_ event:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	for(UITouch *touch_ in touches)
		[[CMMScene sharedScene] glViewTouch:self whenTouchMoved:touch_ event:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	for(UITouch *touch_ in touches)
		[[CMMScene sharedScene] glViewTouch:self whenTouchEnded:touch_ event:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	for(UITouch *touch_ in touches)
		[[CMMScene sharedScene] glViewTouch:self whenTouchCancelled:touch_ event:event];
}

@end
