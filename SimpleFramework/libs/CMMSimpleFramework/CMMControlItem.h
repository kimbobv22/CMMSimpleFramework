//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"
#import "CMMDrawingManager.h"
#import "CMMTouchUtil.h"

@class CMMControlItem;

//interface
@protocol CMMControlItemDelegate <NSObject>
@end

//interface
@interface CMMControlItem : CMMLayer{
	id<CMMControlItemDelegate> delegate;
	BOOL isEnable;
	id userData;
}

+(id)controlItemWithFrameSize:(CGSize)frameSize_;
-(id)initWithFrameSize:(CGSize)frameSize_;

-(void)redraw;

@property (nonatomic, assign) id<CMMControlItemDelegate> delegate;
@property (nonatomic, readwrite) BOOL isEnable;
@property (nonatomic, retain) id userData;

@end
