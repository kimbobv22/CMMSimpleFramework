//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayerMD.h"

@implementation CMMLayerMD
@synthesize touchState,scrollbar,canDragX,canDragY,alwaysShowScrollbar,dragSpeed;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	[touchDispatcher setMaxMultiTouchCount:0];
	canDragX = canDragY = alwaysShowScrollbar = NO;
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
	
	if(!_doShowScrollbar && diffDistance_ == 0.0f && !alwaysShowScrollbar) return;
	
	_doShowScrollbar = (touchState != CMMTouchState_none || diffDistance_ > 0.0f || alwaysShowScrollbar);

	CGSize innerLayerSize_ = [innerLayer contentSize];
	
	float hDiffRate_ = contentSize_.width/innerLayerSize_.width;
	float vDiffRate_ = contentSize_.height/innerLayerSize_.height;
	
	float hScrollBarSize_ = contentSize_.width*hDiffRate_;
	float vScrollBarSize_ = contentSize_.height*vDiffRate_;
	
	CGPoint hScrollPoint_ = ccp(-innerLayerPoint_.x*hDiffRate_,scrollbar.distanceY);
	CGPoint vScrollPoint_ = ccp(contentSize_.width-scrollbar.distanceX,-innerLayerPoint_.y*vDiffRate_);
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	if(canDragX){
		glLineWidth(scrollbar.widthX*CC_CONTENT_SCALE_FACTOR());
		ccColor4F tColor_ = ccc4FFromccc4B(scrollbar.colorX);
		ccDrawColor4F(tColor_.r, tColor_.g, tColor_.b, tColor_.a);
		ccDrawLine(hScrollPoint_, ccpAdd(hScrollPoint_, ccp(hScrollBarSize_,0)));
	}
	if(canDragY){
		glLineWidth(scrollbar.widthY*CC_CONTENT_SCALE_FACTOR());
		ccColor4F tColor_ = ccc4FFromccc4B(scrollbar.colorY);
		ccDrawColor4F(tColor_.r, tColor_.g, tColor_.b, tColor_.a);
		ccDrawLine(vScrollPoint_, ccpAdd(vScrollPoint_, ccp(0,vScrollBarSize_)));
	}
}

-(void)update:(ccTime)dt_{
	switch(touchState){
		case CMMTouchState_onScroll:{
			CGPoint innerLayerOrgPoint_ = [innerLayer position];
			CGPoint innerLayerPoint_ = innerLayerOrgPoint_;
			CGPoint innerLayerAnchorPoint_ = [innerLayer anchorPoint];
			CGSize innerLayerSize_ = [innerLayer contentSize];
			CGSize innerLayerOffsetSize_ = CGSizeMake(innerLayerSize_.width*0.5f-contentSize_.width*0.5f, innerLayerSize_.height*0.5f-contentSize_.height*0.5f);
			CGPoint addPoint_ = CGPointZero;
			innerLayerPoint_ = ccpSub(innerLayerPoint_, ccp((innerLayerSize_.width * innerLayerAnchorPoint_.x),(innerLayerSize_.height * innerLayerAnchorPoint_.y))); //set zero point.
			innerLayerPoint_ = ccpAdd(innerLayerPoint_, ccpFromSize(innerLayerOffsetSize_)); //set center point
		
			float tempABSValue_ = ABS(innerLayerPoint_.x);
			if(tempABSValue_ > innerLayerOffsetSize_.width){
				_curScrollSpeedX = ((tempABSValue_ - innerLayerOffsetSize_.width) * dt_ * dragSpeed) * (innerLayerPoint_.x>0?1.0f:-1.0f);
			}
			
			tempABSValue_ = ABS(innerLayerPoint_.y);
			if(tempABSValue_ > innerLayerOffsetSize_.height){
				_curScrollSpeedY = ((tempABSValue_ - innerLayerOffsetSize_.height) * dt_ * dragSpeed) * (innerLayerPoint_.y>0?1.0f:-1.0f);
			}
			
			addPoint_.x -= _curScrollSpeedX;
			addPoint_.y -= _curScrollSpeedY;
			
			_curScrollSpeedX -= _curScrollSpeedX*dt_*dragSpeed;
			_curScrollSpeedY -= _curScrollSpeedY*dt_*dragSpeed;
			
			if(ABS(ccpLength(addPoint_)) <= 0.1f){
				addPoint_.x -= _curScrollSpeedX;
				addPoint_.y -= _curScrollSpeedY;
				[self setTouchState:CMMTouchState_none];
			}
			[innerLayer setPosition:ccpAdd(innerLayerOrgPoint_, addPoint_)];
			break;
		}
		default: break;
	}
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
			if(!canDragX) diffPoint_.x = 0;
			if(!canDragY) diffPoint_.y = 0;
			CGPoint addPoint_ = diffPoint_;
			
			CGPoint innerLayerOrgPoint_ = [innerLayer position];
			CGPoint innerLayerPoint_ = innerLayerOrgPoint_;
			CGPoint innerLayerAnchorPoint_ = [innerLayer anchorPoint];
			CGSize innerLayerSize_ = [innerLayer contentSize];
			CGSize innerLayerOffsetSize_ = CGSizeMake(innerLayerSize_.width*0.5f-contentSize_.width*0.5f, innerLayerSize_.height*0.5f-contentSize_.height*0.5f);
			innerLayerPoint_ = ccpSub(innerLayerPoint_, ccp((innerLayerSize_.width * innerLayerAnchorPoint_.x),(innerLayerSize_.height * innerLayerAnchorPoint_.y))); //set zero point.
			innerLayerPoint_ = ccpAdd(innerLayerPoint_, ccpFromSize(innerLayerOffsetSize_)); //set center point
			
			float tempABSValue_ = ABS(innerLayerPoint_.x+addPoint_.x);
			if(tempABSValue_>innerLayerOffsetSize_.width){
				addPoint_.x *= MAX(0.8f - (tempABSValue_ - innerLayerOffsetSize_.width) / contentSize_.width,0.0f);
			}
			
			tempABSValue_ = ABS(innerLayerPoint_.y+addPoint_.y);
			if(tempABSValue_>innerLayerOffsetSize_.height){
				addPoint_.y *= MAX(0.8f - (tempABSValue_ - innerLayerOffsetSize_.height) / contentSize_.height,0.0f);
			}
			
			[innerLayer setPosition:ccpAdd(innerLayerOrgPoint_, addPoint_)];
			
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
