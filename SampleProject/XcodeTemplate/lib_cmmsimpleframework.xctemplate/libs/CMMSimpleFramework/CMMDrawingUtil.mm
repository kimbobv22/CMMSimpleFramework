//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingManager.h"
#import "CMMMacro.h"
#import "CMMDrawingUtil.h"
#import "CMMFileUtil.h"

@implementation CMMDrawingUtil
@end

@implementation CMMDrawingUtil(Mask)

+(void)drawMask:(CCRenderTexture *)targetRender_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_ isReverse:(BOOL)isReverse_{
	
	CCSprite *targetSprite_ = [CCSprite spriteWithTexture:sprite_.texture rect:sprite_.textureRect];
	CCSprite *tMaskSprite_ = [CCSprite spriteWithTexture:maskSprite_.texture rect:maskSprite_.textureRect];
	
	targetSprite_.position = spritePoint_;
	tMaskSprite_.position = maskPoint_;
	targetSprite_.flipY = tMaskSprite_.flipY = YES;
	
	if(isReverse_){
		[targetSprite_ visit];
		[tMaskSprite_ setBlendFunc:(ccBlendFunc){GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
		[tMaskSprite_ visit];
	}else{
		[tMaskSprite_ visit];
		[targetSprite_ setBlendFunc:(ccBlendFunc){GL_DST_ALPHA, GL_ZERO}];
		[targetSprite_ visit];
	}
}

+(void)drawMask:(CCRenderTexture *)targetRender_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_{
	[self drawMask:targetRender_ sprite:sprite_ spritePoint:spritePoint_ maskSprite:maskSprite_ maskPoint:maskPoint_ isReverse:NO];
}

+(CCTexture2D *)textureMaskWithFrameSize:(CGSize)frameSize_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_ isReverse:(BOOL)isReverse_{
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:frameSize_.width height:frameSize_.height];
	
	spritePoint_ = ccp(spritePoint_.x,frameSize_.height-spritePoint_.y);
	maskPoint_ = ccp(maskPoint_.x,frameSize_.height-maskPoint_.y);
	
	[render_ begin];
	[self drawMask:render_ sprite:sprite_ spritePoint:spritePoint_ maskSprite:maskSprite_ maskPoint:maskPoint_ isReverse:isReverse_];
	[render_ end];
	
	return render_.sprite.texture;
}
+(CCTexture2D *)textureMaskWithFrameSize:(CGSize)frameSize_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_{
	return [self textureMaskWithFrameSize:frameSize_ sprite:sprite_ spritePoint:spritePoint_ maskSprite:maskSprite_ maskPoint:maskPoint_ isReverse:NO];
}

@end

@implementation CMMDrawingUtil(Capture)

+(CCTexture2D *)captureFromNode:(CCNode *)node_{
	CGSize frameSize_ = [node_ boundingBox].size;
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:frameSize_.width height:frameSize_.height];
	
	node_ = [[node_ retain] autorelease];
	CGPoint anchorPoint_ = node_.anchorPoint;
	CGPoint orgPoint_ = node_.position;
	CCNode *orgParent_ = node_.parent;
	
	[node_ removeFromParentAndCleanup:NO];
	node_.position = ccp(frameSize_.width*anchorPoint_.x,frameSize_.height*anchorPoint_.y);
	node_.scaleY *=-1;
	
	[render_ begin];
	
	[node_ visit];
	
	[render_ end];
	
	node_.scaleY *=-1;
	node_.position = orgPoint_;
	[orgParent_ addChild:node_];
	
	return [[render_ sprite] texture];
}

@end