//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMheader.h"

@interface CustomUITestObject : CCSprite{
	CGPoint accelVector;
}

-(void)update:(ccTime)dt_;

@property (nonatomic, readwrite) CGPoint accelVector;

@end

@interface CustomUITestLayer : CMMLayer<CMMCustomUIJoypadDelegate>{
	CustomUITestObject *target;
	CMMCustomUIJoypad *joypad;
	
	CCLabelTTF *labelA,*labelB;
}

-(void)update:(ccTime)dt_;

@end
