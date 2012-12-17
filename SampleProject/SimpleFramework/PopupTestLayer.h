//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface PopupTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMPopupDispatcherDelegate>{
	CCLabelTTF *testLabel;
	CMMMenuItemL *menuItemOpen,*menuItemClose;
}

@end
