//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayerM.h"

struct CMMLayerMDScrollbar{
	CMMLayerMDScrollbar(){
		colorX = colorY = ccc4(255, 255, 255, 145);
		widthX = widthY = 2.0f;
		distanceX = distanceY = 4.0f;
	}
	
	ccColor4B colorX,colorY;
	float widthX,widthY,distanceX,distanceY;
};

@interface CMMLayerMD : CMMLayerM{
	CMMTouchState touchState;
	CMMLayerMDScrollbar scrollbar;
	
	BOOL canDragX,canDragY,alwaysShowScrollbar,_doShowScrollbar;
	float dragSpeed,_curScrollSpeedX,_curScrollSpeedY;
	
	CGPoint _innerLayerBeforePoint;
}

@property (nonatomic, readwrite) CMMTouchState touchState;
@property (nonatomic, readwrite) CMMLayerMDScrollbar scrollbar;
@property (nonatomic, readwrite, getter = isCanDragX) BOOL canDragX;
@property (nonatomic, readwrite, getter = isCanDragY) BOOL canDragY;
@property (nonatomic, readwrite, getter = isAlwaysShowScrollbar) BOOL alwaysShowScrollbar;
@property (nonatomic, readwrite) float dragSpeed;

@end

@interface CMMLayerMD(ViewControl)

-(void)gotoTop;
-(void)gotoBottom;
-(void)gotoLeft;
-(void)gotoRight;

@end
