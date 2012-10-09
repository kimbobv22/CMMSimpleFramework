//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMTouchDispatcherScene.h"
#import "CMMScene.h"

@implementation CMMTouchDispatcherScene
@end

@implementation CMMTouchDispatcherScene(Handler)

-(void)whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	CMMScene *scene_ = (CMMScene *)target;
	CMMPopupDispatcherItem *popupItem_ = [[scene_ popupDispatcher] popupItemAtIndex:0];
	
	//handling popup
	if(popupItem_){
		[self addTouchItemWithTouch:touch_ node:popupItem_.popup];
		objc_msgSend(popupItem_.popup, [CMMTouchDispatcher touchSelectorAtTouchSelectID:TouchSelectorID_began], self, touch_, event_);
	}else{
		if(scene_.isOnTransition || !scene_.runningLayer) return;
		[super whenTouchBegan:touch_ event:event_];
	}
}

@end