//  Created by JGroup(kimbobv22@gmail.com)

#import "DragLayerTestLayer.h"
#import "HelloWorldLayer.h"

@implementation DragLayerTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CGSize winSize_ = [[CCDirector sharedDirector] winSize];
	
	dragLayer = [CMMLayerMD layerWithColor:ccc4(0, 0, 0, 120) width:winSize_.width*0.6f height:winSize_.height*0.7f];
	dragLayer.canDragX = YES;
	dragLayer.canDragY = YES;
	[[dragLayer innerLayer] setContentSize:CGSizeMake(winSize_.width*2.0f, winSize_.width*2.0f)];
	[[dragLayer innerLayer] setColor:ccc3(0, 100, 0)];
	[[dragLayer innerLayer] setOpacity:180];
	dragLayer.position = ccp(180,50);
	//[dragLayer_ gotoTop]; //use this method when you want to go top
	[self addChild:dragLayer];
	
	//add sprite to dragLayer
	CGSize innerSize_ = [[dragLayer innerLayer] contentSize];
	CCSprite *testSprite_ = [CCSprite spriteWithFile:@"Default.png"];
	testSprite_.position = ccp(innerSize_.width/2,innerSize_.height/2);
	[dragLayer addChildToInner:testSprite_];
	
	_slider = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:_contentSize.width*0.4f];
	[_slider setItemValueRange:CMMFloatRange(0.0f,0.9f)];
	[_slider setUnitValue:0.1f];
	[_slider setItemValue:[dragLayer scrollResistance]];
	[_slider setCallback_whenItemValueChanged:^(float itemValue_, float beforeItemValue_) {
		[dragLayer setScrollResistance:itemValue_];
	}];
	
	[_slider setPosition:cmmFunc_positionFON(dragLayer, _slider, ccp(0.0f,-1.0f), ccp(0.0f,-10.0f))];
	[self addChild:_slider];
	
	//add menuitem to dragLayer
	CMMMenuItemL *menuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem_ setTitle:@"TESTBUTTON"];
	menuItem_.position = ccp(menuItem_.contentSize.width/2+20,menuItem_.contentSize.height/2+20);
	[dragLayer addChildToInner:menuItem_];
	
	CMMMenuItemL *menuItemBack_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2+20);
	[menuItemBack_ setCallback_pushup:^(id item_) {
		[[CMMScene sharedScene] pushStaticLayerForKey:_HelloWorldLayer_key_];
	}];
	[self addChild:menuItemBack_];
	
	return self;
}

-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_{
	
}

@end
