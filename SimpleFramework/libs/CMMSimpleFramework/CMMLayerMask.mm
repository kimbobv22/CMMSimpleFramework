//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayerMask.h"

@implementation CMMLayerMask
@synthesize innerSize,innerColor,innerOpacity,innerPosition;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	_innerLayer = [CMMLayer layerWithColor:ccc4(0, 0, 0, 0)];
	_innerLayer.isTouchEnabled = NO;
	self.innerSize = self.contentSize;
	[self addChildDirect:_innerLayer];
	
	return self;
}

-(void)setInnerSize:(CGSize)innerSize_{
	_innerLayer.contentSize = innerSize_;
}
-(CGSize)innerSize{
	return _innerLayer.contentSize;
}
-(void)setInnerColor:(ccColor3B)innerColor_{
	[_innerLayer setColor:innerColor_];
}
-(ccColor3B)innerColor{
	return _innerLayer.color;
}
-(void)setInnerOpacity:(GLubyte)innerOpacity_{
	_innerLayer.opacity = innerOpacity_;
}
-(GLubyte)innerOpacity{
	return _innerLayer.opacity;
}
-(void)setInnerPosition:(CGPoint)innerPosition_{
	_innerLayer.position = innerPosition_;
}
-(CGPoint)innerPosition{
	return _innerLayer.position;
}

-(CCArray *)children{
	return _innerLayer.children;
}

-(void)addChild:(CCNode *)node z:(NSInteger)z tag:(NSInteger)tag{
	[_innerLayer addChild:node z:z tag:tag];
}

-(CCNode *)getChildByTag:(NSInteger)tag{
	return [_innerLayer getChildByTag:tag];
}

-(void)removeChild:(CCNode *)node cleanup:(BOOL)cleanup{
	[_innerLayer removeChild:node cleanup:cleanup];
}

-(void)addChildDirect:(CCNode *)node z:(NSInteger)z tag:(NSInteger)tag{
	[super addChild:node z:z tag:tag];
}
-(void)addChildDirect:(CCNode *)node z:(NSInteger)z{
	[self addChildDirect:node z:z tag:-1];
}
-(void)addChildDirect:(CCNode *)node{
	[self addChildDirect:node z:0];
}

-(CCNode *)getChildDirectByTag:(NSInteger)tag{
	return [super getChildByTag:tag];
}

-(void)removeChildDirect:(CCNode *)node cleanup:(BOOL)cleanup{
	[super removeChild:node cleanup:cleanup];
}

-(void)innerDraw{
	[_innerLayer draw];
}

-(void)visit{
	glEnable(GL_SCISSOR_TEST);
	CGRect screenRect_;
	screenRect_.origin = ccp(0,0);
	screenRect_.size = self.contentSize;
	screenRect_ = CGRectApplyAffineTransform(screenRect_,[self nodeToWorldTransform]);
	
	glScissor(screenRect_.origin.x*CC_CONTENT_SCALE_FACTOR(), screenRect_.origin.y*CC_CONTENT_SCALE_FACTOR(), screenRect_.size.width*CC_CONTENT_SCALE_FACTOR(), screenRect_.size.height*CC_CONTENT_SCALE_FACTOR());
	
	//draw inner layer first.
	kmGLPushMatrix();
	
	[self transform];
	[super draw];
	[_innerLayer transform];
	[self innerDraw];
	
	CCArray *innerChildren_ = _innerLayer.children;
	ccArray *data_;
	uint count_;
	if(innerChildren_){
		data_ = innerChildren_->data;
		count_ = data_->num;
		for(uint index_=0;index_<count_;index_++){
			CCNode *child_ = data_->arr[index_];
			CGSize spriteSize_ = child_.contentSize;
			CGRect spriteRect_ = CGRectApplyAffineTransform(CGRectMake(0, 0, spriteSize_.width, spriteSize_.height),[child_ nodeToWorldTransform]);
			
			if(CGRectIntersectsRect(spriteRect_,screenRect_))
				[child_ visit];
		}
	}
	
	kmGLPopMatrix();
	
	//draw parent layer second.
	kmGLPushMatrix();
	[self transform];
	[self draw];
	
	glDisable(GL_SCISSOR_TEST);
	
	if(children_){
		data_ = children_->data;
		count_ = data_->num;
		for(uint index_=0;index_<count_;index_++){
			CCNode *child_ = data_->arr[index_];
			if(child_ == _innerLayer) continue;
			[child_ visit];
		}
	}
	
	kmGLPopMatrix();
}

@end

@implementation CMMLayerMaskDrag
@synthesize isCanDragX,isCanDragY,dragAccelRate,touchState;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	touchDispatcher.maxMultiTouchCount = 0;
	isCanDragX = isCanDragY = NO;
	touchState = CMMTouchState_none;
	
	dragAccelRate = 5.0f;
	_scrollAccelX = _scrollAccelY = 0;

	[self scheduleUpdate];
	
	return self;
}

-(void)setTouchState:(CMMTouchState)touchState_{
	touchState = touchState_;
	switch(touchState){
		case CMMTouchState_onDrag:{
			_scrollAccelX = _scrollAccelY = 0;
			break;
		}
		case CMMTouchState_onScroll:
			break;
		case CMMTouchState_none:
		case CMMTouchState_onTouchChild:
		case CMMTouchState_onDragChild:
		case CMMTouchState_onFixed:
		default:
			_scrollAccelX = _scrollAccelY = 0.0f;
			break;
	}
}

-(void)setInnerPosition:(CGPoint)innerPosition_{
	if(ccpDistance(_innerLayer.position,innerPosition_)>= cmmVarCMMLayerMaskDrag_minInnerLayerPositionDiffValue)
		_isInnerLayerMoved = YES;
	[super setInnerPosition:innerPosition_];
}

-(void)draw{
	if(!_isInnerLayerMoved) return;
		
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glLineWidth(2.0f*CC_CONTENT_SCALE_FACTOR());
	ccDrawColor4F(1.0f, 1.0f, 1.0f, 0.5f);
	
	float hDiffRate_ = self.contentSize.width/_innerLayer.contentSize.width;
	float vDiffRate_ = self.contentSize.height/_innerLayer.contentSize.height;
	
	float hScrollBarSize_ = self.contentSize.width*hDiffRate_;
	float vScrollBarSize_ = self.contentSize.height*vDiffRate_;
	
	CGPoint hScrollPoint_ = ccp(-_innerLayer.position.x*hDiffRate_,4);
	CGPoint vScrollPoint_ = ccp(self.contentSize.width-4,-_innerLayer.position.y*vDiffRate_);
	
	if(isCanDragX) ccDrawLine(hScrollPoint_, ccpAdd(hScrollPoint_, ccp(hScrollBarSize_,0)));
	if(isCanDragY) ccDrawLine(vScrollPoint_, ccpAdd(vScrollPoint_, ccp(0,vScrollBarSize_)));
	_isInnerLayerMoved = NO;
}
-(void)_befreDraw{
	[super draw];
}

-(void)update:(ccTime)dt_{
	switch(touchState){
		case CMMTouchState_none:
			break;
		case CMMTouchState_onTouchChild:
			_isInnerLayerMoved = YES;
			break;
		case CMMTouchState_onDrag:
			_isInnerLayerMoved = YES;
			break;
		case CMMTouchState_onFixed:
			break;
		case CMMTouchState_onScroll:{
			_isInnerLayerMoved = YES;
			CGPoint curInnerPoint_ = _innerLayer.position;
			CGSize itemLimitSize_ = self.innerSize;
			CGPoint addPoint_ = CGPointZero;
			if(curInnerPoint_.x>MIN(itemLimitSize_.width-self.contentSize.width,0) && curInnerPoint_.x+itemLimitSize_.width>self.contentSize.width){
				addPoint_.x = -(curInnerPoint_.x+MIN(itemLimitSize_.width-self.contentSize.width,0))*dt_*dragAccelRate;
				_scrollAccelX = 0;
			}else if(curInnerPoint_.x<MAX(itemLimitSize_.width-self.contentSize.width,0) && curInnerPoint_.x+itemLimitSize_.width<self.contentSize.width){
				addPoint_.x = -(curInnerPoint_.x+MAX(itemLimitSize_.width-self.contentSize.width,0))*dt_*dragAccelRate;
				_scrollAccelX = 0;
			}else addPoint_.x = 0;
			
			if(curInnerPoint_.y>MIN(itemLimitSize_.height-self.contentSize.height,0) && curInnerPoint_.y+itemLimitSize_.height>self.contentSize.height){
				addPoint_.y = -(curInnerPoint_.y+MIN(itemLimitSize_.height-self.contentSize.height,0))*dt_*dragAccelRate;
				_scrollAccelY = 0;
			}else if(curInnerPoint_.y<MAX(itemLimitSize_.height-self.contentSize.height,0) && curInnerPoint_.y+itemLimitSize_.height<self.contentSize.height){
				addPoint_.y = -(curInnerPoint_.y+MAX(itemLimitSize_.height-self.contentSize.height,0))*dt_*dragAccelRate;
				_scrollAccelY = 0;
			}else addPoint_.y = 0;
			
			_scrollAccelX -= _scrollAccelX*dt_*dragAccelRate;
			_scrollAccelY -= _scrollAccelY*dt_*dragAccelRate;
			
			addPoint_.x -= _scrollAccelX;
			addPoint_.y -= _scrollAccelY;
			
			if(ABS(ccpLength(addPoint_)) <= 0.1f)
				self.touchState = CMMTouchState_none;
			
			[self setInnerPosition:ccpAdd(_innerLayer.position, addPoint_)];
			break;
		}
		default: break;
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[_innerLayer touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	if([_innerLayer.touchDispatcher touchItemAtIndex:0]) self.touchState = CMMTouchState_onTouchChild;
	else self.touchState = CMMTouchState_none;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[_innerLayer touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	
	CMMTouchDispatcherItem *touchItem_ = [_innerLayer.touchDispatcher touchItemAtIndex:0];
	
	if(!touchItem_)
		self.touchState = CMMTouchState_onDrag;
	else self.touchState = CMMTouchState_onTouchChild;
	
	switch(touchState){
		case CMMTouchState_onDrag:{
			CGPoint curPoint_ = [CMMTouchUtil pointFromTouch:touch_];
			CGPoint diffPoint_ = ccpSub(curPoint_, [CMMTouchUtil prepointFromTouch:touch_]);
			if(!isCanDragX) diffPoint_.x = 0;
			if(!isCanDragY) diffPoint_.y = 0;
			CGPoint addPoint_ = diffPoint_;
			
			CGPoint curInnerPoint_ = _innerLayer.position;
			CGSize itemLimitSize_ = self.innerSize;
			
			if(curInnerPoint_.x>0)
				addPoint_.x *= 1.0f-MIN(curInnerPoint_.x/self.contentSize.width,1);
			else if(curInnerPoint_.x+itemLimitSize_.width<itemLimitSize_.width)
				addPoint_.x *= MIN((curInnerPoint_.x+itemLimitSize_.width)/self.contentSize.width,1);
			
			if(curInnerPoint_.y>0)
				addPoint_.y *= 1.0f-MIN(curInnerPoint_.y/self.contentSize.height,1);
			else if(curInnerPoint_.y+itemLimitSize_.height<itemLimitSize_.height)
				addPoint_.y *= MIN((curInnerPoint_.y+itemLimitSize_.height)/self.contentSize.height,1);
			
			[self setInnerPosition:ccpAdd(_innerLayer.position, addPoint_)];
			
			_scrollAccelX = -diffPoint_.x;
			_scrollAccelY = -diffPoint_.y;
			break;
		}
		default:
			[_innerLayer touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
			break;
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	switch(touchState){
		case CMMTouchState_onDrag:
			break;
		default:
			[_innerLayer touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
			break;
	}
	self.touchState = CMMTouchState_onScroll;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	switch(touchState){
		case CMMTouchState_onDrag:
			break;
		default:
			[_innerLayer touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
			break;
	}
	self.touchState = CMMTouchState_onScroll;
}

@end

@implementation CMMLayerMaskDrag(ViewControl)

-(void)gotoTop{
	[self setInnerPosition:ccp(_innerLayer.position.x,-_innerLayer.contentSize.height+self.contentSize.height)];
}
-(void)gotoBottom{
	[self setInnerPosition:ccp(_innerLayer.position.x,0)];
}

-(void)gotoLeft{
	[self setInnerPosition:ccp(0,_innerLayer.position.y)];
}
-(void)gotoRight{
	[self setInnerPosition:ccp(-_innerLayer.contentSize.width+self.contentSize.width,_innerLayer.position.y)];
}

@end