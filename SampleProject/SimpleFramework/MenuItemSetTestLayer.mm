//  Created by JGroup(kimbobv22@gmail.com)

#import "MenuItemSetTestLayer.h"
#import "HelloWorldLayer.h"

@interface MenuItemSetTestLayer(Privated)

-(void)setAlignType:(CMMMenuItemSetAlignType)alignType_;
-(void)setLineHAlignType:(CMMMenuItemSetLineHAlignType)lineHAlignType_;
-(void)setLineVAlignType:(CMMMenuItemSetLineVAlignType)lineVAlignType_;

@end

@implementation MenuItemSetTestLayer(Privated)

-(void)setAlignType:(CMMMenuItemSetAlignType)alignType_{
	switch(alignType_){
		case CMMMenuItemSetAlignType_horizontal:
			[alignTypeChangeBtn setTitle:@"horizontal"];
			break;
		case CMMMenuItemSetAlignType_vertical:
			[alignTypeChangeBtn setTitle:@"vertical"];
			break;
		default: break;
	}
	[menuItemSet setAlignType:alignType_];
	[menuItemSet updateDisplay];
}

-(void)setLineHAlignType:(CMMMenuItemSetLineHAlignType)lineHAlignType_{
	[menuItemSet setLineHAlignType:lineHAlignType_];
	[menuItemSet updateDisplay];
}
-(void)setLineVAlignType:(CMMMenuItemSetLineVAlignType)lineVAlignType_{
	[menuItemSet setLineVAlignType:lineVAlignType_];
	[menuItemSet updateDisplay];
}

@end

@implementation MenuItemSetTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	menuItemSet = [CMMMenuItemSet menuItemSetWithMenuSize:CGSizeMake(contentSize_.width*0.7f, contentSize_.height*0.7f)];

	//menuItemSet = [CMMMenuItemSet menuItemSetWithMenuSize:CGSizeMake(contentSize_.width*0.7f, contentSize_.height*0.7f) menuItem:[CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(50, 50)],[CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(50, 50)],[CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(50, 50)],[CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(50, 50)],[CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(50, 50)], nil];
	/*[menuItemSet setCallback_pushdown:^(id sender_, CMMMenuItem *menuItem_){
		[self menuItemSet:menuItemSet whenMenuItemPushdownWithMenuItem:menuItem_];
	}];
	[menuItemSet setCallback_pushup:^(id sender_, CMMMenuItem *menuItem_){
		[self menuItemSet:menuItemSet whenMenuItemPushupWithMenuItem:menuItem_];
	}];*/
	[menuItemSet setDelegate:self];
	[menuItemSet setLineHAlignType:CMMMenuItemSetLineHAlignType_middle];
	[menuItemSet setPosition:ccpAdd(cmmFuncCommon_positionInParent(self, menuItemSet), ccp(0,20.0f))];
	[self addChild:menuItemSet];
	
	for(uint index_=0;index_<15;++index_){
		CMMMenuItemLabelTTF *tempItem_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(50, 50)];
		[tempItem_ setTitle:[NSString stringWithFormat:@"%d",index_+1]];
		[menuItemSet addMenuItem:tempItem_];
	}
	
	CMMControlItemSlider *controlItem_ = [CMMControlItemSlider controlItemSliderWithFrameSeq:0 width:150];
	[controlItem_ setMinValue:1.0f];
	[controlItem_ setMaxValue:10.0f];
	[controlItem_ setUnitValue:1.0f];
	[controlItem_ setPosition:ccp(contentSize_.width-controlItem_.contentSize.width,10)];
	[controlItem_ setCallback_whenChangedItemVale:^(id sender_, float curValue_, float beforeValue_) {
		[menuItemSet setUnitPerLine:(uint)curValue_];
		[menuItemSet updateDisplay];
	}];
	[self addChild:controlItem_];
	[controlItem_ setItemValue:5.0f];
	
	alignTypeChangeBtn = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(100, 30)];
	[alignTypeChangeBtn setTitle:@" "];
	[alignTypeChangeBtn setPosition:ccp(controlItem_.position.x-alignTypeChangeBtn.contentSize.width/2.0f-10,controlItem_.position.y+controlItem_.contentSize.height/2.0f)];
	[alignTypeChangeBtn setCallback_pushup:^(id sender_){
		if([menuItemSet alignType] == CMMMenuItemSetAlignType_vertical){
			[self setAlignType:CMMMenuItemSetAlignType_horizontal];
		}else{
			[self setAlignType:CMMMenuItemSetAlignType_vertical];
		}
	}];
	[self addChild:alignTypeChangeBtn];
	[self setAlignType:CMMMenuItemSetAlignType_vertical];
	
	lineHAlignTypeChangeBtn = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(30, 30)];
	[lineHAlignTypeChangeBtn setTitle:@"H"];
	[lineHAlignTypeChangeBtn setPosition:ccp(contentSize_.width-lineHAlignTypeChangeBtn.contentSize.width/2.0f,contentSize_.height/2.0f)];
	[lineHAlignTypeChangeBtn setCallback_pushup:^(id sender_){
		if([menuItemSet lineHAlignType] != CMMMenuItemSetLineHAlignType_bottom){
			[self setLineHAlignType:(CMMMenuItemSetLineHAlignType)([menuItemSet lineHAlignType]+1)];
		}else{
			[self setLineHAlignType:CMMMenuItemSetLineHAlignType_top];
		}
	}];
	[self addChild:lineHAlignTypeChangeBtn];
	
	lineVAlignTypeChangeBtn = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0 frameSize:CGSizeMake(30, 30)];
	[lineVAlignTypeChangeBtn setTitle:@"V"];
	[lineVAlignTypeChangeBtn setPosition:ccp(lineHAlignTypeChangeBtn.position.x,lineHAlignTypeChangeBtn.position.y-50.0f)];
	[lineVAlignTypeChangeBtn setCallback_pushup:^(id sender_){
		if([menuItemSet lineVAlignType] != CMMMenuItemSetLineVAlignType_right){
			[self setLineVAlignType:(CMMMenuItemSetLineVAlignType)([menuItemSet lineVAlignType]+1)];
		}else{
			[self setLineVAlignType:CMMMenuItemSetLineVAlignType_left];
		}
	}];
	[self addChild:lineVAlignTypeChangeBtn];
	
	CMMMenuItemLabelTTF *menuItemButton_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemButton_ setTitle:@"BACK"];
	menuItemButton_.position = ccp(menuItemButton_.contentSize.width/2,menuItemButton_.contentSize.height/2);
	menuItemButton_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemButton_];
	
	return self;
}

-(void)menuItemSet:(CMMMenuItemSet *)menuItemSet_ whenMenuItemPushdownWithMenuItem:(CMMMenuItem *)menuItem_{
	CCLOG(@"whenMenuItemPushdownWithMenuItem -> %d",[menuItemSet indexOfMenuItem:menuItem_]);
}
-(void)menuItemSet:(CMMMenuItemSet *)menuItemSet_ whenMenuItemPushupWithMenuItem:(CMMMenuItem *)menuItem_{
	CCLOG(@"whenMenuItemPushupWithMenuItem -> %d",[menuItemSet indexOfMenuItem:menuItem_]);
}

@end
