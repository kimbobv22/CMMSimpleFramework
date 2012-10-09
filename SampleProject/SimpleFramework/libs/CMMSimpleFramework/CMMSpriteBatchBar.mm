//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSpriteBatchBar.h"

@implementation CMMSpriteBatchBar
@synthesize targetSprite,edgeSize,barCropWidth;

+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_ barCropWidth:(float)barCropWidth_{
	return [[[self alloc] initWithTargetSprite:targetSprite_ batchBarSize:batchBarSize_ edgeSize:edgeSize_ barCropWidth:barCropWidth_] autorelease];
}
+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_{
	return [[[self alloc] initWithTargetSprite:targetSprite_ batchBarSize:batchBarSize_ edgeSize:edgeSize_] autorelease];
}
+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_{
	return [[[self alloc] initWithTargetSprite:targetSprite_ batchBarSize:batchBarSize_] autorelease];
}

-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_ barCropWidth:(float)barCropWidth_{
	if(!(self = [super init])) return self;
	
	[self setIgnoreAnchorPointForPosition:NO];
	[self setAnchorPoint:ccp(0.0f,0.0f)];
	
	edgeSize = edgeSize_;
	barCropWidth = barCropWidth_;
	[self setTargetSprite:[CCSprite spriteWithTexture:[targetSprite_ texture] rect:[targetSprite_ textureRect]]];
	[self setContentSize:batchBarSize_];
	
	return self;
}
-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_{
	return [self initWithTargetSprite:targetSprite_ batchBarSize:batchBarSize_ edgeSize:edgeSize_ barCropWidth:1.0f];
}
-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_{
	CGSize edgeSize_ = CGSizeDiv([targetSprite_ contentSize], 2.0f);
	edgeSize_ = CGSizeSub(edgeSize_, CGSizeMake(1.0f, 1.0f));
	return [self initWithTargetSprite:targetSprite_ batchBarSize:batchBarSize_ edgeSize:CGSizeDiv([targetSprite_ contentSize], 2.0f)];
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	_isDirty = YES;
}

-(void)setTargetSprite:(CCSprite *)targetSprite_{
	[self removeAllChildrenWithCleanup:YES];
	[targetSprite release];
	targetSprite = [targetSprite_ retain];
	
	if(targetSprite){
		[self setTexture:[targetSprite texture]];
		CCTexture2D *targetTexture_ = [self texture];
		[targetTexture_ setAliasTexParameters];
		_targetSpriteOrgTextureRect = [targetSprite textureRect];
		
		/// make batch bar ///
		
		CGPoint targetSpriteTexturePoint_ = _targetSpriteOrgTextureRect.origin;
		CGSize targetSpriteTextureSize_ = _targetSpriteOrgTextureRect.size;
		CGRect drawRect_ = CGRectZero;
		
		//top
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + (targetSpriteTextureSize_.width/2.0f - barCropWidth/2.0f), targetSpriteTexturePoint_.y+targetSpriteTextureSize_.height/2.0f);
		drawRect_.size = CGSizeMake(barCropWidth, targetSpriteTextureSize_.height/2.0f);
		_barTopSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_barTopSprite setBatchNode:self];
		[self addChild:_barTopSprite];
		
		//bottom
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + (targetSpriteTextureSize_.width/2.0f - barCropWidth/2.0f), targetSpriteTexturePoint_.y);
		_barBottomSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_barBottomSprite setBatchNode:self];
		[self addChild:_barBottomSprite];
		
		//left
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x, targetSpriteTexturePoint_.y+(targetSpriteTextureSize_.height/2.0f - barCropWidth/2.0f));
		drawRect_.size = CGSizeMake(targetSpriteTextureSize_.width/2.0f, barCropWidth);
		_barLeftSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_barLeftSprite setBatchNode:self];
		[self addChild:_barLeftSprite];
		
		//right
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + targetSpriteTextureSize_.width/2.0f, targetSpriteTexturePoint_.y+(targetSpriteTextureSize_.height/2.0f - barCropWidth/2.0f));
		_barRightSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_barRightSprite setBatchNode:self];
		[self addChild:_barRightSprite];
		
		//back(center)
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + targetSpriteTextureSize_.width/2.0f-barCropWidth/2.0f, targetSpriteTexturePoint_.y + (targetSpriteTextureSize_.height/2.0f - barCropWidth/2.0f));
		drawRect_.size = CGSizeMake(barCropWidth, barCropWidth);
		_backSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_backSprite setBatchNode:self];
		[self addChild:_backSprite];
		
		//edge1(top-left)
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x, targetSpriteTexturePoint_.y);
		drawRect_.size = edgeSize;
		_edge1Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_edge1Sprite setBatchNode:self];
		[self addChild:_edge1Sprite];
		
		//edge2(top-right)
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + (targetSpriteTextureSize_.width-edgeSize.width), targetSpriteTexturePoint_.y);
		drawRect_.size = edgeSize;
		_edge2Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_edge2Sprite setBatchNode:self];
		[self addChild:_edge2Sprite];
		
		//edge3(bottom-left)
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x, targetSpriteTexturePoint_.y + (targetSpriteTextureSize_.height - edgeSize.height));
		drawRect_.size = edgeSize;
		_edge3Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_edge3Sprite setBatchNode:self];
		[self addChild:_edge3Sprite];
		
		//edge4(bottom-left)
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + (targetSpriteTextureSize_.width-edgeSize.width), targetSpriteTexturePoint_.y + (targetSpriteTextureSize_.height - edgeSize.height));
		drawRect_.size = edgeSize;
		_edge4Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_edge4Sprite setBatchNode:self];
		[self addChild:_edge4Sprite];
		
		_isDirty = YES;
	}
}

-(void)setBarCropWidth:(float)barCropWidth_{
	BOOL doRedraw_ = barCropWidth != barCropWidth_;
	barCropWidth = barCropWidth_;
	
	if(doRedraw_)
		[self setTargetSprite:[[targetSprite retain] autorelease]];
}

-(void)visit{
	if(_isDirty){
		CGSize spriteSize_ = [_barTopSprite contentSize];
		
		//top
		[_barTopSprite setScaleX:(contentSize_.width-edgeSize.width*2.0f)/spriteSize_.width];
		[_barTopSprite setPosition:ccp(contentSize_.width/2.0f,spriteSize_.height/2.0f)];
		
		//bottom
		[_barBottomSprite setScaleX:(contentSize_.width-edgeSize.width*2.0f)/spriteSize_.width];
		[_barBottomSprite setPosition:ccp(contentSize_.width/2.0f,contentSize_.height-spriteSize_.height/2.0f)];
		
		spriteSize_ = [_barLeftSprite contentSize];
		
		//left
		[_barLeftSprite setScaleY:(contentSize_.height-edgeSize.height*2.0f)/spriteSize_.height];
		[_barLeftSprite setPosition:ccp(spriteSize_.width/2.0f,contentSize_.height/2.0f)];
		
		//right
		[_barRightSprite setScaleY:(contentSize_.height-edgeSize.height*2.0f)/spriteSize_.height];
		[_barRightSprite setPosition:ccp(contentSize_.width-spriteSize_.width/2.0f,contentSize_.height/2.0f)];
		
		//(back)center
		spriteSize_ = [_backSprite contentSize];
		[_backSprite setScaleX:(contentSize_.width-_targetSpriteOrgTextureRect.size.width/2.0f)/spriteSize_.width];
		[_backSprite setScaleY:(contentSize_.height-_targetSpriteOrgTextureRect.size.height/2.0f)/spriteSize_.height];
		[_backSprite setPosition:ccp(contentSize_.width/2.0f,contentSize_.height/2.0f)];
		
		//edges
		[_edge1Sprite setPosition:ccp(edgeSize.width/2.0f,contentSize_.height-edgeSize.height/2.0f)];
		[_edge2Sprite setPosition:ccp(contentSize_.width-edgeSize.width/2.0f,contentSize_.height-edgeSize.height/2.0f)];
		[_edge3Sprite setPosition:ccp(edgeSize.width/2.0f,edgeSize.height/2.0f)];
		[_edge4Sprite setPosition:ccp(contentSize_.width-edgeSize.width/2.0f,edgeSize.height/2.0f)];
		
		_isDirty = NO;
	}
	
	[super visit];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{}

-(void)dealloc{
	[targetSprite release];
	[super dealloc];
}

@end
