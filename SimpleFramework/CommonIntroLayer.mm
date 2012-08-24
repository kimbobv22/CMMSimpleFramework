//  Created by JGroup(kimbobv22@gmail.com)

#import "CommonIntroLayer.h"
#import "HelloWorldLayer.h"

@implementation CommonIntroLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	labelDisplay = [CMMFontUtil labelWithstring:@" "];
	[self addChild:labelDisplay];
	[self _setDisplayStr:@"Loading..."];
	
	return self;
}

-(void)_setDisplayStr:(NSString *)str_{
	[labelDisplay setString:str_];
	labelDisplay.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
}

-(void)loadingProcess000{
	[[CCDirector sharedDirector] setAnimationInterval:1.0f/30.0f];
	[self _setDisplayStr:@"Loading sprite frame..."];
}
-(void)loadingProcess001{
	[CMMDrawingManager sharedManager];
}

-(void)loadingProcess002{
	[self _setDisplayStr:@"Initializing gyroscope..."];
}
-(void)loadingProcess003{
	[CMMMotionDispatcher sharedDispatcher];
}

-(void)loadingProcess004{
	[self _setDisplayStr:@"Initializing sound engine..."];
}
-(void)loadingProcess005{
	[CMMSoundEngine sharedEngine];
}

-(void)loadingProcess006{
	[self _setDisplayStr:@"loading complete!"];
}

-(void)whenLoadingEnded{
	[[CMMScene sharedScene] pushLayer:[HelloWorldLayer node]];
}

@end
