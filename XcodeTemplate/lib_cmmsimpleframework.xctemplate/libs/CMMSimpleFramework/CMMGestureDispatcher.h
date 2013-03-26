//
//  CMMGestureDispatcher.h
//  SimpleFramework
//
//  Created by Kim Jazz on 13. 3. 23..
//
//

#import "cocos2d.h"
#import "CMMTouchDispatcher.h"

@class CMMGestureDispatcher;

@protocol CMMGestureDelegate <NSObject>

@optional
-(void)gestureDispatcher:(CMMGestureDispatcher *)gestureDispatcher_ whenLongPressEvent:(UIPinchGestureRecognizer *)gestureRecognizer_;
-(void)gestureDispatcher:(CMMGestureDispatcher *)gestureDispatcher_ whenPinchEvent:(UIPinchGestureRecognizer *)gestureRecognizer_;
-(void)gestureDispatcher:(CMMGestureDispatcher *)gestureDispatcher_ whenRotationEvent:(UIRotationGestureRecognizer *)gestureRecognizer_;
-(void)gestureDispatcher:(CMMGestureDispatcher *)gestureDispatcher_ whenPanEvent:(UIPanGestureRecognizer *)gestureRecognizer_;

@end

@interface CMMGestureDispatcher : NSObject<UIGestureRecognizerDelegate>{
	id<CMMGestureDelegate> delegate;
}

+(id)dispatcherWithDelegate:(id<CMMGestureDelegate>)delegate_;
+(id)dispatcher;
-(id)initWithDelegate:(id<CMMGestureDelegate>)delegate_;

-(void)initializeLongPressRecognizer;
-(void)initializePinchRecognizer;
-(void)initializeRotataionRecognizer;
-(void)initializePanRecognizer;

@property (nonatomic, retain) id<CMMGestureDelegate> delegate;
@property (nonatomic, readonly) UILongPressGestureRecognizer *longPressRecognizer;
@property (nonatomic, readonly) UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, readonly) UIRotationGestureRecognizer *rotationRecognizer;
@property (nonatomic, readonly) UIPanGestureRecognizer *panRecognizer;

@end

