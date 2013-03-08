//  Created by JGroup(kimbobv22@gmail.com)

#import "ControlItemTestLayer.h"
#import "HelloWorldLayer.h"

@implementation ControlItemTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	textField1 = [CMMControlItemText controlItemTextWithFrameSeq:0 width:150];
	[textField1 setPlaceHolder:@"Test text field!"];
	[textField1 setTitle:@"Test Label"];
	[textField1 setCallback_whenItemValueChanged:^(NSString *itemValue_) {
		CCLOG(@"textField1 : %@",itemValue_);
	}];
	[textField1 setCallback_whenKeypadShown:^{
		CCLOG(@"textField1 : whenKeypadShown");
	}];
	[textField1 setCallback_whenKeypadHidden:^{
		CCLOG(@"textField1 : whenKeypadHidden");
	}];
	[textField1 setCallback_whenReturnKeyEntered:^{
		CCLOG(@"textField1 : whenReturnKeyEntered");
	}];
	[textField1 setPosition:cmmFunc_positionIPN(self, textField1,ccp(0.5f,1.0f),ccp(-[textField1 contentSize].width/2.0f-10.0f,-[textField1 contentSize].height-10.0f))];
	[self addChild:textField1];
	
	textField2 = [CMMControlItemText controlItemTextWithFrameSeq:0 width:150];
	[textField2 setPasswordForm:YES];
	//[textField2 setKeyboardType:UIKeyboardTypeNumberPad];
	[textField2 setPlaceHolder:@"Test text field!"];
	[textField2 setTitle:@"Test Label"];
	[textField2 setCallback_whenItemValueChanged:^(NSString *itemValue_) {
		CCLOG(@"textField2 : %@",itemValue_);
	}];
	[textField2 setPosition:cmmFunc_positionFON(textField1, textField2, ccp(1.0f,0.0f),ccp(20.0f,0.0f))];
	[self addChild:textField2];
	
	switch1 = [CMMControlItemSwitch controlItemSwitchWithFrameSeq:0];
	[switch1 setPosition:cmmFunc_positionFON(textField1, switch1, ccp(0.0f,-1.0f),ccp(0.0f,-20.0f))];
	[switch1 setCallback_whenItemValueChanged:^(BOOL itemValue_) {
		CCLOG(@"switch1 : %d",itemValue_);
	}];
	[self addChild:switch1];
	
	switch2 = [CMMControlItemSwitch controlItemSwitchWithFrameSeq:0];
	[switch2 setButtonSprite:[CCSprite spriteWithFile:@"Icon-Small.png"]];
	[switch2 setPosition:cmmFunc_positionFON(switch1, switch2, ccp(1.0f,0.0f),ccp(20.0f,0.0f))];
	[switch2 setCallback_whenItemValueChanged:^(BOOL itemValue_) {
		CCLOG(@"switch2 : %d",itemValue_);
	}];
	[self addChild:switch2];
	
	slider1 = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	[slider1 setMinValue:-10.0f];
	[slider1 setMaxValue:10.0f];
	[slider1  setItemValue:1.0f];
	[slider1 setPosition:cmmFunc_positionFON(switch1, slider1, ccp(0.0f,-1.0f),ccp(0.0f,-20.0f))];
	[slider1 setCallback_whenItemValueChanged:^(float itemValue_, float beforeItemValue_) {
		CCLOG(@"slider1 : %1.1f -> %1.1f",beforeItemValue_,itemValue_);
	}];
	[self addChild:slider1];
	
	slider2 = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	[slider2 setButtonSprite:[CCSprite spriteWithFile:@"Icon-Small.png"]];
	[slider2 setMinValue:-10.0f];
	[slider2 setMaxValue:10.0f];
	[slider2  setItemValue:1.0f];
	[slider2 setPosition:cmmFunc_positionFON(slider1, slider2, ccp(1.0f,0.0f),ccp(20.0f,0.0f))];
	[slider2 setCallback_whenItemValueChanged:^(float itemValue_, float beforeItemValue_) {
		CCLOG(@"slider2 : %1.1f -> %1.1f",beforeItemValue_,itemValue_);
	}];
	[self addChild:slider2];
	
	checkBox = [CMMControlItemCheckbox controlItemCheckboxWithFrameSeq:0];
	[checkBox setCallback_whenChanged:^(BOOL isChecked_) {
		CCLOG(@"checkBox : %d",isChecked_);
	}];
	[checkBox setPosition:cmmFunc_positionFON(switch2, checkBox, ccp(1.0f,0.0f),ccp(10.0f,0.0f))];
	[self addChild:checkBox];
	
	CMMMenuItemL *menuItemBack_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	menuItemBack_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBack_];
	
	CMMMenuItemL *testMenuItem_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[testMenuItem_ setTitle:@"Batch bar test"];
	testMenuItem_.position = ccp(self.contentSize.width-testMenuItem_.contentSize.width/2,testMenuItem_.contentSize.height/2);
	testMenuItem_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[ControlItemTestLayer2 node]];
	};
	[self addChild:testMenuItem_];
	
	return self;
}

@end

@implementation TestSliceBar

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{}

@end

@implementation ControlItemTestLayer2

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	[touchDispatcher setMaxMultiTouchCount:0];
	
	CMMDrawingManagerItem *drawingItem_ = [[CMMDrawingManager sharedManager] drawingItemAtIndex:0];
	batchBar = [TestSliceBar sliceBarWithTargetSprite:[CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_text_bar]]];
	[batchBar setContentSize:CGSizeMake(100, 40)];
	[batchBar setPosition:ccp(10,80)];
	[self addChild:batchBar];
	
	label = [CMMFontUtil labelWithString:@"Drag me!"];
	[label runAction:[CCRepeatForever actionWithAction:[CCBlink actionWithDuration:1 blinks:2]]];
	[self addChild:label];
	
	CMMMenuItemL *menuItemBack_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
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
