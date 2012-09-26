//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScene.h"

static CMMScene *_sharedScene_ = nil;

@interface CMMScene(Private)

-(void)startTransition;
-(void)transition001;
-(void)transition002;

@end

@implementation CMMScene(Private)

-(void)startTransition{
	if(isOnTransition) return;
	isOnTransition = YES;
	runningLayer.isTouchEnabled = NO;
	
	_transitionLayer.opacity = 0.0f;
	[self addChild:_transitionLayer z:1];
	[_transitionLayer runAction:[CCSequence actionOne:[CCFadeTo actionWithDuration:fadeTime/2.0f opacity:255] two:[CCCallFunc actionWithTarget:self selector:@selector(transition001)]]];
}
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
	if(_pushLayerList.count>0)
		[self startTransition];
}

@end

@implementation CMMScene
@synthesize runningLayer,transitionColor,isOnTransition,fadeTime,touchDispatcher,popupDispatcher,noticeDispatcher;

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
	_transitionLayer = [[CCLayerColor alloc] init];
	fadeTime = 0.4f;
	
	_loadingObject = [[CMMLoadingObject alloc] init];
	touchDispatcher = [[CMMTouchDispatcherScene alloc] initWithTarget:self];
	popupDispatcher = [[CMMPopupDispatcher alloc] initWithScene:self];
	noticeDispatcher = [[CMMNoticeDispatcher alloc] initWithTarget:self];
	
#if COCOS2D_DEBUG >= 1
	_touchPoints = [[CCArray alloc] init];
#endif	
	return self;
}

-(void)setTransitionColor:(ccColor3B)transitionColor_{
	[_transitionLayer setColor:transitionColor_];
}
-(ccColor3B)transitionColor{
	return _transitionLayer.color;
}

#if COCOS2D_DEBUG >= 1
-(void)visit{
	[super visit];
	
	kmGLPushMatrix();
	[self transform];
	
	ccArray *data_ = _touchPoints->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CGPoint point_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:data_->arr[index_]]];
		glLineWidth(2.0f);
		ccDrawColor4F(1.0, 1.0, 1.0, 0.7);
		ccDrawCircle(point_, 20, 0, 15, NO);
	}
	
	kmGLPopMatrix();
}
#endif

-(void)glViewTouch:(CMMGLView *)glView_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchBegan:touch_ event:event_];
#if COCOS2D_DEBUG >= 1
	[_touchPoints addObject:touch_];
#endif
}
-(void)glViewTouch:(CMMGLView *)glView_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchMoved:touch_ event:event_];
}
-(void)glViewTouch:(CMMGLView *)glView_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchEnded:touch_ event:event_];
#if COCOS2D_DEBUG >= 1
	[_touchPoints removeObject:touch_];
#endif
}
-(void)glViewTouch:(CMMGLView *)glView_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchCancelled:touch_ event:event_];
#if COCOS2D_DEBUG >= 1
	[_touchPoints removeObject:touch_];
#endif
}

-(void)pushLayer:(CMMLayer *)layer_{
	[_pushLayerList addObject:layer_];
	[self startTransition];
}

-(void)dealloc{
	[noticeDispatcher release];
	[popupDispatcher release];
	[touchDispatcher release];
	[_loadingObject release];
	[_pushLayerList release];
	[_transitionLayer release];
	
#if COCOS2D_DEBUG >= 1
	[_touchPoints release];
#endif
	
	[super dealloc];
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
