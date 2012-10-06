//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"

@implementation CMMLayer
@synthesize touchDispatcher,isAvailableMotion;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	[self setAnchorPoint:CGPointZero];
	[self setIgnoreAnchorPointForPosition:NO];
	
	touchDispatcher = [[CMMTouchDispatcher alloc] initWithTarget:self];
	
	return self;
}

-(void)registerWithTouchDispatcher{}

-(BOOL)isAvailableMotion{
	return ([[CMMMotionDispatcher sharedDispatcher] indexOfTarget:self] != NSNotFound);
}
-(void)setIsAvailableMotion:(BOOL)isAvailableMotion_{
	if(isAvailableMotion){
		[[CMMMotionDispatcher sharedDispatcher] addTarget:self];
	}else{
		 [[CMMMotionDispatcher sharedDispatcher] removeTarget:self];
	}
}

#if COCOS2D_DEBUG >= 1
-(void)visit{
	[super visit];
	
	kmGLPushMatrix();
	[self transform];
	
	ccArray *data_ = touchDispatcher.touchList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMTouchDispatcherItem *touchItem_ = data_->arr[index_];
		CGPoint centerPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touchItem_.touch]];
		glLineWidth(3.0f);
		ccDrawColor4F(0.0, 1.0, 0.0, 1.0);
		ccDrawCircle(centerPoint_, 15, 0, 15, NO);
	}
	
	kmGLPopMatrix();
}
#endif

-(void)onExit{
	[super onExit];
	[[CMMMotionDispatcher sharedDispatcher] removeTarget:self];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchBegan:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchMoved:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchEnded:touch_ event:event_];
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[touchDispatcher whenTouchCancelled:touch_ event:event_];
}

//for reference
-(void)loadingProcess000{}
-(void)whenLoadingEnded{}
-(void)popupDispatcher:(CMMPopupDispatcherItem *)popupItem_ whenClosedWithReceivedData:(id)data_{}

-(void)dealloc{
	[touchDispatcher release];
	[super dealloc];
}

@end
