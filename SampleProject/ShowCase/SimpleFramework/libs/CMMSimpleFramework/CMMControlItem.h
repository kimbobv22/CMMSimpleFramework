//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"
#import "CMMDrawingManager.h"
#import "CMMTouchUtil.h"

#define cmmVarCMMControlItem_redrawDelayTime 0.05f

//interface
@interface CMMControlItem : CMMLayer{
	BOOL enable;
	ccColor3B disabledColor;
	
	ccTime _redrawDelayTime;
	BOOL _doRedraw;
}

+(id)controlItemWithFrameSize:(CGSize)frameSize_;
-(id)initWithFrameSize:(CGSize)frameSize_;

-(void)redraw;
-(void)update:(ccTime)dt_;

@property (nonatomic, readwrite, getter = isEnable) BOOL enable;
@property (nonatomic, readwrite) ccColor3B disabledColor;

@end
