//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayerPinchZoom.h"

@implementation CMMLayerPinchZoom
@synthesize pinchState,pinchRateMax,pinchRateMin;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	pinchState = CMMPinchState_none;
	_touchDistance = 0;
	pinchRateMax = 1.7;
	pinchRateMin = 0.3;
	
	return self;
}

-(void)setCMMPinchState:(CMMPinchState)pinchState_{
	if(pinchState == pinchState_) return;
	pinchState = pinchState_;
	switch(pinchState){
		case CMMPinchState_none:
			_touchDistance = 0;
			break;
		default: break;
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	
	if(touchDispatcher.touchCount>0){
		self.pinchState = CMMPinchState_OnTouchChild;
	}else if(touchDispatcher_.touchCount>=2){
		self.pinchState = CMMPinchState_onPinch;
	}else self.pinchState = CMMPinchState_none;
	
	switch(pinchState){
		case CMMPinchState_onPinch:{
			CGPoint targetPoint_ = self.position;
			
			UITouch *touch1_ = [touchDispatcher_ touchItemAtIndex:0].touch;
			UITouch *touch2_ = [touchDispatcher_ touchItemAtIndex:1].touch;
			
			CGPoint touchPoint1_ = [CMMTouchUtil pointFromTouch:touch1_];
			CGPoint touchPoint2_ = [CMMTouchUtil pointFromTouch:touch2_];
			CGPoint diffPoint_ = ccpSub(touchPoint1_, touchPoint2_);
			
			CGPoint preTouchPoint1_ = [CMMTouchUtil prepointFromTouch:touch1_];
			CGPoint preTouchPoint2_ = [CMMTouchUtil prepointFromTouch:touch2_];
			CGPoint preDiffPoint_ = ccpSub(preTouchPoint1_, preTouchPoint2_);
			
			CGPoint midPoint_ = ccpMidpoint(touchPoint1_, touchPoint2_);
			CGPoint convertMidPoint_ = [self convertToNodeSpace:midPoint_];
			CGPoint preMidPoint_ = ccpMidpoint(preTouchPoint1_, preTouchPoint2_);
			CGPoint midDiffPoint_ = ccpSub(midPoint_,preMidPoint_);
			
			//calculate rotation
		/*	float diffDistance_ = ccpDistance(convertMidPoint_, targetPoint_);
			float diffRadians_ = (ccpToAngle(diffPoint_)-ccpToAngle(preDiffPoint_));
			float orgRoration_ = self.rotation;
			float resultRoration_ = orgRoration_;
			resultRoration_ += (-CC_RADIANS_TO_DEGREES(diffRadians_))*0.5f;
			[self setRotation:resultRoration_];*/
			
			//calculate scale
			float orgScale_ = self.scale;
			float resultScale_ = orgScale_;
			resultScale_ += ((ccpLength(diffPoint_)-ccpLength(preDiffPoint_))/ccpLength(diffPoint_))*0.5f;
			resultScale_ = MAX(MIN(pinchRateMax, resultScale_),pinchRateMin);
			float diffScale_ = orgScale_-resultScale_;
			[self setScale:resultScale_];
			
			//calculate position
			targetPoint_ = ccpAdd(targetPoint_, ccpMult(midDiffPoint_, 0.5f)); //issue
			targetPoint_.x -= anchorPointInPoints_.x; //restore anchorPointInPoint to zero
			targetPoint_.y -= anchorPointInPoints_.y;
			
			CGPoint tAnchorPoint_ = ccp(convertMidPoint_.x/contentSize_.width,convertMidPoint_.y/contentSize_.height);
			CGPoint tAnchorPointInPoint_ = ccp(contentSize_.width*tAnchorPoint_.x,contentSize_.height*tAnchorPoint_.y);
			
			targetPoint_.x += tAnchorPointInPoint_.x*diffScale_;
			targetPoint_.y += tAnchorPointInPoint_.y*diffScale_;
			
			[self setPosition:targetPoint_];
			
			break;
		}
		default: break;
	}
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	if(touchDispatcher_.touchCount<2 && pinchState == CMMPinchState_onPinch)
		self.pinchState = CMMPinchState_none;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	if(touchDispatcher_.touchCount<2 && pinchState == CMMPinchState_onPinch)
		self.pinchState = CMMPinchState_none;
}

@end
