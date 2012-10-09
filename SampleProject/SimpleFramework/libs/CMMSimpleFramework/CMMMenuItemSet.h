//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMLayer.h"
#import "CMMMenuItem.h"

@class CMMMenuItemSet;

@protocol CMMMenuItemSetDelegate<NSObject>

@optional
-(void)menuItemSet:(CMMMenuItemSet *)menuItemSet_ whenMenuItemPushdownWithMenuItem:(CMMMenuItem *)menuItem_;
-(void)menuItemSet:(CMMMenuItemSet *)menuItemSet_ whenMenuItemPushupWithMenuItem:(CMMMenuItem *)menuItem_;

@end

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
	BOOL isEnable;
	
	id<CMMMenuItemSetDelegate> delegate;
	void (^callback_pushdown)(id sender_,CMMMenuItem *menuItem_),(^callback_pushup)(id sender_,CMMMenuItem *menuItem_);
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
@property (nonatomic, readwrite) BOOL isEnable;
@property (nonatomic, readonly) uint count;
@property (nonatomic, retain) id<CMMMenuItemSetDelegate> delegate;
@property (nonatomic, copy) void (^callback_pushdown)(id sender_,CMMMenuItem *menuItem_),(^callback_pushup)(id sender_,CMMMenuItem *menuItem_);

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