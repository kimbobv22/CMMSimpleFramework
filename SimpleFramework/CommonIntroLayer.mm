//  Created by JGroup(kimbobv22@gmail.com)

#import "CommonIntroLayer.h"
#import "HelloWorldLayer.h"
#import "AppDelegate.h"

@implementation CommonIntroLayer1

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	introState = testIntroState_000;
	profileSprite = [CCSprite spriteWithFile:@"develop.png"];
	[profileSprite setPosition:ccp(contentSize_.width/2.0f,contentSize_.height/2.0f)];
	[profileSprite runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.5f],[CCDelayTime actionWithDuration:2.0f],[CCCallFunc actionWithTarget:self selector:@selector(seq001)], nil]];
	[self addChild:profileSprite];
	
	return self;
}

-(void)seq001{
	introState = testIntroState_001;
	[profileSprite stopAllActions];
	[profileSprite setOpacity:255];
	[profileSprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.5f],[CCCallFunc actionWithTarget:self selector:@selector(seq002)], nil]];
}
-(void)seq002{
	introState = testIntroState_002;
	[profileSprite stopAllActions];
	[profileSprite setOpacity:0];
	[[CMMScene sharedScene] pushLayer:[CommonIntroLayer2 node]];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	switch(introState){
		case testIntroState_000:{
			[self seq001];
			break;
		};
		case testIntroState_001:{
			[self seq002];
			break;
		};
		default: break;
	}
}

@end

@implementation CommonIntroLayer2

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	labelDisplay = [CMMFontUtil labelWithstring:@" "];
	[self addChild:labelDisplay];
	[self _setDisplayStr:@"Loading..."];
	
	return self;
}

-(void)_setDisplayStr:(NSString *)str_{
	[labelDisplay setString:str_];
	labelDisplay.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
}

-(void)loadingProcess000{
	[[CCDirector sharedDirector] setAnimationInterval:1.0f/30.0f];
	[self _setDisplayStr:@"Loading sprite frame..."];
}
-(void)loadingProcess001{
	[[CMMDrawingManager sharedManager] addDrawingItemWithFileName:@"IMG_CMN_BFRAME_000"];
}

-(void)loadingProcess002{
	[self _setDisplayStr:@"Initializing gyroscope..."];
}
-(void)loadingProcess003{
	[CMMMotionDispatcher sharedDispatcher];
}

-(void)loadingProcess004{
	[self _setDisplayStr:@"Initializing sound engine..."];
}
-(void)loadingProcess005{
	[CMMSoundEngine sharedEngine];
}

-(void)loadingProcess006{
	[self _setDisplayStr:@"Initializing notice template..."];
}
-(void)loadingProcess007{
	[[CMMScene sharedScene] noticeDispatcher].noticeTemplate = [CMMNoticeDispatcherTemplate_DefaultScale templateWithNoticeDispatcher:[[CMMScene sharedScene] noticeDispatcher]];
}

-(void)loadingProcess008{
	[self _setDisplayStr:@"connecting to Game Center..."];
}

-(void)whenLoadingEnded{
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
