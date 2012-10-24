//  Created by JGroup(kimbobv22@gmail.com)

#import "LoadingTestLayer.h"
#import "HelloWorldLayer.h"

@implementation LoadingTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	menuItemBack = [[CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0] retain];
	[menuItemBack setTitle:@"BACK"];
	menuItemBack.position = ccp(menuItemBack.contentSize.width/2+20,menuItemBack.contentSize.height/2+20);
	menuItemBack.delegate = self;
	
	displayLabel = [CMMFontUtil labelWithstring:@" "];
	displayLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
	[self addChild:displayLabel];
	
	return self;
}

-(void)sceneLoadingProcess000{
	[displayLabel setString:@"000"];
}
-(void)sceneLoadingProcess001{
	[displayLabel setString:@"001"];
}
-(void)sceneLoadingProcess002{
	[displayLabel setString:@"002"];
}
-(void)sceneLoadingProcess003{
	[displayLabel setString:@"003"];
}
-(void)sceneLoadingProcess004{
	[displayLabel setString:@"004"];
}
-(void)sceneLoadingProcess005{
	[displayLabel setString:@"005"];
}
-(void)sceneLoadingProcess006{
	[displayLabel setString:@"006"];
}
-(void)sceneLoadingProcess007{
	[displayLabel setString:@"007"];
}

-(void)sceneDidEndLoading:(CMMScene *)scene_{
	[displayLabel setString:@"completed"];
	[self addChild:menuItemBack];
}

-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_{
	[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
}

-(void)dealloc{
	[menuItemBack release];
	[super dealloc];
}

@end
