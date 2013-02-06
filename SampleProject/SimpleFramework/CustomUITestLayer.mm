//  Created by JGroup(kimbobv22@gmail.com)

#import "CustomUITestLayer.h"
#import "HelloWorldLayer.h"

@implementation CustomUITestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CGSize stageSize_ = _contentSize;
	stageSize_.height -= 60.0f;
	stage = [CMMStage stageWithStageDef:CMMStageDefMake(stageSize_, stageSize_, ccp(0,-9.8))];
	[stage setTouchEnabled:NO];
	[stage setPosition:ccp(_contentSize.width*0.5f-stageSize_.width*0.5f,_contentSize.height-stageSize_.height)];
	[self addChild:stage z:1];
	
	target = [CMMSObject spriteWithFile:@"Icon-Small.png"];
	target.position = cmmFuncCommon_positionInParent(stage, target);
	[stage.world addObject:target];
	
	for(uint index_=0;index_<10;++index_){
		CMMSObject *tempObject_ = [CMMSObject spriteWithFile:@"Icon-Small.png"];
		[tempObject_ setColor:ccc3(180, 80, 80)];
		CGSize tempObjectSize_ = [tempObject_ contentSize];
		CGPoint tempPoint_;
		tempPoint_.x = arc4random()%(int)(stageSize_.width - tempObjectSize_.width) + tempObjectSize_.width/2.0f;
		tempPoint_.y = arc4random()%(int)(stageSize_.height*0.5f - tempObjectSize_.height) + tempObjectSize_.height/2.0f;
		[tempObject_ setPosition:tempPoint_];
		[stage.world addObject:tempObject_];
	}
	
	NSString *joypadSpriteFrameFileName_ = @"IMG_JOYPAD_000.plist";
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:joypadSpriteFrameFileName_];
	joypad = [CMMCustomUIJoypad joypadWithSpriteFrameFileName:joypadSpriteFrameFileName_];
	joypad.opacity = 120.0f;
	[[joypad stick] setCallback_whenStickVectorChanged:^(CGPoint vector_) {
		targetAccelVector = b2Vec2Mult(b2Vec2Fromccp(vector_), 0.2f);
	}];
	
	joypad.buttonA.autoPushdown = YES;
	joypad.buttonB.pushDelayTime = 1.0f;
	
	[self addChild:joypad z:1];
	
	//register callback
	[[joypad buttonA] setCallback_pushdown:^(id sender_){
		[self _setLabelAStr:@"Action!"];
	}];
	[[joypad buttonB] setCallback_pushdown:^(id sender_){
		b2Body *targetBody_ = [target body];
		if(!targetBody_) return;
		targetBody_->ApplyForceToCenter(b2Vec2(0,100.0f));
	}];
	
	labelA = [CMMFontUtil labelWithString:@" "];
	[self addChild:labelA z:2];
	
	labelYou = [CMMFontUtil labelWithString:@"You"];
	[labelYou runAction:[CCRepeatForever actionWithAction:[CCBlink actionWithDuration:0.5 blinks:1]]];
	[self addChild:labelYou z:2];
	
	CMMMenuItemL *menuItemBack_ = [CMMMenuItemL menuItemWithFrameSeq:0 batchBarSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,_contentSize.height-menuItemBack_.contentSize.height/2);
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
	labelA.position = ccp(_contentSize.width/2.0f,_contentSize.height/2+50.0f);
}
-(void)update:(ccTime)dt_{
	b2Body *targetBody_ = [target body];
	if(targetBody_ && targetAccelVector.Length() > 0){
		targetBody_->ApplyLinearImpulse(b2Vec2Mult(targetAccelVector, 30.0f*dt_), targetBody_->GetPosition());
	}
	[joypad update:dt_];
	[stage update:dt_];
	
	CGPoint targetPoint_ = [self convertToNodeSpace:[[stage world] convertToWorldSpace:[target position]]];
	targetPoint_.y += [target contentSize].height+10.0f;
	[labelYou setPosition:targetPoint_];
}

@end
