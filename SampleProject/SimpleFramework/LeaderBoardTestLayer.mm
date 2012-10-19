//  Created by JGroup(kimbobv22@gmail.com)

#import "LeaderBoardTestLayer.h"
#import "HelloWorldLayer.h"

@implementation PlayerItem
@synthesize playerID,playerName;

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	_playerNameLb = [CMMFontUtil labelWithstring:@" " fontSize:9.0f];
	[self addChild:_playerNameLb];
	[self setTitleAlign:kCCTextAlignmentRight];
	
	return self;
}

-(void)updateDisplay{
	[super updateDisplay];
	
	CGPoint labelPoint_ = CGPointZero;
	labelPoint_.x = [_playerNameLb contentSize].width*0.5f + 10.0f;
	labelPoint_.y = contentSize_.height - [_playerNameLb contentSize].height*0.5f - 10.0f;
	[_playerNameLb setPosition:labelPoint_];
}

-(void)setPlayerName:(NSString *)playerName_{
	[_playerNameLb setString:playerName_];
	[self updateDisplay];
}
-(NSString *)playerName{
	return [_playerNameLb string];
}

-(void)dealloc{
	[playerID release];
	[super dealloc];
}

@end

@interface LeaderBoardTestLayer(Private)

-(void)setDisplayStr:(NSString *)str_;
-(void)switchBtn:(BOOL)bool_;
-(void)loadLeaderBoard;
-(void)updateScore;

@end

@implementation LeaderBoardTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CGSize frameSize_ = CGSizeMake(contentSize_.width * 0.6f, contentSize_.height * 0.55f);
	leaderBoardScrollMenu = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:frameSize_];
	CGPoint targetPoint_ = cmmFuncCommon_position_center(self, leaderBoardScrollMenu);
	targetPoint_.y += 40.0f;
	[leaderBoardScrollMenu setPosition:targetPoint_];
	[self addChild:leaderBoardScrollMenu];
	
	reportBtn = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(80, 45)];
	[reportBtn setTitle:@"Submit"];
	[reportBtn setCallback_pushup:^(id sender_){
		[self setDisplayStr:@"reporting score..."];
		[self switchBtn:NO];
		[[CMMGameKitLeaderBoard sharedLeaderBoard] reportScore:_score category:@"CMMSimpleFramework.leaderboard.00001"];
	}];
	targetPoint_.x += frameSize_.width - reportBtn.contentSize.width*0.5f;
	targetPoint_.y -= reportBtn.contentSize.height*0.5f + 10.0f;
	[reportBtn setPosition:targetPoint_];
	[self addChild:reportBtn];
	
	bitBtn = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(150, 45)];
	[bitBtn setTitle:@"BIT !!"];
	[bitBtn setCallback_pushup:^(id sender_){
		[self updateScore];
	}];
	targetPoint_ = [reportBtn position];
	targetPoint_.x -= [reportBtn contentSize].width*0.5f + [bitBtn contentSize].width*0.5f + 10.0f;
	[bitBtn setPosition:targetPoint_];
	[self addChild:bitBtn];
	
	scroeLabel = [CMMFontUtil labelWithstring:@"0"];
	[self addChild:scroeLabel];
	
	CMMMenuItemLabelTTF *menuItemBtn_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"BACK"];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	menuItemBtn_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBtn_];
	
	refreshBtn = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[refreshBtn setTitle:@"Refresh"];
	refreshBtn.position = ccp(contentSize_.width - menuItemBtn_.contentSize.width/2.0f,menuItemBtn_.contentSize.height/2);
	refreshBtn.callback_pushup = ^(id sender_){
		[self loadLeaderBoard];
	};
	[self addChild:refreshBtn];
	
	_displayLabel = [CMMFontUtil labelWithstring:@" "];
	[self addChild:_displayLabel];
	
	_score = 0;
	[self updateScore];
	
	[[CMMGameKitLeaderBoard sharedLeaderBoard] setDelegate:self];
	
	return self;
}

-(void)whenLoadingEnded{
	[self loadLeaderBoard];
}

-(void)onExit{
	[super onExit];
	[[CMMGameKitLeaderBoard sharedLeaderBoard] setDelegate:nil];
}

-(void)setDisplayStr:(NSString *)str_{
	[_displayLabel setString:str_];
	[_displayLabel setPosition:ccp(contentSize_.width*0.5f,leaderBoardScrollMenu.position.y+leaderBoardScrollMenu.contentSize.height+_displayLabel.contentSize.height*0.5f)];
}
-(void)switchBtn:(BOOL)bool_{
	bitBtn.isEnable = reportBtn.isEnable = refreshBtn.isEnable = bool_;
}

-(void)loadLeaderBoard{
	[self switchBtn:NO];
	[self setDisplayStr:@"loading Leaderboard..."];
	[[CMMGameKitLeaderBoard sharedLeaderBoard] loadLeaderBoardWithCategory:@"CMMSimpleFramework.leaderboard.00001" range:NSRangeMake(1, 50)];
}

-(void)updateScore{
	_score += 5.0f;
	[scroeLabel setString:[NSString stringWithFormat:@"score : %@",[CMMStringUtil stringDecimalStyleFromNumber:_score]]];
	CGPoint targetPoint_ = [bitBtn position];
	targetPoint_.x -= [bitBtn contentSize].width*0.5f + [scroeLabel contentSize].width*0.5f + 20.0f;
	[scroeLabel setPosition:targetPoint_];
	
	[scroeLabel stopAllActions];
	[scroeLabel runAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:0.1f scale:1.3f] two:[CCScaleTo actionWithDuration:0.1f scale:1.0f]]];
}

-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenReceiveLeaderBoard:(GKLeaderboard *)leaderBoard_{
	[self setDisplayStr:@"ReceiveLeaderBoard :)"];
	
	CGSize frameSize_ = [leaderBoardScrollMenu contentSize];
	NSMutableArray *playerIDs_ = [NSMutableArray array];
	
	[leaderBoardScrollMenu removeAllItems];
	
	NSArray *scores_ = [leaderBoard_ scores];
	uint count_ = [scores_ count];
	for(uint index_=0;index_<count_;++index_){
		GKScore *score_ = [scores_ objectAtIndex:index_];
		[playerIDs_ addObject:[score_ playerID]];
		PlayerItem *playerItem_ = [PlayerItem menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(frameSize_.width, 45)];
		[playerItem_ setPlayerID:[score_ playerID]];
		[playerItem_ setTitle:[CMMStringUtil stringDecimalStyleFromNumber:[score_ value]]];
		[leaderBoardScrollMenu addItem:playerItem_];
	}
	
	//load player info
	[GKPlayer loadPlayersForIdentifiers:playerIDs_ withCompletionHandler:^(NSArray *players, NSError *error){
		for(GKPlayer *player_ in players){
			ccArray *data_ = [leaderBoardScrollMenu itemList]->data;
			uint count_ = data_->num;
			for(uint index_=0;index_<count_;++index_){
				PlayerItem *playerItem_ = data_->arr[index_];
				if([[playerItem_ playerID] isEqualToString:[player_ playerID]]){
					[playerItem_ setPlayerName:[player_ displayName]];
				}
			}
		}
		
		[self switchBtn:YES];
	}];
}
-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenFailedReceivingLeaderBoard:(GKLeaderboard *)leaderBoard_ withError:(NSError *)error_{
	[self setDisplayStr:@"FailedReceivingLeaderBoard :("];
	[self loadLeaderBoard];
}

-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenCompletedSendingScore:(GKScore *)score_{
	[self setDisplayStr:@"CompletedSendingScore :)"];
	[self loadLeaderBoard];
}
-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenFailedSendingScore:(GKScore *)score_ withError:(NSError *)error_{
	[self setDisplayStr:@"FailedSendingScore :)"];
	[self loadLeaderBoard];
}

@end
