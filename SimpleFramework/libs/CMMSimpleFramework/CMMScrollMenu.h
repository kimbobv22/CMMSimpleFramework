//  Created by JGroup(kimbobv22@gmail.com)
// 12.08.15

#import "CMMLayerMask.h"
#import "CMMMenuItem.h"
#import "CMMDrawingUtil.h"

@class CMMScrollMenu;

@protocol CMMScrollMenuDelegate<NSObject>

@optional
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanSelectAtIndex:(int)index_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenSelectedAtIndex:(int)index_;

-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanAddMenuItem:(CMMMenuItem *)menuItem_ atIndex:(int)index_;
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanRemoveMenuItem:(CMMMenuItem *)menuItem_;
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanSwitchMenuItem:(CMMMenuItem *)menuItem_ toIndex:(int)toIndex_;
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanLinkSwitchMenuItem:(CMMMenuItem *)menuItem_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_;
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanDragMenuItem:(CMMMenuItem *)menuItem_;

-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenAddedMenuItem:(CMMMenuItem *)menuItem_ atIndex:(int)index_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenRemovedMenuItem:(CMMMenuItem *)menuItem_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenSwitchedMenuItem:(CMMMenuItem *)menuItem_ toIndex:(int)toIndex_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenLinkSwitchedMenuItem:(CMMMenuItem *)fromMenuItem_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_;

-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushdownWithMenuItem:(CMMMenuItem *)menuItem_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushupWithMenuItem:(CMMMenuItem *)menuItem_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushcancelWithMenuItem:(CMMMenuItem *)menuItem_;

@end

@interface CMMScrollMenuDragItem : CCSprite{
	int targetIndex;
}

@property (nonatomic, readwrite) int targetIndex;

@end

#define cmmVarCMMScrollMenu_defaultColor ccc4(0, 0, 0, 180)
#define cmmVarCMMScrollMenu_defaultChildZOrder 1
#define cmmVarCMMScrollMenu_defaultOrderingAccelRate 10.0f
#define cmmVarCMMScrollMenu_defaultDragMenuItemDelayTime 1.0f
#define cmmVarCMMScrollMenu_defaultDragMenuItemDitance 30.0f

@interface CMMScrollMenu : CMMLayerMaskDrag{
	int index;
	CCArray *itemList;
	id<CMMScrollMenuDelegate> delegate;
	float marginPerMenuItem;
	BOOL isCanSelectMenuItem;
	
	CMMScrollMenuDragItem *_dragMenuItemView;
	ccTime _beDragMenuItemDelayTime;
	CGPoint _firstTouchPoint;
}

+(id)scrollMenuWithFrameSize:(CGSize)frameSize_ color:(ccColor4B)tcolor_;
+(id)scrollMenuWithFrameSize:(CGSize)frameSize_;

+(id)scrollMenuWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_;

@property (nonatomic, readwrite) int index;
@property (nonatomic, readonly) int count;
@property (nonatomic, readonly) CCArray *itemList;
@property (nonatomic, assign) id<CMMScrollMenuDelegate> delegate;
@property (nonatomic, readwrite) float marginPerMenuItem;
@property (nonatomic, readwrite) BOOL isCanSelectMenuItem;

@end

@interface CMMScrollMenu(Common)

-(void)addMenuItem:(CMMMenuItem *)menuItem_ atIndex:(int)index_;
-(void)addMenuItem:(CMMMenuItem *)menuItem_;

-(void)removeMenuItem:(CMMMenuItem *)menuItem_;
-(void)removeMenuItemAtIndex:(int)index_;

-(CMMMenuItem *)menuItemAtIndex:(int)index_;
-(CMMMenuItem *)menuItemAtKey:(id)key_;

@end

@interface CMMScrollMenu(Switch)

-(BOOL)switchMenuItem:(CMMMenuItem *)menuItem_ toIndex:(int)toIndex_;
-(BOOL)switchMenuItemAtIndex:(int)index_ toIndex:(int)toIndex_;

-(BOOL)linkSwitchMenuItem:(CMMMenuItem *)menuItem_ toScrolMenu:(CMMScrollMenu *)toScrolMenu_ toIndex:(int)toIndex_;
-(BOOL)linkSwitchMenuItemAtIndex:(int)index_ toScrolMenu:(CMMScrollMenu *)toScrolMenu_ toIndex:(int)toIndex_;

@end

@interface CMMScrollMenu(Search)

-(int)indexOfMenuItem:(CMMMenuItem *)menuItem_;
-(int)indexOfKey:(id)key_;
-(int)indexOfPoint:(CGPoint)worldPoint_;
-(int)indexOfTouch:(UITouch *)touch_;

@end
