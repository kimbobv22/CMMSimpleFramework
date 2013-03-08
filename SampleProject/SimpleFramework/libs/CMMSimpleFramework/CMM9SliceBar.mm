//  Created by JGroup(kimbobv22@gmail.com)

#import "CMM9SliceBar.h"

@implementation CMM9SliceBar
@synthesize targetSprite,edgeOffset;

+(id)sliceBarWithTargetSprite:(CCSprite *)targetSprite_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_{
	return [[[self alloc] initWithTargetSprite:targetSprite_ edgeOffset:edgeOffset_] autorelease];
}
+(id)sliceBarWithTargetSprite:(CCSprite *)targetSprite_{
	return [[[self alloc] initWithTargetSprite:targetSprite_] autorelease];
}

-(id)initWithTargetSprite:(CCSprite *)targetSprite_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_{
	if(!(self = [super initWithTexture:[targetSprite_ texture] capacity:9])) return self;
	[self setIgnoreAnchorPointForPosition:NO];
	[self setAnchorPoint:ccp(0.0f,0.0f)];
	
	edgeOffset = edgeOffset_;
	[self setTargetSprite:targetSprite_];
	[self setContentSize:[targetSprite contentSize]];
	
	return self;
}
-(id)initWithTargetSprite:(CCSprite *)targetSprite_{
	CGSize frameSize_ = CGSizeDiv([targetSprite_ contentSize], 2.0f);
	CMM9SliceEdgeOffset edgeOffset_ = CMM9SliceEdgeOffset(CGSizeSub(frameSize_,CGSizeMake(2.0f,2.0f)));
	return [self initWithTargetSprite:targetSprite_ edgeOffset:edgeOffset_];
}

-(void)setContentSize:(CGSize)contentSize_{
	CGSize targetSpriteSize_ = [targetSprite contentSize];
	if(contentSize_.width < targetSpriteSize_.width)
		contentSize_.width = targetSpriteSize_.width;
	if(contentSize_.height < targetSpriteSize_.height)
		contentSize_.height = targetSpriteSize_.height;
	
	[super setContentSize:contentSize_];
	_dirty = YES;
}

-(void)setTargetSprite:(CCSprite *)targetSprite_{
	[targetSprite release];
	targetSprite = [targetSprite_ retain];
	[self setEdgeOffset:edgeOffset];
}
-(void)setEdgeOffset:(CMM9SliceEdgeOffset)edgeOffset_{
	edgeOffset = edgeOffset_;
	[self removeAllChildrenWithCleanup:YES];
	
	CCTexture2D *targetTexture_ = [targetSprite texture];
	[self setTexture:targetTexture_];
	[targetTexture_ setAliasTexParameters];
	CGRect targetSpriteRect_ = [targetSprite textureRect];
	
	/// make batch bar ///
	CGPoint targetSpriteTexturePoint_ = targetSpriteRect_.origin;
	CGSize targetSpriteTextureSize_ = targetSpriteRect_.size;
	CGRect drawRect_ = CGRectZero;
	
	//top
	drawRect_.origin = ccp(targetSpriteTexturePoint_.x + edgeOffset.left, targetSpriteTexturePoint_.y);
	drawRect_.size = CGSizeMake(targetSpriteTextureSize_.width-edgeOffset.left-edgeOffset.right, edgeOffset.top);
	_barTopSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
	[_barTopSprite setBatchNode:self];
	[self addChild:_barTopSprite z:1];

	//bottom
	drawRect_.origin = ccp(targetSpriteTexturePoint_.x + edgeOffset.left, targetSpriteTexturePoint_.y+targetSpriteTextureSize_.height-edgeOffset.bottom);
	drawRect_.size = CGSizeMake(drawRect_.size.width, edgeOffset.bottom);
	_barBottomSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
	[_barBottomSprite setBatchNode:self];
	[self addChild:_barBottomSprite z:1];
	
	//left
	drawRect_.origin = ccp(targetSpriteTexturePoint_.x, targetSpriteTexturePoint_.y+edgeOffset.bottom);
	drawRect_.size = CGSizeMake(edgeOffset.left, targetSpriteTextureSize_.height-edgeOffset.bottom-edgeOffset.top);
	_barLeftSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
	[_barLeftSprite setBatchNode:self];
	[self addChild:_barLeftSprite z:1];	

	//right
	drawRect_.origin = ccp(targetSpriteTexturePoint_.x + targetSpriteTextureSize_.width - edgeOffset.right, targetSpriteTexturePoint_.y+edgeOffset.bottom);
	drawRect_.size = CGSizeMake(edgeOffset.right, targetSpriteTextureSize_.height-edgeOffset.bottom-edgeOffset.top);
	_barRightSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
	[_barRightSprite setBatchNode:self];
	[self addChild:_barRightSprite z:1];
	
	//back(center)
	drawRect_.origin = ccp(targetSpriteTexturePoint_.x + edgeOffset.left, targetSpriteTexturePoint_.y + edgeOffset.bottom);
	drawRect_.size = CGSizeMake(targetSpriteTextureSize_.width-edgeOffset.left-edgeOffset.right, targetSpriteTextureSize_.height-edgeOffset.bottom-edgeOffset.top);
	_backSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
	[_backSprite setBatchNode:self];
	[self addChild:_backSprite z:9];

	//edge1(bottom-left)
	drawRect_.origin = ccp(targetSpriteTexturePoint_.x, targetSpriteTexturePoint_.y+targetSpriteTextureSize_.height-edgeOffset.bottom);
	drawRect_.size = CGSizeMake(edgeOffset.left, edgeOffset.bottom);
	_edge1Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
	[_edge1Sprite setBatchNode:self];
	[self addChild:_edge1Sprite z:0];
	
	//edge2(bottom-right)
	drawRect_.origin = ccp(targetSpriteTexturePoint_.x + targetSpriteTextureSize_.width-edgeOffset.right, targetSpriteTexturePoint_.y+targetSpriteTextureSize_.height-edgeOffset.bottom);
	drawRect_.size = CGSizeMake(edgeOffset.right, edgeOffset.bottom);
	_edge2Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
	[_edge2Sprite setBatchNode:self];
	[self addChild:_edge2Sprite z:0];
	
	//edge3(top-left)
	drawRect_.origin = ccp(targetSpriteTexturePoint_.x, targetSpriteTexturePoint_.y);
	drawRect_.size = CGSizeMake(edgeOffset.left, edgeOffset.top);
	_edge3Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
	[_edge3Sprite setBatchNode:self];
	[self addChild:_edge3Sprite z:0];
	
	//edge4(top-right)
	drawRect_.origin = ccp(targetSpriteTexturePoint_.x + targetSpriteTextureSize_.width-edgeOffset.right, targetSpriteTexturePoint_.y);
	drawRect_.size = CGSizeMake(edgeOffset.right, edgeOffset.top);
	_edge4Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
	[_edge4Sprite setBatchNode:self];
	[self addChild:_edge4Sprite z:0];
	
	_dirty = YES;
}

-(void)visit{
	if(_dirty){
		CGSize spriteSize_ = [_barTopSprite contentSize];

		//top
		[_barTopSprite setScaleX:(_contentSize.width-edgeOffset.left-edgeOffset.right)/spriteSize_.width];
		[_barTopSprite setPosition:ccp(_contentSize.width*0.5f,_contentSize.height-edgeOffset.top*0.5f)];
		
		//bottom
		[_barBottomSprite setScaleX:(_contentSize.width-edgeOffset.left-edgeOffset.right)/spriteSize_.width];
		[_barBottomSprite setPosition:ccp(_contentSize.width*0.5f,edgeOffset.bottom*0.5f)];
	
		spriteSize_ = [_barLeftSprite contentSize];

		//left
		[_barLeftSprite setScaleY:(_contentSize.height-edgeOffset.top-edgeOffset.bottom)/spriteSize_.height];
		[_barLeftSprite setPosition:ccp(edgeOffset.left*0.5f,_contentSize.height*0.5f)];

		//right
		[_barRightSprite setScaleY:(_contentSize.height-edgeOffset.top-edgeOffset.bottom)/spriteSize_.height];
		[_barRightSprite setPosition:ccp(_contentSize.width-edgeOffset.right*0.5f,_contentSize.height*0.5f)];
	
		//(back)center
		spriteSize_ = [_backSprite contentSize];
		[_backSprite setScaleX:(_contentSize.width-edgeOffset.left-edgeOffset.right)/spriteSize_.width];
		[_backSprite setScaleY:(_contentSize.height-edgeOffset.top-edgeOffset.bottom)/spriteSize_.height];
		[_backSprite setPosition:ccp(_contentSize.width*0.5f,_contentSize.height*0.5f)];
			
		//edges
		[_edge1Sprite setPosition:ccp(edgeOffset.left*0.5f,edgeOffset.bottom*0.5f)];
		[_edge2Sprite setPosition:ccp(_contentSize.width-edgeOffset.right*0.5f,edgeOffset.bottom*0.5f)];
		[_edge3Sprite setPosition:ccp(edgeOffset.left*0.5f,_contentSize.height-edgeOffset.top*0.5f)];
		[_edge4Sprite setPosition:ccp(_contentSize.width-edgeOffset.right*0.5f,_contentSize.height-edgeOffset.top*0.5f)];
		
		_dirty = NO;
	}
	
	[super visit];
}

-(void)setColor:(ccColor3B)color{
	if(!_children) return;
	for(CCSprite *sprite_ in _children){
		[sprite_ setColor:color];
	}
}
-(ccColor3B)color{
	return [_backSprite color];
}
-(ccColor3B)displayedColor{
	return [_backSprite displayedColor];
}
-(void)updateDisplayedColor:(ccColor3B)color{
	if(!_children) return;
	for(CCSprite *sprite_ in _children){
		[sprite_ updateDisplayedColor:color];
	}
}
-(void)setCascadeColor:(BOOL)cascadeColor{
	if(!_children) return;
	for(CCSprite *sprite_ in _children){
		[sprite_ setCascadeColor:cascadeColor];
	}
}
-(BOOL)cascadeColor{
	return [_backSprite cascadeColor];
}

-(void)setOpacity:(GLubyte)opacity{
	if(!_children) return;
	for(CCSprite *sprite_ in _children){
		[sprite_ setOpacity:opacity];
	}
}
-(GLubyte)opacity{
	return [_backSprite opacity];
}
-(GLubyte)displayedOpacity{
	return [_backSprite displayedOpacity];
}
-(void)updateDisplayedOpacity:(GLubyte)opacity{
	if(!_children) return;
	for(CCSprite *sprite_ in _children){
		[sprite_ updateDisplayedOpacity:opacity];
	}
}
-(void)setCascadeOpacity:(BOOL)cascadeOpacity{
	if(!_children) return;
	for(CCSprite *sprite_ in _children){
		[sprite_ setCascadeOpacity:cascadeOpacity];
	}
}
-(BOOL)cascadeOpacity{
	return [_backSprite cascadeOpacity];
}

-(void)dealloc{
	[targetSprite release];
	[super dealloc];
}

@end