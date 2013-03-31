//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayerM.h"
#import "CMM9SliceBar.h"

@interface CMMLayerMD : CMMLayerM{
	CMM9SliceBar *scrollbarX,*scrollbarY;
	float scrollbarOffsetX,scrollbarOffsetY;
	float scrollResistance,scrollSpeed;
	
	BOOL canDragX,canDragY,alwaysShowScrollbar;
}

-(void)setInnerPosition:(CGPoint)point_ applyScrolling:(BOOL)applyScrolling_;
-(void)setInnerPosition:(CGPoint)point_;

@property (nonatomic, retain) CMM9SliceBar *scrollbarX,*scrollbarY;
@property (nonatomic, readwrite) float scrollbarOffsetX,scrollbarOffsetY;
@property (nonatomic, readwrite) float scrollResistance,scrollSpeed;
@property (nonatomic, readwrite) float currentScrollSpeedX,currentScrollSpeedY;
@property (nonatomic, readwrite, getter = isCanDragX) BOOL canDragX;
@property (nonatomic, readwrite, getter = isCanDragY) BOOL canDragY;
@property (nonatomic, readwrite, getter = isAlwaysShowScrollbar) BOOL alwaysShowScrollbar;
@property (nonatomic, readonly, getter = isOnScrolling) BOOL onScrolling;

@end

@interface CMMLayerMD(ViewControl)

-(void)gotoTop;
-(void)gotoBottom;
-(void)gotoLeft;
-(void)gotoRight;

@end

@interface CMMLayerMD(Configuration)

+(void)setDefaultScrollbarFrameX:(CCSpriteFrame *)scrollbar_;
+(void)setDefaultScrollbarFrameY:(CCSpriteFrame *)scrollbar_;
+(CCSpriteFrame *)defaultScrollbarFrameX;
+(CCSpriteFrame *)defaultScrollbarFrameY;

+(void)setDefaultScrollbarEdgeX:(CMM9SliceEdgeOffset)edge_;
+(void)setDefaultScrollbarEdgeY:(CMM9SliceEdgeOffset)edge_;
+(CMM9SliceEdgeOffset)defaultScrollbarEdgeX;
+(CMM9SliceEdgeOffset)defaultScrollbarEdgeY;

+(void)setDefaultScrollbarOpacityX:(GLubyte)opacity_;
+(void)setDefaultScrollbarOpacityY:(GLubyte)opacity_;
+(GLubyte)defaultScrollbarOpacityX;
+(GLubyte)defaultScrollbarOpacityY;

@end
