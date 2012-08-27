//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

static CGRect cmmFuncCommon_nodeToworldRect(CCNode *node_){
	CGRect rect_ = CGRectZero;
	rect_.size = node_.contentSize;
	return CGRectApplyAffineTransform(rect_, [node_ nodeToWorldTransform]);
}

static CGPoint cmmFuncCommon_position_center(CGRect parentRect_,CGPoint parentAPoint_,CGRect targetRect_,CGPoint targetAPoint_){
	return ccp((parentRect_.origin.x+parentRect_.size.width*(0.5f-parentAPoint_.x))-(targetRect_.origin.x+targetRect_.size.width*(0.5f-targetAPoint_.x)),(parentRect_.origin.y+parentRect_.size.height*(0.5f-parentAPoint_.y))-(targetRect_.origin.y+targetRect_.size.height*(0.5f-targetAPoint_.y)));
}
static CGPoint cmmFuncCommon_position_center(CCNode *parent_,CCNode *target_){
	CGRect parentRect_ = CGRectZero;
	parentRect_.size = parent_.contentSize;
	CGRect targetRect_ = CGRectZero;
	targetRect_.size = target_.contentSize;
	return cmmFuncCommon_position_center(parentRect_, parent_.anchorPoint, targetRect_, target_.anchorPoint);
}

#define cmmFuncCommon_respondsToSelector(_delegate_,_selector_) ((_delegate_) && [(_delegate_) respondsToSelector:(_selector_)])