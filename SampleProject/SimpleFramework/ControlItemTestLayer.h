//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface ControlItemTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMControlItemSwitchDelegate,CMMControlItemSliderDelegate>{
	CMMControlItemSlider *slider2;
}

@end

@interface ControlItemTestLayer2 : CMMLayer<CMMSceneLoadingProtocol>{
	CMMSpriteBatchBar *batchBar;
	CCLabelTTF *label;
}

@end