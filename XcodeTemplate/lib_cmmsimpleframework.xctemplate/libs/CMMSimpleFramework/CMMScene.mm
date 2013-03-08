//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScene.h"

static CMMScene *_sharedScene_ = nil;

@implementation CMMSceneStaticLayerItem
@synthesize key,layer;

+(id)staticLayerItemWithLayer:(CMMLayer *)layer_ key:(NSString *)key_{
	return [[[self alloc] initWithLayer:layer_ key:key_] autorelease];
}
-(id)initWithLayer:(CMMLayer *)layer_ key:(NSString *)key_{
	if(!(self = [super init])) return self;
	
	[self setKey:key_];
	[self setLayer:layer_];
	
	return self;
}

-(void)dealloc{
	[key release];
	[layer release];
	[super dealloc];
}

@end

@implementation CMMSceneTransitionLayer

//override under method
-(void)startFadeInTransitionWithTarget:(id)target_ callbackSelector:(SEL)selector_{
	[self runAction:[CCCallFunc actionWithTarget:target_ selector:selector_]];
}
-(void)startFadeOutTransitionWithTarget:(id)target_ callbackSelector:(SEL)selector_{
	[self runAction:[CCCallFunc actionWithTarget:target_ selector:selector_]];
}

@end

@implementation CMMSceneTransitionLayer_FadeInOut
@synthesize fadeTime;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	fadeTime = 0.2f;
	
	return self;
}

-(void)startFadeInTransitionWithTarget:(id)target_ callbackSelector:(SEL)selector_{
	[self setOpacity:0.0f];
	[self runAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:fadeTime opacity:255] two:[CCCallFunc actionWithTarget:target_ selector:selector_]]];
}
-(void)startFadeOutTransitionWithTarget:(id)target_ callbackSelector:(SEL)selector_{
	[self runAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:fadeTime opacity:0] two:[CCCallFunc actionWithTarget:target_ selector:selector_]]];
}

@end

@implementation CMMSceneFrontLayer
@synthesize filter_sceneDidChangeLayer;

-(id)init{
	if(!(self = [super init])) return self;
	
	
	return self;
}

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

@implementation CMMScene(Private)

-(void)startTransition{
	if(isOnTransition) return;
	isOnTransition = YES;
	runningLayer.touchEnabled = NO;
	
	[transitionLayer setContentSize:_contentSize];
	[self addChild:transitionLayer z:1];
	[transitionLayer startFadeInTransitionWithTarget:self callbackSelector:@selector(transition001)];
}
-(void)transition001{
	CMMLayer *targetLayer_ = [_pushLayerList objectAtIndex:0];
	targetLayer_.touchEnabled = NO;
	if(runningLayer){
		[self removeChild:runningLayer cleanup:([self indexOfStaticLayerItemWithLayer:runningLayer] == NSNotFound)];
	}
	
	if([frontLayer filter_sceneDidChangeLayer]){
		[frontLayer filter_sceneDidChangeLayer](self);
	}
	
	runningLayer = targetLayer_;
	[self addChild:targetLayer_ z:0];
	[transitionLayer startFadeOutTransitionWithTarget:self callbackSelector:@selector(transition002)];
}
-(void)transition002{
	[_pushLayerList removeObjectAtIndex:0];
	[transitionLayer removeFromParentAndCleanup:YES];
	[runningLayer setTouchEnabled:YES];
	isOnTransition = NO;
	if(cmmFunc_respondsToSelector(runningLayer, @selector(sceneDidEndTransition:))){
		[runningLayer sceneDidEndTransition:self];
	}
	
	if([_pushLayerList count]>0)
		[self startTransition];
}

@end

@implementation CMMScene
@synthesize runningLayer,transitionLayer,isOnTransition,staticLayerItemList,countOfStaticLayerItem,touchDispatcher,popupView,noticeDispatcher,touchEnable,defaultBackGroundNode,frontLayer;

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
	isOnTransition = NO;
	transitionLayer = [[CMMSceneTransitionLayer_FadeInOut alloc] init];
	
	staticLayerItemList = [[CCArray alloc] init];
	
	touchDispatcher = [[CMMTouchDispatcher alloc] initWithTarget:self];
	popupView = [[CMMPopupView alloc] init];
	[self addChild:popupView z:cmmVarCMMScene_popupViewZOrder];
	noticeDispatcher = [[CMMNoticeDispatcher alloc] initWithTarget:self];
	
	frontLayer = [CMMSceneFrontLayer node];
	[self addChild:frontLayer z:cmmVarCMMScene_frontLayerZOrder];
	
	touchEnable = YES;

	return self;
}

-(uint)countOfStaticLayerItem{
	return [staticLayerItemList count];
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

-(void)glView:(CMMGLView *)glView_ whenTouchesBegan:(NSSet *)touches_ event:(UIEvent *)event_{
	if(isOnTransition || !runningLayer || !touchEnable) return;
	[touchDispatcher whenTouchesBeganFromScene:touches_ event:event_];
}
-(void)glView:(CMMGLView *)glView_ whenTouchesMoved:(NSSet *)touches_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchesMovedFromScene:touches_ event:event_];
}
-(void)glView:(CMMGLView *)glView_ whenTouchesEnded:(NSSet *)touches_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchesEndedFromScene:touches_ event:event_];
}
-(void)glView:(CMMGLView *)glView_ whenTouchesCancelled:(NSSet *)touches_ event:(UIEvent *)event_{
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
	[staticLayerItemList release];
	[_pushLayerList release];
	[transitionLayer release];
	
	[super dealloc];
}

@end

@implementation CMMScene(StaticLayer)

-(void)pushStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_{
	if(!staticLayerItem_) return;
	[self pushLayer:[staticLayerItem_ layer]];
}
-(void)pushStaticLayerItemAtKey:(NSString *)key_{
	[self pushStaticLayerItem:[self staticLayerItemAtKey:key_]];
}

-(void)addStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_{
	uint index_ = [self indexOfStaticLayerItem:staticLayerItem_];
	if(index_ != NSNotFound) return;
	[staticLayerItemList addObject:staticLayerItem_];
}
-(CMMSceneStaticLayerItem *)addStaticLayerItemWithLayer:(CMMLayer *)layer_ atKey:(NSString *)key_{
	CMMSceneStaticLayerItem *staticLayerItem_ = [self staticLayerItemAtKey:key_];
	[self removeStaticLayerItem:staticLayerItem_];
	staticLayerItem_ = [CMMSceneStaticLayerItem staticLayerItemWithLayer:layer_ key:key_];
	[self addStaticLayerItem:staticLayerItem_];
	return staticLayerItem_;
}

-(void)removeStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_{
	uint index_ = [self indexOfStaticLayerItem:staticLayerItem_];
	if(index_ == NSNotFound) return;
	[staticLayerItemList removeObjectAtIndex:index_];
}
-(void)removeStaticLayerItemAtIndex:(uint)index_{
	[self removeStaticLayerItem:[self staticLayerItemAtIndex:index_]];
}
-(void)removeStaticLayerItemAtKey:(NSString *)key_{
	[self removeStaticLayerItem:[self staticLayerItemAtKey:key_]];
}
-(void)removeAllStaticLayerItems{
	ccArray *data_ = staticLayerItemList->data;
	for(int index_ = data_->num-1;index>=0;--index_){
		CMMSceneStaticLayerItem *staticLayerItem_ = data_->arr[index_];
		[self removeStaticLayerItem:staticLayerItem_];
	}
}

-(CMMSceneStaticLayerItem *)staticLayerItemAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [staticLayerItemList objectAtIndex:index_];
}
-(CMMSceneStaticLayerItem *)staticLayerItemAtKey:(NSString *)key_{
	return [self staticLayerItemAtIndex:[self indexOfStaticLayerItemWithKey:key_]];
}
-(CMMSceneStaticLayerItem *)staticLayerItemAtLayer:(CMMLayer *)layer_{
	return [self staticLayerItemAtIndex:[self indexOfStaticLayerItemWithLayer:layer_]];
}

-(uint)indexOfStaticLayerItem:(CMMSceneStaticLayerItem *)staticLayerItem_{
	return [staticLayerItemList indexOfObject:staticLayerItem_];
}
-(uint)indexOfStaticLayerItemWithLayer:(CMMLayer *)layer_{
	ccArray *data_ = staticLayerItemList->data;
	uint count_ = data_->num;
	for(uint index_ = 0;index_<count_;++index_){
		CMMSceneStaticLayerItem *staticLayerItem_ = data_->arr[index_];
		if([staticLayerItem_ layer] == layer_)
			return index_;
	}
	return NSNotFound;
}
-(uint)indexOfStaticLayerItemWithKey:(NSString *)key_{
	ccArray *data_ = staticLayerItemList->data;
	uint count_ = data_->num;
	for(uint index_ = 0;index_<count_;++index_){
		CMMSceneStaticLayerItem *staticLayerItem_ = data_->arr[index_];
		if([[staticLayerItem_ key] isEqualToString:key_])
			return index_;
	}
	return NSNotFound;
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
