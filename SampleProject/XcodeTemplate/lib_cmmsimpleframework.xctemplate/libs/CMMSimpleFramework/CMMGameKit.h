//  Created by JGroup(kimbobv22@gmail.com)

#import <GameKit/GameKit.h>
#import "CMMMacro.h"
#import "CMMPacket.h"

#import "CMMStringUtil.h"
#import "CMMFileUtil.h"

@class CMMGameKitPA;

@protocol CMMGameKitPADelegate<NSObject>

@optional
//Authentication
-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenChangedAuthenticationWithBOOL:(BOOL)isAuthenticated_;

-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenTryAuthenticationWithViewController:(UIViewController *)viewController_;
-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenCompletedAuthenticationWithLocalPlayer:(GKPlayer *)localPlayer_;
-(void)gameKitPA:(CMMGameKitPA *)gameKitPA_ whenFailedAuthenticationWithError:(NSError *)error_;

@end

//Player Authentication
@interface CMMGameKitPA : NSObject{
	id<CMMGameKitPADelegate> delegate;
	BOOL isAvailableGameCenter;
}

+(CMMGameKitPA *)sharedPA;

@property (nonatomic, retain) id<CMMGameKitPADelegate> delegate;
@property (nonatomic, readonly) BOOL isAvailableGameCenter,isAuthenticated;

@end

@class CMMGameKitLeaderBoard;

@protocol CMMGameKitLeaderBoardDelegate <NSObject>

@optional
-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenReceiveCategory:(NSArray *)category_ withTitle:(NSArray *)title_;
-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenFailedReceivingCategoryWithError:(NSError *)error_;

-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenReceiveLeaderBoard:(GKLeaderboard *)leaderBoard_;
-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenFailedReceivingLeaderBoard:(GKLeaderboard *)leaderBoard_ withError:(NSError *)error_;

-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenCompletedSendingScore:(GKScore *)score_;
-(void)gameKitLeaderBoard:(CMMGameKitLeaderBoard *)gameKitLeaderBoard_ whenFailedSendingScore:(GKScore *)score_ withError:(NSError *)error_;

@end

@interface CMMGameKitLeaderBoard : NSObject{
	id<CMMGameKitLeaderBoardDelegate> delegate;
}

+(CMMGameKitLeaderBoard *)sharedLeaderBoard;

-(void)loadCategory;

-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_ playerScope:(GKLeaderboardPlayerScope)playerScope_;
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_ timeScope:(GKLeaderboardTimeScope)timeScope_;
-(void)loadLeaderBoardWithCategory:(NSString *)category_ range:(NSRange)range_;

-(void)reportScore:(int64_t)score_ category:(NSString*)category_;

@property (nonatomic, retain) id<CMMGameKitLeaderBoardDelegate> delegate;

@end

@class CMMGameKitAchievements;

@protocol CMMGameKitAchievementsDelegate <NSObject>

@optional
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenCompletedReportingAchievements:(NSArray *)reportedAchievements_;
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedReportingAchievementsWithError:(NSError *)error_;

-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenReceiveAchievements:(NSArray *)achievements_;
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedReceivingAchievementsWithError:(NSError *)error_;

-(void)gameKitAchievements_whenCompletedResettingAchievements:(CMMGameKitAchievements *)gameKitAchievements_;
-(void)gameKitAchievements:(CMMGameKitAchievements *)gameKitAchievements_ whenFailedResettingAchievementsWithError:(NSError *)error_;

@end

#define cmmVarCMMGameKitAchievements_cacheName @"_cmmFile_achievements_cache_"

@interface CMMGameKitAchievements : NSObject{
	id<CMMGameKitAchievementsDelegate> delegate;
	NSMutableArray *_cachedAchievements,*_reportedAchievements;
}

+(CMMGameKitAchievements *)sharedAchievements;

-(void)setAchievementWithIdentifier:(NSString *)identifier_ percentComplete:(double)percentComplete_;
-(void)resetAchievements;

@property (nonatomic, retain) id<CMMGameKitAchievementsDelegate> delegate;
@property (nonatomic, readonly) NSArray *cachedAchievements,*reportedAchievements;

@end

@interface CMMGameKitAchievements(ReportedAchievements)

-(GKAchievement *)reportedAchievementAtIndex:(uint)index_;
-(GKAchievement *)reportedAchievementAtIdentifier:(NSString *)identifier_;

-(uint)indexOfReportedAchievement:(GKAchievement *)achievement_;
-(uint)indexOfReportedAchievementWithIdentifier_:(NSString *)identifier_;

-(void)loadReportedAchievements;

@end

@interface CMMGameKitAchievements(CachedAchievements)

-(GKAchievement *)cachedAchievementAtIndex:(uint)index_;
-(GKAchievement *)cachedAchievementAtIdentifier:(NSString *)identifier_;

-(uint)indexOfCachedAchievement:(GKAchievement *)achievement_;
-(uint)indexOfCachedAchievementWithIdentifier_:(NSString *)identifier_;

-(void)reportCachedAchievements;
-(void)writeCachedAchievements;

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

@property (nonatomic, retain) id<CMMGameKitHandlerDelegate> delegate;
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