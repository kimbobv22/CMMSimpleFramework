//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import <objc/message.h>

static CGPoint ccpOffset(CGPoint centerPoint_,float radians_,float offset_){
	return ccp(centerPoint_.x+cosf(radians_)*offset_,centerPoint_.y+sinf(radians_)*offset_);
}