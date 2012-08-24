//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSprite.h"
#import "CMMMacro.h"
#import "CMMDrawingManager.h"

#import "CMMTouchUtil.h"
#import "CMMFontUtil.h"

#define cmmVarCMMMenuItem_defaultMenuItemSize CGSizeMake(150, 45)

@class CMMMenuItem;

@protocol CMMMenuItemDelegate<NSObject>

@optional
-(BOOL)menuItem_isCanPush:(CMMMenuItem *)menuItem_;
-(void)menuItem_whenPushdown:(CMMMenuItem *)menuItem_;
-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_;
-(void)menuItem_whenPushcancel:(CMMMenuItem *)menuItem_;

@end

@interface CMMMenuItem : CMMSprite{
	id key,userData;
	id<CMMMenuItemDelegate> delegate;
	
	CCAction *_fadeInAction,*_fadeOutAction;
	void (^callback_pushdown)(id sender_),(^callback_pushup)(id sender_),(^callback_pushcancel)(id sender_);
}

+(id)menuItemWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_;
+(id)menuItemWithFrameSeq:(int)frameSeq_;

-(id)initWithFrameSeq:(int)frameSeq_ frameSize:(CGSize)frameSize_;
-(id)initWithFrameSeq:(int)frameSeq_;

-(void)updateDisplay;

@property (nonatomic, retain) id key,userData;
@property (nonatomic, assign) id<CMMMenuItemDelegate> delegate;
@property (nonatomic, copy) void (^callback_pushdown)(id sender_),(^callback_pushup)(id sender_),(^callback_pushcancel)(id sender_);

@end

@interface CMMMenuItemLabelTTF : CMMMenuItem{
	CCLabelTTF *labelTitle;
}

@property (nonatomic, assign) NSString *title;

@end