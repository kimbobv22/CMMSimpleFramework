//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface CommonIntroLayer1 : CMMLayer<CMMSequenceMakerDelegate>{
	CCSprite *profileSprite;
	CMMSequenceMaker *sequencer;
}

@end

@interface CommonIntroLayer2 : CMMLayer<CMMGameKitPADelegate,CMMGameKitAchievementsDelegate>{
	CCLabelTTF *labelDisplay;
}

-(void)forwardScene;

@end
