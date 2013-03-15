//
//  SequenceMakerTestLayer.h
//  SimpleFramework
//
//  Created by Kim Jazz on 12. 10. 19..
//
//

#import "CMMHeader.h"

@interface SequenceMakerTestLayer : CMMLayer{
	CMMSequencer *sequencer;
	CCSprite *testSprite;
	CMMMenuItemL *nextBtn,*prevBtn;
}

@end
