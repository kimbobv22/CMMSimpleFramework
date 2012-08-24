//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScene.h"

static CMMScene *_sharedScene_ = nil;

@interface CMMScene(Private)

-(void)transition001;
-(void)transition002;

@end

@implementation CMMScene
@synthesize runningLayer,transitionColor,isOnTransition,fadeTime,touchDispatcher,popupDispatcher;

+(id)sharedScene{
	if(!_sharedScene_){
		_sharedScene_ = [[CMMScene alloc] init];
	}
	
	return _sharedScene_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	runningLayer = nil;
	_pushLayerList = [[CCArray alloc] init];
	isOnTransition = NO;
	_transitionLayer = [[CCLayerColor alloc] init];
	fadeTime = 0.4f;
	
	touchDispatcher = [[CMMTouchDispatcherScene alloc] initWithTarget:self];
	popupDispatcher = [[CMMPopupDispatcher alloc] initWithScene:self];
	_loadingObject = [[CMMLoadingObject alloc] init];
	
	[self scheduleUpdate];
	
	return self;
}

-(void)setTransitionColor:(ccColor3B)transitionColor_{
	[_transitionLayer setColor:transitionColor_];
}
-(ccColor3B)transitionColor{
	return _transitionLayer.color;
}

-(void)glViewTouch:(CMMGLView *)glView_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchBegan:touch_ event:event_];
}
-(void)glViewTouch:(CMMGLView *)glView_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchMoved:touch_ event:event_];
}
-(void)glViewTouch:(CMMGLView *)glView_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchEnded:touch_ event:event_];
}
-(void)glViewTouch:(CMMGLView *)glView_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchCancelled:touch_ event:event_];
}

-(void)update:(ccTime)dt_{
	if(_pushLayerList.count<=0 || isOnTransition) return;
	
	isOnTransition = YES;
	runningLayer.isTouchEnabled = NO;
	
	_transitionLayer.opacity = 0.0f;
	[self addChild:_transitionLayer z:1];
	[_transitionLayer runAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:fadeTime/2.0f opacity:255] two:[CCCallFunc actionWithTarget:self selector:@selector(transition001)]]];
}
-(void)pushLayer:(CMMLayer *)layer_{
	[_pushLayerList addObject:layer_];
}

-(void)dealloc{
	[_loadingObject release];
	[popupDispatcher release];
	[touchDispatcher release];
	[_pushLayerList release];
	[_transitionLayer release];
	[super dealloc];
}

@end

@implementation CMMScene(Private)

-(void)transition001{
	CMMLayer *targetLayer_ = [_pushLayerList objectAtIndex:0];
	targetLayer_.isTouchEnabled = NO;
	if(runningLayer){
		[runningLayer removeFromParentAndCleanup:YES];
	}
	
	runningLayer = targetLayer_;
	[self addChild:targetLayer_ z:0];
	
	[_transitionLayer runAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:fadeTime/2.0f opacity:0] two:[CCCallFunc actionWithTarget:self selector:@selector(transition002)]]];
}
-(void)transition002{
	_loadingObject.delegate = self;
	[_loadingObject startLoadingWithTarget:runningLayer];
}

-(void)loadingObject_whenLoadingEnded:(CMMLoadingObject *)loadingLayer_{
	[_pushLayerList removeObjectAtIndex:0];
	[_transitionLayer removeFromParentAndCleanup:YES];
	runningLayer.isTouchEnabled = YES;
	isOnTransition = NO;
	[runningLayer whenLoadingEnded];
}

@end

@implementation CMMScene(Popup)

-(void)openPopup:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_{
	[popupDispatcher addPopupItemWithPopup:popup_ delegate:delegate_];
}
-(void)openPopupAtFirst:(CMMLayerPopup *)popup_ delegate:(id<CMMPopupDispatcherDelegate>)delegate_{
	[popupDispatcher addPopupItemWithPopup:popup_ delegate:delegate_ atIndex:0];
}

-(void)closePopup:(CMMLayerPopup *)popup_ withData:(id)data_{
	[popupDispatcher removePopupItemAtPopup:popup_ withData:data_];
}
-(void)closePopup:(CMMLayerPopup *)popup_{
	[self closePopup:popup_ withData:nil];
}

@end
