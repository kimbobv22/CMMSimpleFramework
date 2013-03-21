//  Created by JGroup(kimbobv22@gmail.com)
// 12.08.15

#import "CMMLayerMD.h"
#import "CMMMenuItem.h"
#import "CMMDrawingUtil.h"

#define cmmVarCMMScrollMenu_defaultColor ccc4(0, 0, 0, 180)
#define cmmVarCMMScrollMenu_defaultChildZOrder 1
#define cmmVarCMMScrollMenu_defaultOrderingAccelRate 10.0f

@interface CMMScrollMenu : CMMLayerMD<NSFastEnumeration>{
	int index;
	CCArray *itemList;
	float marginPerItem;
	
	void (^callback_whenIndexChanged)(int index_);
	void (^callback_whenTapAtIndex)(int index_);
	void (^callback_whenItemAdded)(CMMMenuItem *item_, int index_);
	void (^callback_whenItemRemoved)(CMMMenuItem *item_);
	void (^callback_whenItemSwitched)(CMMMenuItem *item_, int toIndex_);
	void (^callback_whenItemLinkSwitched)(CMMMenuItem *fromItem_, CMMScrollMenu *toScrollMenu_, int toIndex_);
	void (^callback_whenItemMoved)(CMMMenuItem *item_, int toIndex_);
	
	BOOL (^filter_canChangeIndex)(int index_);
	BOOL (^filter_canAddItem)(CMMMenuItem *item_, int index_);
	BOOL (^filter_canRemoveItem)(CMMMenuItem *item_);
	BOOL (^filter_canSwitchItem)(CMMMenuItem *item_, int toIndex_);
	BOOL (^filter_canLinkSwitchItem)(CMMMenuItem *fromItem_, CMMScrollMenu *toScrollMenu_, int toIndex_);
	BOOL (^filter_canMoveItem)(CMMMenuItem *item_, int toIndex_);
}

+(id)scrollMenuWithFrameSize:(CGSize)frameSize_ color:(ccColor4B)tcolor_;
+(id)scrollMenuWithFrameSize:(CGSize)frameSize_;

+(id)scrollMenuWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_;

@property (nonatomic, readwrite) int index;
@property (nonatomic, readonly) int count;
@property (nonatomic, readonly) CCArray *itemList;
@property (nonatomic, readwrite) float marginPerItem;

@property (nonatomic, copy) void (^callback_whenIndexChanged)(int index_);
@property (nonatomic, copy) void (^callback_whenTapAtIndex)(int index_);
@property (nonatomic, copy) void (^callback_whenItemAdded)(CMMMenuItem *item_, int index_);
@property (nonatomic, copy) void (^callback_whenItemRemoved)(CMMMenuItem *item_);
@property (nonatomic, copy) void (^callback_whenItemSwitched)(CMMMenuItem *item_, int toIndex_);
@property (nonatomic, copy) void (^callback_whenItemLinkSwitched)(CMMMenuItem *fromItem_, CMMScrollMenu *toScrollMenu_, int toIndex_);
@property (nonatomic, copy) void (^callback_whenItemMoved)(CMMMenuItem *item_, int toIndex_);

@property (nonatomic, copy) BOOL (^filter_canChangeIndex)(int index_);
@property (nonatomic, copy) BOOL (^filter_canAddItem)(CMMMenuItem *item_, int index_);
@property (nonatomic, copy) BOOL (^filter_canRemoveItem)(CMMMenuItem *item_);
@property (nonatomic, copy) BOOL (^filter_canSwitchItem)(CMMMenuItem *item_, int toIndex_);
@property (nonatomic, copy) BOOL (^filter_canLinkSwitchItem)(CMMMenuItem *fromItem_, CMMScrollMenu *toScrollMenu_, int toIndex_);
@property (nonatomic, copy) BOOL (^filter_canMoveItem)(CMMMenuItem *item_, int toIndex_);

-(void)setCallback_whenIndexChanged:(void (^)(int index_))block_;
-(void)setCallback_whenTapAtIndex:(void (^)(int index_))block_;
-(void)setCallback_whenItemAdded:(void (^)(CMMMenuItem *item_, int index_))block_;
-(void)setCallback_whenItemRemoved:(void (^)(CMMMenuItem *item_))block_;
-(void)setCallback_whenItemSwitched:(void (^)(CMMMenuItem *item_, int toIndex_))block_;
-(void)setCallback_whenItemLinkSwitched:(void (^)(CMMMenuItem *item_, CMMScrollMenu *toScrollMenu_, int toIndex_))block_;
-(void)setCallback_whenItemMoved:(void (^)(CMMMenuItem *item_, int toIndex_))block_;

-(void)setFilter_canChangeIndex:(BOOL (^)(int index_))block_;
-(void)setFilter_canAddItem:(BOOL (^)(CMMMenuItem *item_, int index_))block_;
-(void)setFilter_canRemoveItem:(BOOL (^)(CMMMenuItem *item_))block_;
-(void)setFilter_canSwitchItem:(BOOL (^)(CMMMenuItem *item_, int index_))block_;
-(void)setFilter_canLinkSwitchItem:(BOOL (^)(CMMMenuItem *item_, CMMScrollMenu * toScrollMenu_, int toIndex_))block_;
-(void)setFilter_canMoveItem:(BOOL (^)(CMMMenuItem *item_, int toIndex_))block_;

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

-(BOOL)moveItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_;
-(BOOL)moveItemAtIndex:(int)index_ toIndex:(int)toIndex_;

-(BOOL)switchItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_;
-(BOOL)switchItemAtIndex:(int)index_ toIndex:(int)toIndex_;

-(BOOL)linkSwitchItem:(CMMMenuItem *)item_ toScrolMenu:(CMMScrollMenu *)toScrolMenu_ toIndex:(int)toIndex_;
-(BOOL)linkSwitchItemAtIndex:(int)index_ toScrolMenu:(CMMScrollMenu *)toScrolMenu_ toIndex:(int)toIndex_;

@end

@interface CMMScrollMenu(Search)

-(int)indexOfItem:(CMMMenuItem *)item_;
-(int)indexOfPoint:(CGPoint)worldPoint_ margin:(float)margin_;
-(int)indexOfPoint:(CGPoint)worldPoint_;
-(int)indexOfTouch:(UITouch *)touch_ margin:(float)margin_;
-(int)indexOfTouch:(UITouch *)touch_;

@end
