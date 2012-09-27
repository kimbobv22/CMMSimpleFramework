//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

enum testIntroState{
	testIntroState_000,
	testIntroState_001,
	testIntroState_002,
};

@interface CommonIntroLayer1 : CMMLayer{
	CCSprite *profileSprite;
	testIntroState introState;
}

@end

@interface CommonIntroLayer2 : CMMLayer{
	CCLabelTTF *labelDisplay;
}

@end
