#import "cocos2d.h"
#import "CDAudioManager.h"

typedef int SoundID;

@class CMMSoundEngine;

@interface CMMSoundEngineBuffer : NSObject{
	CMMSoundEngine *engine;
	
	NSMutableDictionary *sharedBufferList;
	CCArray *freedSoundIDs;
	
	int _soundIDSeq_;
}

-(id)initSoundEngineBuffer:(CMMSoundEngine *)engine_;

-(BOOL)bufferSoundDirect:(SoundID)soundId_ soundPath:(NSString *)soundPath_;
-(SoundID)bufferSound:(NSString *)soundPath_;

-(void)debufferSound:(SoundID)soundID_;
-(void)debufferAllSounds;

-(BOOL)isBuffered:(SoundID)soundId_;

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

-(void)play:(SoundID)soundId_ gain:(Float32)gain_ pan:(Float32)pan_ pitch:(Float32)pitch_;
-(void)play:(SoundID)soundId_ gain:(Float32)gain_ pan:(Float32)pan_;
-(void)play:(SoundID)soundId_ gain:(Float32)gain_;
-(void)play:(SoundID)soundId_;

-(void)stop:(SoundID)soundId_;

-(SoundID)bufferAndplay:(NSString*)filePath_ gain:(Float32)gain_ pan:(Float32)pan_ pitch:(Float32)pitch_;
-(SoundID)bufferAndplay:(NSString*)filePath_ gain:(Float32)gain_ pan:(Float32)pan_;
-(SoundID)bufferAndplay:(NSString*)filePath_ gain:(Float32)gain_;
-(SoundID)bufferAndplay:(NSString*)filePath_;

-(CDSoundSource *)soundSource:(SoundID)soundId_;

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

typedef enum{
	CMMSoundHandlerItemType_default,
	CMMSoundHandlerItemType_follow,
} CMMSoundHandlerItemType;

@interface CMMSoundHandlerItem : NSObject{
	CDSoundSource *soundSource;
	CMMSoundHandlerItemType type;
	
	CGPoint soundPoint;
	float gainRate,panRate;
	BOOL isLoop,deregWhenStop;
	ccTime loopDelayTime,_curLoopDelayTime;
}

+(id)itemWithSoundSource:(CDSoundSource *)soundSource_ soundPoint:(CGPoint)soundPoint_;
-(id)initWithSoundSource:(CDSoundSource *)soundSource_ soundPoint:(CGPoint)soundPoint_;

-(void)update:(ccTime)dt_;

-(void)play;
-(void)stop;

-(void)resetState;

@property (nonatomic, readonly) SoundID soundID;
@property (nonatomic, retain) CDSoundSource *soundSource;
@property (nonatomic, readonly) CMMSoundHandlerItemType type;

@property (nonatomic, readwrite) CGPoint soundPoint;
@property (nonatomic, readwrite) float gainRate,panRate,gain,pan,pitch;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readwrite) BOOL isLoop;
@property (nonatomic, readwrite) ccTime loopDelayTime;
@property (nonatomic, readwrite) BOOL deregWhenStop;

@end

@interface CMMSoundHandlerItemFollow : CMMSoundHandlerItem{
	CCNode *trackNode;
}

+(id)itemWithSoundSource:(CDSoundSource *)soundSource_ trackNode:(CCNode *)trackNode_;
-(id)initWithSoundSource:(CDSoundSource *)soundSource_ trackNode:(CCNode *)trackNode_;

@property (nonatomic, retain) CCNode *trackNode;

@end

@interface CMMSoundHandler : NSObject{
	CCArray *itemList;
	CMMSoundEngine *sharedEngine;
	
	CGPoint centerPoint;
	float soundDistance,panRate;
	int maxItemPerSound;
	
	CCArray *_cachedElements;
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

-(int)indexOfSoundItem:(CMMSoundHandlerItem *)soundItem_;

-(CMMSoundHandlerItem *)addSoundItem:(NSString*)soundPath_ soundPoint:(CGPoint)soundPoint_;
-(CMMSoundHandlerItemFollow *)addSoundItemFollow:(NSString*)soundPath_ trackNode:(CCNode *)trackNode_;

-(CMMSoundHandlerItem *)soundElementAtIndex:(int)index_;

-(void)removeSoundItemAtIndex:(int)index_;
-(void)removeSoundItem:(CMMSoundHandlerItem *)soundItem_;
-(void)removeSoundItemOfTrackNode:(CCNode *)trackNode_;
-(void)removeAllSoundItem;

@end

@interface CMMSoundHandler(Cache)

-(CMMSoundHandlerItem *)cachedSoundItem:(CMMSoundHandlerItemType)soundItemType_;

@end