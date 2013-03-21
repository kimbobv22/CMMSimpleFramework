//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayerMD.h"

static CCSprite *_staticCMMLayerMD_DefaultScrollbarX_ = nil;
static CCSprite *_staticCMMLayerMD_DefaultScrollbarY_ = nil;

@implementation CMMLayerMD{
	float _curScrollSpeedX,_curScrollSpeedY;
	
	BOOL _onScrolling;
	CGPoint _targetInnerLayerPosition;
}
@synthesize scrollbarX,scrollbarY,scrollbarOffsetX,scrollbarOffsetY,scrollResistance,scrollSpeed,canDragX,canDragY,alwaysShowScrollbar,innerLayerTouchEnable;
@synthesize currentScrollSpeedX = _curScrollSpeedX,currentScrollSpeedY = _curScrollSpeedY;
@synthesize onScrolling = _onScrolling;

+(void)_initializeScrollbar{
	CGSize targetSize_ = CGSizeMake(2.0f, 2.0f);
	CCRenderTexture *render_ = [CCRenderTexture renderTextureWithWidth:(int)targetSize_.width height:(int)targetSize_.height];
	[render_ begin];
	
	ccDrawSolidRect(CGPointZero, ccpFromSize(targetSize_), ccc4f(1.0f, 1.0f, 1.0f, 0.5f));
	
	[render_ end];
	
	CCSprite *resultSprite_ = [render_ sprite];
	
	if(!_staticCMMLayerMD_DefaultScrollbarX_){
		[self setDefaultScrollbarX:resultSprite_];
	}
	if(!_staticCMMLayerMD_DefaultScrollbarY_){
		[self setDefaultScrollbarY:resultSprite_];
	}
}
+(void)setDefaultScrollbarX:(CCSprite *)scrollbar_{
	[_staticCMMLayerMD_DefaultScrollbarX_ release];
	_staticCMMLayerMD_DefaultScrollbarX_ = [scrollbar_ retain];
}
+(CCSprite *)defaultScrollbarX{
	if(!_staticCMMLayerMD_DefaultScrollbarX_){
		[self _initializeScrollbar];
	}
	
	return _staticCMMLayerMD_DefaultScrollbarX_;
}

+(void)setDefaultScrollbarY:(CCSprite *)scrollbar_{
	[_staticCMMLayerMD_DefaultScrollbarY_ release];
	_staticCMMLayerMD_DefaultScrollbarY_ = [scrollbar_ retain];
}
+(CCSprite *)defaultScrollbarY{
	if(!_staticCMMLayerMD_DefaultScrollbarY_){
		[self _initializeScrollbar];
	}
	
	return _staticCMMLayerMD_DefaultScrollbarY_;
}

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	[touchDispatcher setMaxMultiTouchCount:0];
	canDragX = canDragY = alwaysShowScrollbar = NO;
	
	CCSprite *scrollbarSpriteX_ = [[self class] defaultScrollbarX];
	CCSprite *scrollbarSpriteY_ = [[self class] defaultScrollbarX];
	[self setScrollbarX:[CMM9SliceBar sliceBarWithTargetSprite:[CCSprite spriteWithTexture:[scrollbarSpriteX_ texture] rect:[scrollbarSpriteX_ textureRect]] edgeOffset:CMM9SliceEdgeOffset(0.5f,0.5f)]];
	[self setScrollbarY:[CMM9SliceBar sliceBarWithTargetSprite:[CCSprite spriteWithTexture:[scrollbarSpriteY_ texture] rect:[scrollbarSpriteY_ textureRect]] edgeOffset:CMM9SliceEdgeOffset(0.5f,0.5f)]];
	scrollbarOffsetX = scrollbarOffsetY = 5.0f;
	scrollResistance = 0.4f;
	scrollSpeed = 5.0f;
	
	[self setInnerPosition:CGPointZero applyScrolling:NO];
	
	[self scheduleUpdate];
	
	return self;
}

-(void)setScrollbarX:(CMM9SliceBar *)scrollbarX_{
	if(!scrollbarX_) return;
	
	if(scrollbarX){
		[scrollbarX removeFromParentAndCleanup:YES];
	}
	scrollbarX = scrollbarX_;
	[self addChild:scrollbarX_];
}
-(void)setScrollbarY:(CMM9SliceBar *)scrollbarY_{
	if(!scrollbarY_) return;
	
	if(scrollbarY){
		[scrollbarY removeFromParentAndCleanup:YES];
	}
	scrollbarY = scrollbarY_;
	[self addChild:scrollbarY_];
}

-(void)setInnerPosition:(CGPoint)point_ applyScrolling:(BOOL)applyScrolling_{
	_targetInnerLayerPosition = point_;
	_onScrolling = applyScrolling_;
}
-(void)setInnerPosition:(CGPoint)point_{
	[self setInnerPosition:point_ applyScrolling:YES];
}

-(void)draw{
	[scrollbarX setVisible:NO];
	[scrollbarY setVisible:NO];
	
	if(![self isOnScrolling] && !alwaysShowScrollbar) return;

	CGPoint innerLayerPoint_ = [innerLayer position];
	CGSize innerLayerSize_ = [innerLayer contentSize];
	
	CMMFloatRange scrollbarRangeX_ = CMMFloatRange(MIN(-0.01f,innerLayerPoint_.x),MAX(_contentSize.width,innerLayerPoint_.x+innerLayerSize_.width));
	CMMFloatRange scrollbarRangeY_ = CMMFloatRange(MIN(-0.01f,innerLayerPoint_.y),MAX(_contentSize.height,innerLayerPoint_.y+innerLayerSize_.height));
	
	float scrollbarSizeX_ = _contentSize.width * (_contentSize.width/(scrollbarRangeX_.len - scrollbarRangeX_.loc));
	float scrollbarSizeY_ = _contentSize.height * (_contentSize.height/(scrollbarRangeY_.len - scrollbarRangeY_.loc));
	float scrollbarPointX_ = (_contentSize.width-scrollbarSizeX_) * ABS(scrollbarRangeX_.loc/((scrollbarRangeX_.len - scrollbarRangeX_.loc) - _contentSize.width)) + scrollbarOffsetX;
	float scrollbarPointY_ = (_contentSize.height-scrollbarSizeY_) * ABS(scrollbarRangeY_.loc/((scrollbarRangeY_.len - scrollbarRangeY_.loc) - _contentSize.height)) + scrollbarOffsetY;
	
	[scrollbarX setContentSize:CGSizeMake(scrollbarSizeX_-scrollbarOffsetX*2.0f, [scrollbarX contentSize].height)];
	[scrollbarY setContentSize:CGSizeMake([scrollbarY contentSize].width, scrollbarSizeY_-scrollbarOffsetY*2.0f)];
	
	[scrollbarX setPosition:ccp(scrollbarPointX_,scrollbarOffsetY)];
	[scrollbarY setPosition:ccp(_contentSize.width-[scrollbarY contentSize].width-scrollbarOffsetX,scrollbarPointY_)];
	
	[scrollbarX setVisible:canDragX];
	[scrollbarY setVisible:canDragY];
}

-(void)update:(ccTime)dt_{
	CGPoint innerPoint_ = [innerLayer position];
	CGPoint addPoint_ = CGPointZero;
	uint touchCount_ = [touchDispatcher touchCount];
	addPoint_ = ccpSub(_targetInnerLayerPosition, innerPoint_);
	CGSize frameSize_ = _contentSize;
	CGSize innerSize_ = [innerLayer contentSize];

	float overLengthX_ = 0.0f;
	float overLengthY_ = 0.0f;
	if(frameSize_.width - innerPoint_.x < frameSize_.width){
		overLengthX_ = -(frameSize_.width - (frameSize_.width - innerPoint_.x));
	}else if(innerPoint_.x + innerSize_.width < frameSize_.width){
		overLengthX_ = frameSize_.width - (innerPoint_.x + innerSize_.width);
	}
	
	if(frameSize_.height - innerPoint_.y < frameSize_.height){
		overLengthY_ = -(frameSize_.height - (frameSize_.height - innerPoint_.y));
	}else if(innerPoint_.y + innerSize_.height < frameSize_.height){
		overLengthY_ = frameSize_.height - (innerPoint_.y + innerSize_.height);
	}
	
	float absOverLengthX_ = ABS(overLengthX_);
	float absOverLengthY_ = ABS(overLengthY_);
	
	if(absOverLengthX_ > 0.0f){
		addPoint_.x *= ((1.0f-scrollResistance) + (absOverLengthX_ / frameSize_.width)) * 0.5f;
	}
	if(absOverLengthY_ > 0.0f){
		addPoint_.y *= ((1.0f-scrollResistance) + (absOverLengthY_ / frameSize_.height)) * 0.5f;
	}
	
	_targetInnerLayerPosition = ccpAdd(innerPoint_, addPoint_);
	
	if(touchCount_ == 0){
		addPoint_ = CGPointZero;
		if(absOverLengthX_ > 0.0f){
			float offsetX_ = overLengthX_*(absOverLengthX_ > 0.1f ? scrollSpeed*dt_ : 1.0f);
			addPoint_.x += offsetX_;
			_onScrolling = YES;
			_curScrollSpeedX = 0.0f;
		}
		if(absOverLengthY_ > 0.0f){
			float offsetY_ = overLengthY_*(absOverLengthY_ > 0.1f ? scrollSpeed*dt_ : 1.0f);
			addPoint_.y += offsetY_;
			_onScrolling = YES;
			_curScrollSpeedY = 0.0f;
		}
		
		if(ABS(_curScrollSpeedX) > 0.0f || ABS(_curScrollSpeedY) > 0.0f){
			CGPoint scrollAddPoint_ = ccp(_curScrollSpeedX*scrollSpeed*dt_,_curScrollSpeedY*scrollSpeed*dt_);
			_curScrollSpeedX -= (((_curScrollSpeedX) * scrollResistance) * scrollSpeed) * dt_;
			_curScrollSpeedY -= (((_curScrollSpeedY) * scrollResistance) * scrollSpeed) * dt_;
			
			if(ccpLength(scrollAddPoint_) <= 0.01f){
				scrollAddPoint_.x += _curScrollSpeedX;
				scrollAddPoint_.y += _curScrollSpeedY;
				_curScrollSpeedX = _curScrollSpeedY = 0.0f;
			}
			
			addPoint_ = ccpAdd(addPoint_, scrollAddPoint_);
			_onScrolling = YES;
		}
		
		_targetInnerLayerPosition = ccpAdd(_targetInnerLayerPosition, addPoint_);
	}
	
	if(_onScrolling){
		_onScrolling = ccpDistance(innerPoint_,_targetInnerLayerPosition) > 0.0f || touchCount_ > 0;
	}
	[innerLayer setPosition:_targetInnerLayerPosition];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	if([self isOnScrolling]){
		_curScrollSpeedX = _curScrollSpeedY = 0.0f;
		[self setInnerPosition:[innerLayer position]];
		[touchDispatcher addTouchItemWithTouch:touch_ node:innerLayer];
		return;
	}
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	if([[self innerTouchDispatcher] touchCount] > 0){
		[innerLayer touchDispatcher:touchDispatcher whenTouchMoved:touch_ event:event_];
		return;
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	
	CMMTouchDispatcherItem *touchItem_ = [[self innerTouchDispatcher] touchItemAtTouch:touch_];
	if(!touchItem_){
		_curScrollSpeedX = _curScrollSpeedY = 0.0f;
		
		CGPoint innerPoint_ = [innerLayer position];
		CGPoint addPoint_ = ccpSub([CMMTouchUtil pointFromTouch:touch_], [CMMTouchUtil prepointFromTouch:touch_]);
		if(!canDragX) addPoint_.x = 0.0f;
		if(!canDragY) addPoint_.y = 0.0f;
		
		[self setInnerPosition:ccpAdd(innerPoint_, addPoint_)];
		_onScrolling = YES;
		
		_curScrollSpeedX += addPoint_.x*scrollSpeed;
		_curScrollSpeedY += addPoint_.y*scrollSpeed;
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	_curScrollSpeedX = 0.0f;
	_curScrollSpeedY = 0.0f;
}

@end

@implementation CMMLayerMD(ViewControl)

-(void)gotoTop{
	[self setInnerPosition:ccp([innerLayer position].x,-[innerLayer contentSize].height+_contentSize.height) applyScrolling:NO];
}
-(void)gotoBottom{
	[self setInnerPosition:ccp([innerLayer position].x,0) applyScrolling:NO];
}

-(void)gotoLeft{
	[self setInnerPosition:ccp(0,[innerLayer position].y) applyScrolling:NO];
}
-(void)gotoRight{
	[self setInnerPosition:ccp(-[innerLayer contentSize].width+_contentSize.width,[innerLayer position].y) applyScrolling:NO];
}

@end
