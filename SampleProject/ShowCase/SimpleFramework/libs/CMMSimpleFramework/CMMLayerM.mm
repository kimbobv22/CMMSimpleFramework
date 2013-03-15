//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayerM.h"

@implementation CMMLayerM
@synthesize innerLayer,innerTouchDispatcher;

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	innerLayer = [CMMLayer layerWithColor:ccc4(0, 0, 0, 0)];
	[innerLayer setContentSize:_contentSize];
	innerTouchDispatcher = [innerLayer touchDispatcher]; //weak ref
	[self addChild:innerLayer];
	
	return self;
}

-(void)visit{
	glEnable(GL_SCISSOR_TEST);
	CGRect screenRect_;
	screenRect_.origin = ccp(0,0);
	screenRect_.size = self.contentSize;
	screenRect_ = CGRectApplyAffineTransform(screenRect_,[self nodeToWorldTransform]);
	
	glScissor(screenRect_.origin.x*CC_CONTENT_SCALE_FACTOR(), screenRect_.origin.y*CC_CONTENT_SCALE_FACTOR(), screenRect_.size.width*CC_CONTENT_SCALE_FACTOR(), screenRect_.size.height*CC_CONTENT_SCALE_FACTOR());
	
	//draw inner layer first.
	kmGLPushMatrix();
	
	[self transform];
	[super draw];
	
	kmGLPushMatrix();
	
	[innerLayer transform];
	[innerLayer draw];
	
	CCArray *innerChildren_ = [innerLayer children];
	ccArray *data_;
	uint count_;
	if(innerChildren_){
		data_ = innerChildren_->data;
		count_ = data_->num;
		for(uint index_=0;index_<count_;++index_){
			CCNode *child_ = data_->arr[index_];
			CGSize spriteSize_ = [child_ contentSize];
			CGRect spriteRect_ = CGRectApplyAffineTransform(CGRectMake(0, 0, spriteSize_.width, spriteSize_.height),[child_ nodeToWorldTransform]);
			
			if(CGRectIntersectsRect(spriteRect_,screenRect_))
				[child_ visit];
		}
	}
	
	kmGLPopMatrix();
	kmGLPopMatrix();
	
	//draw parent layer second.
	kmGLPushMatrix();
	[self transform];
	[self draw];
	
	glDisable(GL_SCISSOR_TEST);
	
	if(_children){
		data_ = _children->data;
		count_ = data_->num;
		for(uint index_=0;index_<count_;++index_){
			CCNode *child_ = data_->arr[index_];
			if(child_ == innerLayer) continue;
			[child_ visit];
		}
	}
	
	kmGLPopMatrix();
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[innerLayer setTouchEnabled:NO];
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	[innerLayer setTouchEnabled:YES];
	if([touchDispatcher touchCount] == 0){
		[touchDispatcher addTouchItemWithTouch:touch_ node:innerLayer];
		[innerLayer touchDispatcher:touchDispatcher whenTouchBegan:touch_ event:event_];
	}
}

-(void)addChildToInner:(CCNode *)node z:(NSInteger)z tag:(NSInteger)tag{
	[innerLayer addChild:node z:z tag:tag];
}
-(void)addChildToInner:(CCNode *)node z:(NSInteger)z{
	[self addChildToInner:node z:z tag:[node tag]];
}
-(void)addChildToInner:(CCNode *)node{
	[self addChildToInner:node z:[node zOrder]];
}

-(void)removeChildFromInner:(CCNode *)node cleanup:(BOOL)cleanup{
	[innerLayer removeChild:node cleanup:cleanup];
}
-(void)removeChildByTagFromInner:(NSInteger)tag cleanup:(BOOL)cleanup{
	[innerLayer removeChildByTag:tag cleanup:cleanup];
}

@end
