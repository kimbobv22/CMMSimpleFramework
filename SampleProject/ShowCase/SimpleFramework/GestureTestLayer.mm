//  Created by JGroup(kimbobv22@gmail.com)

#import "GestureTestLayer.h"
#import "HelloWorldLayer.h"

@implementation GestureTestLayer{
	float _lastScale,_firstRotation;
	CGPoint _lastPoint;
	
	CMMGestureDispatcher *_gestureDispatcher;
}

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	tempSprite = [CCSprite spriteWithFile:@"Default.png"];
	[tempSprite setPosition:cmmFunc_positionIPN(self, tempSprite)];
	[tempSprite setScale:0.5];
	[self addChild:tempSprite];
	
	CMMMenuItemL *menuItemBack_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2+20);
	[menuItemBack_ setCallback_pushup:^(id) {
		[[CMMScene sharedScene] pushStaticLayerForKey:_HelloWorldLayer_key_];
	}];
	[self addChild:menuItemBack_];
	
	_gestureDispatcher = [[CMMGestureDispatcher alloc] initWithDelegate:self];
	
	//long press
	[_gestureDispatcher initializeLongPressRecognizer];
	[[_gestureDispatcher longPressRecognizer] setMinimumPressDuration:3.0f];
	
	//pinch, rotation, pan
	[_gestureDispatcher initializePinchRecognizer];
	[_gestureDispatcher initializeRotataionRecognizer];
	[_gestureDispatcher initializePanRecognizer];
	[[_gestureDispatcher panRecognizer] setMinimumNumberOfTouches:2];
	
	return self;
}

-(void)gestureDispatcher:(CMMGestureDispatcher *)gestureDispatcher_ whenLongPressEvent:(UIPinchGestureRecognizer *)gestureRecognizer_{
	CCLOG(@"long press gesture fired : %d",[gestureRecognizer_ state]);
}
-(void)gestureDispatcher:(CMMGestureDispatcher *)gestureDispatcher_ whenPinchEvent:(UIPinchGestureRecognizer *)gestureRecognizer_{
	switch([gestureRecognizer_ state]){
		case UIGestureRecognizerStateBegan:{
			_lastScale = 1.0f;
			break;
		}
		case UIGestureRecognizerStateChanged:{
			float curScale_ = [tempSprite scale];
			[tempSprite setScale:curScale_ - (curScale_ * (_lastScale - [gestureRecognizer_ scale]))];
			_lastScale = [gestureRecognizer_ scale];
			break;
		}
		default: break;
	}
}
-(void)gestureDispatcher:(CMMGestureDispatcher *)gestureDispatcher_ whenRotationEvent:(UIRotationGestureRecognizer *)gestureRecognizer_{
	switch([gestureRecognizer_ state]){
		case UIGestureRecognizerStateBegan:{
			_firstRotation = [tempSprite rotation];
			break;
		}
		case UIGestureRecognizerStateChanged:{
			float targetRotation_ = [gestureRecognizer_ rotation];
			[tempSprite setRotation:_firstRotation + CC_RADIANS_TO_DEGREES(targetRotation_)];
			break;
		}
		default: break;
	}
}
-(void)gestureDispatcher:(CMMGestureDispatcher *)gestureDispatcher_ whenPanEvent:(UIPanGestureRecognizer *)gestureRecognizer_{
	switch([gestureRecognizer_ state]){
		case UIGestureRecognizerStateBegan:{
			_lastPoint = CGPointZero;
			break;
		}
		case UIGestureRecognizerStateChanged:{
			CGPoint targetPoint_ = [gestureRecognizer_ translationInView:[gestureRecognizer_ view]];
			CGPoint diffPoint_ = ccpSub(targetPoint_, _lastPoint);
			[tempSprite setPosition:ccpAdd([tempSprite position], ccp(diffPoint_.x,-diffPoint_.y))];
			
			_lastPoint = targetPoint_;
			
			break;
		}
		default: break;
	}
}

-(void)cleanup{
	[_gestureDispatcher setDelegate:nil];
	[super cleanup];
}
-(void)dealloc{
	[_gestureDispatcher release];
	[super dealloc];
}

@end
