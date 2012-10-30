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
-(void)menuItem_whenPushdown:(CMMMenuItem *)menuItem_;
-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_;
-(void)menuItem_whenPushcancel:(CMMMenuItem *)menuItem_;

@end

@interface CMMMenuItem : CMMSprite{
	id key,userData;
	CCSprite *normalImage,*selectedImage;
	id<CMMMenuItemDelegate> delegate;
	BOOL isEnable,_isOnSelected;
	
	CCAction *pushDownAction,*pushUpAction;
	void (^callback_pushdown)(id sender_),(^callback_pushup)(id sender_),(^callback_pushcancel)(id sender_);
}

+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_;
+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_;

-(id)initWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_;
-(id)initWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_;

-(void)updateDisplay;

@property (nonatomic, retain) id key,userData;
@property (nonatomic, retain) CCSprite *normalImage,*selectedImage;
@property (nonatomic, assign) id<CMMMenuItemDelegate> delegate;
@property (nonatomic, readwrite) BOOL isEnable;
@property (nonatomic, readonly) BOOL isOnSelected;
@property (nonatomic, copy) void (^callback_pushdown)(id sender_),(^callback_pushup)(id sender_),(^callback_pushcancel)(id sender_);
@property (nonatomic, retain) CCAction *pushDownAction,*pushUpAction;

@end

@interface CMMMenuItem(Callback)

-(void)callCallback_pushdown;
-(void)callCallback_pushup;
-(void)callCallback_pushcancel;

@end

@interface CMMMenuItemLabelTTF : CMMMenuItem{
	CCLabelTTF *labelTitle;
	CCTextAlignment titleAlign;
}

@property (nonatomic, assign) NSString *title;
@property (nonatomic, readonly) CCLabelTTF *labelTitle;
@property (nonatomic, readwrite) CCTextAlignment titleAlign;
@property (nonatomic, readwrite) float titleSize;
@property (nonatomic, readwrite) ccColor3B titleColor;

@end