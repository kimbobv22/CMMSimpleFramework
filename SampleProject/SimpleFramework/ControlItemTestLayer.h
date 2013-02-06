//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface ControlItemTestLayer : CMMLayer{
	CMMControlItemText *textField1,*textField2;
	CMMControlItemSwitch *switch1,*switch2;
	CMMControlItemSlider *slider1,*slider2;
}

@end

@interface ControlItemTestLayer2 : CMMLayer{
	CMMSpriteBatchBar *batchBar;
	CCLabelTTF *label;
}

@end