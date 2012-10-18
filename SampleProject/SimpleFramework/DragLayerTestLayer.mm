//  Created by JGroup(kimbobv22@gmail.com)

#import "DragLayerTestLayer.h"
#import "HelloWorldLayer.h"

@implementation DragLayerTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	dragLayer = [CMMLayerMD layerWithColor:ccc4(100, 0, 0, 120) width:250 height:250];
	dragLayer.isCanDragX = YES;
	dragLayer.isCanDragY = YES;
	[[dragLayer innerLayer] setContentSize:CGSizeMake(700, 700)];
	[[dragLayer innerLayer] setColor:ccc3(0, 100, 0)];
	dragLayer.position = ccp(180,50);
	//[dragLayer_ gotoTop]; //use this method when you want to go top
	[self addChild:dragLayer];
	
	//add sprite to dragLayer
	CGSize innerSize_ = [[dragLayer innerLayer] contentSize];
	CCSprite *testSprite_ = [CCSprite spriteWithFile:@"Default.png"];
	testSprite_.position = ccp(innerSize_.width/2,innerSize_.height/2);
	[dragLayer addChildToInner:testSprite_];
	
	//add menuitem to dragLayer
	CMMMenuItemLabelTTF *menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"TESTBUTTON"];
	menuItem_.position = ccp(menuItem_.contentSize.width/2+20,menuItem_.contentSize.height/2+20);
	[dragLayer addChildToInner:menuItem_];
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2+20);
	menuItemBack_.delegate = self;
	[self addChild:menuItemBack_];
	
	return self;
}

-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_{
	[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
}

@end
