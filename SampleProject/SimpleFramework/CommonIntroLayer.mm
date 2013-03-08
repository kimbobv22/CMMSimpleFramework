//  Created by JGroup(kimbobv22@gmail.com)

#import "CommonIntroLayer.h"
#import "HelloWorldLayer.h"
#import "AppDelegate.h"

@implementation CommonIntroLayer1

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	profileSprite = [CCSprite spriteWithFile:@"develop.png"];
	[profileSprite setPosition:cmmFunc_positionIPN(self, profileSprite)];
	[profileSprite setOpacity:0];
	[self addChild:profileSprite];
	
	sequencer = [[CMMSequencer alloc] init];
	[sequencer addSequenceForMainQueue:^{
		CCLOG(@"intro sequence 1");
		[profileSprite runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.5f],[CCDelayTime actionWithDuration:5.0f],[CCCallFunc actionWithTarget:sequencer selector:@selector(callSequence)], nil]];
	}];
	
	[sequencer addSequenceForMainQueue:^{
		CCLOG(@"intro sequence 2");
		[profileSprite stopAllActions];
		[profileSprite setOpacity:255];
		[profileSprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.5f],[CCCallFunc actionWithTarget:sequencer selector:@selector(callSequence)], nil]];
	}];
	[sequencer addSequenceForMainQueue:^{
		CCLOG(@"intro sequence 3");
		[profileSprite stopAllActions];
		[profileSprite setOpacity:0];
	} callback:^{
		[[CMMScene sharedScene] pushLayer:[CommonIntroLayer2 node]];
	}];
	
	return self;
}
-(void)sceneDidEndTransition:(CMMScene *)scene_{
	[sequencer callSequence];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	if([sequencer state] == CMMSequencerState_waitingNextSequence){
		[sequencer callSequence];
	}
}

-(void)cleanup{
	[sequencer cleanup];
	[super cleanup];
}

-(void)dealloc{
	[sequencer release];
	[super dealloc];
}

@end

@implementation CommonIntroLayer2

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	labelDisplay = [CMMFontUtil labelWithString:@" "];
	[self addChild:labelDisplay];
	[self _setDisplayStr:@"Loading..."];
	
	loadingRate = 0.0f;
	
	loadingMaker = [[CMMSequencerAuto alloc] init];
	[loadingMaker setCallback_whenStateChanged:^{
		loadingRate = ((float)[loadingMaker sequenceIndex]+1)/(float)([loadingMaker count]);
	}];
	
	//loading resources
	[loadingMaker addSequenceForMainQueue:^{
		[self _setDisplayStr:@"Loading Resources..."];
	}];
	[loadingMaker addSequenceForBackgroundQueue:^{
		//sprite frame
		[[CMMDrawingManager sharedManager] addDrawingItemWithFileName:@"IMG_CMN_BFRAME_000"];
		
		//motion(gyro)
		[CMMMotionDispatcher sharedDispatcher];
		
		//sound engine
		[CMMSoundEngine sharedEngine];
		
		//notice template
		[[CMMScene sharedScene] noticeDispatcher].noticeTemplate = [CMMNoticeDispatcherTemplate_DefaultScale templateWithNoticeDispatcher:[[CMMScene sharedScene] noticeDispatcher]];
	}];
	
	//connecting to Game center
	[loadingMaker addSequenceForMainQueue:^{
		[self _setDisplayStr:@"connecting to Game Center..."];
	}];
	[loadingMaker addSequenceForMainQueue:^{
		if(![[CMMGameKitPA sharedPA] isAvailableGameCenter]){
			[self forwardScene];
			return;
		}
		
		[[CMMGameKitPA sharedPA] setAuthenticateHandler:^(CMMGameKitPAAuthenticationState state_, NSError *error_) {
			switch(state_){
				case CMMGameKitPAAuthenticationState_succeed:{
					[self _setDisplayStr:@"reporting Achievements..."];
					[[CMMGameKitAchievements sharedAchievements] reportCachedAchievementsWithBlock:^(NSArray *reportedAchievements_, NSError *error_) {
						if(error_){
							[self forwardScene];
						}else{
							[[CMMGameKitAchievements sharedAchievements] loadReportedAchievementsWithBlock:^(NSError *error_) {
								[self forwardScene];
							}];
						}
					}];
					break;
				}
				case CMMGameKitPAAuthenticationState_cancelled:
				case CMMGameKitPAAuthenticationState_failed:
				default:{
					[self forwardScene];
					break;
				}
			}
		}];
	}];
	
	return self;
}

-(void)sceneDidEndTransition:(CMMScene *)scene_{
	[loadingMaker callSequence];
}

-(void)_setDisplayStr:(NSString *)str_{
	[labelDisplay setString:str_];
	[labelDisplay setPosition:cmmFunc_positionIPN(self, labelDisplay)];
}

-(void)draw{
	[super draw];
	
	ccDrawColor4B(255, 255, 255, 120.0f);
	glLineWidth(5.0f*CC_CONTENT_SCALE_FACTOR());
	CGPoint lineStartPoint_ = ccp(0,_contentSize.height*0.08f);
	ccDrawLine(lineStartPoint_, ccpAdd(lineStartPoint_, ccp(_contentSize.width,0)));
	
	ccDrawColor4B(0, 0, 120, 120.0f);
	glLineWidth(3.0f*CC_CONTENT_SCALE_FACTOR());
	ccDrawLine(lineStartPoint_, ccpAdd(lineStartPoint_, ccp(_contentSize.width*loadingRate,0)));
}

-(void)forwardScene{
	//release delegate from CMMGameKitPA
	[[CMMGameKitPA sharedPA] setCallback_whenAuthenticationChanged:nil];
	[[CMMGameKitPA sharedPA] setAuthenticateHandler:nil];
	
	/*
	 set HelloWorldLayer to static layer.
	 static layer can be saved self state.
	 */
	CMMScene *scene_ = [CMMScene sharedScene];
	[scene_ addStaticLayerItemWithLayer:[HelloWorldLayer node] atKey:_HelloWorldLayer_key_];
	
	/*
	 push static layer to scene.
	 */
	[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
}

-(void)cleanup{
	[loadingMaker cleanup];
	[super cleanup];
}
-(void)dealloc{
	[loadingMaker release];
	[super dealloc];
}

@end
