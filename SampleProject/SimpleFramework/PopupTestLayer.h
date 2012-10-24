//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface PopupTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMPopupDispatcherDelegate,CMMMenuItemDelegate>{
	CCLabelTTF *testLabel;
	CMMMenuItemLabelTTF *menuItemOpen,*menuItemClose;
}

@end
