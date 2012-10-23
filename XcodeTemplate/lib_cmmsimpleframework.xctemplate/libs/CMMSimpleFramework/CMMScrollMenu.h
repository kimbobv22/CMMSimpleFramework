//  Created by JGroup(kimbobv22@gmail.com)
// 12.08.15

#import "CMMLayerMD.h"
#import "CMMMenuItem.h"
#import "CMMDrawingUtil.h"

@class CMMScrollMenu;

@protocol CMMScrollMenuDelegate<NSObject>

@optional
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanSelectAtIndex:(int)index_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenSelectedAtIndex:(int)index_;

-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanAddItem:(CMMMenuItem *)item_ atIndex:(int)index_;
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanRemoveItem:(CMMMenuItem *)item_;
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanSwitchItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_;
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanLinkSwitchItem:(CMMMenuItem *)item_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_;

-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenAddedItem:(CMMMenuItem *)item_ atIndex:(int)index_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenRemovedItem:(CMMMenuItem *)item_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenSwitchedItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenLinkSwitchedItem:(CMMMenuItem *)fromItem_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_;

-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushdownWithItem:(CMMMenuItem *)item_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushupWithItem:(CMMMenuItem *)item_;
-(void)scrollMenu:(CMMScrollMenu *)scrollMenu_ whenPushcancelWithItem:(CMMMenuItem *)item_;

@end

#define cmmVarCMMScrollMenu_defaultColor ccc4(0, 0, 0, 180)
#define cmmVarCMMScrollMenu_defaultChildZOrder 1
#define cmmVarCMMScrollMenu_defaultOrderingAccelRate 10.0f

@interface CMMScrollMenu : CMMLayerMD<NSFastEnumeration>{
	int index;
	CCArray *itemList;
	id<CMMScrollMenuDelegate> delegate;
	float marginPerItem;
	BOOL isCanSelectItem;
}

+(id)scrollMenuWithFrameSize:(CGSize)frameSize_ color:(ccColor4B)tcolor_;
+(id)scrollMenuWithFrameSize:(CGSize)frameSize_;

+(id)scrollMenuWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_;

@property (nonatomic, readwrite) int index;
@property (nonatomic, readonly) int count;
@property (nonatomic, readonly) CCArray *itemList;
@property (nonatomic, assign) id<CMMScrollMenuDelegate> delegate;
@property (nonatomic, readwrite) float marginPerItem;
@property (nonatomic, readwrite) BOOL isCanSelectItem;

@end

@interface CMMScrollMenu(Display)

-(void)doUpdateInnerSize;
-(void)updateMenuArrangeWithInterval:(ccTime)dt_;

@end

@interface CMMScrollMenu(Common)

-(void)addItem:(CMMMenuItem *)item_ atIndex:(int)index_;
-(void)addItem:(CMMMenuItem *)item_;

-(void)removeItem:(CMMMenuItem *)item_;
-(void)removeItemAtIndex:(int)index_;
-(void)removeAllItems;

-(CMMMenuItem *)itemAtIndex:(int)index_;

@end

@interface CMMScrollMenu(Switch)

-(BOOL)switchItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_;
-(BOOL)switchItemAtIndex:(int)index_ toIndex:(int)toIndex_;

-(BOOL)linkSwitchItem:(CMMMenuItem *)item_ toScrolMenu:(CMMScrollMenu *)toScrolMenu_ toIndex:(int)toIndex_;
-(BOOL)linkSwitchItemAtIndex:(int)index_ toScrolMenu:(CMMScrollMenu *)toScrolMenu_ toIndex:(int)toIndex_;

@end

@interface CMMScrollMenu(Search)

-(int)indexOfItem:(CMMMenuItem *)item_;
-(int)indexOfPoint:(CGPoint)worldPoint_;
-(int)indexOfTouch:(UITouch *)touch_;

@end
