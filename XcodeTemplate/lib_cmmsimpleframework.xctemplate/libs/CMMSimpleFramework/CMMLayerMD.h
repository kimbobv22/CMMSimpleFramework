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
	
	BOOL isCanDragX,isCanDragY,isAlwaysShowScrollbar,_doShowScrollbar;
	float dragSpeed,_curScrollSpeedX,_curScrollSpeedY;
	
	CGPoint _innerLayerBeforePoint;
}

@property (nonatomic, readwrite) CMMTouchState touchState;
@property (nonatomic, readwrite) CMMLayerMDScrollbar scrollbar;
@property (nonatomic, readwrite) BOOL isCanDragX,isCanDragY,isAlwaysShowScrollbar;
@property (nonatomic, readwrite) float dragSpeed;

@end

@interface CMMLayerMD(ViewControl)

-(void)gotoTop;
-(void)gotoBottom;
-(void)gotoLeft;
-(void)gotoRight;

@end
