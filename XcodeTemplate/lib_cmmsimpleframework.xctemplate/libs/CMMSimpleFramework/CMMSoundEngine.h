#import "cocos2d.h"
#import "CDAudioManager.h"
#import "CMMSimpleCache.h"

typedef int CMMSoundID;

@class CMMSoundEngine;

@interface CMMSoundEngineBuffer : NSObject{
	CMMSoundEngine *engine;
	
	NSMutableDictionary *sharedBufferList;
	CCArray *freedSoundIDs;
	
	int _soundIDSeq_;
}

-(id)initSoundEngineBuffer:(CMMSoundEngine *)engine_;

-(BOOL)bufferSoundDirect:(CMMSoundID)soundId_ soundPath:(NSString *)soundPath_;
-(CMMSoundID)bufferSound:(NSString *)soundPath_;

-(void)debufferSound:(CMMSoundID)soundID_;
-(void)debufferAllSounds;

-(BOOL)isBuffered:(CMMSoundID)soundId_;

@property (nonatomic, assign) CMMSoundEngine *engine;
@property (nonatomic, readonly) NSMutableDictionary *sharedBufferList;

@end

@interface CMMSoundEngineBack : NSObject{
	CMMSoundEngine *engine;
}

-(id)initSoundEngineBack:(CMMSoundEngine *)engine_;

-(void)preload:(NSString*)filePath_;
-(void)play:(NSString*)filePath_ loop:(BOOL)loop_;
-(void)play:(NSString*)filePath_;
-(void)stop;
-(void)pause;
-(void)resume;
-(void)rewind;

@property (nonatomic, assign) CMMSoundEngine *engine;
@property (nonatomic, readonly) BOOL isPlaying,willPlay;
@property (nonatomic, readwrite) float volume;

@end

@interface CMMSoundEngineEffect : NSObject{
	CMMSoundEngine *engine;
}

-(id)initSoundEngineEffect:(CMMSoundEngine *)engine_;

-(void)play:(CMMSoundID)soundId_ gain:(Float32)gain_ pan:(Float32)pan_ pitch:(Float32)pitch_;
-(void)play:(CMMSoundID)soundId_ gain:(Float32)gain_ pan:(Float32)pan_;
-(void)play:(CMMSoundID)soundId_ gain:(Float32)gain_;
-(void)play:(CMMSoundID)soundId_;

-(void)stop:(CMMSoundID)soundId_;

-(CMMSoundID)bufferAndplay:(NSString*)filePath_ gain:(Float32)gain_ pan:(Float32)pan_ pitch:(Float32)pitch_;
-(CMMSoundID)bufferAndplay:(NSString*)filePath_ gain:(Float32)gain_ pan:(Float32)pan_;
-(CMMSoundID)bufferAndplay:(NSString*)filePath_ gain:(Float32)gain_;
-(CMMSoundID)bufferAndplay:(NSString*)filePath_;

-(CDSoundSource *)soundSource:(CMMSoundID)soundId_;

@property (nonatomic, assign) CMMSoundEngine *engine;
@property (nonatomic, readwrite) float volume;

@end

@interface CMMSoundEngine : NSObject<CDAudioInterruptProtocol>{
	CDAudioManager *audioManager;
	CDSoundEngine* soundEngine;
	
	CMMSoundEngineBuffer *buffer;
	CMMSoundEngineBack *back;
	CMMSoundEngineEffect *effect;
}

+(CMMSoundEngine *)sharedEngine;

-(id)initSoundEngine;

@property (nonatomic, readonly) CDAudioManager *audioManager;
@property (nonatomic, readonly) CDSoundEngine* soundEngine;

@property (nonatomic, readwrite) BOOL mute,enabled;

@property (nonatomic, readonly) CMMSoundEngineBuffer *buffer;
@property (nonatomic, readonly) CMMSoundEngineBack *back;
@property (nonatomic, readonly) CMMSoundEngineEffect *effect;

@end

@interface CMMSoundHandlerItem : NSObject{
	CDSoundSource *soundSource;
	
	CGPoint soundPoint;
	float gainRate,panRate;
	BOOL isLoop,deregWhenStop;
	ccTime loopDelayTime,_curLoopDelayTime;
	
	CCNode *trackNode;
}

+(id)itemWithSoundSource:(CDSoundSource *)soundSource_ soundPoint:(CGPoint)soundPoint_;
-(id)initWithSoundSource:(CDSoundSource *)soundSource_ soundPoint:(CGPoint)soundPoint_;

-(void)update:(ccTime)dt_;

-(void)play;
-(void)stop;

-(void)resetState;

@property (nonatomic, readonly) CMMSoundID soundID;
@property (nonatomic, retain) CDSoundSource *soundSource;

@property (nonatomic, readwrite) CGPoint soundPoint;
@property (nonatomic, readwrite) float gainRate,panRate,gain,pan,pitch;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readwrite) BOOL isLoop;
@property (nonatomic, readwrite) ccTime loopDelayTime;
@property (nonatomic, readwrite) BOOL deregWhenStop;

@property (nonatomic, retain) CCNode *trackNode;

@end

@interface CMMSoundHandler : NSObject{
	CCArray *itemList;
	CMMSoundEngine *sharedEngine;
	
	CGPoint centerPoint;
	float soundDistance,panRate;
	int maxItemPerSound;
	
	CMMSimpleCache *_cachedElements;
}

+(id)soundHandler:(CGPoint)centerPoint_ soundDistance:(float)soundDistance_ panRate:(float)panRate_;
+(id)soundHandler:(CGPoint)centerPoint_ soundDistance:(float)soundDistance_;
+(id)soundHandler:(CGPoint)centerPoint_;

-(id)initSoundHandler:(CGPoint)centerPoint_ soundDistance:(float)soundDistance_ panRate:(float)panRate_;
-(id)initSoundHandler:(CGPoint)centerPoint_ soundDistance:(float)soundDistance_;
-(id)initSoundHandler:(CGPoint)centerPoint_;

-(void)update:(ccTime)dt_;

@property (nonatomic, readwrite) CGPoint centerPoint;
@property (nonatomic, readwrite) float soundDistance,panRate;
@property (nonatomic, readwrite) int maxItemPerSound;

@end

@interface CMMSoundHandler(Common)

-(CMMSoundHandlerItem *)addSoundItemWithSoundPath:(NSString*)soundPath_ soundPoint:(CGPoint)soundPoint_;
-(CMMSoundHandlerItem *)addSoundItemWithSoundPath:(NSString*)soundPath_;

-(void)removeSoundItemAtIndex:(uint)index_;
-(void)removeSoundItem:(CMMSoundHandlerItem *)soundItem_;
-(void)removeSoundItemOfTrackNode:(CCNode *)trackNode_;
-(void)removeAllSoundItem;

-(CMMSoundHandlerItem *)soundElementAtIndex:(uint)index_;

-(uint)indexOfSoundItem:(CMMSoundHandlerItem *)soundItem_;

@end