//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"

@implementation CMMLayer
@synthesize touchDispatcher,isAvailableMotion;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	self.anchorPoint = ccp(0,0);
	self.ignoreAnchorPointForPosition = NO;
	
	touchDispatcher = [[CMMTouchDispatcher alloc] initWithTarget:self];
	isAvailableMotion = NO;
	
	return self;
}

-(void)registerWithTouchDispatcher{}

-(void)setIsAvailableMotion:(BOOL)isAvailableMotion_{
	isAvailableMotion = isAvailableMotion_;
	
	if(isAvailableMotion && isRunning_)
		[[CMMMotionDispatcher sharedDispatcher] addTarget:self];
	else [[CMMMotionDispatcher sharedDispatcher] removeTarget:self];
}

#if COCOS2D_DEBUG >= 1
-(void)draw{
	[super draw];
	
	ccArray *data_ = touchDispatcher.touchList->data;
	int count_ = data_->num;
	for(uint index_=0;index_<count_;index_++){
		CMMTouchDispatcherItem *touchItem_ = data_->arr[index_];
		CGPoint centerPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touchItem_.touch]];
		glLineWidth(2.0f);
		ccDrawColor4F(1.0, 1.0, 1.0, 1.0);
		ccDrawCircle(centerPoint_, 20, 0, 15, NO);
	}
}
#endif

-(void)onEnter{
	[super onEnter];
	if(isAvailableMotion) [[CMMMotionDispatcher sharedDispatcher] addTarget:self];
}
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
