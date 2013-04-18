//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface ControlItemTestLayer : CMMLayer{
	CMMControlItemText *textField1,*textField2;
	CMMControlItemSwitch *switch1,*switch2;
	CMMControlItemSlider *slider1,*slider2;
	CMMControlItemCheckbox *checkBox;
	CMMControlItemCombo *combo1,*combo2;
}

@end

@interface TestSliceBar : CMM9SliceBar<CMMTouchDispatcherDelegate>

@end

@interface ControlItemTestLayer2 : CMMLayer{
	TestSliceBar *batchBar;
	CCLabelTTF *label;
}

@end