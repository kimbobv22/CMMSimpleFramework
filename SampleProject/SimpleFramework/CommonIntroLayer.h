//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface CommonIntroLayer1 : CMMLayer<CMMSceneLoadingProtocol,CMMSequenceMakerDelegate>{
	CCSprite *profileSprite;
	CMMSequenceMaker *sequencer;
}

@end

@interface CommonIntroLayer2 : CMMLayer<CMMSceneLoadingProtocol,CMMGameKitPADelegate,CMMGameKitAchievementsDelegate>{
	CCLabelTTF *labelDisplay;
}

-(void)forwardScene;

@end
