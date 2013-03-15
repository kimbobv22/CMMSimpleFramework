#import "HelloWorldLayer.h"
#import "SampleGameLayer.h"

@implementation HelloWorldLayer{
	CMMSequencer *_loadingSequencer;
}

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;

	SamplePopupLoading *loadingLayer_ = [SamplePopupLoading node];
	[[CMMScene sharedScene] openPopupAtFirst:loadingLayer_];
	
	_loadingSequencer = [[CMMSequencer alloc] init];
	
	[_loadingSequencer addSequenceForBackgroundQueue:^{
		[[CMMDrawingManager sharedManager] addDrawingItemWithFileName:@"barFrame000"];
	} callback:^{
		[_loadingSequencer callSequence];
	}];
	
	[_loadingSequencer addSequenceForMainQueue:^{
		[[CMMScene sharedScene] setStaticLayer:[SampleStaticMenu node] forKey:varSampleStaticMenu_staticKey];
	} callback:^{
		[loadingLayer_ close];
		[[CMMScene sharedScene] pushStaticLayerForKey:varSampleStaticMenu_staticKey];
	}];

	return self;
}
-(void)sceneDidEndTransition:(CMMScene *)scene_{
	[_loadingSequencer callSequence];
}

-(void)dealloc{
	[_loadingSequencer release];
	[super dealloc];
}

@end

@implementation SampleStaticMenu

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	_btnStart = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[_btnStart setTitle:@"Start"];
	[_btnStart setCallback_pushup:^(id item_) {
		[[CMMScene sharedScene] pushLayer:[SampleGameLayer gameLayer]];
	}];
	[_btnStart setPosition:cmmFunc_positionIPN(self, _btnStart)];
	[self addChild:_btnStart];
	
	return self;
}

@end