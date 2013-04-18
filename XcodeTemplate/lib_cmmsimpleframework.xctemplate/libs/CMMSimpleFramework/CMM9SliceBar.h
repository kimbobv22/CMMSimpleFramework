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
	CGRect targetRect;
	CMM9SliceEdgeOffset edgeOffset;
}

+(id)sliceBarWithTexture:(CCTexture2D *)texture_ targetRect:(CGRect)targetRect_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_;
+(id)sliceBarWithTexture:(CCTexture2D *)texture_ targetRect:(CGRect)targetRect_;
+(id)sliceBarWithTexture:(CCTexture2D *)texture_;

-(id)initWithTexture:(CCTexture2D *)texture_ targetRect:(CGRect)targetRect_ edgeOffset:(CMM9SliceEdgeOffset)edgeOffset_;
-(id)initWithTexture:(CCTexture2D *)texture_ targetRect:(CGRect)targetRect_;
-(id)initWithTexture:(CCTexture2D *)texture_;

-(void)setTexture:(CCTexture2D *)texture_ targetRect:(CGRect)targetRect_;
-(void)setTextureWithSprite:(CCSprite *)sprite_;
-(void)setTextureWithFrame:(CCSpriteFrame *)frame_;

@property (nonatomic, readwrite) CGRect targetRect;
@property (nonatomic, readwrite) CMM9SliceEdgeOffset edgeOffset;

@end