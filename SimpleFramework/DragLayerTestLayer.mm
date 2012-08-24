//  Created by JGroup(kimbobv22@gmail.com)

#import "DragLayerTestLayer.h"
#import "HelloWorldLayer.h"

@implementation DragLayerTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	dragLayer = [CMMLayerMaskDrag layerWithColor:ccc4(100, 0, 0, 120) width:250 height:250];
	dragLayer.isCanDragX = YES;
	dragLayer.isCanDragY = YES;
	dragLayer.innerSize = CGSizeMake(700, 700);
	dragLayer.position = ccp(180,50);
	//[dragLayer_ gotoTop]; //맨위로 갈때 사용하세요!
	[self addChild:dragLayer];
	
	//add sprite to dragLayer
	CGSize innerSize_ = dragLayer.innerSize;
	CCSprite *testSprite_ = [CCSprite spriteWithFile:@"Default.png"];
	testSprite_.position = ccp(innerSize_.width/2,innerSize_.height/2);
	[dragLayer addChild:testSprite_];
	
	//add menuitem to dragLayer
	CMMMenuItemLabelTTF *menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[menuItem_ setTitle:@"TESTBUTTON"];
	menuItem_.position = ccp(menuItem_.contentSize.width/2+20,menuItem_.contentSize.height/2+20);
	[dragLayer addChild:menuItem_];
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2+20);
	menuItemBack_.delegate = self;
	[self addChild:menuItemBack_];
	
	return self;
}

-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_{
	[[CMMScene sharedScene] pushLayer:[HelloWorldLayer node]];
}

@end
