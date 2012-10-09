//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface SoundTestLayer : CMMLayer<CMMMenuItemDelegate>{
	CMMSoundHandler *handler;
	CMMSprite *listenSprite,*soundSprite1,*soundSprite2;
}

@end
