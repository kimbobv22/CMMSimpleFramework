//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMLayer.h"
#import "CMMMenuItem.h"

@class CMMMenuItemSet;

enum CMMMenuItemSetAlignType{
	CMMMenuItemSetAlignType_horizontal,
	CMMMenuItemSetAlignType_vertical,
};

enum CMMMenuItemSetLineHAlignType{
	CMMMenuItemSetLineHAlignType_top,
	CMMMenuItemSetLineHAlignType_middle,
	CMMMenuItemSetLineHAlignType_bottom,
};

enum CMMMenuItemSetLineVAlignType{
	CMMMenuItemSetLineVAlignType_left,
	CMMMenuItemSetLineVAlignType_center,
	CMMMenuItemSetLineVAlignType_right,
};

@interface CMMMenuItemSet : CMMLayer{
	CCArray *itemList;
	CMMMenuItemSetAlignType alignType;
	CMMMenuItemSetLineHAlignType lineHAlignType;
	CMMMenuItemSetLineVAlignType lineVAlignType;
	uint unitPerLine;
	BOOL enable;
	
	void (^callback_whenItemPushdown)(CMMMenuItem *item_),(^callback_whenItemPushup)(CMMMenuItem *item_);
}

+(id)menuItemSetWithMenuSize:(CGSize)menuSize_;
+(id)menuItemSetWithMenuSize:(CGSize)menuSize_ menuItem:(CMMMenuItem *)menuItem_,... NS_REQUIRES_NIL_TERMINATION;
+(id)menuItemSetWithMenuSize:(CGSize)menuSize_ menuItemArray:(CCArray *)array_;

-(id)initWithMenuSize:(CGSize)menuSize_;
-(id)initWithMenuSize:(CGSize)menuSize_ menuItemArray:(CCArray *)array_;

-(void)updateDisplay;

@property (nonatomic, readonly) CCArray *itemList;
@property (nonatomic, readwrite) CMMMenuItemSetAlignType alignType;
@property (nonatomic, readwrite) CMMMenuItemSetLineHAlignType lineHAlignType;
@property (nonatomic, readwrite) CMMMenuItemSetLineVAlignType lineVAlignType;
@property (nonatomic, readwrite) uint unitPerLine;
@property (nonatomic, readwrite, getter = isEnable) BOOL enable;
@property (nonatomic, readonly) uint count;
@property (nonatomic, copy) void (^callback_whenItemPushdown)(CMMMenuItem *item_),(^callback_whenItemPushup)(CMMMenuItem *item_);

-(void)setCallback_whenItemPushdown:(void (^)(CMMMenuItem *item_))block_;
-(void)setCallback_whenItemPushup:(void (^)(CMMMenuItem *item_))block_;

@end

@interface CMMMenuItemSet(Common)

-(void)addMenuItem:(CMMMenuItem *)menuItem_ atIndex:(uint)index_;
-(void)addMenuItem:(CMMMenuItem *)menuItem_;

-(void)removeMenuItem:(CMMMenuItem *)menuItem_;
-(void)removeMenuItemAtInex:(uint)index_;
-(void)removeAllMenuItems;

-(CMMMenuItem *)menuItemAtIndex:(uint)index_;

-(uint)indexOfMenuItem:(CMMMenuItem *)menuItem_;

@end

@interface CMMMenuItemSet(Callback)

-(void)callCallback_pushdownWithMenuItem:(CMMMenuItem *)menuItem_;
-(void)callCallback_pushupWithMenuItem:(CMMMenuItem *)menuItem_;

@end