//  Created by JGroup(kimbobv22@gmail.com)

#import "NoticeTestLayer.h"
#import "HelloWorldLayer.h"

@implementation NoticeTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemLabelTTF *tempButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[tempButton_ setTitle:@"BACK"];
	tempButton_.position = ccp(tempButton_.contentSize.width/2+20,tempButton_.contentSize.height/2);
	tempButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[HelloWorldLayer node]];
	};
	[self addChild:tempButton_];
	
	CCLabelTTF *tempLabel_ = [CMMFontUtil labelWithstring:@"change template to push the button"];
	CGPoint tempPoint_ = cmmFuncCommon_position_center(self, tempLabel_);
	tempPoint_.y += 100;
	tempLabel_.position = tempPoint_;
	[self addChild:tempLabel_];
	
	tempButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	tempButton_.position = cmmFuncCommon_position_center(self, tempButton_);
	[tempButton_ setTitle:@"Scale"];
	tempButton_.callback_pushup = ^(CMMMenuItem *menuItem_){
		[[CMMScene sharedScene] noticeDispatcher].noticeTemplate = [CMMNoticeDispatcherTemplate_DefaultScale templateWithNoticeDispatcher:[[CMMScene sharedScene] noticeDispatcher]];
	};
	[self addChild:tempButton_];
	
	tempButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	tempPoint_ = cmmFuncCommon_position_center(self, tempButton_);
	tempPoint_.x -= tempButton_.contentSize.width+10;
	tempButton_.position = tempPoint_;
	[tempButton_ setTitle:@"MoveDown"];
	tempButton_.callback_pushup = ^(CMMMenuItem *menuItem_){
		[[CMMScene sharedScene] noticeDispatcher].noticeTemplate = [CMMNoticeDispatcherTemplate_DefaultMoveDown templateWithNoticeDispatcher:[[CMMScene sharedScene] noticeDispatcher]];
	};
	[self addChild:tempButton_];
	
	tempButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	tempPoint_ = cmmFuncCommon_position_center(self, tempButton_);
	tempPoint_.x += tempButton_.contentSize.width+10;
	tempButton_.position = tempPoint_;
	[tempButton_ setTitle:@"FadeInOut"];
	tempButton_.callback_pushup = ^(CMMMenuItem *menuItem_){
		[[CMMScene sharedScene] noticeDispatcher].noticeTemplate = [CMMNoticeDispatcherTemplate_DefaultFadeInOut templateWithNoticeDispatcher:[[CMMScene sharedScene] noticeDispatcher]];
	};
	[self addChild:tempButton_];
	
	tempButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[tempButton_ setTitle:@"do Notice!"];
	tempButton_.callback_pushup = ^(CMMMenuItem *menuItem_){
		[[[CMMScene sharedScene] noticeDispatcher] addNoticeItemWithTitle:@"Hello world :)" subject:@"Welcome to CMMSimpleFramework!"];
	};
	tempPoint_ = cmmFuncCommon_position_center(self, tempLabel_);
	tempPoint_.y -= 70;
	tempButton_.position = tempPoint_;
	[self addChild:tempButton_];
	
	return self;
}


@end
