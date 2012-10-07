//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMGameKit.h"
#import "CMMScene.h"

static CMMGameKitPA *_sharedCMMGameKitPA_ = nil;

@interface CMMGameKitPA(Private)

-(void)onLocalPlayerAuthenticationChanged;

@end

@implementation CMMGameKitPA(Private)

-(void)onLocalPlayerAuthenticationChanged{
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitPA:whenChangedAuthenticationWithBOOL:))){
		[delegate gameKitPA:self whenChangedAuthenticationWithBOOL:[self isAuthenticated]];
	}
}

@end

@implementation CMMGameKitPA
@synthesize delegate,isAvailableGameCenter,isAuthenticated;

+(CMMGameKitPA *)sharedPA{
	if(!_sharedCMMGameKitPA_){
		_sharedCMMGameKitPA_ = [[self alloc] init];
	}
	return _sharedCMMGameKitPA_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	Class gameKitLocalPlayerClass_ = NSClassFromString(@"GKLocalPlayer");
	bool isLocalPlayerAvailable = (gameKitLocalPlayerClass_ != nil);
	
	NSString* reqSysVer = @"4.1";
	NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
	bool isOSVer41 = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	isAvailableGameCenter = (isLocalPlayerAvailable && isOSVer41);
	
	if(!isAvailableGameCenter){
		return self;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocalPlayerAuthenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
	
	[[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController_, NSError *error_){
		if(viewController_){
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitPA:whenTryAuthenticationWithViewController:))){
				[delegate gameKitPA:self whenTryAuthenticationWithViewController:viewController_];
			}else{
				[[CMMScene sharedScene] presentViewController:viewController_ animated:YES completion:nil];
			}
		}else if(error_ && cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitPA:whenFailedAuthenticationWithError:))){
			[delegate gameKitPA:self whenFailedAuthenticationWithError:error_];
		}else if(!error_ && cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitPA:whenCompletedAuthenticationWithLocalPlayer:))){
			[delegate gameKitPA:self whenCompletedAuthenticationWithLocalPlayer:[GKLocalPlayer localPlayer]];
		}
	}];
	
	return self;
}

-(BOOL)isAuthenticated{
	return (isAvailableGameCenter && [[GKLocalPlayer localPlayer] isAuthenticated]);
}

-(void)dealloc{
	[delegate release];
	[super dealloc];
}

@end

static CMMGameKitLeaderBoard *_sharedCMMGameKitLeaderBoard_ = nil;

@implementation CMMGameKitLeaderBoard
@synthesize delegate;

+(CMMGameKitLeaderBoard *)sharedLeaderBoard{
	if(!_sharedCMMGameKitLeaderBoard_){
		_sharedCMMGameKitLeaderBoard_ = [[self alloc] init];
	}
	
	return _sharedCMMGameKitLeaderBoard_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	return self;
}

-(void)loadCategory{
	[GKLeaderboard loadCategoriesWithCompletionHandler:^(NSArray *categories_, NSArray *titles_, NSError *error_) {
		if(error_){
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitLeaderBoard:whenFailedReceivingCategoryWithError:))){
				[delegate gameKitLeaderBoard:self whenFailedReceivingCategoryWithError:error_];
			}
		}else{
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitLeaderBoard:whenReceiveCategory:withTitle:))){
				[delegate gameKitLeaderBoard:self whenReceiveCategory:categories_ withTitle:titles_];
			}
		}
	}];
}

-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_ playerScope:(GKLeaderboardPlayerScope)playerScope_{
	GKLeaderboard *leaderBoard_ = [[[GKLeaderboard alloc] init] autorelease];
	[leaderBoard_ setCategory:category_];
	[leaderBoard_ setTimeScope:timeScope_];
	[leaderBoard_ setPlayerScope:playerScope_];
	[leaderBoard_ setRange:range_];
	[leaderBoard_ loadScoresWithCompletionHandler:^(NSArray *scores_, NSError *error_) {
		if(error_){
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitLeaderBoard:whenFailedReceivingLeaderBoard:withError:))){
				[delegate gameKitLeaderBoard:self whenFailedReceivingLeaderBoard:leaderBoard_ withError:error_];
			}
		}else{
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitLeaderBoard:whenReceiveLeaderBoard:))){
				[delegate gameKitLeaderBoard:self whenReceiveLeaderBoard:leaderBoard_];
			}
		}
	}];
}
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_{
	[self loadLeaderBoardWithCategory:category_ range:range_ timeScope:timeScope_ playerScope:GKLeaderboardPlayerScopeGlobal];
}
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_{
	[self loadLeaderBoardWithCategory:category_ range:range_ timeScope:GKLeaderboardTimeScopeAllTime];
}

-(void)reportScore:(int64_t)score_ category:(NSString*)category_{
	GKScore *gkScore_ = [[[GKScore alloc] init] autorelease];
	[gkScore_ setCategory:category_];
	[gkScore_ setValue:score_];
	[gkScore_ reportScoreWithCompletionHandler:^(NSError *error_){
		if(error_){
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitLeaderBoard:whenFailedSendingScore:withError:))){
				[delegate gameKitLeaderBoard:self whenFailedSendingScore:gkScore_ withError:error_];
			}
		}else{
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitLeaderBoard:whenCompletedSendingScore:))){
				[delegate gameKitLeaderBoard:self whenCompletedSendingScore:gkScore_];
			}
		}
	}];
}

-(void)dealloc{
	[delegate release];
	[super dealloc];
}

@end

static CMMGameKitAchievements *_sharedCMMGameKitAchievements_ = nil;

@interface CMMGameKitAchievements(Private)

-(void)setReportedAchievements:(NSArray *)reportedAchievements_;

@end

@implementation CMMGameKitAchievements
@synthesize delegate,cachedAchievements,reportedAchievements;

+(CMMGameKitAchievements *)sharedAchievements{
	if(!_sharedCMMGameKitAchievements_){
		_sharedCMMGameKitAchievements_ = [[self alloc] init];
	}
	
	return _sharedCMMGameKitAchievements_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	_cachedAchievements = [[NSMutableArray alloc] init];
	_reportedAchievements = [[NSMutableArray alloc] init];
	
	NSData *achievementsData_ = [CMMFileUtil dataWithFileName:cmmVarCMMGameKitAchievements_cacheName isInDocument:YES];
	if(achievementsData_){
		NSArray *targetArray_ = [NSKeyedUnarchiver unarchiveObjectWithData:achievementsData_];
		for(GKAchievement *achievement_ in targetArray_){
			[_cachedAchievements addObject:achievement_];
		}
	}
	
	return self;
}

-(NSArray *)cachedAchievements{
	return [NSArray arrayWithArray:_cachedAchievements];
}
-(NSArray *)reportedAchievements{
	return [NSArray arrayWithArray:_reportedAchievements];
}

-(void)setAchievementWithIdentifier:(NSString *)identifier_ percentComplete:(double)percentComplete_{
	GKAchievement *achievement_ = [self cachedAchievementAtIdentifier:identifier_];
	BOOL doCache_ = !achievement_;
	
	achievement_ = [self reportedAchievementAtIdentifier:identifier_];
	if(!achievement_){
		achievement_ = [[[GKAchievement alloc] initWithIdentifier:identifier_] autorelease];
	}else if([achievement_ percentComplete] >= percentComplete_){
		return;
	}
	
	if(doCache_){
		[_cachedAchievements addObject:achievement_];
	}
	
	[achievement_ setPercentComplete:percentComplete_];
}

-(void)resetAchievements{
	[GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error_){
		if(error_){
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitAchievements:whenFailedResettingAchievementsWithError:))){
				[delegate gameKitAchievements:self whenFailedResettingAchievementsWithError:error_];
			}
		}else{
			[_cachedAchievements removeAllObjects];
			[_reportedAchievements removeAllObjects];
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitAchievements_whenCompletedResettingAchievements:))){
				[delegate gameKitAchievements_whenCompletedResettingAchievements:self];
			}
		}
	}];
}

-(void)dealloc{
	[self writeCachedAchievements];
	[delegate release];
	[_cachedAchievements release];
	[_reportedAchievements release];
	[super dealloc];
}

@end

@implementation CMMGameKitAchievements(ReportedAchievements)

-(GKAchievement *)reportedAchievementAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [_reportedAchievements objectAtIndex:index_];
}
-(GKAchievement *)reportedAchievementAtIdentifier:(NSString *)identifier_{
	return [self reportedAchievementAtIndex:[self indexOfReportedAchievementWithIdentifier_:identifier_]];
}

-(uint)indexOfReportedAchievement:(GKAchievement *)achievement_{
	return [_reportedAchievements indexOfObject:achievement_];
}
-(uint)indexOfReportedAchievementWithIdentifier_:(NSString *)identifier_{
	uint count_ = [_reportedAchievements count];
	for(uint index_=0;index_<count_;++index_){
		GKAchievement *achievement_ = [_reportedAchievements objectAtIndex:index_];
		if([[achievement_ identifier] isEqualToString:identifier_]){
			return index_;
		}
	}
	
	return NSNotFound;
}

-(void)loadReportedAchievements{
	[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements_, NSError *error_){
		if(error_){
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitAchievements:whenFailedReceivingAchievementsWithError:))){
				[delegate gameKitAchievements:self whenFailedReceivingAchievementsWithError:error_];
			}
		}else{
			[_reportedAchievements removeAllObjects];
			[_reportedAchievements addObjectsFromArray:achievements_];
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitAchievements:whenReceiveAchievements:))){
				[delegate gameKitAchievements:self whenReceiveAchievements:reportedAchievements];
			}
		}
	}];
}

@end

@implementation CMMGameKitAchievements(CachedAchievements)

-(GKAchievement *)cachedAchievementAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [_cachedAchievements objectAtIndex:index_];
}
-(GKAchievement *)cachedAchievementAtIdentifier:(NSString *)identifier_{
	return [self cachedAchievementAtIndex:[self indexOfCachedAchievementWithIdentifier_:identifier_]];
}

-(uint)indexOfCachedAchievement:(GKAchievement *)achievement_{
	return [_cachedAchievements indexOfObject:achievement_];
}
-(uint)indexOfCachedAchievementWithIdentifier_:(NSString *)identifier_{
	uint count_ = [_cachedAchievements count];
	for(uint index_=0;index_<count_;++index_){
		GKAchievement *achievement_ = [_cachedAchievements objectAtIndex:index_];
		if([[achievement_ identifier] isEqualToString:identifier_]){
			return index_;
		}
	}
	
	return NSNotFound;
}

-(void)reportCachedAchievements{
	[GKAchievement reportAchievements:_cachedAchievements withCompletionHandler:^(NSError *error_) {
		if(error_){
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitAchievements:whenFailedReportingAchievementsWithError:))){
				[delegate gameKitAchievements:self whenFailedReportingAchievementsWithError:error_];
			}
		}else{
			if(cmmFuncCommon_respondsToSelector(delegate, @selector(gameKitAchievements:whenCompletedReportingAchievements:))){
				[delegate gameKitAchievements:self whenCompletedReportingAchievements:[self cachedAchievements]];
			}
			
			for(GKAchievement *cachedAchievement_ in _cachedAchievements){
				BOOL isExistsAchievement_ = NO;
				for(GKAchievement *reportedAchievement_ in _reportedAchievements){
					if([[reportedAchievement_ identifier] isEqualToString:[cachedAchievement_ identifier]]){
						isExistsAchievement_ = YES;
						break;
					}
				}
				
				if(!isExistsAchievement_){
					[_reportedAchievements addObject:cachedAchievement_];
				}
			}
			
			[_cachedAchievements removeAllObjects];
		}
	}];
}
-(void)writeCachedAchievements{
	NSData *targetData_ = [NSKeyedArchiver archivedDataWithRootObject:_cachedAchievements];
	[targetData_ writeToFile:[CMMStringUtil stringPathOfDocument:cmmVarCMMGameKitAchievements_cacheName] atomically:YES];
}

@end

@implementation CMMGameKitHandler
@synthesize delegate,serverID,myIdentifier;

+(id)gameKitHandler{
	return [[[self alloc] init] autorelease];
}

-(NSString *)myIdentifier{
	return nil;
}

-(void)whenReceivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_{
	if(delegate){
		[delegate gameKitHandler:self whenReceivePacketData:packetData_ fromID:fromID_];
	}
	[CMMPacketData cacheData:packetData_];
}

-(void)sendPacketData:(CMMPacketData *)packetData_ toIDs:(NSArray *)toIDs_{}
-(void)sendPacket:(CMMPacket *)packet_ toIDs:(NSArray *)toIDs_{}
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toIDs:(NSArray *)toIDs_{}

-(void)sendPacketData:(CMMPacketData *)packetData_ toID:(NSString *)toID_{}
-(void)sendPacket:(CMMPacket *)packet_ toID:(NSString *)toID_{}
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toID:(NSString *)toID_{}

-(void)sendPacketDataToAll:(CMMPacketData *)packetData_{}
-(void)sendPacketToAll:(CMMPacket *)packet_{}
-(void)sendBytesToAll:(void *)bytes_ length:(uint)length_{}

-(void)sendPacketDataToServer:(CMMPacketData *)packetData_{
	[self sendPacketData:packetData_ toID:serverID];
}
-(void)sendPacketToServer:(CMMPacket *)packet_{
	[self sendPacket:packet_ toID:serverID];
}
-(void)sendBytesToServer:(void *)bytes_ length:(uint)length_{
	[self sendBytes:bytes_ length:length_ toID:serverID];
}

-(void)dealloc{
	[delegate release];
	[serverID release];
	[super dealloc];
}

@end

static GKMatch *_sharedCMMGameKitHandlerMatch_GKMatch_ = nil;

@implementation CMMGameKitHandlerMatch
@synthesize match,sendDataMode;

-(id)init{
	if(!(self = [super init])) return self;
	
	sendDataMode = GKMatchSendDataReliable;
	
	return self;
}

-(NSString *)myIdentifier{
	if(![[CMMGameKitPA sharedPA] isAuthenticated]) return nil;
	return [[GKLocalPlayer localPlayer] playerID];
}
-(void)setMatch:(GKMatch *)match_{
	if(_sharedCMMGameKitHandlerMatch_GKMatch_){
		[_sharedCMMGameKitHandlerMatch_GKMatch_ setDelegate:nil];
		[_sharedCMMGameKitHandlerMatch_GKMatch_ disconnect];
	}
	[_sharedCMMGameKitHandlerMatch_GKMatch_ release];
	_sharedCMMGameKitHandlerMatch_GKMatch_ = [match_ retain];
	if(_sharedCMMGameKitHandlerMatch_GKMatch_){
		[_sharedCMMGameKitHandlerMatch_GKMatch_ setDelegate:self];
	}
}
-(GKMatch *)match{
	return _sharedCMMGameKitHandlerMatch_GKMatch_;
}

-(void)findMatch:(uint)minPlayerCount_ maxPlayerCount:(uint)maxPlayerCount_{
	if(![[CMMGameKitPA sharedPA] isAuthenticated]) return;
	
	[self setMatch:nil];
	
	GKMatchRequest *request_ = [[[GKMatchRequest alloc] init] autorelease];
	[request_ setMinPlayers:MAX(MIN(minPlayerCount_,maxPlayerCount_),2)];
	[request_ setMaxPlayers:MIN(MAX(minPlayerCount_,maxPlayerCount_),4)];
	
	[[GKMatchmaker sharedMatchmaker] findMatchForRequest:request_ withCompletionHandler:^(GKMatch *match_, NSError *error_) {
		id<CMMGameKitHandlerMatchDelegate>delegate_ = (id<CMMGameKitHandlerMatchDelegate>)delegate;
		
		if(error_){
			if(!cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:whenFailedFindingMatchWithError:))){
				[NSException raise:@"CMMGameKitHandlerMatch : not found delegate method - 'gameKitHandlerMatch:whenFailedToFindingMatchWithError:'" format:nil];
			}
			[delegate_ gameKitHandlerMatch:self whenFailedFindingMatchWithError:error_];
		}else{
			if(!cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:whenFoundMatch:withRequest:))){
				[NSException raise:@"CMMGameKitHandlerMatch : not found delegate method - 'gameKitHandlerMatch:whenFoundMatch:withRequest:'" format:nil];
			}
			[delegate_ gameKitHandlerMatch:self whenFoundMatch:match_ withRequest:request_];
		}
	}];
}
-(void)findMatch:(uint)minPlayerCount_{
	[self findMatch:minPlayerCount_ maxPlayerCount:minPlayerCount_];
}

-(void)connectToMatch:(GKMatch *)match_ withRequest:(GKMatchRequest *)request_{
	if(![[CMMGameKitPA sharedPA] isAuthenticated]) return;
	
	[[GKMatchmaker sharedMatchmaker] addPlayersToMatch:match_ matchRequest:request_ completionHandler:^(NSError *error_){
		id<CMMGameKitHandlerMatchDelegate>delegate_ = (id<CMMGameKitHandlerMatchDelegate>)delegate;
		
		if(error_){
			if(!cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:whenFailedConnetingToMatch:withError:))){
				[NSException raise:@"CMMGameKitHandlerMatch : not found delegate method - 'gameKitHandlerMatch:whenFailedToConnetingMatch:withError:'" format:nil];
			}
			
			[delegate_ gameKitHandlerMatch:self whenFailedConnetingToMatch:match_ withError:error_];
			
		}else{
			if(!cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:whenConnectedToMatch:))){
				[NSException raise:@"CMMGameKitHandlerMatch : not found delegate method - 'gameKitHandlerMatch:whenConnectedToMatch:'" format:nil];
			}
			[self setMatch:match_];
			[delegate_ gameKitHandlerMatch:self whenConnectedToMatch:match];
		}
	}];
}

-(void)match:(GKMatch *)match_ didReceiveData:(NSData *)data_ fromPlayer:(NSString *)playerID_{
	[self whenReceivePacketData:(CMMPacketData *)data_ fromID:playerID_];
}

-(void)sendPacketData:(CMMPacketData *)packetData_ toIDs:(NSArray *)toIDs_{
	[_sharedCMMGameKitHandlerMatch_GKMatch_ sendData:packetData_ toPlayers:toIDs_ withDataMode:sendDataMode error:nil];
	[CMMPacketData cacheData:packetData_];
}
-(void)sendPacket:(CMMPacket *)packet_ toIDs:(NSArray *)toIDs_{
	CMMPacketData *packetData_ = [CMMPacketData createData];
	[packetData_ setDataWithPacket:packet_];
	[self sendPacketData:packetData_ toIDs:toIDs_];
}
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toIDs:(NSArray *)toIDs_{
	CMMPacketData *packetData_ = [CMMPacketData createData];
	[packetData_ setDataWithBytes:bytes_ length:length_];
	[self sendPacketData:packetData_ toIDs:toIDs_];
}

-(void)sendPacketData:(CMMPacketData *)packetData_ toID:(NSString *)toID_{
	[self sendPacketData:packetData_ toIDs:[NSArray arrayWithObjects:toID_, nil]];
}
-(void)sendPacket:(CMMPacket *)packet_ toID:(NSString *)toID_{
	[self sendPacket:packet_ toIDs:[NSArray arrayWithObjects:toID_, nil]];
}
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toID:(NSString *)toID_{
	[self sendBytes:bytes_ length:length_ toIDs:[NSArray arrayWithObjects:toID_, nil]];
}

-(void)sendPacketDataToAll:(CMMPacketData *)packetData_{
	[_sharedCMMGameKitHandlerMatch_GKMatch_ sendDataToAllPlayers:packetData_ withDataMode:sendDataMode error:nil];
	[CMMPacketData cacheData:packetData_];
	
	[self sendPacketData:packetData_ toIDs:[_sharedCMMGameKitHandlerMatch_GKMatch_ playerIDs]];
}
-(void)sendPacketToAll:(CMMPacket *)packet_{
	CMMPacketData *packetData_ = [CMMPacketData createData];
	[packetData_ setDataWithPacket:packet_];
	[self sendPacketDataToAll:packetData_];
}
-(void)sendBytesToAll:(void *)bytes_ length:(uint)length_{
	CMMPacketData *packetData_ = [CMMPacketData createData];
	[packetData_ setDataWithBytes:bytes_ length:length_];
	[self sendPacketDataToAll:packetData_];
}

-(void)match:(GKMatch *)match_ player:(NSString *)playerID_ didChangeState:(GKPlayerConnectionState)state_{
	id<CMMGameKitHandlerMatchDelegate> delegate_ = (id<CMMGameKitHandlerMatchDelegate>)delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:playerID:didChangeState:))){
		[delegate_ gameKitHandlerMatch:self playerID:playerID_ didChangeState:state_];
	}
}

-(void)match:(GKMatch *)match_ didFailWithError:(NSError *)error_{
	id<CMMGameKitHandlerMatchDelegate> delegate_ = (id<CMMGameKitHandlerMatchDelegate>)delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:didFailWithError:))){
		[delegate_ gameKitHandlerMatch:self didFailWithError:error_];
	}
}

-(BOOL)match:(GKMatch *)match_ shouldReinvitePlayer:(NSString *)playerID_{
	id<CMMGameKitHandlerMatchDelegate> delegate_ = (id<CMMGameKitHandlerMatchDelegate>)delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:shouldReinvitePlayer:))){
		return [delegate_ gameKitHandlerMatch:self shouldReinvitePlayer:playerID_];
	}
	
	return NO;
}

-(void)dealloc{
	[self setMatch:nil];
	[super dealloc];
}

@end

static GKSession *_sharedCMMGameKitHandlerSession_GKSession_ = nil;

@implementation CMMGameKitHandlerSession
@synthesize session,sessionMode,sendDataMode;

-(id)init{
	if(!(self = [super init])) return self;
	
	sendDataMode = GKSendDataReliable;
	
	return self;
}

-(NSString *)myIdentifier{
	if(!_sharedCMMGameKitHandlerSession_GKSession_) return nil;
	return [_sharedCMMGameKitHandlerSession_GKSession_ peerID];
}

-(void)setSession:(GKSession *)session_{
	if(_sharedCMMGameKitHandlerSession_GKSession_){
		[_sharedCMMGameKitHandlerSession_GKSession_ setDelegate:nil];
		[_sharedCMMGameKitHandlerSession_GKSession_ disconnectFromAllPeers];
	}
	[_sharedCMMGameKitHandlerSession_GKSession_ release];
	_sharedCMMGameKitHandlerSession_GKSession_ = [session_ retain];
	if(_sharedCMMGameKitHandlerSession_GKSession_){
		[_sharedCMMGameKitHandlerSession_GKSession_ setDelegate:self];
	}
}
-(GKSession *)session{
	return _sharedCMMGameKitHandlerSession_GKSession_;
}
-(GKSessionMode)sessionMode{
	if(_sharedCMMGameKitHandlerSession_GKSession_){
		return [_sharedCMMGameKitHandlerSession_GKSession_ sessionMode];
	}
	CCLOG(@"CMMGameKitHandlerSession : can't identifies current session mode, GKSession is not open!");
	return GKSessionModeClient;
}

-(void)openGameSessionWithSessionID:(NSString *)sessionID_ displayName:(NSString *)displayName_ sessionMode:(GKSessionMode)sessionMode_{
	[self setSession:[[[GKSession alloc] initWithSessionID:sessionID_ displayName:displayName_ sessionMode:sessionMode_] autorelease]];
	[_sharedCMMGameKitHandlerSession_GKSession_ setAvailable:YES];
	[_sharedCMMGameKitHandlerSession_GKSession_ setDataReceiveHandler:self withContext:nil];
}

-(void)connectToPeer:(NSString *)peerID_ withTimeout:(ccTime)timeout_{
	if(!_sharedCMMGameKitHandlerSession_GKSession_) return;
	[_sharedCMMGameKitHandlerSession_GKSession_ connectToPeer:peerID_ withTimeout:timeout_];
}
-(void)disconnectPeer:(NSString *)peerID_{
	if(!_sharedCMMGameKitHandlerSession_GKSession_) return;
	[_sharedCMMGameKitHandlerSession_GKSession_ disconnectPeerFromAllPeers:peerID_];
}
-(void)disconnectFromAllPeers{
	if(!_sharedCMMGameKitHandlerSession_GKSession_) return;
	[_sharedCMMGameKitHandlerSession_GKSession_ disconnectFromAllPeers];
}

-(void)receiveData:(NSData *)data_ fromPeer:(NSString *)peerID_ inSession:(GKSession *)session_ context:(void *)context_{
	[self whenReceivePacketData:(CMMPacketData *)data_ fromID:peerID_];
}

-(void)sendPacketData:(CMMPacketData *)packetData_ toIDs:(NSArray *)toIDs_{
	[_sharedCMMGameKitHandlerSession_GKSession_ sendData:packetData_ toPeers:toIDs_ withDataMode:sendDataMode error:nil];
	[CMMPacketData cacheData:packetData_];
}
-(void)sendPacket:(CMMPacket *)packet_ toIDs:(NSArray *)toIDs_{
	CMMPacketData *packetData_ = [CMMPacketData createData];
	[packetData_ setDataWithPacket:packet_];
	[self sendPacketData:packetData_ toIDs:toIDs_];
}
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toIDs:(NSArray *)toIDs_{
	CMMPacketData *packetData_ = [CMMPacketData createData];
	[packetData_ setDataWithBytes:bytes_ length:length_];
	[self sendPacketData:packetData_ toIDs:toIDs_];
}

-(void)sendPacketData:(CMMPacketData *)packetData_ toID:(NSString *)toID_{
	[self sendPacketData:packetData_ toIDs:[NSArray arrayWithObjects:toID_, nil]];
}
-(void)sendPacket:(CMMPacket *)packet_ toID:(NSString *)toID_{
	[self sendPacket:packet_ toIDs:[NSArray arrayWithObjects:toID_, nil]];
}
-(void)sendBytes:(void *)bytes_ length:(uint)length_ toID:(NSString *)toID_{
	[self sendBytes:bytes_ length:length_ toIDs:[NSArray arrayWithObjects:toID_, nil]];
}

-(void)sendPacketDataToAll:(CMMPacketData *)packetData_{
	[_sharedCMMGameKitHandlerSession_GKSession_ sendDataToAllPeers:packetData_ withDataMode:sendDataMode error:nil];
	[CMMPacketData cacheData:packetData_];
}
-(void)sendPacketToAll:(CMMPacket *)packet_{
	CMMPacketData *packetData_ = [CMMPacketData createData];
	[packetData_ setDataWithPacket:packet_];
	[self sendPacketDataToAll:packetData_];
}
-(void)sendBytesToAll:(void *)bytes_ length:(uint)length_{
	CMMPacketData *packetData_ = [CMMPacketData createData];
	[packetData_ setDataWithBytes:bytes_ length:length_];
	[self sendPacketDataToAll:packetData_];
}

-(void)session:(GKSession *)session_ peer:(NSString *)peerID_ didChangeState:(GKPeerConnectionState)state_{
	id<CMMGameKitHandlerSessionDelegate> delegate_ = (id<CMMGameKitHandlerSessionDelegate>)delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerSession:peer:didChangeState:))){
		[delegate_ gameKitHandlerSession:self peer:peerID_ didChangeState:state_];
	}
}

-(void)session:(GKSession *)session_ didReceiveConnectionRequestFromPeer:(NSString *)peerID_{
	id<CMMGameKitHandlerSessionDelegate> delegate_ = (id<CMMGameKitHandlerSessionDelegate>)delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerSession:didReceiveConnectionRequestFromPeer:))){
		[delegate_ gameKitHandlerSession:self didReceiveConnectionRequestFromPeer:peerID_];
	}
}

-(void)session:(GKSession *)session_ connectionWithPeerFailed:(NSString *)peerID_ withError:(NSError *)error_{
	id<CMMGameKitHandlerSessionDelegate> delegate_ = (id<CMMGameKitHandlerSessionDelegate>)delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerSession:connectionWithPeerFailed:withError:))){
		[delegate_ gameKitHandlerSession:self connectionWithPeerFailed:peerID_ withError:error_];
	}
}

-(void)session:(GKSession *)session_ didFailWithError:(NSError *)error_{
	id<CMMGameKitHandlerSessionDelegate> delegate_ = (id<CMMGameKitHandlerSessionDelegate>)delegate;
	if(cmmFuncCommon_respondsToSelector(delegate_, @selector(gameKitHandlerSession:didFailWithError:))){
		[delegate_ gameKitHandlerSession:self didFailWithError:error_];
	}
}

-(void)dealloc{
	[self setSession:nil];
	[super dealloc];
}

@end