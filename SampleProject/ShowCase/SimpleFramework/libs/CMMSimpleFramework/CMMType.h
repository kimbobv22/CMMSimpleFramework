//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"

struct CMMFloatRange{
	float loc,len;
	
	CMMFloatRange(){
		loc = len = 0.0f;
	}
	CMMFloatRange(float loc_,float len_){
		loc = loc_;
		len = len_;
	}
	
	float LimitValue(){
		return loc + len;
	}
	float RandomValue(){
		return len * CCRANDOM_0_1() + loc;
	}
};
typedef CMMFloatRange CMMFloatRange;