//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface CommonIntroLayer1 : CMMLayer{
	CCSprite *profileSprite;
	CMMSequencer *sequencer;
}

@end

@interface CommonIntroLayer2 : CMMLayer{
	CCLabelTTF *labelDisplay;
	float loadingRate;
	CMMSequencer *loadingMaker;
}

-(void)forwardScene;

@end
