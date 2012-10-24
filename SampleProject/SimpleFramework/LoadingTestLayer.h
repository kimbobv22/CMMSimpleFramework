//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface LoadingTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMMenuItemDelegate>{
	CMMMenuItemLabelTTF *menuItemBack;
	CCLabelTTF *displayLabel;
}

@end
