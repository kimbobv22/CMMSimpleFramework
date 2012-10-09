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
	
	menu = [CMMMenuItemSet menuItemSetWithMenuSize:CGSizeMake(contentSize_.width*0.8f, contentSize_.height*0.6f)];
	[menu setAlignType:CMMMenuItemSetAlignType_vertical];
	[menu setLineVAlignType:CMMMenuItemSetLineVAlignType_center];
	[menu setUnitPerLine:2];
	[menu setPosition:cmmFuncCommon_position_center(self, menu)];
	[self addChild:menu];
	
	useGameCenterBanner = NO;
	
	CMMMenuItemLabelTTF *menuItemBtn_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"test report1"];
	[menuItemBtn_ setCallback_pushup:^(id sender_){
		useGameCenterBanner = NO;
		[self switchBtnTo:NO];
		[self setDisplayStr:@"reporting achievements..."];
		
		[[CMMGameKitAchievements sharedAchievements] setAchievementWithIdentifier:@"CMMSimpleFramework.achievement.00001" percentComplete:100.0f];
		[[CMMGameKitAchievements sharedAchievements] reportCachedAchievements];
	}];
	
	[menu addMenuItem:menuItemBtn_];
	
	menuItemBtn_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"test report2"];
	[menuItemBtn_ setCallback_pushup:^(id sender_){
		useGameCenterBanner = YES;
		[self switchBtnTo:NO];
		[self setDisplayStr:@"reporting achievements..."];
		
		[[CMMGameKitAchievements sharedAchievements] setAchievementWithIdentifier:@"CMMSimpleFramework.achievement.00002" percentComplete:100.0f];
		[[CMMGameKitAchievements sharedAchievements] reportCachedAchievements];
	}];
	
	[menu addMenuItem:menuItemBtn_];
	
	menuItemBtn_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"reset Achievements"];
	[menuItemBtn_ setCallback_pushup:^(id sender_){
		[self setDisplayStr:@"resetting achievements..."];
		[self switchBtnTo:NO];
		[[CMMGameKitAchievements sharedAchievements] resetAchievements];
	}];
	
	[menu addMenuItem:menuItemBtn_];
	
	[menu updateDisplay];
	
	menuItemBtn_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"BACK"];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBtn_];
	
	displayLb = [CMMFontUtil labelWithstring:@" "];
	[self addChild:displayLb];
	
	[[CMMGameKitAchievements sharedAchievements] setDelegate:self];
	
	return self;
}

-(void)onExit{
	[super onExit];
	[[CMMGameKitAchievements sharedAchievements] setDelegate:nil];
}

-(void)switchBtnTo:(BOOL)bool_{
	[menu setIsEnable:bool_];
}
-(void)setDisplayStr:(NSString *)str_{
	[displayLb setString:str_];
	[displayLb setPosition:ccp(contentSize_.width/2.0f,[menu position].y + [menu contentSize].height + 20.0f)];
}

-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenCompletedReportingAchievements:(NSArray *)reportedAchievements_{
	for(GKAchievement *achievement_ in reportedAchievements_){
		if([achievement_ percentComplete] == 100.0f){
			if(useGameCenterBanner){
				[GKNotificationBanner showBannerWithTitle:@"Test banner" message:[achievement_ identifier] completionHandler:nil];
			}else{
				[[[CMMScene sharedScene] noticeDispatcher] addNoticeItemWithTitle:@"Test banner" subject:[achievement_ identifier]];
			}
		}
	}
	
	//put delay time & load reported achievements
	[self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:1.0f] two:[CCCallBlock actionWithBlock:^{[[CMMGameKitAchievements sharedAchievements] loadReportedAchievements];}]]];
}

-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenReceiveAchievements:(NSArray *)achievements_{
	[self setDisplayStr:@"Completed Reporting & Receiving Achievements :)"];
	[self switchBtnTo:YES];
}
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedReceivingAchievementsWithError:(NSError *)error_{
	[self setDisplayStr:@"FailedReceivingAchievementsWithError :("];
	[self switchBtnTo:YES];
}

-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedReportingAchievementsWithError:(NSError *)error_{
	[self setDisplayStr:@"FailedReportingAchievementsWithError :("];
	[self switchBtnTo:YES];
}

-(void)gameKitAchievements_whenCompletedResettingAchievements:(CMMGameKitAchievements *)gameKitAchievements_{
	[self setDisplayStr:@"CompletedResettingAchievements :)"];
	[self switchBtnTo:YES];
}

-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedResettingAchievementsWithError:(NSError *)error_{
	[self setDisplayStr:@"FailedResettingAchievementsWithError :("];
	[self switchBtnTo:YES];
}

@end
