#import "HelloWorldLayer.h"

@implementation HelloWorldLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	//preload batch bar frame(just one time)
	[[CMMDrawingManager sharedManager] addDrawingItemWithFileName:@"barFrame000"];
	
	scrollMenu1 = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(contentSize_.width * 0.4f, contentSize_.height * 0.8f)];
	[scrollMenu1 setDelegate:self];
	[scrollMenu1 setPosition:ccpAdd(cmmFuncCommon_positionInParent(self, scrollMenu1), ccp(scrollMenu1.contentSize.width/2.0f+10.0f,0))];
	[self addChild:scrollMenu1];
	
	scrollMenu2 = [CMMScrollMenuV scrollMenuWithFrameSeq:0 batchBarSeq:1 frameSize:CGSizeMake(contentSize_.width * 0.4f, contentSize_.height * 0.8f)];
	[scrollMenu2 setDelegate:self];
	[scrollMenu2 setPosition:ccpSub(cmmFuncCommon_positionInParent(self, scrollMenu2), ccp(scrollMenu2.contentSize.width/2.0f+10.0f,0))];
	[self addChild:scrollMenu2];
	
	[self addMenuItem];
	
	return self;
}

-(BOOL)scrollMenu:(CMMScrollMenuV *)scrollMenu_ isCanDragItem:(CMMMenuItem *)item_{
	return YES;
}
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanSwitchItem:(CMMMenuItem *)item_ toIndex:(int)toIndex_{
	return YES;
}
-(BOOL)scrollMenu:(CMMScrollMenu *)scrollMenu_ isCanLinkSwitchItem:(CMMMenuItem *)item_ toScrollMenu:(CMMScrollMenu *)toScrollMenu_ toIndex:(int)toIndex_{
	return YES;
}

-(void)addMenuItem{
	++tempCount;
	
	CGSize menuItemSize_ = CGSizeMake(scrollMenu1.contentSize.width, 55);
	
	CMMMenuItemLabelTTF *menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:menuItemSize_];
	menuItem_.callback_pushup = ^(CMMMenuItem *menuItem_){
		[self addMenuItem];
	};
	[menuItem_ setTitle:[NSString stringWithFormat:@"Hello world :) [%d]",tempCount]];
 	[scrollMenu1 addItem:menuItem_];
}

-(void)applicationDidBecomeActive{
	CCLOG(@"HelloWorldLayer : applicationDidBecomeActive");
}
-(void)applicationWillResignActive{
	CCLOG(@"HelloWorldLayer : applicationWillResignActive");
}
-(void)applicationWillTerminate{
	CCLOG(@"HelloWorldLayer : applicationWillTerminate");
}
-(void)applicationDidEnterBackground{
	CCLOG(@"HelloWorldLayer : applicationDidEnterBackground");
}
-(void)applicationWillEnterForeground{
	CCLOG(@"HelloWorldLayer : applicationWillEnterForeground");
}
-(void)applicationDidReceiveMemoryWarning{
	CCLOG(@"HelloWorldLayer : applicationDidReceiveMemoryWarning");
}

@end