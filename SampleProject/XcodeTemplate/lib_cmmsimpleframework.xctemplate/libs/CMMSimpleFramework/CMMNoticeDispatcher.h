//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"
#import "CMMFontUtil.h"

#define CMMNoticeDispatcherItem_defaultNoticeZOrder 999

@interface CMMNoticeDispatcherItem : NSObject{
	NSString *title,*subject;
	id userData;
	void (^callback_notice)(CMMNoticeDispatcherItem *sender_);
}

+(id)noticeItemWithTitle:(NSString *)title_ subject:(NSString *)subject_;
-(id)initWithTitle:(NSString *)title_ subject:(NSString *)subject_;

-(void)reset;

@property (nonatomic, copy) NSString *title,*subject;
@property (nonatomic, retain) id userData;
@property (nonatomic, copy) void (^callback_notice)(CMMNoticeDispatcherItem *sender_);

@end

@class CMMNoticeDispatcher;

@interface CMMNoticeDispatcherTemplate : CMMLayer{
	CMMNoticeDispatcher *noticeDispatcher;
	
	CCLabelTTF *labelTitle,*labelSubject;
	CCFiniteTimeAction *noticeAction;
}

+(id)templateWithNoticeDispatcher:(CMMNoticeDispatcher *)noticeDispatcher_;
-(id)initWithNoticeDispatcher:(CMMNoticeDispatcher *)noticeDispatcher_;

-(void)setTitle:(NSString *)title_ subject:(NSString *)subject_;

-(void)arrangePosition;
-(void)resetTemplate;

@property (nonatomic, retain) CMMNoticeDispatcher *noticeDispatcher;
@property (nonatomic, readonly) CCFiniteTimeAction *noticeAction;

@end

@interface CMMNoticeDispatcherTemplate_Default : CMMNoticeDispatcherTemplate

@end

@interface CMMNoticeDispatcherTemplate_DefaultFadeInOut : CMMNoticeDispatcherTemplate_Default

@end

@interface CMMNoticeDispatcherTemplate_DefaultScale : CMMNoticeDispatcherTemplate_Default

@end

@interface CMMNoticeDispatcherTemplate_DefaultMoveDown : CMMNoticeDispatcherTemplate_Default

@end

#define cmmVarCMMNoticeDispatcher_defaultCacheCount 10

typedef enum{
	CMMNoticePositionType_top,
	CMMNoticePositionType_center,
	CMMNoticePositionType_bottom,
	CMMNoticePositionType_custom,
} CMMNoticePositionType;

@interface CMMNoticeDispatcher : NSObject{
	CCNode *target;
	CCArray *itemList;
	
	CMMNoticeDispatcherTemplate *noticeTemplate;
	CMMNoticePositionType noticePositionType;
	CGPoint noticePosition;

	BOOL _isOnNotice;
}

+(id)noticeWithTarget:(CCNode *)target_;
-(id)initWithTarget:(CCNode *)target_;

-(void)addNoticeItem:(CMMNoticeDispatcherItem *)noticeItem_;
-(CMMNoticeDispatcherItem *)addNoticeItemWithTitle:(NSString *)title_ subject:(NSString *)subject_;

@property (nonatomic, retain) CCNode *target;
@property (nonatomic, retain) CCArray *itemList;

@property (nonatomic, retain) CMMNoticeDispatcherTemplate *noticeTemplate;
@property (nonatomic, readwrite) CMMNoticePositionType noticePositionType;
@property (nonatomic, readwrite) CGPoint noticePosition;

@end
