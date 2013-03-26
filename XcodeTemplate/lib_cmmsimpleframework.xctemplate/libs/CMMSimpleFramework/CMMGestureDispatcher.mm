//
//  CMMGestureDispatcher.mm
//  SimpleFramework
//
//  Created by Kim Jazz on 13. 3. 23..
//
//

#import "CMMGestureDispatcher.h"
#import "CMMTouchUtil.h"

@interface CMMGestureDispatcher(Private)

-(void)_handleLongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer_;
-(void)_handlePinchEvent:(UIPinchGestureRecognizer *)gestureRecognizer_;
-(void)_handleRotationEvent:(UIRotationGestureRecognizer *)gestureRecognizer_;
-(void)_handlePanEvent:(UIPanGestureRecognizer *)gestureRecognizer_;

-(void)_fireSELToTargets:(SEL)selector_ recognizer:(UIGestureRecognizer *)recognizer_;
-(void)_safeRelease:(UIGestureRecognizer *)recognizer_;

@end

namespace _CMMGestureSpace{
	typedef enum{
		SELIDLongPressEvent,
		SELIDPinchEvent,
		SELIDRotationEvent,
		SELIDPanEvent,
		
		SELIDMaxCount,
	} SELID;
	
	static SEL SELIDs[SELIDMaxCount];
}
using namespace _CMMGestureSpace;

@implementation CMMGestureDispatcher{
	UILongPressGestureRecognizer *_longPressRecognizer;
	UIPinchGestureRecognizer *_pinchRecognizer;
	UIRotationGestureRecognizer *_rotationRecognizer;
	UIPanGestureRecognizer *_panRecognizer;
}
@synthesize delegate;
@synthesize longPressRecognizer = _longPressRecognizer,pinchRecognizer = _pinchRecognizer, rotationRecognizer = _rotationRecognizer, panRecognizer = _panRecognizer;

+(id)dispatcherWithDelegate:(id<CMMGestureDelegate>)delegate_{
	return [[[self alloc] initWithDelegate:delegate_] autorelease];
}
+(id)dispatcher{
	return [[[self alloc] init] autorelease];
}
-(id)init{
	if(!(self = [super init])) return self;
	
	if(!SELIDs[SELIDLongPressEvent]){
		SELIDs[SELIDLongPressEvent] = @selector(gestureDispatcher:whenLongPressEvent:);
		SELIDs[SELIDPinchEvent] = @selector(gestureDispatcher:whenPinchEvent:);
		SELIDs[SELIDRotationEvent] = @selector(gestureDispatcher:whenRotationEvent:);
		SELIDs[SELIDPanEvent] = @selector(gestureDispatcher:whenPanEvent:);
	}
	
	return self;
}
-(id)initWithDelegate:(id<CMMGestureDelegate>)delegate_{
	if(!(self = [self init])) return self;
	
	[self setDelegate:delegate_];
	
	return self;
}
-(void)initializeLongPressRecognizer{
	if(!_longPressRecognizer){
		_longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handleLongPressEvent:)];
		[_longPressRecognizer setDelegate:self];
		[_longPressRecognizer setCancelsTouchesInView:NO];
		[[[CCDirector sharedDirector] view] addGestureRecognizer:_longPressRecognizer];
	}
}
-(UILongPressGestureRecognizer *)recognizerLongPress{
	[self initializeLongPressRecognizer];
	return _longPressRecognizer;
}
-(void)initializePinchRecognizer{
	if(!_pinchRecognizer){
		_pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePinchEvent:)];
		[_pinchRecognizer setDelegate:self];
		[_pinchRecognizer setCancelsTouchesInView:NO];
		[[[CCDirector sharedDirector] view] addGestureRecognizer:_pinchRecognizer];
	}
}
-(UIPinchGestureRecognizer *)recognizerPinch{
	[self initializePinchRecognizer];
	return _pinchRecognizer;
}
-(void)initializeRotataionRecognizer{
	if(!_rotationRecognizer){
		_rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(_handleRotationEvent:)];
		[_rotationRecognizer setDelegate:self];
		[_rotationRecognizer setCancelsTouchesInView:NO];
		[[[CCDirector sharedDirector] view] addGestureRecognizer:_rotationRecognizer];
	}
}
-(UIRotationGestureRecognizer *)recognizerRotation{
	[self initializeRotataionRecognizer];
	return _rotationRecognizer;
}
-(void)initializePanRecognizer{
	if(!_panRecognizer){
		_panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanEvent:)];
		[_panRecognizer setDelegate:self];
		[_panRecognizer setCancelsTouchesInView:NO];
		[[[CCDirector sharedDirector] view] addGestureRecognizer:_panRecognizer];
	}
}
-(UIPanGestureRecognizer *)recognizerPan{
	[self initializePanRecognizer];
	return _panRecognizer;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
	return YES;
}

-(void)dealloc{
	[delegate release];
	[self _safeRelease:_longPressRecognizer];
	[self _safeRelease:_pinchRecognizer];
	[self _safeRelease:_rotationRecognizer];
	[self _safeRelease:_panRecognizer];
	[super dealloc];
}

@end

@implementation CMMGestureDispatcher(Private)

-(void)_handleLongPressEvent:(UILongPressGestureRecognizer *)gestureRecognizer_{
	[self _fireSELToTargets:SELIDs[SELIDLongPressEvent] recognizer:gestureRecognizer_];
}
-(void)_handlePinchEvent:(UIPinchGestureRecognizer *)gestureRecognizer_{
	[self _fireSELToTargets:SELIDs[SELIDPinchEvent] recognizer:gestureRecognizer_];
}
-(void)_handleRotationEvent:(UIRotationGestureRecognizer *)gestureRecognizer_{
	[self _fireSELToTargets:SELIDs[SELIDRotationEvent] recognizer:gestureRecognizer_];
}
-(void)_handlePanEvent:(UIPanGestureRecognizer *)gestureRecognizer_{
	[self _fireSELToTargets:SELIDs[SELIDPanEvent] recognizer:gestureRecognizer_];
}

-(void)_fireSELToTargets:(SEL)selector_ recognizer:(UIGestureRecognizer *)recognizer_{
	if(cmmFunc_respondsToSelector(delegate, selector_)){
		objc_msgSend(delegate, selector_, self, recognizer_);
	}
}
-(void)_safeRelease:(UIGestureRecognizer *)recognizer_{
	if(recognizer_){
		[[[CCDirector sharedDirector] view] removeGestureRecognizer:recognizer_];
		[recognizer_ release];
		recognizer_ = nil;
	}
}

@end
