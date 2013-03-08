//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMMacro.h"
#import "CMMTouchDispatcher.h"

struct CMM9SliceEdgeOffset{
	float left,right,top,bottom;
	
	CMM9SliceEdgeOffset(){
		left = right = top = bottom = 5.0f;
	}
	CMM9SliceEdgeOffset(float left_, float right_, float top_, float bottom_) : left(left_),right(right_),top(top_),bottom(bottom_){}
	CMM9SliceEdgeOffset(float width_, float height_) : left(width_),right(width_),top(height_),bottom(height_){}
	CMM9SliceEdgeOffset(CGSize edgeSize_) : left(edgeSize_.width),right(edgeSize_.width),top(edgeSize_.height),bottom(edgeSize_.height){}
	
	BOOL Equals(CMM9SliceEdgeOffset other_){
		return (left == other_.left && right == other_.right && top == other_.top && bottom == other_.bottom);
	}
};
typedef CMM9SliceEdgeOffset CMM9SliceEdgeOffset;

@interface CMM9SliceBar : CCSpriteBatchNode<CCRGBAProtocol>{
	CCSprite *targetSprite;
	CCSprite *_barTopSprite,*_barBottomSprite,*_barLeftSprite,*_barRightSprite,*_backSprite,*_edge1Sprite,*_edge2Sprite,*_edge3Sprite,*_edge4Sprite;
	BOOL _dirty;
	
	CMM9SliceEdgeOffset edgeOffset;
}

+(id)sliceBarWithTargetSprite:(CCSprite *)targetSprite_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_;
+(id)sliceBarWithTargetSprite:(CCSprite *)targetSprite_;

-(id)initWithTargetSprite:(CCSprite *)targetSprite_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_;
-(id)initWithTargetSprite:(CCSprite *)targetSprite_;

@property (nonatomic, assign) CCSprite *targetSprite;
@property (nonatomic, readwrite) CMM9SliceEdgeOffset edgeOffset;

@end