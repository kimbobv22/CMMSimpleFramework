//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMheader.h"

@interface CustomUITestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMCustomUIJoypadDelegate>{
	CMMStage *stage;
	
	CMMSObject *target;
	CMMCustomUIJoypad *joypad;
	CCLabelTTF *labelA,*labelYou;
	
	b2Vec2 targetAccelVector;
}

-(void)update:(ccTime)dt_;

@end
