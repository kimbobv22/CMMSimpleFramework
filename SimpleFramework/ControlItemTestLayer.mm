//  Created by JGroup(kimbobv22@gmail.com)

#import "ControlItemTestLayer.h"
#import "HelloWorldLayer.h"

@implementation ControlItemTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMControlItemText *testTextItem_ = [CMMControlItemText controlItemTextWithFrameSeq:0 width:150];
	testTextItem_.itemValue = @"test";
	testTextItem_.callback_whenChangedItemVale = ^(id sender_, NSString *itemValue_){
		CCLOG(@"test value : %@",itemValue_);
	};
	testTextItem_.position = ccp(self.contentSize.width/2-testTextItem_.contentSize.width/2,240.0f);
	[self addChild:testTextItem_];
	
	CMMControlItemSwitch *testSwitchItem_ = [CMMControlItemSwitch controlItemSwitchWithFrameSeq:0];
	testSwitchItem_.position = ccp(self.contentSize.width/2-testSwitchItem_.contentSize.width-10,self.contentSize.height/2+30);
	testSwitchItem_.callback_whenChangedItemVale = ^(id sender_, BOOL itemValue_){
		[self controlItemSwitch:sender_ whenChangedItemValue:itemValue_];
	};
	//testSwitchItem_.isEnable = NO;
	[self addChild:testSwitchItem_];
	
	testSwitchItem_ = [CMMControlItemSwitch controlItemSwitchWithFrameSeq:0];
	testSwitchItem_.position = ccp(self.contentSize.width/2+10,self.contentSize.height/2+30);
	testSwitchItem_.delegate = self;
	[self addChild:testSwitchItem_];
	
	CMMControlItemSlider *testSliderItem_ = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	testSliderItem_.minValue = -8.0f;
	testSliderItem_.itemValue = 1.0f;
	testSliderItem_.position = ccp(self.contentSize.width/2-testSliderItem_.contentSize.width-10,testSwitchItem_.position.y-testSwitchItem_.contentSize.height-testSliderItem_.contentSize.height);
	testSliderItem_.delegate = self;
	[self addChild:testSliderItem_];
	
	slider2 = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	slider2.minValue = -8.0f;
	slider2.itemValue = 1.0f;
	slider2.position = ccp(self.contentSize.width/2+10,testSwitchItem_.position.y-testSwitchItem_.contentSize.height-slider2.contentSize.height);
	slider2.callback_whenChangedItemVale = ^(id sender_, float itemValue_, float beforeItemValue_){
		[self controlItemSlider:sender_ whenChangedItemValue:itemValue_ beforeItemValue:beforeItemValue_];
	};
	[self addChild:slider2];
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	menuItemBack_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[HelloWorldLayer node]];
	};
	[self addChild:menuItemBack_];
	
	CMMMenuItemLabelTTF *testMenuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[testMenuItem_ setTitle:@"CHNAGE!"];
	testMenuItem_.position = ccp(self.contentSize.width-testMenuItem_.contentSize.width/2,testMenuItem_.contentSize.height/2);
	testMenuItem_.callback_pushup = ^(id sender_){
		slider2.contentSize = CGSizeMake((arc4random()%50)+100.0f, slider2.contentSize.height);
	};
	[self addChild:testMenuItem_];
	
	return self;
}

-(void)controlItemSwitch:(CMMControlItemSwitch *)controlItem_ whenChangedItemValue:(BOOL)itemValue_{
	CCLOG(@"test value : %d",itemValue_);
}

-(void)controlItemSlider:(CMMControlItemSlider *)controlItem_ whenChangedItemValue:(float)itemValue_ beforeItemValue:(float)beforeItemValue_{
	CCLOG(@"test value : %1.1f -> %1.1f",beforeItemValue_,itemValue_);
}

@end
