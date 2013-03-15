//  Created by JGroup(kimbobv22@gmail.com)

#import "TransitionTestLayer.h"
#import "HelloWorldLayer.h"

@implementation TestTransitionLayer_door

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	door1 = [CCLayerGradient layerWithColor:ccc4(100,0,0,255) fadingTo:ccc4(200,0,0,255)];
	door2 = [CCLayerGradient layerWithColor:ccc4(0,100,0,255) fadingTo:ccc4(0,100,0,255)];
	
	[self addChild:door1];
	[self addChild:door2];
	
	return self;
}

-(void)setContentSize:(CGSize)contentSize{
	[super setContentSize:contentSize];
	CGSize halfSize_ = CGSizeMake(contentSize.width*0.5f, contentSize.height);
	[door1 setContentSize:halfSize_];
	[door2 setContentSize:halfSize_];
}

-(void)scene:(CMMScene *)scene_ didStartTransitionWithCallbackAction:(CCCallFunc *)callbackAction_{
	[door1 stopAllActions];
	[door2 stopAllActions];
	
	[door1 setPosition:ccp(-_contentSize.width*0.5f,0)];
	[door2 setPosition:ccp(_contentSize.width,0)];
	
	[door1 runAction:[CCMoveTo actionWithDuration:0.2f position:ccp(0,0)]];
	[door2 runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.2f position:ccp(_contentSize.width*0.5f,0)],[CCDelayTime actionWithDuration:0.2f],callbackAction_,nil]];	
}
-(void)scene:(CMMScene *)scene_ didEndTransitionWithCallbackAction:(CCCallFunc *)callbackAction_{
	[door1 stopAllActions];
	[door2 stopAllActions];
	
	[door1 runAction:[CCMoveTo actionWithDuration:0.2f position:ccp(-_contentSize.width*0.5f,0)]];
	[door2 runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.2f position:ccp(_contentSize.width,0)],callbackAction_,nil]];
}

@end

@implementation TransitionTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemL *menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"BACK"];
	[menuItemBtn_ setCallback_pushup:^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerForKey:_HelloWorldLayer_key_];
	}];
	menuItemBtn_.position = ccp(menuItemBtn_.contentSize.width/2,menuItemBtn_.contentSize.height/2);
	[self addChild:menuItemBtn_];
	
	menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"Default Transition"];
	[menuItemBtn_ setCallback_pushup:^(id sender_){
		[[CMMScene sharedScene] setTransitionLayer:[CMMSceneTransitionLayer_FadeInOut node]];
	}];
	menuItemBtn_.position = ccp(_contentSize.width/2.0f-menuItemBtn_.contentSize.width/2-10,_contentSize.height/2);
	[self addChild:menuItemBtn_];
	
	menuItemBtn_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBtn_ setTitle:@"Door Transition"];
	[menuItemBtn_ setCallback_pushup:^(id sender_){
		[[CMMScene sharedScene] setTransitionLayer:[TestTransitionLayer_door node]];
	}];
	menuItemBtn_.position = ccp(_contentSize.width/2.0f+menuItemBtn_.contentSize.width/2+10,_contentSize.height/2);
	[self addChild:menuItemBtn_];
	
	return self;
}

@end
