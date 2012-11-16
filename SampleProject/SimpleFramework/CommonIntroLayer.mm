//  Created by JGroup(kimbobv22@gmail.com)

#import "CommonIntroLayer.h"
#import "HelloWorldLayer.h"
#import "AppDelegate.h"

@implementation CommonIntroLayer1

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	profileSprite = [CCSprite spriteWithFile:@"develop.png"];
	[profileSprite setPosition:cmmFuncCommon_positionInParent(self, profileSprite)];
	[profileSprite setOpacity:0];
	[self addChild:profileSprite];
	
	sequencer = [[CMMSequenceMaker alloc] init];
	[sequencer setDelegate:self];
	[sequencer setSequenceMethodFormatter:@"seq%03d"];
	
	return self;
}
-(void)sceneDidEndLoading:(CMMScene *)scene_{
	[sequencer start];
}

-(void)seq000{
	[profileSprite runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.5f],[CCDelayTime actionWithDuration:2.0f],[CCCallFunc actionWithTarget:sequencer selector:@selector(stepSequence)], nil]];
}

-(void)seq001{
	[profileSprite stopAllActions];
	[profileSprite setOpacity:255];
	[profileSprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.5f],[CCCallFunc actionWithTarget:sequencer selector:@selector(stepSequence)], nil]];
}

-(void)sequenceMakerDidEnd:(CMMSequenceMaker *)sequenceMaker_{
	[profileSprite stopAllActions];
	[profileSprite setOpacity:0];
	[[CMMScene sharedScene] pushLayer:[CommonIntroLayer2 node]];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	if([sequencer sequenceState] == CMMSequenceMakerState_waitingNextSequence){
		[sequencer stepSequence];
	}
}

-(void)cleanup{
	[sequencer setDelegate:nil];
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
	
	labelDisplay = [CMMFontUtil labelWithstring:@" "];
	[self addChild:labelDisplay];
	[self _setDisplayStr:@"Loading..."];
	
	loadingRate = 0.0f;
	
	return self;
}

-(void)_setDisplayStr:(NSString *)str_{
	[labelDisplay setString:str_];
	[labelDisplay setPosition:cmmFuncCommon_positionInParent(self, labelDisplay)];
}

-(void)draw{
	[super draw];
	
	ccDrawColor4B(255, 255, 255, 120.0f);
	glLineWidth(5.0f*CC_CONTENT_SCALE_FACTOR());
	CGPoint lineStartPoint_ = ccp(0,contentSize_.height*0.08f);
	ccDrawLine(lineStartPoint_, ccpAdd(lineStartPoint_, ccp(contentSize_.width,0)));
	
	ccDrawColor4B(0, 0, 120, 120.0f);
	glLineWidth(3.0f*CC_CONTENT_SCALE_FACTOR());
	ccDrawLine(lineStartPoint_, ccpAdd(lineStartPoint_, ccp(contentSize_.width*loadingRate,0)));
}

-(void)scene:(CMMScene *)scene_ didChangeLoadingSequence:(uint)curSequence_ sequenceCount:(uint)sequenceCount_{
	loadingRate = ((float)curSequence_)/(float)(sequenceCount_);
}

-(void)sceneLoadingProcess000{
	[self _setDisplayStr:@"Loading sprite frame..."];
}
-(void)sceneLoadingProcess001{
	[[CMMDrawingManager sharedManager] addDrawingItemWithFileName:@"IMG_CMN_BFRAME_000"];
}

-(void)sceneLoadingProcess002{
	[self _setDisplayStr:@"Initializing gyroscope..."];
}
-(void)sceneLoadingProcess003{
	[CMMMotionDispatcher sharedDispatcher];
}

-(void)sceneLoadingProcess004{
	[self _setDisplayStr:@"Initializing sound engine..."];
}
-(void)sceneLoadingProcess005{
	[CMMSoundEngine sharedEngine];
}

-(void)sceneLoadingProcess006{
	[self _setDisplayStr:@"Initializing notice template..."];
}
-(void)sceneLoadingProcess007{
	[[CMMScene sharedScene] noticeDispatcher].noticeTemplate = [CMMNoticeDispatcherTemplate_DefaultScale templateWithNoticeDispatcher:[[CMMScene sharedScene] noticeDispatcher]];
}

-(void)sceneLoadingProcess008{
	[self _setDisplayStr:@"connecting to Game Center..."];
}

-(void)sceneDidEndLoading:(CMMScene *)scene_{
	if(![[CMMGameKitPA sharedPA] isAvailableGameCenter]){
		[self forwardScene];
		return;
	}
	
	[[CMMGameKitPA sharedPA] setDelegate:self];
}

//handling game center login view.
/*-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenTryAuthenticationWithViewController:(UIViewController *)viewController_{
	AppController *appDelegate_ = (AppController*)[[UIApplication sharedApplication] delegate];
	[[appDelegate_ navController] presentViewController:viewController_ animated:YES completion:nil];
}*/
-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenCompletedAuthenticationWithLocalPlayer:(GKPlayer *)localPlayer_{
	[[CMMGameKitAchievements sharedAchievements] setDelegate:self];
	[[CMMGameKitAchievements sharedAchievements] reportCachedAchievements];
}
-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenFailedAuthenticationWithError:(NSError *)error_{
	[self forwardScene];
}

-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenCompletedReportingAchievements:(NSArray *)achievements_{
	CCLOG(@"whenCompletedReportingAchievements : count %d",[achievements_ count]);
	[[CMMGameKitAchievements sharedAchievements] loadReportedAchievements];
}
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedReportingAchievementsWithError:(NSError *)error_{
	CCLOG(@"whenFailedReportingAchievementsWithError : %@",[error_ debugDescription]);
	[self forwardScene];
}

-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenReceiveAchievements:(NSArray *)achievements_{
	CCLOG(@"whenReceiveAchievements : count %d",[achievements_ count]);
	[self forwardScene];
}
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedReceivingAchievementsWithError:(NSError *)error_{
	CCLOG(@"whenFailedReceivingAchievementsWithError : %@",[error_ debugDescription]);
	[self forwardScene];
}

-(void)forwardScene{
	//release delegate from CMMGameKitPA
	[[CMMGameKitPA sharedPA] setDelegate:nil];
	[[CMMGameKitAchievements sharedAchievements] setDelegate:nil];
	
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

-(void)dealloc{
	[super dealloc];
}

@end
