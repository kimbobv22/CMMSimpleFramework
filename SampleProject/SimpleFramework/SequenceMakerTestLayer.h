//
//  SequenceMakerTestLayer.h
//  SimpleFramework
//
//  Created by Kim Jazz on 12. 10. 19..
//
//

#import "CMMHeader.h"

@interface SequenceMakerTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMSequenceMakerDelegate>{
	CMMSequenceMaker *sequencer;
	CCSprite *testSprite;
	CMMMenuItemL *startBtn,*nextBtn,*prevBtn;
}

@end
