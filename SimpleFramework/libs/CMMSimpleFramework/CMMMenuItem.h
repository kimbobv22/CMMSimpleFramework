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
-(BOOL)menuItem_isCanPush:(CMMMenuItem *)menuItem_ DEPRECATED_ATTRIBUTE;
-(void)menuItem_whenPushdown:(CMMMenuItem *)menuItem_;
-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_;
-(void)menuItem_whenPushcancel:(CMMMenuItem *)menuItem_;

@end

@interface CMMMenuItem : CMMSprite{
	id key,userData;
	CCSprite *selectedImage,*_normalImage;
	id<CMMMenuItemDelegate> delegate;
	BOOL isEnable;
	
	CCAction *_fadeInAction,*_fadeOutAction;
	void (^callback_pushdown)(id sender_),(^callback_pushup)(id sender_),(^callback_pushcancel)(id sender_);
}

+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_;
+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_;

-(id)initWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_;
-(id)initWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_;

-(void)updateDisplay;

@property (nonatomic, retain) id key,userData;
@property (nonatomic, retain) CCSprite *selectedImage;
@property (nonatomic, retain) id<CMMMenuItemDelegate> delegate;
@property (nonatomic, readwrite) BOOL isEnable;
@property (nonatomic, copy) void (^callback_pushdown)(id sender_),(^callback_pushup)(id sender_),(^callback_pushcancel)(id sender_);

@end

@interface CMMMenuItem(Callback)

-(void)callCallback_pushdown;
-(void)callCallback_pushup;
-(void)callCallback_pushcancel;

@end

@interface CMMMenuItemLabelTTF : CMMMenuItem{
	CCLabelTTF *labelTitle;
}

@property (nonatomic, assign) NSString *title;

@end