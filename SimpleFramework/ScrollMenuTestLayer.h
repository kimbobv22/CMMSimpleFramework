//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface ScrollMenuTestLayer : CMMLayer{
	
}

@end

@interface ScrollMenuTestLayer_H : CMMLayer<CMMScrollMenuHDelegate>{
	CMMScrollMenuH *scrollMenu;
	CCLabelTTF *labelDisplay;
}

@end

@interface ScrollMenuTestLayer_V : CMMLayer<CMMScrollMenuVDelegate>{
	CMMScrollMenuV *scrollMenu1,*scrollMenu2;
	CCLabelTTF *labelDisplay;
}

@end