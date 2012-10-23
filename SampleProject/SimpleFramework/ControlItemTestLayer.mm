//  Created by JGroup(kimbobv22@gmail.com)

#import "ControlItemTestLayer.h"
#import "HelloWorldLayer.h"

@implementation ControlItemTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMControlItemText *testTextItem_ = [CMMControlItemText controlItemTextWithFrameSeq:0 width:150];
	testTextItem_.itemValue = @"test";
	testTextItem_.itemTitle = @"Test Label";
	testTextItem_.callback_whenChangedItemVale = ^(id sender_, NSString *itemValue_){
		CCLOG(@"test value : %@",itemValue_);
	};
	testTextItem_.position = cmmFuncCommon_positionInParent(self, testTextItem_,ccp(0.5f,0.8f));
	[self addChild:testTextItem_];
	
	CMMControlItemSwitch *testSwitchItem_ = [CMMControlItemSwitch controlItemSwitchWithFrameSeq:0];
	testSwitchItem_.position = ccp(self.contentSize.width/2-testSwitchItem_.contentSize.width-10,self.contentSize.height/2+30);
	testSwitchItem_.callback_whenChangedItemVale = ^(id sender_, BOOL itemValue_){
		[self controlItemSwitch:sender_ whenChangedItemValue:itemValue_];
	};
	[self addChild:testSwitchItem_];
	
	testSwitchItem_ = [CMMControlItemSwitch controlItemSwitchWithFrameSeq:0];
	[testSwitchItem_ setButtonSprite:[CCSprite spriteWithFile:@"Icon-Small.png"]];
	testSwitchItem_.position = ccp(self.contentSize.width/2+10,self.contentSize.height/2+30);
	testSwitchItem_.delegate = self;
	[self addChild:testSwitchItem_];
	
	CMMControlItemSlider *testSliderItem_ = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	testSliderItem_.minValue = -10.0f;
	testSliderItem_.maxValue = 10.0f;
	testSliderItem_.itemValue = 1.0f;
	testSliderItem_.position = ccp(self.contentSize.width/2-testSliderItem_.contentSize.width-10,testSwitchItem_.position.y-testSwitchItem_.contentSize.height-testSliderItem_.contentSize.height);
	testSliderItem_.delegate = self;
	[self addChild:testSliderItem_];
	
	slider2 = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	[slider2 setButtonSprite:[CCSprite spriteWithFile:@"Icon-Small.png"]];
	slider2.minValue = -10.0f;
	slider2.maxValue = 10.0f;
	slider2.itemValue = 1.0f;
	slider2.position = ccp(self.contentSize.width/2+10,testSwitchItem_.position.y-testSwitchItem_.contentSize.height-slider2.contentSize.height);
	slider2.callback_whenChangedItemVale = ^(id sender_, float itemValue_, float beforeItemValue_){
		[self controlItemSlider:sender_ whenChangedItemValue:itemValue_ beforeItemValue:beforeItemValue_];
	};
	[self addChild:slider2];
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	menuItemBack_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBack_];
	
	CMMMenuItemLabelTTF *testMenuItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[testMenuItem_ setTitle:@"Batch bar test"];
	testMenuItem_.position = ccp(self.contentSize.width-testMenuItem_.contentSize.width/2,testMenuItem_.contentSize.height/2);
	testMenuItem_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[ControlItemTestLayer2 node]];
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

@implementation ControlItemTestLayer2

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	[touchDispatcher setMaxMultiTouchCount:0];
	
	CMMDrawingManagerItem *drawingItem_ = [[CMMDrawingManager sharedManager] drawingItemAtIndex:0];
	batchBar = [CMMSpriteBatchBar batchBarWithTargetSprite:[CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_text_bar]] batchBarSize:CGSizeMake(100, 40)];
	[batchBar setPosition:ccp(10,80)];
	[self addChild:batchBar];
	
	label = [CMMFontUtil labelWithstring:@"Drag me!"];
	[label runAction:[CCRepeatForever actionWithAction:[CCBlink actionWithDuration:1 blinks:2]]];
	[self addChild:label];
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	menuItemBack_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[ControlItemTestLayer node]];
	};
	[self addChild:menuItemBack_];
	
	[self scheduleUpdate];
	
	return self;
}

-(void)update:(ccTime)dt_{
	CGPoint batchBarPoint_ = [batchBar position];
	CGSize targetSize_ = [batchBar contentSize];
	[batchBar setContentSize:targetSize_];
	
	batchBarPoint_.x += targetSize_.width - [label contentSize].width/2.0f;
	batchBarPoint_.y += targetSize_.height + [label contentSize].height/2.0f;
	[label setPosition:batchBarPoint_];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtIndex:0];
	
	if(touchItem_){
		CGPoint batchBarPoint_ = [batchBar position];
		CGPoint touchPoint_ = [CMMTouchUtil pointFromTouch:touch_ targetNode:self];
		CGPoint diffPoint_ = ccpSub(touchPoint_, batchBarPoint_);
		
		if(diffPoint_.x < 100)
			diffPoint_.x = 100;
		if(diffPoint_.y < 40)
			diffPoint_.y = 40;
		
		CGSize targetSize_ = CGSizeFromccp(diffPoint_);
		[batchBar setContentSize:targetSize_];
	}
}

@end
