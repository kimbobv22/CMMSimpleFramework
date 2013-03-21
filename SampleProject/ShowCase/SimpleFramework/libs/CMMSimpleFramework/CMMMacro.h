//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import <objc/message.h>

#define cmmFunc_MINMAX(_value_,_minValue_,_maxValue_) MIN(MAX((_value_),(_minValue_)), (_maxValue_))

inline static float ccpToAngle(CGPoint point1_, CGPoint point2_){
	return ccpToAngle(ccpSub(point1_, point2_));
}

inline static CGSize CGSizeFromccp(CGPoint point_){
	return CGSizeMake(point_.x, point_.y);
}

inline static CGPoint ccpDiv(float x_, float y_,float divValue_){
	return CGPointMake(x_/divValue_,y_/divValue_);
}
inline static CGPoint ccpDiv(CGPoint point_, float divValue_){
	return ccpDiv(point_.x,point_.y,divValue_);
}

inline static CGSize CGSizeAdd(CGSize size1_, CGSize size2_){
	return CGSizeMake(size1_.width+size2_.width, size1_.height+size2_.height);
}
inline static CGSize CGSizeSub(CGSize size1_, CGSize size2_){
	return CGSizeMake(size1_.width-size2_.width, size1_.height-size2_.height);
}

inline static CGSize CGSizeMult(CGSize size_, float multValue_){
	return CGSizeMake(size_.width*multValue_, size_.height*multValue_);
}

inline static CGSize CGSizeDiv(CGSize size_, float divValue_){
	return CGSizeMake(size_.width/divValue_,size_.height/divValue_);
}

inline static float CGSizeDot(CGSize size1_, CGSize size2_){
	return size1_.width*size2_.width + size1_.height*size2_.height;
}

inline static float CGSizeLength(CGSize size_){
	return sqrtf(CGSizeDot(size_, size_));
}

inline static CGPoint ccpOffset(float x_, float y_ ,float radians_,float offset_){
	return CGPointMake(x_+cosf(radians_)*offset_,y_+sinf(radians_)*offset_);
}
inline static CGPoint ccpOffset(CGPoint point_,float radians_,float offset_){
	return ccpOffset(point_.x,point_.y,radians_,offset_);
}

inline static NSRange NSRangeMake(uint loc_, uint len_){
	return NSMakeRange(loc_, len_);
}

inline static float cmmFunc_fixRadians(float radians_){
	return atan2f(sinf(radians_), cosf(radians_));
}
inline static float cmmFunc_fixDegrees(float degrees_){
	return CC_RADIANS_TO_DEGREES(cmmFunc_fixRadians(CC_DEGREES_TO_RADIANS(degrees_)));
}

inline static CGRect cmmFunc_nodeToWorldRect(CCNode *node_){
	CGRect rect_ = CGRectZero;
	rect_.size = node_.contentSize;
	return CGRectApplyAffineTransform(rect_, [node_ nodeToWorldTransform]);
}

//position in parent node
inline static CGPoint cmmFunc_positionIPN(CGRect sourceRect_,CGRect targetRect_,CGPoint targetAPoint_,CGPoint ratio_, CGPoint offset_){
	CGPoint resultPoint_ = CGPointMake((sourceRect_.origin.x+sourceRect_.size.width*ratio_.x)-(targetRect_.origin.x+targetRect_.size.width*(0.5f-targetAPoint_.x)),(sourceRect_.origin.y+sourceRect_.size.height*ratio_.y)-(targetRect_.origin.y+targetRect_.size.height*(0.5f-targetAPoint_.y)));
	resultPoint_.x += offset_.x;
	resultPoint_.y += offset_.y;
	return resultPoint_;
}

inline static CGPoint cmmFunc_positionIPN(CGRect sourceRect_,CGRect targetRect_,CGPoint targetAPoint_,CGPoint ratio_){
	return cmmFunc_positionIPN(sourceRect_,targetRect_,targetAPoint_,ratio_,CGPointZero);
}
inline static CGPoint cmmFunc_positionIPN(CCNode *parentNode_,CCNode *targetNode_,CGPoint ratio_,CGPoint offset_){
	CGRect parentRect_ = CGRectZero;
	parentRect_.size = [parentNode_ contentSize];
	CGRect targetRect_ = CGRectZero;
	targetRect_.size = [targetNode_ contentSize];
	return cmmFunc_positionIPN(parentRect_, targetRect_, [targetNode_ anchorPoint],ratio_,offset_);
}
inline static CGPoint cmmFunc_positionIPN(CCNode *parentNode_,CCNode *targetNode_,CGPoint ratio_){
	return cmmFunc_positionIPN(parentNode_, targetNode_, ratio_, CGPointZero);
}
inline static CGPoint cmmFunc_positionIPN(CCNode *parentNode_,CCNode *targetNode_){
	return cmmFunc_positionIPN(parentNode_,targetNode_,CGPointMake(0.5f, 0.5f),CGPointZero);
}

//position from other node
inline static CGPoint cmmFunc_positionFON(CCNode *otherNode_,CCNode *targetNode_,CGPoint ratio_,CGPoint offset_){
	CGPoint otherPoint_ = [otherNode_ position];
	CGPoint otherAnchorPoint_ = [otherNode_ anchorPoint];
	CGSize otherSize_ = [otherNode_ contentSize];
	CGSize targetSize_ = [targetNode_ contentSize];
	CGPoint targetAnchorPoint_ = [targetNode_ anchorPoint];
	
	// set combine size
	CGPoint resultPoint_ = otherPoint_;
	CGSize resultSize_ = CGSizeDiv(CGSizeAdd(otherSize_, targetSize_), 2.0f);
	resultSize_ = CGSizeMake((resultSize_.width)*ratio_.x, (resultSize_.height)*ratio_.y);
	
	// set center point
	resultPoint_.x -= otherSize_.width * otherAnchorPoint_.x;
	resultPoint_.y -= otherSize_.height * otherAnchorPoint_.y;
	resultPoint_ = ccpAdd(resultPoint_, ccpDiv(ccpFromSize(otherSize_),2.0f));
	resultPoint_.x += targetSize_.width * targetAnchorPoint_.x;
	resultPoint_.y += targetSize_.height * targetAnchorPoint_.y;
	resultPoint_ = ccpSub(resultPoint_, ccpDiv(ccpFromSize(targetSize_),2.0f));
	resultPoint_ = ccpAdd(resultPoint_, offset_);
	
	return ccpAdd(resultPoint_, ccpFromSize(resultSize_));
}
inline static CGPoint cmmFunc_positionFON(CCNode *otherNode_,CCNode *targetNode_,CGPoint ratio_){
	return cmmFunc_positionFON(otherNode_, targetNode_, ratio_, CGPointZero);
}

inline static BOOL cmmFunc_respondsToSelector(id target_,SEL selector_){
	return (target_ && [target_ respondsToSelector:selector_]);
}

inline static void cmmFunc_callMainQueue(void(^block_)()){
	dispatch_async(dispatch_get_main_queue(),block_);
}
inline static void cmmFunc_callBackQueue(dispatch_queue_priority_t priority_,void(^block_)()){
	dispatch_async(dispatch_get_global_queue(priority_,0), block_);
}
inline static void cmmFunc_callBackQueue(void(^block_)()){
	cmmFunc_callBackQueue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, block_);
}