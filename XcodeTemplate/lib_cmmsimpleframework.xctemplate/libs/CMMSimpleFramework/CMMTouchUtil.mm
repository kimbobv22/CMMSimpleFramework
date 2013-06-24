//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMTouchUtil.h"

@implementation CMMTouchUtil

+(CGPoint)pointFromTouch:(UITouch *)touch_{
	return [[CCDirector sharedDirector] convertToGL:[touch_ locationInView:[touch_ view]]];
}
+(CGPoint)pointFromTouch:(UITouch *)touch_ targetNode:(CCNode *)node_{
	return [node_ convertToNodeSpace:[self pointFromTouch:touch_]];
}

+(CGPoint)prepointFromTouch:(UITouch *)touch_{
	return [[CCDirector sharedDirector] convertToGL:[touch_ previousLocationInView:[touch_ view]]];
}
+(CGPoint)prepointFromTouch:(UITouch *)touch_ targetNode:(CCNode *)node_{
	return [node_ convertToNodeSpace:[self prepointFromTouch:touch_]];
}

+(CGPoint)movedPointWithTouch:(UITouch *)touch_{
	return ccpSub([self pointFromTouch:touch_], [self prepointFromTouch:touch_]);
}

@end

@implementation CMMTouchUtil(Check)

+(BOOL)isRectInPoint:(CGRect)rect_ point:(CGPoint)point_ margin:(float)margin_{
	CGRect targetRect_ = rect_;
	targetRect_.origin = ccp(targetRect_.origin.x-margin_, targetRect_.origin.y-margin_);
	targetRect_.size = CGSizeMake(targetRect_.size.width+margin_*2.0f, targetRect_.size.height+margin_*2.0f);
	
	return CGRectContainsPoint(targetRect_, point_);
}
+(BOOL)isRectInPoint:(CGRect)rect_ point:(CGPoint)point_{
	return [self isRectInPoint:rect_ point:point_ margin:0.0f];
}

+(BOOL)isNodeInPoint:(CCNode *)node_ point:(CGPoint)point_ margin:(float)margin_{
	return [self isRectInPoint:cmmFunc_nodeToWorldRect(node_) point:point_ margin:margin_];
}
+(BOOL)isNodeInPoint:(CCNode *)node_ point:(CGPoint)point_{
	return [self isNodeInPoint:node_ point:point_ margin:0.0f];
}

+(BOOL)isNodeInTouch:(CCNode *)node_ touch:(UITouch *)touch_ margin:(float)margin_{
	return [self isNodeInPoint:node_ point:[self pointFromTouch:touch_] margin:margin_];
}
+(BOOL)isNodeInTouch:(CCNode *)node_ touch:(UITouch *)touch_{
	return [self isNodeInTouch:node_ touch:touch_ margin:0.0f];
}

+(uint)nodeCountInPoint:(CCArray *)nodes_ point:(CGPoint)point_ margin:(float)margin_{
	uint result_ = 0;
	ccArray *data_ = nodes_->data;
	uint count_ = data_->num;
	for(uint index_=0;index_<count_;++index_){
		CCNode *node_ = data_->arr[index_];
		if([self isNodeInPoint:node_ point:point_ margin:margin_]){
			++result_;
		}
	}
		
	return result_;
}
+(uint)nodeCountInPoint:(CCArray *)nodes_ point:(CGPoint)point_{
	return [self nodeCountInPoint:nodes_ point:point_ margin:0.0f];
}

+(uint)nodeCountInTouch:(CCArray *)nodes_ touch:(UITouch *)touch_ margin:(float)margin_{
	return [self nodeCountInPoint:nodes_ point:[self pointFromTouch:touch_] margin:margin_];
}
+(uint)nodeCountInTouch:(CCArray *)nodes_ touch:(UITouch *)touch_{
	return [self nodeCountInTouch:nodes_ touch:touch_ margin:0.0f];
}

@end