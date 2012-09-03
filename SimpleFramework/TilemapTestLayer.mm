//  Created by JGroup(kimbobv22@gmail.com)

#import "TilemapTestLayer.h"
#import "HelloWorldLayer.h"

@implementation TilemapTestLayer

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	CMMMenuItemLabelTTF *menuItemBack_ = [CMMMenuItemLabelTTF menuItemWithFrameSeq:0];
	[menuItemBack_ setTitle:@"BACK"];
	menuItemBack_.position = ccp(menuItemBack_.contentSize.width/2+20,menuItemBack_.contentSize.height/2);
	menuItemBack_.callback_pushup = ^(id sender_){
		[[CMMScene sharedScene] pushLayer:[HelloWorldLayer node]];
	};
	[self addChild:menuItemBack_];
	
	return self;
}

-(void)loadingProcess000{
	CMMStageSpecDef stageSpecDef_ = CMMStageSpecDef(CGSizeMake(480, 270),CGSizeZero,ccp(0,-9.8f));
	tilemapStage = [CMMStageTMX stageWithStageSpecDef:stageSpecDef_ tmxFileName:@"TMX_SAMPLE_000.tmx" isInDocument:NO];
	tilemapStage.position = ccp(0,self.contentSize.height-tilemapStage.contentSize.height);
	tilemapStage.delegate = self;
	tilemapStage.isAllowTouch = YES;
	
	[self addChild:tilemapStage];
}
-(void)loadingProcess001{
	[tilemapStage addGroundTMXLayerAtLayerName:@"ground"];
	[tilemapStage buildupTilemap];
}
-(void)whenLoadingEnded{
	[self scheduleUpdate];
}

-(void)stage:(CMMStage *)stage_ whenTouchBegan:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	_isOnDrag = NO;
}
-(void)stage:(CMMStage *)stage_ whenTouchMoved:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	CGPoint diffPoint_ = ccpSub([CMMTouchUtil prepointFromTouch:touch_],[CMMTouchUtil pointFromTouch:touch_]);
	tilemapStage.worldPoint = ccpAdd(tilemapStage.worldPoint, diffPoint_);
	_isOnDrag = YES;
}
-(void)stage:(CMMStage *)stage_ whenTouchEnded:(UITouch *)touch_ withObject:(CMMSObject *)object_{
	if(!_isOnDrag){
		CMMSObject *object_ = [CMMSObject spriteWithFile:@"Icon-Small.png"];
		object_.position = [tilemapStage convertToStageWorldSpace:[CMMTouchUtil pointFromTouch:touch_]];
		[tilemapStage.world addObject:object_];
	}
}

-(void)stage:(CMMStage *)stage_ whenAddedObjects:(CCArray *)objects_{
	CMMSObject *object_ = [objects_ objectAtIndex:0];
	object_.body->GetFixtureList()->SetRestitution(0.7f);
}

-(void)tilemapStage:(CMMStageTMX *)stage_ whenTileBuiltupAtTMXLayer:(CCTMXLayer *)tmxLayer_ fromXIndex:(float)fromXIndex_ toXIndex:(float)toXIndex_ yIndex:(float)yIndex_ tileFixture:(b2Fixture *)tileFixture_{
	CCLOG(@"tile built up! [ X : %d -> %d , Y: %d ]",(int)fromXIndex_,(int)toXIndex_,(int)yIndex_);
}
-(BOOL)tilemapStage:(CMMStageTMX *)stage_ isSingleTileAtTMXLayer:(CCTMXLayer *)tmxLayer_ tile:(CCSprite *)tile_ xIndex:(float)xIndex_ yIndex:(float)yIndex_{
	return NO; // if return value is 'yes', a tile will be built up as single;
}

-(void)update:(ccTime)dt_{
	[tilemapStage update:dt_];
}

@end
