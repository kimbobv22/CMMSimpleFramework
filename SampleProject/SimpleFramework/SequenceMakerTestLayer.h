//
//  SequenceMakerTestLayer.h
//  SimpleFramework
//
//  Created by Kim Jazz on 12. 10. 19..
//
//

#import "CMMHeader.h"

@interface SequenceMakerTestLayer : CMMLayer<CMMSequenceMakerDelegate>{
	CMMSequenceMaker *sequencer;
	CCSprite *testSprite;
	CMMMenuItemLabelTTF *startBtn,*nextBtn,*prevBtn;
}

@end
