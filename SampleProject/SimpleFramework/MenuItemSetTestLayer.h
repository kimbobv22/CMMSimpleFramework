//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface MenuItemSetTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMMenuItemSetDelegate>{
	CMMMenuItemSet *menuItemSet;
	CMMMenuItemLabelTTF *alignTypeChangeBtn,*lineHAlignTypeChangeBtn,*lineVAlignTypeChangeBtn;
}

@end
