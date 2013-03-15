//  Created by JGroup(kimbobv22@gmail.com)

#import <GameKit/GameKit.h>
#import "CMMMacro.h"
#import "CMMPacketData.h"

#import "CMMStringUtil.h"
#import "CMMFileUtil.h"

typedef enum{
	CMMGameKitPAAuthenticationState_succeed,
	CMMGameKitPAAuthenticationState_failed,
	CMMGameKitPAAuthenticationState_cancelled,
} CMMGameKitPAAuthenticationState;

//Player Authentication
@interface CMMGameKitPA : NSObject{
	BOOL availableGameCenter;
	
	void (^callback_whenAuthenticationChanged)(BOOL isAuthenticated_);
	void (^authenticateHandler)(CMMGameKitPAAuthenticationState state_, NSError *error_);
}

+(CMMGameKitPA *)sharedPA;

@property (nonatomic, readonly, getter = isAvailableGameCenter) BOOL availableGameCenter;
@property (nonatomic, readonly, getter = isAuthenticated) BOOL authenticated;
@property (nonatomic, copy) void (^callback_whenAuthenticationChanged)(BOOL isAuthenticated_);
@property (nonatomic, copy) void (^authenticateHandler)(CMMGameKitPAAuthenticationState state_, NSError *error_);

-(void)setCallback_whenAuthenticationChanged:(void (^)(BOOL isAuthenticated_))block_;
-(void)setAuthenticateHandler:(void (^)(CMMGameKitPAAuthenticationState state_, NSError *error_))block_;

@end

@interface CMMGameKitLeaderBoardCategory : NSObject{
	NSString *category,*title;
}

+(id)categoryWithCategory:(NSString *)category_ title:(NSString *)title_;
-(id)initWithCategory:(NSString *)category_ title:(NSString *)title_;

@property (nonatomic, copy) NSString *category,*title;

@end

@interface CMMGameKitLeaderBoard : NSObject{
	CCArray *loadedCategories;
}

+(CMMGameKitLeaderBoard *)sharedLeaderBoard;

@property (nonatomic, readonly) CCArray *loadedCategories;

@end

@interface CMMGameKitLeaderBoard(Category)

-(CMMGameKitLeaderBoardCategory *)categoryAtIndex:(uint)index_;

-(void)loadCategoriesWithBlock:(void(^)(CCArray *categories_))block_;
-(void)loadCategories;

@end

@interface CMMGameKitLeaderBoard(Score)

-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_ playerScope:(GKLeaderboardPlayerScope)playerScope_ block:(void(^)(GKLeaderboard *leaderboard_, NSError *error_))block_;
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_ block:(void(^)(GKLeaderboard *leaderboard_, NSError *error_))block_;
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ block:(void(^)(GKLeaderboard *leaderboard_, NSError *error_))block_;

-(void)reportScore:(int64_t)score_ category:(NSString*)category_ block:(void(^)(GKScore *score_, NSError *error_))block_;

@end

#define cmmVarCMMGameKitAchievement_key_achievement @"achiev"
#define cmmVarCMMGameKitAchievement_key_reported @"reported"

@interface CMMGameKitAchievement : NSObject<NSCoding>{
	GKAchievement *achievement;
	BOOL reported;
}

+(id)achievementWithAchievement:(GKAchievement *)achievement_;
-(id)initWithAchievement:(GKAchievement *)achievement_;

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, retain) GKAchievement *achievement;
@property (nonatomic, readwrite) double percentComplete;
@property (nonatomic, readonly, getter = isReported) BOOL reported;

@end

#define cmmVarCMMGameKitAchievements_cacheName @"_cmmFile_achievements_cache_"

@interface CMMGameKitAchievements : NSObject{
	NSMutableDictionary *_achievements;
}

+(CMMGameKitAchievements *)sharedAchievements;

-(void)setAchievementWithIdentifier:(NSString *)identifier_ percentComplete:(double)percentComplete_;
-(CMMGameKitAchievement *)achievementForIdentifier:(NSString *)identifier_;

-(void)resetAchievementsWithBlock:(void(^)(NSError *error_))block_;
-(void)resetAchievements;

@property (nonatomic, readonly) NSArray *cachedAchievements,*reportedAchievements;

@end

@interface CMMGameKitAchievements(ReportedAchievements)

-(void)loadReportedAchievementsWithBlock:(void(^)(NSError *error_))block_;
-(void)loadReportedAchievements;

@end

@interface CMMGameKitAchievements(CachedAchievements)

-(void)reportCachedAchievementsWithBlock:(void(^)(NSArray *reportedAchievements_ ,NSError *error_))block_;
-(void)reportCachedAchievements;

-(void)writeCachedAchievementsToFileWithBlock:(void(^)(NSError *error_))block_;
-(void)writeCachedAchievementsToFile;

-(void)loadCachedAchievementsFromFileWithBlock:(void(^)(BOOL isSucceed))block_;
-(void)loadCachedAchievementsFromFile;

@end

@class CMMGameKitHandler;

@protocol CMMGameKitHandlerDelegate <NSObject>

-(void)gameKitHandler:(CMMGameKitHandler *)gameKitHandler_ whenReceivePacketData:(CMMPacketData *)packetData_ fromID:(NSString *)fromID_;

@end

@interface CMMGameKitHandler : NSObject<CMMPacketDataReceiverProtocol,CMMPacketDataSenderProtocol>{
	id<CMMGameKitHandlerDelegate> delegate;
	NSString *serverID; //user custom value
}

+(id)gameKitHandler;

@property (nonatomic, assign) id<CMMGameKitHandlerDelegate> delegate;
@property (nonatomic, copy) NSString *serverID;
@property (nonatomic, readonly) NSString *myIdentifier;

@end

@class CMMGameKitHandlerMatch;

@protocol CMMGameKitHandlerMatchDelegate <CMMGameKitHandlerDelegate>

-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ whenFoundMatch:(GKMatch *)match_ withRequest:(GKMatchRequest *)request_;
-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ whenFailedFindingMatchWithError:(NSError *)error_;

-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ whenConnectedToMatch:(GKMatch *)match_;
-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ whenFailedConnetingToMatch:(GKMatch *)match_ withError:(NSError *)error_;

-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ whenMatchFailedWithError:(NSError *)error_;

@optional
-(void)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ playerID:(NSString *)playerID_ didChangeState:(GKPlayerConnectionState)state_;
-(BOOL)gameKitHandlerMatch:(CMMGameKitHandlerMatch *)gameKitHandler_ shouldReinvitePlayer:(NSString *)playerID_;

@end

@interface CMMGameKitHandlerMatch : CMMGameKitHandler<GKMatchDelegate>{
	GKMatchSendDataMode sendDataMode;
}

-(void)findMatch:(uint)minPlayerCount_ maxPlayerCount:(uint)maxPlayerCount_;
-(void)findMatch:(uint)minPlayerCount_;

-(void)connectToMatch:(GKMatch *)match_ withRequest:(GKMatchRequest *)request_;

@property (nonatomic, retain) GKMatch *match;
@property (nonatomic, readwrite) GKMatchSendDataMode sendDataMode;

@end

@class CMMGameKitHandlerSession;

@protocol CMMGameKitHandlerSessionDelegate <CMMGameKitHandlerDelegate>

-(void)gameKitHandlerSession:(CMMGameKitHandlerSession *)gameKitHandler_ whenFoundConnectionWithPeer:(NSString *)peerID_;
-(void)gameKitHandlerSession:(CMMGameKitHandlerSession *)gameKitHandler_ whenFailedConnectionWithPeer:(NSString *)peerID_ withError:(NSError *)error_;
-(void)gameKitHandlerSession:(CMMGameKitHandlerSession *)gameKitHandler_ whenSessionFailedWithError:(NSError *)error_;

@optional
-(void)gameKitHandlerSession:(CMMGameKitHandlerSession *)gameKitHandler_ peer:(NSString *)peerID_ didChangeState:(GKPeerConnectionState)state_;

@end

@protocol CMMGameKitHandlerSessionReceiveDataProtocol <NSObject>

-(void)receiveData:(NSData *)data_ fromPeer:(NSString *)peerID_ inSession:(GKSession *)session_ context:(void *)context_;

@end

@interface CMMGameKitHandlerSession : CMMGameKitHandler<GKSessionDelegate,CMMGameKitHandlerSessionReceiveDataProtocol>{
	GKSendDataMode sendDataMode;
	ccTime connectionRequestTimeout;
}

-(void)openGameSessionWithSessionID:(NSString *)sessionID_ displayName:(NSString *)displayName_ sessionMode:(GKSessionMode)sessionMode_;

-(void)connectToPeer:(NSString *)peerID_;
-(void)disconnectPeer:(NSString *)peerID_;
-(void)disconnectFromAllPeers;

@property (nonatomic, retain) GKSession *session;
@property (nonatomic, readonly) GKSessionMode sessionMode;
@property (nonatomic, readwrite) GKSendDataMode sendDataMode;
@property (nonatomic, readwrite) ccTime connectionRequestTimeout;

@end