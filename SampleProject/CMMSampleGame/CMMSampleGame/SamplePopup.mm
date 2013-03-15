//
//  SamplePopup.mm
//  CMMSampleGame
//
//  Created by Kim Jazz on 13. 3. 15..
//  Copyright (c) 2013년 Kim Jazz. All rights reserved.
//

#import "SamplePopup.h"

@implementation  SamplePopupLoading

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CCLabelTTF *label_ = [CMMFontUtil labelWithString:@"Loading..."];
	[label_ setPosition:cmmFunc_positionIPN(self, label_)];
	[self addChild:label_];
	
	return self;
}

@end

@implementation SamplePopupNotice
@synthesize notice;

+(id)noticeWithNotice:(NSString *)notice_{
	return [[[self alloc] initWithNotice:notice_] autorelease];
}
-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	_labelNotice = [CMMFontUtil labelWithString:@"Loading..."];
	[_labelNotice setPosition:cmmFunc_positionIPN(self, _labelNotice)];
	
	_btnClose = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[_btnClose setTitle:@"Close"];
	[_btnClose setCallback_pushup:^(id item_) {
		[self close];
	}];
	[_btnClose setPosition:cmmFunc_positionIPN(self, _btnClose,ccp(0.8f,0.1f))];
	
	[self addChild:_labelNotice];
	[self addChild:_btnClose];
	
	return self;
}
-(id)initWithNotice:(NSString *)notice_{
	if(!(self = [self init])) return self;
	
	[self setNotice:notice_];
	
	return self;
}

-(void)setNotice:(NSString *)notice_{
	[_labelNotice setString:notice_];
}
-(NSString *)notice{
	return [_labelNotice string];
}

@end
