//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScene.h"

static CMMScene *_sharedScene_ = nil;

@implementation CMMSceneTransitionLayer

//Please override the method below.
-(void)scene:(CMMScene *)scene_ didStartTransitionWithCallbackAction:(CCCallFunc *)callbackAction_{
	[self runAction:callbackAction_];
}
-(void)scene:(CMMScene *)scene_ didEndTransitionWithCallbackAction:(CCCallFunc *)callbackAction_{
	[self runAction:callbackAction_];
}

@end

@implementation CMMSceneTransitionLayer_FadeInOut
@synthesize fadeTime;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	fadeTime = 0.2f;
	
	return self;
}

-(void)scene:(CMMScene *)scene_ didStartTransitionWithCallbackAction:(CCCallFunc *)callbackAction_{
	[self setOpacity:0];
	[self runAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:fadeTime opacity:255] two:callbackAction_]];
}
-(void)scene:(CMMScene *)scene_ didEndTransitionWithCallbackAction:(CCCallFunc *)callbackAction_{
	[self setOpacity:255];
	[self runAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:fadeTime opacity:0] two:callbackAction_]];
}

@end

@implementation CMMSceneFrontLayer
@synthesize filter_sceneDidChangeLayer;

-(void)cleanup{
	[self setFilter_sceneDidChangeLayer:nil];
	[super cleanup];
}
-(void)dealloc{
	[filter_sceneDidChangeLayer release];
	[super dealloc];
}

@end

@interface CMMScene(Private)

-(void)startTransition;
-(void)transition001;
-(void)transition002;

@end

@implementation CMMScene{
	CCArray *_pushLayerList;
	NSMutableDictionary *_staticLayers;
}
@synthesize runningLayer,transitionLayer,onTransition,countOfStaticLayers,touchDispatcher,popupView,noticeDispatcher,touchEnable,defaultBackGroundNode,frontLayer;
@synthesize staticLayers = _staticLayers;

+(CMMScene *)sharedScene{
	if(!_sharedScene_){
		_sharedScene_ = [[self alloc] init];
	}
	
	return _sharedScene_;
}

-(id)init{
	if(!(self = [super init])) return self;
	[self setAnchorPoint:CGPointZero];
	[self setIgnoreAnchorPointForPosition:NO];
	
	runningLayer = nil;
	_pushLayerList = [[CCArray alloc] init];
	onTransition = NO;
	transitionLayer = [[CMMSceneTransitionLayer_FadeInOut alloc] init];
	
	_staticLayers = [[NSMutableDictionary alloc] init];
	
	touchDispatcher = [[CMMTouchDispatcher alloc] initWithTarget:self];
	popupView = [[CMMPopupView alloc] init];
	[self addChild:popupView z:cmmVarCMMScene_popupViewZOrder];
	noticeDispatcher = [[CMMNoticeDispatcher alloc] initWithTarget:self];
	
	frontLayer = [CMMSceneFrontLayer node];
	[self addChild:frontLayer z:cmmVarCMMScene_frontLayerZOrder];
	
	touchEnable = YES;

	return self;
}

-(uint)countOfStaticLayers{
	return [_staticLayers count];
}

-(void)setDefaultBackGroundNode:(CCNode *)defaultBackGroundNode_{
	if(defaultBackGroundNode == defaultBackGroundNode_) return;
	if(defaultBackGroundNode){
		[self removeChild:defaultBackGroundNode cleanup:YES];
	}
	
	defaultBackGroundNode = defaultBackGroundNode_;
	if(defaultBackGroundNode){
		[self addChild:defaultBackGroundNode z:-1];
	}
}

#if COCOS2D_DEBUG >= 1
-(void)visit{
	[super visit];
	
	kmGLPushMatrix();
	[self transform];
	
	ccArray *data_ = [touchDispatcher touchList]->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMTouchDispatcherItem *touchItem_ = data_->arr[index_];
		CGPoint point_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:[touchItem_ touch]]];
		glLineWidth(2.0f);
		ccDrawColor4F(1.0, 1.0, 1.0, 0.7);
		ccDrawCircle(point_, 20, 0, 15, NO);
	}
	
	kmGLPopMatrix();
}
#endif

-(void)touchesBegan:(NSSet *)touches_ withEvent:(UIEvent *)event_{
	if(onTransition || !runningLayer || !touchEnable) return;
	[touchDispatcher whenTouchesBeganFromScene:touches_ event:event_];
}
-(void)touchesMoved:(NSSet *)touches_ withEvent:(UIEvent *)event_{
	[touchDispatcher whenTouchesMovedFromScene:touches_ event:event_];
}
-(void)touchesEnded:(NSSet *)touches_ withEvent:(UIEvent *)event_{
	[touchDispatcher whenTouchesEndedFromScene:touches_ event:event_];
}
-(void)touchesCancelled:(NSSet *)touches_ withEvent:(UIEvent *)event_{
	[touchDispatcher whenTouchesCancelledFromScene:touches_ event:event_];
}

-(void)pushLayer:(CMMLayer *)layer_{
	[_pushLayerList addObject:layer_];
	[self startTransition];
}

-(void)dealloc{
	[noticeDispatcher release];
	[popupView release];
	[touchDispatcher release];
	[_staticLayers release];
	[_pushLayerList release];
	[transitionLayer release];
	
	[super dealloc];
}

@end

@implementation CMMScene(StaticLayer)

-(void)setStaticLayer:(CMMLayer *)layer_ forKey:(NSString *)key_{
	[_staticLayers setObject:layer_ forKey:key_];
}

-(void)removeStaticLayerForKey:(NSString *)key_{
	[_staticLayers removeObjectForKey:key_];
}
-(void)removeAllStaticLayers{
	NSArray *keys_ = [_staticLayers allKeys];
	for(NSString *key_ in keys_){
		[self removeStaticLayerForKey:key_];
	}
}
-(CMMLayer *)staticLayerForKey:(NSString *)key_{
	return [_staticLayers objectForKey:key_];
}

-(void)pushStaticLayerForKey:(NSString *)key_{
	CMMLayer *staticLayer_ = [self staticLayerForKey:key_];
	if(!staticLayer_) return;
	[self pushLayer:staticLayer_];
}

@end

@implementation CMMScene(Popup)

-(void)openPopup:(CMMPopupLayer *)popup_{
	[popupView addPopup:popup_];
}
-(void)openPopupAtFirst:(CMMPopupLayer *)popup_{
	[popupView addPopup:popup_ atIndex:0];
}

@end

@implementation CMMScene(ViewController)

-(void)presentViewController:(UIViewController *)viewController_ animated:(BOOL)animated_ completion:(void (^)(void))completion_{
	[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:viewController_ animated:animated_ completion:completion_];
}

@end

@implementation CMMScene(Private)

-(void)startTransition{
	if(onTransition) return;
	onTransition = YES;
	[runningLayer setTouchEnabled:NO];
	[runningLayer setTouchEnabled:NO];
	
	[transitionLayer setContentSize:_contentSize];
	[self addChild:transitionLayer z:1];
	[transitionLayer scene:self didStartTransitionWithCallbackAction:[CCCallFunc actionWithTarget:self selector:@selector(transition001)]];
}
-(void)transition001{
	CMMLayer *targetLayer_ = [_pushLayerList objectAtIndex:0];
	targetLayer_.touchEnabled = NO;
	if(runningLayer){
		uint check_ = [[_staticLayers allKeysForObject:runningLayer] count];
		[self removeChild:runningLayer cleanup:(check_ == 0)];
	}
	
	if([frontLayer filter_sceneDidChangeLayer]){
		[frontLayer filter_sceneDidChangeLayer](self);
	}
	
	runningLayer = targetLayer_;
	[self addChild:targetLayer_ z:0];
	[transitionLayer scene:self didEndTransitionWithCallbackAction:[CCCallFunc actionWithTarget:self selector:@selector(transition002)]];
}
-(void)transition002{
	[_pushLayerList removeObjectAtIndex:0];
	[runningLayer setTouchEnabled:YES];
	onTransition = NO;
	if(cmmFunc_respondsToSelector(runningLayer, @selector(sceneDidEndTransition:))){
		[runningLayer sceneDidEndTransition:self];
	}
	[self removeChild:transitionLayer cleanup:NO];
	if([_pushLayerList count]>0)
		[self startTransition];
}

@end
