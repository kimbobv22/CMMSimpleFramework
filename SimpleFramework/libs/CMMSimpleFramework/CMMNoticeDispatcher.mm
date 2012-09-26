//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMNoticeDispatcher.h"

@implementation CMMNoticeDispatcherItem
@synthesize title,subject,userData,callback_notice;

+(id)noticeItemWithTitle:(NSString *)title_ subject:(NSString *)subject_{
	return [[[self alloc] initWithTitle:title_ subject:subject_] autorelease];
}
-(id)initWithTitle:(NSString *)title_ subject:(NSString *)subject_{
	if(!(self = [super init])) return self;
	
	title = [title_ copy];
	subject = [subject_ copy];
	userData = nil;
	callback_notice = nil;
	
	return self;
}

-(void)reset{
	[self setTitle:nil];
	[self setSubject:nil];
	[self setUserData:nil];
	[self setCallback_notice:nil];
}

-(void)dealloc{
	[callback_notice release];
	[userData release];
	[subject release];
	[title release];
	[super dealloc];
}

@end

@implementation CMMNoticeDispatcherTemplate
@synthesize noticeDispatcher,noticeAction;

+(id)templateWithNoticeDispatcher:(CMMNoticeDispatcher *)noticeDispatcher_{
	return [[[self alloc] initWithNoticeDispatcher:noticeDispatcher_] autorelease];
}
-(id)initWithNoticeDispatcher:(CMMNoticeDispatcher *)noticeDispatcher_{
	if(!(self = [super initWithColor:ccc4(0, 0, 0, 0)])) return self;
	
	noticeDispatcher = [noticeDispatcher_ retain];
	
	labelTitle = [CMMFontUtil labelWithstring:@" " fontSize:16.0f];
	labelSubject = [CMMFontUtil labelWithstring:@" " fontSize:14.0f];
	[self addChild:labelTitle];
	[self addChild:labelSubject];
	noticeAction = nil;
	[self resetTemplate];
	
	return self;
}

-(BOOL)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ isAllowTouch:(UITouch *)touch_ event:(UIEvent *)event_{
	return NO;
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	[self arrangePosition];
}

-(void)setTitle:(NSString *)title_ subject:(NSString *)subject_{
	[labelTitle setString:title_];
	[labelSubject setString:subject_];
	[self arrangePosition];
}
-(void)arrangePosition{}
-(void)resetTemplate{}

-(void)dealloc{
	[noticeAction release];
	[noticeDispatcher release];
	[super dealloc];
}

@end

@implementation CMMNoticeDispatcherTemplate_Default

-(id)initWithNoticeDispatcher:(CMMNoticeDispatcher *)noticeDispatcher_{
	if(!(self = [super initWithNoticeDispatcher:noticeDispatcher_])) return self;

	CGSize frameSize_ = [CCDirector sharedDirector].winSize;
	[self setContentSize:CGSizeMake(frameSize_.width, 50.0f)];
	
	return self;
}

-(void)arrangePosition{
	labelTitle.position = ccp(labelTitle.contentSize.width/2+20.0f,contentSize_.height-labelTitle.contentSize.height/2.0f);
	labelSubject.position = ccp(contentSize_.width/2.0f,contentSize_.height/2.0f-10.0f);
}
-(void)resetTemplate{
	[self setColor:ccc3(80, 80, 80)];
	[self setOpacity:180.0f];
}

@end

@implementation CMMNoticeDispatcherTemplate_DefaultFadeInOut

-(id)initWithNoticeDispatcher:(CMMNoticeDispatcher *)noticeDispatcher_{
	if(!(self = [super initWithNoticeDispatcher:noticeDispatcher_])) return self;
	
	noticeAction = [[CCSequence actions:[CCFadeTo actionWithDuration:0.2f opacity:180.0f],[CCDelayTime actionWithDuration:3.0f],[CCFadeTo actionWithDuration:0.2f opacity:0.0f], nil] retain];
	
	return self;
}

-(void)setOpacity:(GLubyte)opacity{
	[super setOpacity:opacity];
	[labelTitle setOpacity:opacity];
	[labelSubject setOpacity:opacity];
}

-(void)resetTemplate{
	[super resetTemplate];
	[self setOpacity:0.0f];
}

@end

@implementation CMMNoticeDispatcherTemplate_DefaultScale

-(id)initWithNoticeDispatcher:(CMMNoticeDispatcher *)noticeDispatcher_{
	if(!(self = [super initWithNoticeDispatcher:noticeDispatcher_])) return self;
	[self setAnchorPoint:ccp(0.5f,0.0f)]; //issue
	noticeAction = [[CCSequence actions:[CCScaleTo actionWithDuration:0.1f scale:1.1f],[CCScaleTo actionWithDuration:0.1f scale:1.0f],[CCDelayTime actionWithDuration:3.0f],[CCScaleTo actionWithDuration:0.1f scale:1.1f],[CCSpawn actionOne:[CCScaleTo actionWithDuration:0.2f scale:0.8f] two:[CCFadeTo actionWithDuration:0.2f opacity:0.0f]], nil] retain];
	
	return self;
}

-(void)resetTemplate{
	[super resetTemplate];
	[self setScale:0.9f];
}

@end

@implementation CMMNoticeDispatcherTemplate_DefaultMoveDown

-(id)initWithNoticeDispatcher:(CMMNoticeDispatcher *)noticeDispatcher_{
	if(!(self = [super initWithNoticeDispatcher:noticeDispatcher_])) return self;
	
	noticeAction = [[CCSequence actions:[CCSpawn actionOne:[CCFadeTo actionWithDuration:0.1f opacity:120.0f] two:[CCMoveBy actionWithDuration:0.2f position:ccp(0,-contentSize_.height)]],[CCDelayTime actionWithDuration:3.0f],[CCSpawn actionOne:[CCFadeTo actionWithDuration:0.1f opacity:0.0f] two:[CCMoveBy actionWithDuration:0.2f position:ccp(0,contentSize_.height)]], nil] retain];
	
	return self;
}

-(void)resetTemplate{
	[super resetTemplate];
	[self setOpacity:0.0f];
	CGPoint targetPoint_ = self.position;
	targetPoint_.y += contentSize_.height;
	[self setPosition:targetPoint_];
}

@end

static CCArray *_cachedNoticeDispatcherItems_ = nil;

@interface CMMNoticeDispatcher(Private)

+(CMMNoticeDispatcherItem *)cachedNoticeItem;
+(void)cacheNoticeItem:(CMMNoticeDispatcherItem *)noticeItem_;

-(void)_startNotice;
-(void)_endNoticeWithNoticeItem:(CMMNoticeDispatcherItem *)noticeItem_;

@end

@implementation CMMNoticeDispatcher(Private)

+(CMMNoticeDispatcherItem *)cachedNoticeItem{
	if(!_cachedNoticeDispatcherItems_){
		_cachedNoticeDispatcherItems_ = [[CCArray alloc] init];
		for(uint index_=0;index_<cmmVarCMMNoticeDispatcher_defaultCacheCount;++index_)
			[_cachedNoticeDispatcherItems_ addObject:[CMMNoticeDispatcherItem noticeItemWithTitle:nil subject:nil]];
	}
	
	CMMNoticeDispatcherItem *noticeItem_ = nil;
	if(_cachedNoticeDispatcherItems_.count > 0){
		noticeItem_ = [[[_cachedNoticeDispatcherItems_ objectAtIndex:0] retain] autorelease];
		[_cachedNoticeDispatcherItems_ removeObjectAtIndex:0];
	}
	return noticeItem_;
}
+(void)cacheNoticeItem:(CMMNoticeDispatcherItem *)noticeItem_{
	[noticeItem_ reset];
	[_cachedNoticeDispatcherItems_ addObject:noticeItem_];
}

-(void)_startNotice{
	if(_isOnNotice || itemList.count <= 0) return;
	NSAssert(noticeTemplate, @"NoticeTemplate must be exists");
	NSAssert(noticeTemplate.noticeAction, @"NoticeTemplate Action must be exists");
	
	_isOnNotice = YES;
	CMMNoticeDispatcherItem *noticeItem_ = [itemList objectAtIndex:0];
	
	[noticeTemplate setTitle:noticeItem_.title subject:noticeItem_.subject];
	CGPoint targetPoint_ = noticePosition;
	CGSize templateSize_ = noticeTemplate.contentSize;
	switch(positionType){
		case CMMNoticePositionType_top:{
			targetPoint_ = cmmFuncCommon_position_center(target, noticeTemplate);
			targetPoint_.y = target.contentSize.height-templateSize_.height*(1.0f-noticeTemplate.anchorPoint.y);
			break;
		}
		case CMMNoticePositionType_center:{
			targetPoint_ = cmmFuncCommon_position_center(target, noticeTemplate);
			break;
		}
		case CMMNoticePositionType_bottom:{
			targetPoint_ = cmmFuncCommon_position_center(target, noticeTemplate);
			targetPoint_.y = templateSize_.height*(1.0f-noticeTemplate.anchorPoint.y);
			break;
		}
		default: break;
	}
	
	[noticeTemplate setPosition:targetPoint_];
	[noticeTemplate resetTemplate];
	[target addChild:noticeTemplate z:CMMNoticeDispatcherItem_defaultNoticeZOrder];
	[noticeTemplate runAction:[CCSequence actionOne:noticeTemplate.noticeAction two:[CCCallFuncO actionWithTarget:self selector:@selector(_endNoticeWithNoticeItem:) object:noticeItem_]]];
}
-(void)_endNoticeWithNoticeItem:(CMMNoticeDispatcherItem *)noticeItem_{
	if(noticeItem_.callback_notice)
		noticeItem_.callback_notice(noticeItem_);
	
	[CMMNoticeDispatcher cacheNoticeItem:noticeItem_];
	[itemList removeObject:noticeItem_];
	[target removeChild:noticeTemplate cleanup:YES];
	
	_isOnNotice = NO;
	
	if(itemList.count>0)
		[self _startNotice];
}

@end

@implementation CMMNoticeDispatcher
@synthesize target,itemList,noticeTemplate,positionType,noticePosition;

+(id)noticeWithTarget:(CCNode *)target_{
	return [[[self alloc] initWithTarget:target_] autorelease];
}
-(id)initWithTarget:(CCNode *)target_{
	if(!(self = [super init])) return self;
	
	target = [target_ retain];
	itemList = [[CCArray alloc] init];
	
	noticeTemplate = nil;
	positionType = CMMNoticePositionType_top;
	noticePosition = CGPointZero;
	_isOnNotice = NO;
	
	return self;
}

-(void)setNoticeTemplate:(CMMNoticeDispatcherTemplate *)noticeTemplate_{
	BOOL isOnNotice_ = _isOnNotice;
	if(isOnNotice_ && noticeTemplate){
		[noticeTemplate removeFromParentAndCleanup:YES];
		[noticeTemplate release];
		_isOnNotice = NO;
	}
	
	noticeTemplate = [noticeTemplate_ retain];
	
	if(isOnNotice_)
		[self _startNotice];
}

-(void)addNoticeItem:(CMMNoticeDispatcherItem *)noticeItem_{
	[itemList addObject:noticeItem_];
	[self _startNotice];
}
-(CMMNoticeDispatcherItem *)addNoticeItemWithTitle:(NSString *)title_ subject:(NSString *)subject_{
	CMMNoticeDispatcherItem *noticeItem_ = [CMMNoticeDispatcher cachedNoticeItem];
	
	if(!noticeItem_)
		noticeItem_ = [CMMNoticeDispatcherItem noticeItemWithTitle:nil subject:nil];
	
	noticeItem_.title = title_;
	noticeItem_.subject = subject_;
	
	[self addNoticeItem:noticeItem_];
	return noticeItem_;
}

-(void)dealloc{
	[noticeTemplate release];
	[itemList release];
	[target release];
	[super dealloc];
}

@end
