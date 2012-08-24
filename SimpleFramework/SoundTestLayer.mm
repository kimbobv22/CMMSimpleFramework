//  Created by JGroup(kimbobv22@gmail.com)

#import "SoundTestLayer.h"
#import "HelloWorldLayer.h"

@implementation SoundTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	listenSprite = [CMMSprite spriteWithFile:@"IMG_ICON_hdp.png"];
	listenSprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
	[self addChild:listenSprite];
	
	handler = [[CMMSoundHandler alloc] initSoundHandler:listenSprite.position soundDistance:400.0f panRate:0.3f];
	
	//add sound1
	soundSprite1 = [CMMSprite spriteWithFile:@"IMG_ICON_spk.png"];
	soundSprite1.position = ccp(soundSprite1.contentSize.width/2+20,self.contentSize.height/2);
	[self addChild:soundSprite1];

	CMMSoundHandlerItem *element_ = [handler addSoundItemFollow:@"SND_EFT_00001.caf" trackNode:soundSprite1];
	element_.isLoop = YES;
	element_.loopDelayTime = 1.0f;
	
	//add sound2
	soundSprite2 = [CMMSprite spriteWithFile:@"IMG_ICON_spk.png"];
	soundSprite2.position = ccp(self.contentSize.width-soundSprite2.contentSize.width/2-20,self.contentSize.height/2);
	[self addChild:soundSprite2];
	
	element_ = [handler addSoundItemFollow:@"SND_EFT_00002.caf" trackNode:soundSprite2];
	element_.isLoop = YES;
	element_.loopDelayTime = 0.5f;
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2+20);
	menuItemBack_.delegate = self;
	[self addChild:menuItemBack_];
	
	[self scheduleUpdate];
	
	return self;
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchMoved:touch_ event:event_];
	CMMTouchDispatcherItem *touchItem_ = [touchDispatcher touchItemAtTouch:touch_];
	
	if(![touchItem_.node isKindOfClass:[CMMMenuItem class]]){
		CGPoint curPoint_ = [self convertToNodeSpace:[CMMTouchUtil pointFromTouch:touch_]];
		curPoint_.y += 20;
		touchItem_.node.position = curPoint_;
	}
}

-(void)menuItem_whenPushup:(CMMMenuItem *)menuItem_{
	[[CMMScene sharedScene] pushLayer:[HelloWorldLayer node]];
}

-(void)update:(ccTime)dt_{
	handler.centerPoint = listenSprite.position;
	[handler update:dt_];
}


@end
