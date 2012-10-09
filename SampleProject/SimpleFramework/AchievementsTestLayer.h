//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface AchievementsTestLayer : CMMLayer<CMMGameKitAchievementsDelegate>{
	CMMMenuItemSet *menu;
	CCLabelTTF *displayLb;
	BOOL useGameCenterBanner;
}

@end
