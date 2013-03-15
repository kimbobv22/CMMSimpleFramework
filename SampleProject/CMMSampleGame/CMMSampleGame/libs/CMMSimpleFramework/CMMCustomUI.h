//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"

@interface CMMCustomUI : CMMLayer{
	BOOL enable;
}

-(void)update:(ccTime)dt_;

@property (nonatomic, readwrite, getter = isEnable) BOOL enable;

@end
