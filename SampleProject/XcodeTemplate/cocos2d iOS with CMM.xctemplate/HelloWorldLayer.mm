#import "HelloWorldLayer.h"

@implementation HelloWorldLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	//preload batch bar frame(just one time)
	[[CMMDrawingManager sharedManager] addDrawingItemWithFileName:@"barFrame000"];
	
	scorllMenu = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(contentSize_.width * 0.5f, contentSize_.height * 0.8f)];
	scorllMenu.position = cmmFuncCommon_position_center(self, scorllMenu);
	[self addChild:scorllMenu];
	
	[self addMenuItem];
	
	return self;
}

-(void)addMenuItem{
	CGSize menuItemSize_ = CGSizeMake(scorllMenu.contentSize.width, 55);
	
	CMMMenuItemLabelTTF *menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){
		[self addMenuItem];
	};
	[menuItem_ setTitle:@"Hello world :)"];
 	[scorllMenu addItem:menuItem_];
}

@end