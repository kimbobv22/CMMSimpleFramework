//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSprite.h"
#import "CMMMacro.h"
#import "CMMDrawingManager.h"

#import "CMMTouchUtil.h"
#import "CMMFontUtil.h"

#define cmmVarCMMMenuItem_defaultMenuItemSize CGSizeMake(150, 45)

@interface CMMMenuItem : CMMSprite{
	id key;
	CCSpriteFrame *normalFrame,*selectedFrame;
	BOOL enable,onSelect;
	
	CCAction *pushDownAction,*pushUpAction;
	BOOL (^filter_canSelectItem)(id item_);
	void (^callback_pushdown)(id item_),(^callback_pushup)(id item_),(^callback_pushcancel)(id item_);
}

+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_;
+(id)menuItemWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_;

-(id)initWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_ frameSize:(CGSize)frameSize_;
-(id)initWithFrameSeq:(uint)frameSeq_ batchBarSeq:(uint)batchBarSeq_;

-(void)updateDisplay;

-(void)setNormalFrame:(CCSpriteFrame *)frame_;
-(void)setNormalFrameWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_;
-(void)setNormalFrameWithSprite:(CCSprite *)sprite_;

-(void)setSelectedFrame:(CCSpriteFrame *)frame_;
-(void)setSelectedFrameWithTexture:(CCTexture2D *)texture_ rect:(CGRect)rect_;
-(void)setSelectedFrameWithSprite:(CCSprite *)sprite_;

@property (nonatomic, retain) id key;

@property (nonatomic, readwrite, getter = isEnable) BOOL enable;
@property (nonatomic, readonly, getter = isOnSelect) BOOL onSelect;
@property (nonatomic, readonly) CCSpriteFrame *normalFrame,*selectedFrame;
@property (nonatomic, copy) BOOL (^filter_canSelectItem)(id item_);
@property (nonatomic, copy) void (^callback_pushdown)(id item_),(^callback_pushup)(id item_),(^callback_pushcancel)(id item_);
@property (nonatomic, retain) CCAction *pushDownAction,*pushUpAction;

-(void)setFilter_canSelectItem:(BOOL (^)(id item_))block_;
-(void)setCallback_pushdown:(void (^)(id item_))block_;
-(void)setCallback_pushup:(void (^)(id item_))block_;
-(void)setCallback_pushcancel:(void (^)(id item_))block_;

@end

@interface CMMMenuItem(Callback)

-(void)callCallback_pushdown;
-(void)callCallback_pushup;
-(void)callCallback_pushcancel;

@end

@interface CMMMenuItemL : CMMMenuItem{
	CCLabelTTF *labelTitle;
	CCTextAlignment titleAlign;
}

@property (nonatomic, assign) NSString *title;
@property (nonatomic, readonly) CCLabelTTF *labelTitle;
@property (nonatomic, readwrite) CCTextAlignment titleAlign;
@property (nonatomic, readwrite) float titleSize;
@property (nonatomic, readwrite) ccColor3B titleColor;

@end