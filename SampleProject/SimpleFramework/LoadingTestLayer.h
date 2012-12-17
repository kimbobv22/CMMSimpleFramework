//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface LoadingTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMMenuItemDelegate>{
	CMMMenuItemL *menuItemBack;
	CCLabelTTF *displayLabel;
}

@end
