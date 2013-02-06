//  Created by JGroup(kimbobv22@gmail.com)

#import "MenuItemTestLayer.h"
#import "HelloWorldLayer.h"

@implementation MenuItemTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	menuItem1 = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem1 setCallback_pushup:^(id item_) {
		[displayLabel setString:@"button 1 push up"];
	}];
	[menuItem1 setCallback_pushdown:^(id item_) {
		[displayLabel setString:@"button 1 push down"];
	}];
	[menuItem1 setCallback_pushcancel:^(id item_) {
		[displayLabel setString:@"button 1 push cancel"];
	}];
	menuItem1.title = @"button 1";
	menuItem1.userData = @"first Button";
	menuItem1.position = ccp(self.contentSize.width/2-menuItem1.contentSize.width/2-10,self.contentSize.height/2);
	[self addChild:menuItem1];
	
	menuItem2 = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItem2 setSelectedImage:[CCSprite spriteWithFile:@"Icon.png"]];
	menuItem2.touchCancelDistance = 100.0f; // check this function
	menuItem2.title = @"button 2";
	menuItem2.userData = @"second Button";
	[menuItem2 setCallback_pushup:^(id item_) {
		[displayLabel setString:@"button 2 push up"];
	}];
	[menuItem2 setCallback_pushdown:^(id item_) {
		[displayLabel setString:@"button 2 push down"];
	}];
	[menuItem2 setCallback_pushcancel:^(id item_) {
		[displayLabel setString:@"button 2 push cancel"];
	}];
	menuItem2.position = ccp(self.contentSize.width/2+menuItem2.contentSize.width/2+10,self.contentSize.height/2);
	[self addChild:menuItem2];
	
	menuItem3 = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	menuItem3.title = @"disabled button";
	menuItem3.position = ccp(_contentSize.width/2,_contentSize.height/2+menuItem3.contentSize.height+10);
	[menuItem3 setEnable:NO];
	[self addChild:menuItem3];
	
	menuItemBack = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack setTitle:@"BACK"];
	menuItemBack.position = ccp(menuItemBack.contentSize.width/2+20,menuItemBack.contentSize.height/2+20);
	[menuItemBack setCallback_pushup:^(id item_) {
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	}];
	[self addChild:menuItemBack];
	
	displayLabel = [CMMFontUtil labelWithString:@" "];
	displayLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2-60);
	[self addChild:displayLabel];
	
	return self;
}

@end
