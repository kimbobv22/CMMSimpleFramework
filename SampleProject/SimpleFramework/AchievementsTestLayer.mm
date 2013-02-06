//  Created by JGroup(kimbobv22@gmail.com)

#import "AchievementsTestLayer.h"
#import "HelloWorldLayer.h"

@interface AchievementsTestLayer(Private)

-(void)switchBtnTo:(BOOL)bool_;
-(void)setDisplayStr:(NSString *)str_;

@end

@implementation AchievementsTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CGSize btnSize_ = CGSizeMake(100, 40);

	CMMMenuItemL *menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:btnSize_];
	[menuItemBtn_ setTitle:@"BACK"];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBtn_];

	useGameCenterBanner = NO;
	
	btnReport1 = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:btnSize_];
	[btnReport1 setTitle:@"REPORT 1"];
	[btnReport1 setCallback_pushup:^(id sender_){
		useGameCenterBanner = NO;
		[[CMMGameKitAchievements sharedAchievements] setAchievementWithIdentifier:@"CMMSimpleFramework.achievement.00001" percentComplete:100.0f];
		[self _reportAchievements];
	}];
	
	btnReport2 = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:btnSize_];
	[btnReport2 setTitle:@"REPORT 2"];
	[btnReport2 setCallback_pushup:^(id sender_){
		useGameCenterBanner = YES;
		[[CMMGameKitAchievements sharedAchievements] setAchievementWithIdentifier:@"CMMSimpleFramework.achievement.00002" percentComplete:100.0f];
		[self _reportAchievements];
	}];
	
	btnReset = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:btnSize_];
	[btnReset setTitle:@"RESET"];
	[btnReset setCallback_pushup:^(id sender_){
		[self _resetAchievements];
	}];
	
	[btnReport2 setPosition:cmmFuncCommon_positionInParent(self, btnReport1,ccp(0.5f,0.4f))];
	[btnReport1 setPosition:cmmFuncCommon_positionFromOtherNode(btnReport2, btnReport1, ccp(-1.0,0.0f),ccp(-10.0f,0.0f))];
	[btnReset setPosition:cmmFuncCommon_positionFromOtherNode(btnReport2, btnReset, ccp(1.0,0.0f),ccp(10.0f,0.0f))];
	
	[self addChild:btnReport1];
	[self addChild:btnReport2];
	[self addChild:btnReset];
	
	displayLb = [CMMFontUtil labelWithString:@" "];
	[self addChild:displayLb];
	
	if(![[CMMGameKitPA sharedPA] isAuthenticated]){
		[self setDisplayStr:@"unavailable Game center! please check Game center"];
		[self switchBtnTo:NO];
	}
	
	return self;
}

-(void)switchBtnTo:(BOOL)bool_{
	[btnReport1 setEnable:bool_];
	[btnReport2 setEnable:bool_];
	[btnReset setEnable:bool_];
}
-(void)setDisplayStr:(NSString *)str_{
	[displayLb setString:str_];
	[displayLb setPosition:cmmFuncCommon_positionInParent(self, displayLb,ccp(0.5,1.0f),ccp(0.0f,-[displayLb contentSize].height))];
}

-(void)_loadAchievements{
	[self switchBtnTo:NO];
	[[CMMGameKitAchievements sharedAchievements] loadReportedAchievementsWithBlock:^(NSError *error_) {
		if(error_){
			[self setDisplayStr:@"FailedReceivingAchievementsWithError :("];
		}else{
			[self setDisplayStr:@"Completed Reporting & Receiving Achievements :)"];
		}
		
		[self switchBtnTo:YES];
	}];
}
-(void)_reportAchievements{
	[self switchBtnTo:NO];
	[self setDisplayStr:@"reporting achievements..."];
	
	[[CMMGameKitAchievements sharedAchievements] reportCachedAchievementsWithBlock:^(NSArray *reportedAchievements_, NSError *error_) {
		if(error_){
			[self setDisplayStr:@"FailedReportingAchievementsWithError :("];
			[self switchBtnTo:YES];
			return;
		}
		
		for(CMMGameKitAchievement *cmmAchievement_ in reportedAchievements_){
			if(useGameCenterBanner){
				[GKNotificationBanner showBannerWithTitle:@"Test banner" message:[cmmAchievement_ identifier] completionHandler:nil];
			}else{
				[[[CMMScene sharedScene] noticeDispatcher] addNoticeItemWithTitle:@"Test banner" subject:[cmmAchievement_ identifier]];
			}
		}
		
		//put delay time & load reported achievements
		[self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:1.0f] two:[CCCallBlock actionWithBlock:^{[self _loadAchievements];}]]];
	}];
}
-(void)_resetAchievements{
	[self switchBtnTo:NO];
	[self setDisplayStr:@"resetting achievements..."];
	[[CMMGameKitAchievements sharedAchievements] resetAchievementsWithBlock:^(NSError *error_) {
		if(error_){
			[self setDisplayStr:@"FailedResettingAchievementsWithError :("];
		}else{
			[self setDisplayStr:@"CompletedResettingAchievements :)"];
		}
		
		[self switchBtnTo:YES];
	}];
}

@end
