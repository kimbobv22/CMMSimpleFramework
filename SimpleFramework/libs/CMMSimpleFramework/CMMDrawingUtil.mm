//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMDrawingManager.h"
#import "CMMType.h"
#import "CMMDrawingUtil.h"
#import "CMMFileUtil.h"

@implementation CMMDrawingUtil
@end

@implementation CMMDrawingUtil(Line)

+(void)drawLineP2P:(CCRenderTexture *)targetRender_ spriteFrames:(CCArray *)spriteFrames_ point1:(CGPoint)point1_ point2:(CGPoint)point2_{
	float targetLength_ = ccpDistance(point1_, point2_);
	float targetRadians_ = ccpToAngle(ccpSub(point2_,point1_));
	
	int totalSeq_ = spriteFrames_.count-1;
	
	CCSprite *barSprite_ = [CCSprite spriteWithSpriteFrame:[spriteFrames_ objectAtIndex:0]];
	barSprite_.ignoreAnchorPointForPosition = NO;
	[barSprite_.texture setAliasTexParameters];
	barSprite_.anchorPoint = ccp(0.5,0);
	barSprite_.scaleY = targetLength_/barSprite_.contentSize.height;
	barSprite_.rotation = -CC_RADIANS_TO_DEGREES(targetRadians_)+90.0f;
	barSprite_.position = point1_;
	[barSprite_ visit];
	
	int pointCount_ = rand()%3;
	float pointUnit_ = (targetLength_/(float)pointCount_);
	for(uint pointIndex_=0;pointIndex_<pointCount_;pointIndex_++){
		[barSprite_ setDisplayFrame:[spriteFrames_ objectAtIndex:MAX(rand()%totalSeq_,1)]];
		barSprite_.ignoreAnchorPointForPosition = NO;
		[barSprite_.texture setAliasTexParameters];
		barSprite_.anchorPoint = ccp(0.5,0);
		barSprite_.scaleY = 1;
		barSprite_.rotation = -CC_RADIANS_TO_DEGREES(targetRadians_)+90.0f;
		
		float startLength_ = ((float)pointIndex_/(float)pointCount_)*targetLength_;
		float curTarget_ = startLength_+MIN(CCRANDOM_0_1()*pointUnit_,pointUnit_-barSprite_.contentSize.height);
		CGPoint targetPoint_ = ccpOffset(point1_, targetRadians_, curTarget_);
		
		barSprite_.position = targetPoint_;
		[barSprite_ visit];
	}
}
+(void)drawLineP2P:(CCRenderTexture *)targetRender_ spriteFrame:(CCSpriteFrame *)spriteFrame_ point1:(CGPoint)point1_ point2:(CGPoint)point2_{
	CCArray *tempArray_ = [CCArray array];
	[tempArray_ addObject:spriteFrame_];
	[self drawLineP2P:targetRender_ spriteFrames:tempArray_ point1:point1_ point2:point2_];
}

+(CCTexture2D *)textureLineP2PWithFrameSize:(CGSize)frameSize_ spriteFrames:(CCArray *)spriteFrames_ point1:(CGPoint)point1_ point2:(CGPoint)point2_{
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:frameSize_.width height:frameSize_.height];
	
	point1_ = ccp(point1_.x,frameSize_.height-point1_.y);
	point2_ = ccp(point2_.x,frameSize_.height-point2_.y);
	
	[render_ begin];
	[self drawLineP2P:render_ spriteFrames:spriteFrames_ point1:point1_ point2:point2_];
	[render_ end];

	return render_.sprite.texture;
}
+(CCTexture2D *)textureLineP2PWithFrameSize:(CGSize)frameSize_ spriteFrame:(CCSpriteFrame *)spriteFrame_ point1:(CGPoint)point1_ point2:(CGPoint)point2_{
	CCArray *tempArray_ = [CCArray array];
	[tempArray_ addObject:spriteFrame_];
	return [self textureLineP2PWithFrameSize:frameSize_ spriteFrames:tempArray_ point1:point1_ point2:point2_];
}

+(void)drawLineP2P:(CCRenderTexture *)targetRender_ frameSeq:(int)frameSeq_ point1:(CGPoint)point1_ point2:(CGPoint)point2_{
	CMMDrawingManagerItem *drawingItem_ = [[CMMDrawingManager sharedManager] drawingItemAtIndex:frameSeq_];
	if(!drawingItem_) return;
	[self drawLineP2P:targetRender_ spriteFrames:drawingItem_.default_barFrames point1:point1_ point2:point2_];
}

@end

@implementation CMMDrawingUtil(Fill)

+(void)drawFill:(CCRenderTexture *)targetRender_ backSprite:(CCSprite *)backSprite_ rect:(CGRect)rect_{
	CCSprite *tBackSprite_ = [CCSprite spriteWithTexture:backSprite_.texture rect:backSprite_.textureRect];
	[tBackSprite_.texture setAliasTexParameters];
	tBackSprite_.ignoreAnchorPointForPosition = NO;
	tBackSprite_.anchorPoint = ccp(0.1f,0.0f);
	tBackSprite_.scaleX = (rect_.size.width)/tBackSprite_.contentSize.width*1.1f; //issue
	tBackSprite_.scaleY = (rect_.size.height)/tBackSprite_.contentSize.height;
	tBackSprite_.position = rect_.origin;
	tBackSprite_.flipY = YES;
	
	[tBackSprite_ visit];
}
+(void)drawFill:(CCRenderTexture *)targetRender_ backSprite:(CCSprite *)backSprite_{
	CGRect targetRect_ = CGRectZero;
	targetRect_.size = targetRender_.sprite.contentSize;
	[self drawFill:targetRender_ backSprite:backSprite_ rect:targetRect_];
}

+(CCTexture2D *)textureFillWithFrameSize:(CGSize)frameSize_ backSprite:(CCSprite *)backSprite_ rect:(CGRect)rect_{
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:frameSize_.width height:frameSize_.height];
	[render_ begin];
	[self drawFill:render_ backSprite:backSprite_ rect:rect_];
	[render_ end];
	
	return render_.sprite.texture;
}
+(CCTexture2D *)textureFillWithFrameSize:(CGSize)frameSize_ backSprite:(CCSprite *)backSprite_{
	CGRect targetRect_ = CGRectZero;
	targetRect_.size = frameSize_;
	return [self textureFillWithFrameSize:frameSize_ backSprite:backSprite_ rect:targetRect_];
}

@end

@implementation CMMDrawingUtil(Frame)

+(void)drawFrame:(CCRenderTexture *)targetRender_ barSpriteFrames:(CCArray *)barSpriteFrames_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_ rect:(CGRect)rect_{
	
	CCSpriteFrame *barSpriteFrame_ = [barSpriteFrames_ objectAtIndex:0];
	CGSize barSize_ = barSpriteFrame_.rect.size;
	
	//draw shadow
	glLineWidth(barSize_.width*CC_CONTENT_SCALE_FACTOR());
	ccDrawColor4B(0, 0, 0, 50);
	ccDrawLine(ccp(rect_.origin.x+barSize_.width,rect_.origin.y), ccp(rect_.origin.x+barSize_.width,rect_.origin.y+rect_.size.height));
	ccDrawLine(ccp(rect_.origin.x+barSize_.width,rect_.origin.y+barSize_.width), ccp(rect_.origin.x+rect_.size.width,rect_.origin.y+barSize_.width));
	
	//top & bottom
	[self drawLineP2P:targetRender_ spriteFrames:barSpriteFrames_ point1:ccp(rect_.origin.x+rect_.size.width,rect_.origin.y+barSize_.width/2) point2:ccp(rect_.origin.x,rect_.origin.y+barSize_.width/2)];
	[self drawLineP2P:targetRender_ spriteFrames:barSpriteFrames_ point1:ccp(rect_.origin.x,rect_.origin.y+rect_.size.height-barSize_.width/2) point2:ccp(rect_.origin.x+rect_.size.width,rect_.origin.y+rect_.size.height-barSize_.width/2)];
	
	//left & right
	[self drawLineP2P:targetRender_ spriteFrames:barSpriteFrames_ point1:ccp(rect_.origin.x+barSize_.width/2,rect_.origin.y) point2:ccp(rect_.origin.x+barSize_.width/2,rect_.origin.y+rect_.size.height)];
	[self drawLineP2P:targetRender_ spriteFrames:barSpriteFrames_ point1:ccp(rect_.origin.x+rect_.size.width-barSize_.width/2,rect_.origin.y+rect_.size.height) point2:ccp(rect_.origin.x+rect_.size.width-barSize_.width/2,rect_.origin.y)];
	
	//draw edge
	CCSprite *edgeSprite_ = [CCSprite spriteWithSpriteFrame:edgeSpriteFrame_];
	edgeSprite_.scaleY = -1;
	CGSize edgeSize_ = edgeSprite_.contentSize;
	edgeSprite_.position = ccp(rect_.origin.x+edgeSize_.width/2,rect_.origin.y+edgeSize_.height/2);
	[edgeSprite_ visit];
	
	edgeSprite_.position = ccp(rect_.origin.x+rect_.size.width-edgeSize_.width/2,rect_.origin.y+edgeSize_.height/2);
	edgeSprite_.scaleX = -1;
	[edgeSprite_ visit];
	
	edgeSprite_.position = ccp(rect_.origin.x+rect_.size.width-edgeSize_.width/2,rect_.origin.y+rect_.size.height-edgeSize_.height/2);
	edgeSprite_.rotation = -90.0f;
	edgeSprite_.scaleX = -1;
	[edgeSprite_ visit];
	
	edgeSprite_.position = ccp(rect_.origin.x+edgeSize_.width/2,rect_.origin.y+rect_.size.height-edgeSize_.height/2);
	edgeSprite_.rotation = 90.0f;
	edgeSprite_.scaleX = 1;
	[edgeSprite_ visit];
}
+(void)drawFrame:(CCRenderTexture *)targetRender_ barSpriteFrames:(CCArray *)barSpriteFrames_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_{
	CGRect targetRect_ = CGRectZero;
	targetRect_.size = targetRender_.sprite.contentSize;
	[self drawFrame:targetRender_ barSpriteFrames:barSpriteFrames_ edgeSpriteFrame:edgeSpriteFrame_ rect:targetRect_];
}

+(void)drawFrame:(CCRenderTexture *)targetRender_ barSpriteFrame:(CCSpriteFrame *)barSpriteFrame_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_ rect:(CGRect)rect_{
	CCArray *tempArray_ = [CCArray array];
	[tempArray_ addObject:barSpriteFrame_];
	[self drawFrame:targetRender_ barSpriteFrames:tempArray_ edgeSpriteFrame:edgeSpriteFrame_];
}
+(void)drawFrame:(CCRenderTexture *)targetRender_ barSpriteFrame:(CCSpriteFrame *)barSpriteFrame_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_{
	CGRect targetRect_ = CGRectZero;
	targetRect_.size = targetRender_.sprite.contentSize;
	[self drawFrame:targetRender_ barSpriteFrame:barSpriteFrame_ edgeSpriteFrame:edgeSpriteFrame_ rect:targetRect_];
}

+(CCTexture2D *)textureFrameWithFrameSize:(CGSize)frameSize_ barSpriteFrames:(CCArray *)barSpriteFrames_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_ rect:(CGRect)rect_{
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:frameSize_.width height:frameSize_.height];
	
	[render_ begin];
	[self drawFrame:render_ barSpriteFrames:barSpriteFrames_ edgeSpriteFrame:edgeSpriteFrame_];
	[render_ end];
	
	return render_.sprite.texture;
}
+(CCTexture2D *)textureFrameWithFrameSize:(CGSize)frameSize_ barSpriteFrames:(CCArray *)barSpriteFrames_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_{
	CGRect targetRect_ = CGRectZero;
	targetRect_.size = frameSize_;
	return [self textureFrameWithFrameSize:frameSize_ barSpriteFrames:barSpriteFrames_ edgeSpriteFrame:edgeSpriteFrame_ rect:targetRect_];
}

+(CCTexture2D *)textureFrameWithFrameSize:(CGSize)frameSize_ barSpriteFrame:(CCSpriteFrame *)barSpriteFrame_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_ rect:(CGRect)rect_{
	CCArray *tempArray_ = [CCArray array];
	[tempArray_ addObject:barSpriteFrame_];
	return [self textureFrameWithFrameSize:frameSize_ barSpriteFrames:tempArray_ edgeSpriteFrame:edgeSpriteFrame_ rect:rect_];
}
+(CCTexture2D *)textureFrameWithFrameSize:(CGSize)frameSize_ barSpriteFrame:(CCSpriteFrame *)barSpriteFrame_ edgeSpriteFrame:(CCSpriteFrame *)edgeSpriteFrame_{
	CGRect targetRect_ = CGRectZero;
	targetRect_.size = frameSize_;
	return [self textureFrameWithFrameSize:frameSize_ barSpriteFrame:barSpriteFrame_ edgeSpriteFrame:edgeSpriteFrame_ rect:targetRect_];
}

@end

@implementation CMMDrawingUtil(Deprecated)

+(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_ barYN:(BOOL)barYN_{
	return [[CMMDrawingManager sharedManager] textureFrameWithFrameSeq:frameSeq_ size:size_ backGroundYN:backGroundYN_ barYN:barYN_];
}
+(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_ backGroundYN:(BOOL)backGroundYN_{
	return [self textureFrameWithFrameSeq:frameSeq_ size:size_ backGroundYN:backGroundYN_ barYN:YES];
}
+(CCTexture2D *)textureFrameWithFrameSeq:(int)frameSeq_ size:(CGSize)size_{
	return [self textureFrameWithFrameSeq:frameSeq_ size:size_ backGroundYN:YES];
}

@end

@implementation CMMDrawingUtil(Mask)

+(void)drawMask:(CCRenderTexture *)targetRender_ sprite:(CCSprite *)sprite_ spritePoint:(CGPoint)spritePoint_ maskSprite:(CCSprite *)maskSprite_ maskPoint:(CGPoint)maskPoint_ isReverse:(BOOL)isReverse_{
	
	[targetRender_ end];
	
	CGSize renderSize_ = targetRender_.sprite.contentSize;
	CCRenderTexture *otherRender_ = [CCRenderTexture renderTextureWithWidth:renderSize_.width height:renderSize_.height];
	
	CCSprite *targetSprite_ = [CCSprite spriteWithTexture:sprite_.texture rect:sprite_.textureRect];
	CCSprite *tMaskSprite_ = [CCSprite spriteWithTexture:maskSprite_.texture rect:maskSprite_.textureRect];
	
	targetSprite_.position = spritePoint_;
	tMaskSprite_.position = maskPoint_;
	targetSprite_.flipY = tMaskSprite_.flipY = YES;
	
	[otherRender_ begin];
	
	[targetSprite_ visit];
	[tMaskSprite_ setBlendFunc:(ccBlendFunc){GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
	[tMaskSprite_ visit];
	
	[otherRender_ end];
	
	CCSprite *cutSprite_ = [CCSprite spriteWithTexture:otherRender_.sprite.texture];
	cutSprite_.position = ccp(renderSize_.width/2.0f,renderSize_.height/2.0f);
	cutSprite_.flipY = YES;
	
	[targetRender_ begin];
	
	if(isReverse_){
		[cutSprite_ visit];
	}else{
		[targetSprite_ visit];
		[cutSprite_ setBlendFunc:(ccBlendFunc){GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
		[cutSprite_ visit];
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

@implementation CMMDrawingUtil(BatchBar)

+(void)drawBar:(CCRenderTexture *)targetRender_ edgeSprite:(CCSprite *)edgeSprite_ barCropWidth:(float)barCropWidth_ startPoint:(CGPoint)startPoint_ width:(float)width_{
	
	[targetRender_ end];
	
	CGSize edgeSize_ = edgeSprite_.contentSize;
	CCRenderTexture *cropBarRender_ = [CCRenderTexture renderTextureWithWidth:barCropWidth_ height:edgeSize_.height];
	CCSprite *tEdgeSprite_ = [CCSprite spriteWithTexture:edgeSprite_.texture rect:edgeSprite_.textureRect];
	tEdgeSprite_.anchorPoint = ccp(0.0f,0.5f);
	
	[cropBarRender_ begin];
	
	[tEdgeSprite_ setBlendFunc:(ccBlendFunc){GL_ONE,GL_ONE}];
	[tEdgeSprite_.texture setAliasTexParameters];
	tEdgeSprite_.flipX = NO;
	tEdgeSprite_.flipY = YES;
	tEdgeSprite_.position = ccp(-edgeSize_.width+barCropWidth_,edgeSize_.height/2.0f);
	[tEdgeSprite_ visit];
	
	[cropBarRender_ end];
	
	CCSprite *barFrameSprite_ = [CCSprite spriteWithTexture:cropBarRender_.sprite.texture];
	[barFrameSprite_ setBlendFunc:(ccBlendFunc){GL_ONE,GL_ONE}];
	[barFrameSprite_.texture setAliasTexParameters];
	barFrameSprite_.anchorPoint = ccp(0.0f,0.5f);
	
	[targetRender_ begin];
	
	CGPoint endPoint_ = ccp(startPoint_.x+width_-edgeSize_.width,startPoint_.y);
	
	barFrameSprite_.scaleY = -1;
	barFrameSprite_.scaleX = (ABS(startPoint_.x-endPoint_.x)-edgeSize_.width)/barFrameSprite_.contentSize.width;
	barFrameSprite_.position = ccp(startPoint_.x+edgeSize_.width,startPoint_.y);
	[barFrameSprite_ visit];
	
	tEdgeSprite_.position = startPoint_;
	tEdgeSprite_.flipX = NO;
	[tEdgeSprite_ visit];
	
	tEdgeSprite_.position = endPoint_;
	tEdgeSprite_.flipX = YES;
	[tEdgeSprite_ visit];
}
+(CCTexture2D *)textureBarWithFrameSize:(CGSize)frameSize_ edgeSprite:(CCSprite *)edgeSprite_ barCropWidth:(float)barCropWidth_ startPoint:(CGPoint)startPoint_ width:(float)width_{
	
	startPoint_.y = frameSize_.height-startPoint_.y;
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:frameSize_.width height:frameSize_.height];
	[render_ begin];
	[self drawBar:render_ edgeSprite:edgeSprite_ barCropWidth:barCropWidth_ startPoint:startPoint_ width:width_];
	[render_ end];
	return render_.sprite.texture;
}

@end

@implementation CMMDrawingUtil(Copy)

+(CCTexture2D *)copyFromTexture:(CCNode *)targetNode_{
	CGSize frameSize_ = targetNode_.contentSize;
	CCRenderTexture *render_ = [[[CCRenderTexture alloc] initWithWidth:frameSize_.width height:frameSize_.height pixelFormat:kCCTexture2DPixelFormat_Default] autorelease];
	
	CCNode *orgParent_ = targetNode_.parent;
	CGPoint orgPoint_ = targetNode_.position;
	float orgYScale_ = targetNode_.scaleY;
	[targetNode_ removeFromParentAndCleanup:NO];
	targetNode_.position = ccp(targetNode_.contentSize.width*targetNode_.anchorPoint.x
							   ,targetNode_.contentSize.height*targetNode_.anchorPoint.y);
	
	[render_ begin];
	
	[render_ addChild:targetNode_];
	targetNode_.scaleY = -1;
	[targetNode_ visit];
	[targetNode_ removeFromParentAndCleanup:NO];
	
	[render_ end];
	
	if(orgParent_)
		[orgParent_ addChild:targetNode_];
	targetNode_.position = orgPoint_;
	targetNode_.scaleY = orgYScale_;
	
	return render_.sprite.texture;
}
+(CCSprite *)copyFromSprite:(CCNode *)targetNode_{
	return [CCSprite spriteWithTexture:[self copyFromTexture:targetNode_]];
}

@end
