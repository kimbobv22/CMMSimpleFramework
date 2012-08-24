//  Created by JGroup(kimbobv22@gmail.com)

#define cmmFuncCommon_position_center(_parent_,_target_) ccp((_parent_).contentSize.width*(0.5f-(_parent_).anchorPoint.x)-(_target_).contentSize.width*(0.5f-(_target_).anchorPoint.x),(_parent_).contentSize.height*(0.5f-(_parent_).anchorPoint.y)-(_target_).contentSize.height*(0.5f-(_target_).anchorPoint.y))

#define cmmFuncCommon_respondsToSelector(_delegate_,_selector_) ((_delegate_) && [(_delegate_) respondsToSelector:(_selector_)])