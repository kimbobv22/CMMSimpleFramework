//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface AchievementsTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMGameKitAchievementsDelegate>{
	CMMMenuItemSet *menu;
	CCLabelTTF *displayLb;
	BOOL useGameCenterBanner;
}

@end
