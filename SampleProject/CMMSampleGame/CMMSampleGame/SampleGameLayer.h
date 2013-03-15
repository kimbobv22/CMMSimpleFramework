//
//  SampleGameLayer.h
//  CMMSampleGame
//
//  Created by Kim Jazz on 13. 3. 15..
//  Copyright (c) 2013년 Kim Jazz. All rights reserved.
//

#import "CMMHeader.h"
#import "SamplePopup.h"

@interface TestPlayer : CMMSObject{
	b2Vec2 accelVector;
	float speed;
}

@property (nonatomic, readwrite) b2Vec2 accelVector;
@property (nonatomic, readwrite) float speed;

@end

@interface TestEnemy : TestPlayer

@end

@interface TestGoal : CMMSObject

+(id)goal;

@end

@interface TestGoalSView : CMMSObjectSView

@end

typedef enum{
	TestStageState_pause,
	TestStageState_play,
} TestStageState;

@interface SampleGameLayer : CMMLayer{
	CMMStage *stage;
	TestStageState stageState;
	TestPlayer *player;
}

+(id)gameLayer;

-(void)doGameOver;
-(void)doGameComplete;

-(void)doNextGoal;

@end
