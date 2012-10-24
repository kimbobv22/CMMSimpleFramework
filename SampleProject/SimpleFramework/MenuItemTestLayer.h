//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface MenuItemTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMMenuItemDelegate>{
	CMMMenuItemLabelTTF *menuItem1,*menuItem2,*menuItem3,*menuItemBack;
	
	CCLabelTTF *displayLabel;
}

@end
