//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayerMD.h"

@implementation CMMLayerMD
@synthesize touchState,scrollbar,isCanDragX,isCanDragY,isAlwaysShowScrollbar,dragSpeed;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	[touchDispatcher setMaxMultiTouchCount:0];
	isCanDragX = isCanDragY = isAlwaysShowScrollbar = NO;
	scrollbar = CMMLayerMDScrollbar();
	
	dragSpeed = 5.0f;
	[self setTouchState:CMMTouchState_none];
	
	[self scheduleUpdate];
	
	return self;
}

-(void)setTouchState:(CMMTouchState)touchState_{
	touchState = touchState_;
	switch(touchState){
		case CMMTouchState_onTouchChild:
			_doShowScrollbar = NO;
		case CMMTouchState_none:
		case CMMTouchState_onDrag:
		case CMMTouchState_onFixed:
			_curScrollSpeedX = _curScrollSpeedY = 0;
			break;
		default: break;
	}
}

-(void)draw{
	CGPoint beforePoint_ = _innerLayerBeforePoint;
	CGPoint innerLayerPoint_ = [innerLayer position];
	_innerLayerBeforePoint = innerLayerPoint_;
	float diffDistance_ = ccpDistance(beforePoint_, innerLayerPoint_);
	
	if(!_doShowScrollbar && diffDistance_ == 0.0f && !isAlwaysShowScrollbar) return;
	
	_doShowScrollbar = (touchState != CMMTouchState_none || diffDistance_ > 0.0f || isAlwaysShowScrollbar);

	CGSize innerLayerSize_ = [innerLayer contentSize];
	
	float hDiffRate_ = contentSize_.width/innerLayerSize_.width;
	float vDiffRate_ = contentSize_.height/innerLayerSize_.height;
	
	float hScrollBarSize_ = contentSize_.width*hDiffRate_;
	float vScrollBarSize_ = contentSize_.height*vDiffRate_;
	
	CGPoint hScrollPoint_ = ccp(-innerLayerPoint_.x*hDiffRate_,scrollbar.distanceY);
	CGPoint vScrollPoint_ = ccp(contentSize_.width-scrollbar.distanceX,-innerLayerPoint_.y*vDiffRate_);
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	if(isCanDragX){
		glLineWidth(scrollbar.widthX*CC_CONTENT_SCALE_FACTOR());
		ccColor4F tColor_ = ccc4FFromccc4B(scrollbar.colorX);
		ccDrawColor4F(tColor_.r, tColor_.g, tColor_.b, tColor_.a);
		ccDrawLine(hScrollPoint_, ccpAdd(hScrollPoint_, ccp(hScrollBarSize_,0)));
	}
	if(isCanDragY){
		glLineWidth(scrollbar.widthY*CC_CONTENT_SCALE_FACTOR());
		ccColor4F tColor_ = ccc4FFromccc4B(scrollbar.colorY);
		ccDrawColor4F(tColor_.r, tColor_.g, tColor_.b, tColor_.a);
		ccDrawLine(vScrollPoint_, ccpAdd(vScrollPoint_, ccp(0,vScrollBarSize_)));
	}
}

-(void)update:(ccTime)dt_{
	switch(touchState){
		case CMMTouchState_onScroll:{
			CGPoint innerLayerPoint_ = [innerLayer position];
			CGSize itemLimitSize_ = [innerLayer contentSize];
			CGPoint addPoint_ = CGPointZero;
			if(innerLayerPoint_.x>MIN(itemLimitSize_.width-contentSize_.width,0) && innerLayerPoint_.x+itemLimitSize_.width>contentSize_.width){
				addPoint_.x = -(innerLayerPoint_.x+MIN(itemLimitSize_.width-contentSize_.width,0))*dt_*dragSpeed;
				_curScrollSpeedX = 0;
			}else if(innerLayerPoint_.x<MAX(itemLimitSize_.width-contentSize_.width,0) && innerLayerPoint_.x+itemLimitSize_.width<contentSize_.width){
				addPoint_.x = -(innerLayerPoint_.x+MAX(itemLimitSize_.width-contentSize_.width,0))*dt_*dragSpeed;
				_curScrollSpeedX = 0;
			}else addPoint_.x = 0;
			
			if(innerLayerPoint_.y>MIN(itemLimitSize_.height-contentSize_.height,0) && innerLayerPoint_.y+itemLimitSize_.height>contentSize_.height){
				addPoint_.y = -(innerLayerPoint_.y+MIN(itemLimitSize_.height-contentSize_.height,0))*dt_*dragSpeed;
				_curScrollSpeedY = 0;
			}else if(innerLayerPoint_.y<MAX(itemLimitSize_.height-contentSize_.height,0) && innerLayerPoint_.y+itemLimitSize_.height<contentSize_.height){
				addPoint_.y = -(innerLayerPoint_.y+MAX(itemLimitSize_.height-contentSize_.height,0))*dt_*dragSpeed;
				_curScrollSpeedY = 0;
			}else addPoint_.y = 0;
			
			addPoint_.x -= _curScrollSpeedX;
			addPoint_.y -= _curScrollSpeedY;
			
			[innerLayer setPosition:ccpAdd(innerLayerPoint_, addPoint_)];
			
			if(ABS(ccpLength(addPoint_)) <= 0.1f)
				[self setTouchState:CMMTouchState_none];
	
			break;
		}
		default: break;
	}
	
	_curScrollSpeedX -= _curScrollSpeedX*dt_*dragSpeed;
	_curScrollSpeedY -= _curScrollSpeedY*dt_*dragSpeed;
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	if([innerTouchDispatcher touchItemAtIndex:0]) [self setTouchState:CMMTouchState_onTouchChild];
	else [self setTouchState:CMMTouchState_none];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	if(touchState == CMMTouchState_onFixed){
		return;
	}
	
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	
	CMMTouchDispatcherItem *touchItem_ = [innerTouchDispatcher touchItemAtIndex:0];
	
	if((!touchItem_ && touchState == CMMTouchState_onTouchChild) || touchState == CMMTouchState_none){
		[self touchDispatcher:touchDispatcher whenTouchCancelled:touch_ event:event_];
		[self setTouchState:CMMTouchState_onDrag];
	}
	
	switch(touchState){
		case CMMTouchState_onDrag:{
			CGPoint curPoint_ = [CMMTouchUtil pointFromTouch:touch_];
			CGPoint diffPoint_ = ccpSub(curPoint_, [CMMTouchUtil prepointFromTouch:touch_]);
			if(!isCanDragX) diffPoint_.x = 0;
			if(!isCanDragY) diffPoint_.y = 0;
			CGPoint addPoint_ = diffPoint_;
			
			CGPoint innerLayerPoint_ = [innerLayer position];
			CGSize itemLimitSize_ = [innerLayer contentSize];
			
			if(innerLayerPoint_.x>0)
				addPoint_.x *= 1.0f-MIN(innerLayerPoint_.x/contentSize_.width,1);
			else if(innerLayerPoint_.x+itemLimitSize_.width<itemLimitSize_.width)
				addPoint_.x *= MIN((innerLayerPoint_.x+itemLimitSize_.width)/contentSize_.width,1);
			
			if(innerLayerPoint_.y>0)
				addPoint_.y *= 1.0f-MIN(innerLayerPoint_.y/contentSize_.height,1);
			else if(innerLayerPoint_.y+itemLimitSize_.height<itemLimitSize_.height)
				addPoint_.y *= MIN((innerLayerPoint_.y+itemLimitSize_.height)/contentSize_.height,1);
			
			[innerLayer setPosition:ccpAdd(innerLayerPoint_, addPoint_)];
			
			_curScrollSpeedX = -diffPoint_.x;
			_curScrollSpeedY = -diffPoint_.y;
			break;
		}
		default: break;
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	[self setTouchState:(touchState==CMMTouchState_onDrag?CMMTouchState_onScroll:CMMTouchState_none)];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	[self setTouchState:(touchState==CMMTouchState_onDrag?CMMTouchState_onScroll:CMMTouchState_none)];
}

-(void)addChildToInner:(CCNode *)node z:(NSInteger)z tag:(NSInteger)tag{
	[innerLayer addChild:node z:z tag:tag];
}
-(void)addChildToInner:(CCNode *)node z:(NSInteger)z{
	[self addChildToInner:node z:z tag:[node tag]];
}
-(void)addChildToInner:(CCNode *)node{
	[self addChildToInner:node z:[node zOrder]];
}

-(void)removeChildFromInner:(CCNode *)node cleanup:(BOOL)cleanup{
	[innerLayer removeChild:node cleanup:cleanup];
}
-(void)removeChildByTagFromInner:(NSInteger)tag cleanup:(BOOL)cleanup{
	[innerLayer removeChildByTag:tag cleanup:cleanup];
}

@end

@implementation CMMLayerMD(ViewControl)

-(void)gotoTop{
	[innerLayer setPosition:ccp(innerLayer.position.x,-innerLayer.contentSize.height+contentSize_.height)];
}
-(void)gotoBottom{
	[innerLayer setPosition:ccp(innerLayer.position.x,0)];
}

-(void)gotoLeft{
	[innerLayer setPosition:ccp(0,innerLayer.position.y)];
}
-(void)gotoRight{
	[innerLayer setPosition:ccp(-innerLayer.contentSize.width+contentSize_.width,innerLayer.position.y)];
}

@end
