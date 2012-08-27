//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"
#import "CMMDrawingManager.h"
#import "CMMTouchUtil.h"

@class CMMControlItem;

//interface
@protocol CMMControlItemDelegate <NSObject>
@end

#define cmmVarCMMControlItem_redrawDelayTime 0.05f

//interface
@interface CMMControlItem : CMMLayer{
	id<CMMControlItemDelegate> delegate;
	BOOL isEnable;
	id userData;
	
	ccTime _redrawDelayTime;
	BOOL _doRedraw;
}

+(id)controlItemWithFrameSize:(CGSize)frameSize_;
-(id)initWithFrameSize:(CGSize)frameSize_;

-(void)redraw;
-(void)update:(ccTime)dt_;

@property (nonatomic, assign) id<CMMControlItemDelegate> delegate;
@property (nonatomic, readwrite) BOOL isEnable;
@property (nonatomic, retain) id userData;

@end
