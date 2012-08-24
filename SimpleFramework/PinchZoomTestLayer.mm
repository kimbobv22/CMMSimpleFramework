//  Created by JGroup(kimbobv22@gmail.com)

#import "PinchZoomTestLayer.h"
#import "HelloWorldLayer.h"

@implementation PinchZoomTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	pinchZoomLayer = [CMMLayerPinchZoom layerWithColor:ccc4(100, 0, 0, 120) width:250 height:250];
	pinchZoomLayer.position = ccp(180,50);
	[self addChild:pinchZoomLayer];
	
	//add menuitem to dragLayer
	CMMMenuItemLabelTTF *menuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[menuItem_ setTitle:@"TESTBUTTON"];
	menuItem_.position = ccp(menuItem_.contentSize.width/2+20,menuItem_.contentSize.height/2+20);
	[pinchZoomLayer addChild:menuItem_];
	
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
