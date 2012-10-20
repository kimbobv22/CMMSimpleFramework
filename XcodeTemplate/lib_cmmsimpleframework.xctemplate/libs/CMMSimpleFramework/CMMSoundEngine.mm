#import "CMMSoundEngine.h"

static CMMSoundEngine* sharedsoundEngine = nil;

@implementation CMMSoundEngineBuffer
@synthesize engine,sharedBufferList;

-(id)initSoundEngineBuffer:(CMMSoundEngine *)engine_{
	if(!(self = [super init])) return self;
	
	engine = engine_;
	sharedBufferList = [[NSMutableDictionary alloc] init];
	
	freedSoundIDs = [[CCArray alloc] init];
	
	_soundIDSeq_ = 0;
	
	return self;
}

-(BOOL)bufferSoundDirect:(SoundID)soundId_ soundPath:(NSString *)soundPath_{
	if(soundId_>=_soundIDSeq_)
		_soundIDSeq_ = soundId_+1;
	
	if([engine.soundEngine loadBuffer:soundId_ filePath:soundPath_]){
		[sharedBufferList setObject:soundPath_ forKey:[NSNumber numberWithInt:soundId_]];
		return YES;
	}return NO;
}

-(SoundID)bufferSound:(NSString *)soundPath_{
	NSArray *soundPaths_ = [sharedBufferList allKeys];
	uint count_ = soundPaths_.count;
	for(int index_=0; index_<count_;++index_){
		NSNumber *soundId_ = [soundPaths_ objectAtIndex:index_];
		NSString *existsPath_ = [sharedBufferList objectForKey:soundId_];
		if([existsPath_ isEqualToString:soundPath_]){
			CCLOG(@"bufferSound : Shared SoundID %d",[soundId_ intValue]);
			return (SoundID)[soundId_ intValue];
		}
	}
	
	SoundID targetSoundId_;
	if([freedSoundIDs count] > 0){
		targetSoundId_ = [[freedSoundIDs lastObject] intValue];
		[freedSoundIDs removeLastObject]; 
	}else targetSoundId_ = _soundIDSeq_++;
	
	
	if([self bufferSoundDirect:targetSoundId_ soundPath:soundPath_]){
		CCLOG(@"bufferSound : New SoundID %d",targetSoundId_);
		return targetSoundId_;
	}else{
		CCLOG(@"bufferSound: Error!");
		return kCDNoBuffer;
	}
}

-(void)debufferSound:(SoundID)soundId_{
	NSNumber *soundIDO_ = [NSNumber numberWithInt:soundId_];
	if(![sharedBufferList objectForKey:soundIDO_])
		return;
	
	[engine.soundEngine unloadBuffer:soundId_];
	[sharedBufferList removeObjectForKey:soundIDO_];
	[freedSoundIDs addObject:soundIDO_];
}

-(void)debufferAllSounds{
	NSArray *allKey_ = [sharedBufferList allKeys];
	for(NSNumber *soundId_ in allKey_)
		[self debufferSound:[soundId_ intValue]];
}

-(BOOL)isBuffered:(SoundID)soundId_{
	if([sharedBufferList objectForKey:[NSNumber numberWithInt:soundId_]])
		return YES;
	return NO;
}

-(void)dealloc{
	[sharedBufferList release];
	[freedSoundIDs release];
	[super dealloc];
}

@end

@implementation CMMSoundEngineBack
@synthesize engine,isPlaying,willPlay,volume;

-(id)initSoundEngineBack:(CMMSoundEngine *)engine_{
	if(!(self = [super init])) return self;
	
	engine = engine_;
	
	return self;
}

-(void)preload:(NSString*)filePath_{
	[engine.audioManager preloadBackgroundMusic:filePath_];
}

-(void)play:(NSString*)filePath_ loop:(BOOL)loop_{
	[engine.audioManager playBackgroundMusic:filePath_ loop:loop_];
}

-(void)play:(NSString*)filePath_{
	[self play:filePath_ loop:YES];
}

-(void)stop{
	[engine.audioManager stopBackgroundMusic];
}

-(void)pause{
	[engine.audioManager pauseBackgroundMusic];
}	

-(void)resume{
	[engine.audioManager resumeBackgroundMusic];
}	

-(void)rewind{
	[engine.audioManager rewindBackgroundMusic];
}

-(float)volume{
	return engine.audioManager.backgroundMusic.volume;
}

-(void)setVolume:(float)volume_{
	engine.audioManager.backgroundMusic.volume = volume_;
}

-(BOOL)isPlaying{
	return [engine.audioManager isBackgroundMusicPlaying];
}

-(BOOL)willPlay{
	return [engine.audioManager willPlayBackgroundMusic];
}

@end

@implementation CMMSoundEngineEffect
@synthesize engine,volume;

-(id)initSoundEngineEffect:(CMMSoundEngine *)engine_{
	if(!(self = [super init])) return self;
	
	engine = engine_;
	
	return self;
}

-(void)play:(SoundID)soundId_ gain:(Float32)gain_ pan:(Float32)pan_ pitch:(Float32)pitch_{
	if([engine.buffer isBuffered:soundId_])
		[engine.soundEngine playSound:soundId_ sourceGroupId:0 pitch:pitch_ pan:pan_ gain:gain_ loop:false];
}
-(void)play:(SoundID)soundId_ gain:(Float32)gain_ pan:(Float32)pan_{
	[self play:soundId_ gain:gain_ pan:pan_ pitch:1.0f];
}
-(void)play:(SoundID)soundId_ gain:(Float32)gain_{
	[self play:soundId_ gain:gain_ pan:0];
}
-(void)play:(SoundID)soundId_{
	[self play:soundId_ gain:1.0f];
}

-(void)stop:(SoundID)soundId_{
	[engine.soundEngine stopSound:soundId_];
}

-(SoundID)bufferAndplay:(NSString*)filePath_ gain:(Float32)gain_ pan:(Float32)pan_ pitch:(Float32)pitch_{
	int soundId_ = [engine.buffer bufferSound:filePath_];
	[self play:soundId_ gain:gain_ pan:pan_ pitch:pitch_];
	return soundId_;
}
-(SoundID)bufferAndplay:(NSString*)filePath_ gain:(Float32)gain_ pan:(Float32)pan_{
	return [self bufferAndplay:filePath_ gain:gain_ pan:pan_ pitch:1.0f];
}
-(SoundID)bufferAndplay:(NSString*)filePath_ gain:(Float32)gain_{
	return [self bufferAndplay:filePath_ gain:gain_ pan:0];
}
-(SoundID)bufferAndplay:(NSString*)filePath_{
	return [self bufferAndplay:filePath_ gain:1.0f];
}

-(float)volume{
	return engine.soundEngine.masterGain;
}

-(void)setVolume:(float)volume_{
	engine.soundEngine.masterGain = volume_;
}

-(CDSoundSource *)soundSource:(SoundID)soundId_{
	return [engine.soundEngine soundSourceForSound:soundId_ sourceGroupId:0];
}	

@end

@implementation CMMSoundEngine
@synthesize audioManager,soundEngine,mute,enabled,buffer,back,effect;

+(CMMSoundEngine *)sharedEngine{
	if(!sharedsoundEngine)
		sharedsoundEngine = [[CMMSoundEngine alloc] initSoundEngine];
	
	return sharedsoundEngine;
}

-(id)initSoundEngine{
	if(!(self = [super init])) return self;
	
	audioManager = [CDAudioManager sharedManager];
	soundEngine = audioManager.soundEngine;
	
	buffer = [[CMMSoundEngineBuffer alloc] initSoundEngineBuffer:self];
	back = [[CMMSoundEngineBack alloc] initSoundEngineBack:self];
	effect = [[CMMSoundEngineEffect alloc] initSoundEngineEffect:self];
	
	return self;
}

-(BOOL)mute{
	return audioManager.mute;
}
-(void)setMute:(BOOL)mute_{
	audioManager.mute = mute_;
}

-(BOOL)enabled{
	return audioManager.enabled;
}

-(void)setEnabled:(BOOL)enabled_{
	audioManager.enabled = enabled_;
}

-(void)dealloc{
	[effect release];
	[back release];
	[buffer release];
	[CDAudioManager end];
	[sharedsoundEngine release];
	[super dealloc];
}

@end

@implementation CMMSoundHandlerItem
@synthesize soundID,soundPoint,soundSource,gainRate,panRate,gain,pan,pitch,isPlaying,isLoop,loopDelayTime,deregWhenStop,trackNode;

+(id)itemWithSoundSource:(CDSoundSource *)soundSource_ soundPoint:(CGPoint)soundPoint_{
	return [[[self alloc] initWithSoundSource:soundSource_ soundPoint:soundPoint_] autorelease];
}
-(id)initWithSoundSource:(CDSoundSource *)soundSource_ soundPoint:(CGPoint)soundPoint_{
	if(!(self = [super init])) return self;
	
	self.soundSource = soundSource_;
	soundPoint = soundPoint_;
	gainRate = panRate = 1.0f;
	deregWhenStop = NO;
	isLoop = NO;
	loopDelayTime = _curLoopDelayTime = 0.0f;
	
	return self;
}

-(SoundID)soundID{
	if(soundSource)
		return soundSource.soundId;
	else return (SoundID)-1;
}

-(void)setGain:(float)gain_{
	soundSource.gain = MAX(MIN(gain_,1),0)*gainRate;
}
-(float)gain{
	return soundSource.gain;
}

-(void)setPan:(float)pan_{
	soundSource.pan = MAX(MIN((pan_)*panRate,1.0f),-1.0f);
}
-(float)pan{
	return soundSource.pan;
}

-(void)setPitch:(float)pitch_{
	soundSource.pitch = MAX(MIN(pitch_,2.0f),0.5);
}
-(float)pitch{
	return soundSource.pitch;
}

-(BOOL)isPlaying{
	return soundSource.isPlaying;
}

-(void)setSoundSource:(CDSoundSource *)soundSource_{
	if(soundSource == soundSource_) return;
	[soundSource release];
	soundSource = [soundSource_ retain];
}

-(void)play{
	self.gain = 0.0f;
	[soundSource play];
}
-(void)stop{
	[soundSource stop];
}

-(void)update:(ccTime)dt_{
	if(trackNode)
		soundPoint = [trackNode position];
	
	if(isLoop){
		if(!self.isPlaying){
			_curLoopDelayTime += dt_;
			if(loopDelayTime <= _curLoopDelayTime){
				_curLoopDelayTime = 0.0f;
				[self play];
			}
		}
	}
}

-(void)resetState{
	soundPoint = CGPointZero;
	[self setTrackNode:nil];
}

-(void)dealloc{
	[soundSource release];
	[trackNode release];
	[super dealloc];
}

@end

@interface CMMSoundHandler(Private)

-(CMMSoundHandlerItem *)_addSoundItemWithSoundPath:(NSString*)soundPath_;
-(BOOL)_isExistSoundID:(SoundID)soundID_;

@end

@implementation CMMSoundHandler(Private)

-(CMMSoundHandlerItem *)_addSoundItemWithSoundPath:(NSString*)soundPath_{
	SoundID soundID_ = [sharedEngine.buffer bufferSound:soundPath_];
	ccArray *data_ = itemList->data;
	int targetSoundCount = 0;
	int targetIndex_ = -1;
	for(uint index_=0;index_<data_->num;++index_){
		CMMSoundHandlerItem *soundItem_ = data_->arr[index_];
		if(soundItem_.soundID == soundID_){
			if(targetIndex_<0) targetIndex_ = index_;
			targetSoundCount++;
		}
	}
	
	CMMSoundHandlerItem *soundItem_;
	if(targetSoundCount>maxItemPerSound){
		soundItem_ = [[data_->arr[targetIndex_] retain] autorelease];
		[itemList removeObjectAtIndex:targetIndex_];
		[itemList addObject:soundItem_];
		CCLOG(@"reuse soundItem %d -> %d",targetIndex_,data_->num-1);
	}else{
		soundItem_ = [_cachedElements cachedObject];
#if CD_DEBUG >= 1
		if(soundItem_) CCLOG(@"cached soundItem");
#endif
		
		if(!soundItem_){
			soundItem_ = [CMMSoundHandlerItem itemWithSoundSource:nil soundPoint:CGPointZero];
			CCLOG(@"new soundElement");
		}
		
		soundItem_.soundSource = [sharedEngine.effect soundSource:soundID_];
		soundItem_.gainRate = soundItem_.panRate = 1.0f;
		soundItem_.deregWhenStop = NO;
		[itemList addObject:soundItem_];
	}
	
	return soundItem_;
}

-(BOOL)_isExistSoundID:(SoundID)soundID_{
	ccArray *data_ = itemList->data;
	for(uint index_=0;index_>data_->num;++index_){
		CMMSoundHandlerItem *soundItem_ = data_->arr[index_];
		if(soundItem_.soundID == soundID_)
			return YES;
	}
	return NO;
}

@end

@implementation CMMSoundHandler
@synthesize centerPoint,maxItemPerSound,soundDistance,panRate;

+(id)soundHandler:(CGPoint)centerPoint_ soundDistance:(float)soundDistance_ panRate:(float)panRate_{
	return [[[self alloc] initSoundHandler:centerPoint_ soundDistance:soundDistance_ panRate:panRate_] autorelease];
}
+(id)soundHandler:(CGPoint)centerPoint_ soundDistance:(float)soundDistance_{
	return [self soundHandler:centerPoint_ soundDistance:soundDistance_ panRate:0.3f];
}
+(id)soundHandler:(CGPoint)centerPoint_{
	return [self soundHandler:centerPoint_ soundDistance:500];
}

-(id)initSoundHandler:(CGPoint)centerPoint_ soundDistance:(float)soundDistance_ panRate:(float)panRate_{
	if(!(self = [super init])) return self;
	
	centerPoint = centerPoint_;
	soundDistance = soundDistance_;
	panRate = panRate_;
	maxItemPerSound = 3;
	
	itemList = [[CCArray alloc] init];
	sharedEngine = [CMMSoundEngine sharedEngine];
	_cachedElements = [[CMMSimpleCache alloc] init];
	
	return self;
}
-(id)initSoundHandler:(CGPoint)centerPoint_ soundDistance:(float)soundDistance_{
	return [self initSoundHandler:centerPoint_ soundDistance:soundDistance_ panRate:0.3f];
}
-(id)initSoundHandler:(CGPoint)centerPoint_{
	return [self initSoundHandler:centerPoint_ soundDistance:500];
}

-(void)update:(ccTime)dt_{
	ccArray *data_ = itemList->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMSoundHandlerItem *soundItem_ = data_->arr[index_];
		if(soundItem_.deregWhenStop && !soundItem_.isPlaying && !soundItem_.isLoop){
			[self removeSoundItemAtIndex:index_];
		}
	}
	
	CMMSoundHandlerItem *soundItem_;
	CCARRAY_FOREACH(itemList, soundItem_){
		[soundItem_ update:dt_];
		
		float distance_ = ccpDistance(soundItem_.soundPoint, centerPoint);
		float distanceRate_ = MIN(MAX(1.0f-(distance_/soundDistance), 0.0f),1.0f);
	
		if(soundItem_.soundSource){
			soundItem_.gain = distanceRate_;
			soundItem_.pan = (soundItem_.soundPoint.x-centerPoint.x)/(soundDistance*panRate);
		}
	}
}

-(void)dealloc{
	ccArray *data_ = itemList->data;
	for(uint index_=0;index_<data_->num;++index_){
		CMMSoundHandlerItem *soundItem_ = data_->arr[index_];
		[sharedEngine.buffer debufferSound:soundItem_.soundID];
	}
	
	[self removeAllSoundItem];
	[itemList release];	
	[_cachedElements release];
	[super dealloc];
}

@end

@implementation CMMSoundHandler(Common)

-(CMMSoundHandlerItem *)addSoundItemWithSoundPath:(NSString*)soundPath_ soundPoint:(CGPoint)soundPoint_{
	CMMSoundHandlerItem *soundItem_ = [self _addSoundItemWithSoundPath:soundPath_];
	[soundItem_ setSoundPoint:soundPoint_];
	return soundItem_;
}
-(CMMSoundHandlerItem *)addSoundItemWithSoundPath:(NSString*)soundPath_{
	return [self addSoundItemWithSoundPath:soundPath_ soundPoint:CGPointZero];
}

-(void)removeSoundItem:(CMMSoundHandlerItem *)soundItem_{
	uint index_ = [self indexOfSoundItem:soundItem_];
	if(index_ == NSNotFound){
		CCLOG(@"removeSoundItemAtIndex : can't find soundElement / index: %d",index_);
		return;
	}
	
	[soundItem_ stop];
	[soundItem_ resetState];
	[soundItem_ setSoundSource:nil];
	
	[_cachedElements addObject:soundItem_];
	[itemList removeObjectAtIndex:index_];
}
-(void)removeSoundItemAtIndex:(uint)index_{
	[self removeSoundItem:[self soundElementAtIndex:index_]];
}

-(void)removeSoundItemOfTrackNode:(CCNode *)trackNode_{
	ccArray *data_ = itemList->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMSoundHandlerItem *soundItem_ = data_->arr[index_];
		if(soundItem_.trackNode == trackNode_)
			[self removeSoundItemAtIndex:index_];
		
	}
}
-(void)removeAllSoundItem{
	ccArray *data_ = itemList->data;
	for(int index_=data_->num-1;index_>=0;--index_){
		[self removeSoundItemAtIndex:index_];
	}
}

-(CMMSoundHandlerItem *)soundElementAtIndex:(uint)index_{
	return [itemList objectAtIndex:index_];
}

-(uint)indexOfSoundItem:(CMMSoundHandlerItem *)soundItem_{
	return [itemList indexOfObject:soundItem_];
}

@end