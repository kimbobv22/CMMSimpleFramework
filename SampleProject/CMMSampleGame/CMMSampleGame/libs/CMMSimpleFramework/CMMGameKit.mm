//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMGameKit.h"
#import "CMMScene.h"

static CMMGameKitPA *_sharedCMMGameKitPA_ = nil;

@interface CMMGameKitPA(Private)

-(void)onLocalPlayerAuthenticationChanged;

@end

@implementation CMMGameKitPA(Private)

-(void)onLocalPlayerAuthenticationChanged{
	if(callback_whenAuthenticationChanged){
		callback_whenAuthenticationChanged([self isAuthenticated]);
	}
}

@end

@implementation CMMGameKitPA
@synthesize availableGameCenter,authenticated;
@synthesize callback_whenAuthenticationChanged,authenticateHandler;

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
	
	availableGameCenter = (isLocalPlayerAvailable && isOSVer41);
	
	if(!availableGameCenter){
		return self;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocalPlayerAuthenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
	
	[[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewController_, NSError *error_){
		if(viewController_){
			[[CMMScene sharedScene] presentViewController:viewController_ animated:YES completion:nil];
			return;
		}
		
		if(authenticateHandler){
			CMMGameKitPAAuthenticationState state_ = CMMGameKitPAAuthenticationState_succeed;
			if(error_){
				state_ = CMMGameKitPAAuthenticationState_failed;
				
				switch([error_ code]){
					case GKErrorCancelled:
						state_ = CMMGameKitPAAuthenticationState_cancelled;
						break;
					default: break;
				}
			}
			
			authenticateHandler(state_,error_);
		}
	}];
	
	return self;
}

-(BOOL)isAuthenticated{
	return (availableGameCenter && [[GKLocalPlayer localPlayer] isAuthenticated]);
}

-(void)dealloc{
	[callback_whenAuthenticationChanged release];
	[authenticateHandler release];
	[super dealloc];
}

@end

@implementation CMMGameKitLeaderBoardCategory
@synthesize category,title;

+(id)categoryWithCategory:(NSString *)category_ title:(NSString *)title_{
	return [[[self alloc] initWithCategory:category_ title:title_] autorelease];
}
-(id)initWithCategory:(NSString *)category_ title:(NSString *)title_{
	if(!(self = [super init])) return self;
	
	[self setCategory:category_];
	[self setTitle:title_];
	
	return self;
}

-(void)dealloc{
	[category release];
	[title release];
	[super dealloc];
}

@end

static CMMGameKitLeaderBoard *_sharedCMMGameKitLeaderBoard_ = nil;

@implementation CMMGameKitLeaderBoard
@synthesize loadedCategories;

+(CMMGameKitLeaderBoard *)sharedLeaderBoard{
	if(!_sharedCMMGameKitLeaderBoard_){
		_sharedCMMGameKitLeaderBoard_ = [[self alloc] init];
	}
	
	return _sharedCMMGameKitLeaderBoard_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	loadedCategories = [[CCArray alloc] init];
	
	return self;
}

-(CCArray *)loadedCategories{
	return [[loadedCategories copy] autorelease];
}

-(void)dealloc{
	[loadedCategories release];
	[super dealloc];
}

@end

@implementation CMMGameKitLeaderBoard(Category)

-(CMMGameKitLeaderBoardCategory *)categoryAtIndex:(uint)index_{
	return [loadedCategories objectAtIndex:index_];
}

-(void)loadCategoriesWithBlock:(void(^)(CCArray *categories_))block_{
	[loadedCategories removeAllObjects];
	[GKLeaderboard loadCategoriesWithCompletionHandler:^(NSArray *categories_, NSArray *titles_, NSError *error_) {
		if(block_){
			block_([self loadedCategories]);
		}
	}];
}
-(void)loadCategories{
	[self loadCategoriesWithBlock:nil];
}

@end

@implementation CMMGameKitLeaderBoard(Score)

-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_ playerScope:(GKLeaderboardPlayerScope)playerScope_ block:(void(^)(GKLeaderboard *leaderboard_, NSError *error_))block_{
	GKLeaderboard *leaderBoard_ = [[[GKLeaderboard alloc] init] autorelease];
	[leaderBoard_ setCategory:category_];
	[leaderBoard_ setTimeScope:timeScope_];
	[leaderBoard_ setPlayerScope:playerScope_];
	[leaderBoard_ setRange:range_];
	[leaderBoard_ loadScoresWithCompletionHandler:^(NSArray *scores_, NSError *error_) {
		block_(leaderBoard_,error_);
	}];
}
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_ block:(void(^)(GKLeaderboard *leaderboard_, NSError *error_))block_{
	[self loadLeaderBoardWithCategory:category_ range:range_ timeScope:timeScope_ playerScope:GKLeaderboardPlayerScopeGlobal block:block_];
}
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ block:(void(^)(GKLeaderboard *leaderboard_, NSError *error_))block_{
	[self loadLeaderBoardWithCategory:category_ range:range_ timeScope:GKLeaderboardTimeScopeAllTime block:block_];
}

-(void)reportScore:(int64_t)score_ category:(NSString*)category_ block:(void(^)(GKScore *score_, NSError *error_))block_{
	GKScore *gkScore_ = [[[GKScore alloc] init] autorelease];
	[gkScore_ setCategory:category_];
	[gkScore_ setValue:score_];
	[gkScore_ reportScoreWithCompletionHandler:^(NSError *error_){
		block_(gkScore_,error_);
	}];
}

@end

@interface CMMGameKitAchievement(Private)

-(void)_setReported:(BOOL)isReported_;

@end

@implementation CMMGameKitAchievement(Private)

-(void)_setReported:(BOOL)isReported_{
	reported = isReported_;
}

@end

@implementation CMMGameKitAchievement
@synthesize identifier,achievement,reported;

+(id)achievementWithAchievement:(GKAchievement *)achievement_{
	return [[[self alloc] initWithAchievement:achievement_] autorelease];
}
-(id)initWithAchievement:(GKAchievement *)achievement_{
	if(!(self = [super init])) return self;
	
	[self setAchievement:achievement_];
	reported = NO;
	
	return self;
}
-(id)initWithCoder:(NSCoder *)decoder_{
	if(!(self = [self initWithAchievement:[decoder_ decodeObjectForKey:cmmVarCMMGameKitAchievement_key_achievement]])) return self;
	reported = [decoder_ decodeBoolForKey:cmmVarCMMGameKitAchievement_key_reported];
	return self;
}

-(NSString *)identifier{
	return [achievement identifier];
}
-(void)setPercentComplete:(double)percentComplete_{
	if([self percentComplete] == percentComplete_) return;
	[achievement setPercentComplete:percentComplete_];
	[self _setReported:NO];
}
-(double)percentComplete{
	return [achievement percentComplete];
}

-(void)encodeWithCoder:(NSCoder *)encoder_{
	[encoder_ encodeObject:achievement forKey:cmmVarCMMGameKitAchievement_key_achievement];
	[encoder_ encodeBool:reported forKey:cmmVarCMMGameKitAchievement_key_reported];
}

-(void)dealloc{
	[achievement release];
	[super dealloc];
}

@end

static CMMGameKitAchievements *_sharedCMMGameKitAchievements_ = nil;

@implementation CMMGameKitAchievements
@synthesize cachedAchievements,reportedAchievements;

+(CMMGameKitAchievements *)sharedAchievements{
	if(!_sharedCMMGameKitAchievements_){
		_sharedCMMGameKitAchievements_ = [[self alloc] init];
	}
	
	return _sharedCMMGameKitAchievements_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	_achievements = [[NSMutableDictionary alloc] init];
	
	return self;
}

-(CMMGameKitAchievement *)_setAchievementWithGkAchievement:(GKAchievement *)gkAchievement_ isReported:(BOOL)isReported_{
	NSString *identifier_ = [gkAchievement_ identifier];
	CMMGameKitAchievement *achievement_ = [self achievementForIdentifier:identifier_];
	if(!achievement_){
		achievement_ = [CMMGameKitAchievement achievementWithAchievement:gkAchievement_];
		[achievement_ _setReported:isReported_];
		[_achievements setObject:achievement_ forKey:identifier_];
	}else if([achievement_ percentComplete] < [gkAchievement_ percentComplete]){
		[achievement_ setPercentComplete:[gkAchievement_ percentComplete]];
		[achievement_ _setReported:NO];
	}
	
	return achievement_;
}
-(void)setAchievementWithIdentifier:(NSString *)identifier_ percentComplete:(double)percentComplete_{
	GKAchievement *gkAchievement_ = [[[GKAchievement alloc] initWithIdentifier:identifier_] autorelease];
	[gkAchievement_ setPercentComplete:percentComplete_];
	[self _setAchievementWithGkAchievement:gkAchievement_ isReported:NO];
}
-(CMMGameKitAchievement *)achievementForIdentifier:(NSString *)identifier_{
	return [_achievements objectForKey:identifier_];
}

-(void)resetAchievementsWithBlock:(void(^)(NSError *error_))block_{
	[GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error_){
		if(!error_){
			[_achievements removeAllObjects];
		}
		if(block_){
			block_(error_);
		}
	}];
}
-(void)resetAchievements{
	[self resetAchievementsWithBlock:nil];
}

-(NSArray *)_achievements:(BOOL)isReported_{
	NSMutableArray *result_ = [NSMutableArray array];
	NSArray *target_ = [_achievements allValues];
	for(CMMGameKitAchievement *achievement_ in target_){
		if([achievement_ isReported] == isReported_){
			[result_ addObject:achievement_];
		}
	}

	return result_;
}
-(NSArray *)cachedAchievements{
	return [self _achievements:NO];
}
-(NSArray *)reportedAchievements{
	return [self _achievements:YES];
}

-(void)dealloc{
	[_achievements release];
	[super dealloc];
}

@end

@implementation CMMGameKitAchievements(ReportedAchievements)

-(void)loadReportedAchievementsWithBlock:(void(^)(NSError *error_))block_{
	[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements_, NSError *error_){
		if(!error_){
			for(GKAchievement *achievement_ in achievements_){
				[self _setAchievementWithGkAchievement:achievement_ isReported:YES];
			}
		}
		if(block_){
			block_(error_);
		}
	}];
}
-(void)loadReportedAchievements{
	[self loadReportedAchievementsWithBlock:nil];
}

@end

@implementation CMMGameKitAchievements(CachedAchievements)

-(void)reportCachedAchievementsWithBlock:(void(^)(NSArray *reportedAchievements_ ,NSError *error_))block_{
	NSArray *cachedAchievements_ = [self cachedAchievements];
	NSMutableArray *targetArray_ = [NSMutableArray array];
	for(CMMGameKitAchievement *achievement_ in cachedAchievements_){
		[targetArray_ addObject:[achievement_ achievement]];
	}

	[GKAchievement reportAchievements:targetArray_ withCompletionHandler:^(NSError *error_) {
		if(!error_){
			for(CMMGameKitAchievement *achievement_ in cachedAchievements_){
				[achievement_ _setReported:YES];
			}
		}
		if(block_){
			block_(cachedAchievements_, error_);
		}
	}];
}
-(void)reportCachedAchievements{
	[self reportCachedAchievementsWithBlock:nil];
}

-(void)writeCachedAchievementsToFileWithBlock:(void(^)(NSError *error_))block_{
	NSData *targetData_ = [NSKeyedArchiver archivedDataWithRootObject:[self cachedAchievements]];
	[CMMFileUtil writeFileInBackgroundWithData:targetData_ path:[CMMStringUtil stringPathOfDocument:cmmVarCMMGameKitAchievements_cacheName] block:block_];
}
-(void)writeCachedAchievementsToFile{
	[self writeCachedAchievementsToFileWithBlock:nil];
}

-(void)loadCachedAchievementsFromFileWithBlock:(void(^)(BOOL isSucceed_))block_{
	cmmFunc_callBackQueue(^{
		NSData *achievementsData_ = [CMMFileUtil dataWithFileName:cmmVarCMMGameKitAchievements_cacheName isInDocument:YES];
		if(achievementsData_){
			NSDictionary *cachedDict_ = [NSKeyedUnarchiver unarchiveObjectWithData:achievementsData_];
			NSArray *cachedValues_ = [cachedDict_ allValues];
			for(CMMGameKitAchievement *achievement_ in cachedValues_){
				[self setAchievementWithIdentifier:[achievement_ identifier] percentComplete:[achievement_ percentComplete]];
			}
		}
		
		if(block_){
			block_(achievementsData_ != nil);
		}
	});
}
-(void)loadCachedAchievementsFromFile{
	[self loadCachedAchievementsFromFileWithBlock:nil];
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

-(void)receivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_{
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
			if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:whenFailedFindingMatchWithError:))){
				[delegate_ gameKitHandlerMatch:self whenFailedFindingMatchWithError:error_];
			}
		}else{
			if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:whenFoundMatch:withRequest:))){
				[delegate_ gameKitHandlerMatch:self whenFoundMatch:match_ withRequest:request_];
			}
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
			if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:whenFailedConnetingToMatch:withError:))){
				[delegate_ gameKitHandlerMatch:self whenFailedConnetingToMatch:match_ withError:error_];
			}
		}else if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:whenConnectedToMatch:))){
			[self setMatch:match_];
			[delegate_ gameKitHandlerMatch:self whenConnectedToMatch:match_];
		}
	}];
}

-(void)match:(GKMatch *)match_ didReceiveData:(NSData *)data_ fromPlayer:(NSString *)playerID_{
	[self receivePacketData:(CMMPacketData *)data_ fromID:playerID_];
}

-(void)sendPacketData:(CMMPacketData *)packetData_ toIDs:(NSArray *)toIDs_{
	[_sharedCMMGameKitHandlerMatch_GKMatch_ sendData:[packetData_ toPackedData] toPlayers:toIDs_ withDataMode:sendDataMode error:nil];
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
	[_sharedCMMGameKitHandlerMatch_GKMatch_ sendDataToAllPlayers:[packetData_ toPackedData] withDataMode:sendDataMode error:nil];
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
	if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:playerID:didChangeState:))){
		[delegate_ gameKitHandlerMatch:self playerID:playerID_ didChangeState:state_];
	}
}

-(void)match:(GKMatch *)match_ didFailWithError:(NSError *)error_{
	id<CMMGameKitHandlerMatchDelegate> delegate_ = (id<CMMGameKitHandlerMatchDelegate>)delegate;
	if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:whenMatchFailedWithError:))){
		[delegate_ gameKitHandlerMatch:self whenMatchFailedWithError:error_];
	}
}

-(BOOL)match:(GKMatch *)match_ shouldReinvitePlayer:(NSString *)playerID_{
	id<CMMGameKitHandlerMatchDelegate> delegate_ = (id<CMMGameKitHandlerMatchDelegate>)delegate;
	if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerMatch:shouldReinvitePlayer:))){
		return [delegate_ gameKitHandlerMatch:self shouldReinvitePlayer:playerID_];
	}
	
	return NO;
}

-(void)dealloc{
	[delegate release];
	[self setMatch:nil];
	[super dealloc];
}

@end

static GKSession *_sharedCMMGameKitHandlerSession_GKSession_ = nil;

@implementation CMMGameKitHandlerSession
@synthesize session,sessionMode,sendDataMode,connectionRequestTimeout;

-(id)init{
	if(!(self = [super init])) return self;
	
	sendDataMode = GKSendDataReliable;
	connectionRequestTimeout = 30.0f;
	
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
	
	[NSException raise:@"CMMGameKitHandlerSession" format:@"can't identifies current session mode, GKSession is not open"];
	return GKSessionModeClient;
}

-(void)openGameSessionWithSessionID:(NSString *)sessionID_ displayName:(NSString *)displayName_ sessionMode:(GKSessionMode)sessionMode_{
	[self setSession:[[[GKSession alloc] initWithSessionID:sessionID_ displayName:displayName_ sessionMode:sessionMode_] autorelease]];
	[_sharedCMMGameKitHandlerSession_GKSession_ setAvailable:YES];
	[_sharedCMMGameKitHandlerSession_GKSession_ setDataReceiveHandler:self withContext:nil];
}

-(void)connectToPeer:(NSString *)peerID_{
	if(!_sharedCMMGameKitHandlerSession_GKSession_) return;
	[_sharedCMMGameKitHandlerSession_GKSession_ connectToPeer:peerID_ withTimeout:connectionRequestTimeout];
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
	[self receivePacketData:(CMMPacketData *)data_ fromID:peerID_];
}

-(void)sendPacketData:(CMMPacketData *)packetData_ toIDs:(NSArray *)toIDs_{
	[_sharedCMMGameKitHandlerSession_GKSession_ sendData:[packetData_ toPackedData] toPeers:toIDs_ withDataMode:sendDataMode error:nil];
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
	[_sharedCMMGameKitHandlerSession_GKSession_ sendDataToAllPeers:[packetData_ toPackedData] withDataMode:sendDataMode error:nil];
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
	if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerSession:peer:didChangeState:))){
		[delegate_ gameKitHandlerSession:self peer:peerID_ didChangeState:state_];
	}
}

-(void)session:(GKSession *)session_ didReceiveConnectionRequestFromPeer:(NSString *)peerID_{
	id<CMMGameKitHandlerSessionDelegate> delegate_ = (id<CMMGameKitHandlerSessionDelegate>)delegate;
	if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerSession:whenFoundConnectionWithPeer:))){
		[delegate_ gameKitHandlerSession:self whenFoundConnectionWithPeer:peerID_];
	}
}

-(void)session:(GKSession *)session_ connectionWithPeerFailed:(NSString *)peerID_ withError:(NSError *)error_{
	id<CMMGameKitHandlerSessionDelegate> delegate_ = (id<CMMGameKitHandlerSessionDelegate>)delegate;
	if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerSession:whenFailedConnectionWithPeer:withError:))){
		[delegate_ gameKitHandlerSession:self whenFailedConnectionWithPeer:peerID_ withError:error_];
	}
}

-(void)session:(GKSession *)session_ didFailWithError:(NSError *)error_{
	id<CMMGameKitHandlerSessionDelegate> delegate_ = (id<CMMGameKitHandlerSessionDelegate>)delegate;
	if(cmmFunc_respondsToSelector(delegate_, @selector(gameKitHandlerSession:whenSessionFailedWithError:))){
		[delegate_ gameKitHandlerSession:self whenSessionFailedWithError:error_];
	}
}

-(void)dealloc{
	[self setSession:nil];
	[super dealloc];
}

@end