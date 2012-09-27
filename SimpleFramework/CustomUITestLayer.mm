//  Created by JGroup(kimbobv22@gmail.com)

#import "CustomUITestLayer.h"
#import "HelloWorldLayer.h"

@implementation CustomUITestObject
@synthesize accelVector;

-(void)update:(ccTime)dt_{
	self.position = ccpAdd(self.position, ccpMult(accelVector, 6.0f));
}

@end

@implementation CustomUITestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	target = [CustomUITestObject spriteWithFile:@"Icon-Small.png"];
	target.position = cmmFuncCommon_position_center(self, target);
	[self addChild:target z:0];
	
	NSString *joypadSpriteFrameFileName_ = @"IMG_JOYPAD_000.plist";
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:joypadSpriteFrameFileName_];
	joypad = [CMMCustomUIJoypad joypadWithSpriteFrameFileName:joypadSpriteFrameFileName_];
	joypad.opacity = 120.0f;
	joypad.buttonA.isAutoPushdown = YES;
	joypad.delegate = self;
	[self addChild:joypad z:1];
	
	labelA = [CMMFontUtil labelWithstring:@" "];
	labelB = [CMMFontUtil labelWithstring:@" "];
	[self addChild:labelA];
	[self addChild:labelB];
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,contentSize_.height-menuItemBack_.contentSize.height/2);
	menuItemBack_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushStaticLayerItemAtKey:_HelloWorldLayer_key_];
	};
	[self addChild:menuItemBack_ z:2];
	
	[self scheduleUpdate];
	
	return self;
}

-(void)_setLabelStr:(NSString *)str_ atLabel:(CCLabelTTF *)label_{
	[label_ setString:str_];
	[label_ stopAllActions];
	label_.scale = 1.0f;
	[label_ runAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:0.1 scale:1.2f] two:[CCScaleTo actionWithDuration:0.1 scale:1.0f]]];
}
-(void)_setLabelAStr:(NSString *)str_{
	[self _setLabelStr:str_ atLabel:labelA];
	labelA.position = ccp(contentSize_.width/2-labelA.contentSize.width/2-5.0f,contentSize_.height/2+50.0f);
}
-(void)_setLabelBStr:(NSString *)str_{
	[self _setLabelStr:str_ atLabel:labelB];
	labelB.position = ccp(contentSize_.width/2+labelB.contentSize.width/2+5.0f,contentSize_.height/2+50.0f);
}

-(void)customUIJoypad:(CMMCustomUIJoypad *)joypad_ whenChangedStickVector:(CGPoint)vector_{
	target.accelVector = vector_;
}
-(void)customUIJoypad:(CMMCustomUIJoypad *)joypad_ whenPushdownWithButton:(CMMCustomUIJoypadButton *)button_{
	if(button_ == joypad_.buttonA) [self _setLabelAStr:@"push down"];
	else [self _setLabelBStr:@"push down"];
}
-(void)customUIJoypad:(CMMCustomUIJoypad *)joypad_ whenPushupWithButton:(CMMCustomUIJoypadButton *)button_{
	if(button_ == joypad_.buttonA) [self _setLabelAStr:@"push up"];
	else [self _setLabelBStr:@"push up"];
}
-(void)customUIJoypad:(CMMCustomUIJoypad *)joypad_ whenPushcancelWithButton:(CMMCustomUIJoypadButton *)button_{
	if(button_ == joypad_.buttonA) [self _setLabelAStr:@"push cancel"];
	else [self _setLabelBStr:@"push cancel"];
}

-(void)update:(ccTime)dt_{
	[joypad update:dt_];
	[target update:dt_];
}

@end
