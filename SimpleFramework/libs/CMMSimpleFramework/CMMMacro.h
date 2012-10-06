//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import <objc/message.h>

static float cmmFuncCommon_fixRadians(float radians_){
	return atan2f(sinf(radians_), cosf(radians_));
}
static float cmmFuncCommon_fixDegrees(float degrees_){
	return CC_RADIANS_TO_DEGREES(cmmFuncCommon_fixRadians(CC_DEGREES_TO_RADIANS(degrees_)));
}

static float ccpToAngle(CGPoint point1_, CGPoint point2_){
	return ccpToAngle(ccpSub(point1_, point2_));
}

static CGSize CGSizeFromccp(CGPoint point_){
	return CGSizeMake(point_.x, point_.y);
}

static CGPoint ccpDiv(float x_, float y_,float divValue_){
	return CGPointMake(x_/divValue_,y_/divValue_);
}
static CGPoint ccpDiv(CGPoint point_, float divValue_){
	return ccpDiv(point_.x,point_.y,divValue_);
}

static CGSize CGSizeAdd(CGSize size1_, CGSize size2_){
	return CGSizeMake(size1_.width+size2_.width, size1_.height+size2_.height);
}
static CGSize CGSizeSub(CGSize size1_, CGSize size2_){
	return CGSizeMake(size1_.width-size2_.width, size1_.height-size2_.height);
}

static CGSize CGSizeMult(CGSize size_, float multValue_){
	return CGSizeMake(size_.width*multValue_, size_.height*multValue_);
}

static CGSize CGSizeDiv(CGSize size_, float divValue_){
	return CGSizeMake(size_.width/divValue_,size_.height/divValue_);
}

static float CGSizeDot(CGSize size1_, CGSize size2_){
	return size1_.width*size2_.width + size1_.height*size2_.height;
}

static float CGSizeLength(CGSize size_){
	return sqrtf(CGSizeDot(size_, size_));
}

static CGPoint ccpOffset(float x_, float y_ ,float radians_,float offset_){
	return CGPointMake(x_+cosf(radians_)*offset_,y_+sinf(radians_)*offset_);
}
static CGPoint ccpOffset(CGPoint point_,float radians_,float offset_){
	return ccpOffset(point_.x,point_.y,radians_,offset_);
}

static NSRange NSRangeMake(uint loc_, uint len_){
	return NSMakeRange(loc_, len_);
}

static CGRect cmmFuncCommon_nodeToworldRect(CCNode *node_){
	CGRect rect_ = CGRectZero;
	rect_.size = node_.contentSize;
	return CGRectApplyAffineTransform(rect_, [node_ nodeToWorldTransform]);
}

static CGPoint cmmFuncCommon_position_center(CGRect parentRect_,CGPoint parentAPoint_,CGRect targetRect_,CGPoint targetAPoint_){
	return CGPointMake((parentRect_.origin.x+parentRect_.size.width*(0.5f-parentAPoint_.x))-(targetRect_.origin.x+targetRect_.size.width*(0.5f-targetAPoint_.x)),(parentRect_.origin.y+parentRect_.size.height*(0.5f-parentAPoint_.y))-(targetRect_.origin.y+targetRect_.size.height*(0.5f-targetAPoint_.y)));
}
static CGPoint cmmFuncCommon_position_center(CCNode *parent_,CCNode *target_){
	CGRect parentRect_ = CGRectZero;
	parentRect_.size = [parent_ contentSize];
	CGRect targetRect_ = CGRectZero;
	targetRect_.size = [target_ contentSize];
	return cmmFuncCommon_position_center(parentRect_, [parent_ anchorPoint], targetRect_, [target_ anchorPoint]);
}

static BOOL cmmFuncCommon_respondsToSelector(id target_,SEL selector_){
	return (target_ && [target_ respondsToSelector:selector_]);
}