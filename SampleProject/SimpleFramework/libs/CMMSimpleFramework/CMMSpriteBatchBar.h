//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMMacro.h"
#import "CMMTouchDispatcher.h"

@interface CMMSpriteBatchBar : CCSpriteBatchNode<CMMTouchDispatcherDelegate,CCRGBAProtocol>{
	CCSprite *targetSprite;
	CGSize edgeSize;
	float barCropWidth;
	
	CGRect _targetSpriteOrgTextureRect;
	BOOL _isDirty;
	
	CCSprite *_barTopSprite,*_barBottomSprite,*_barLeftSprite,*_barRightSprite,*_backSprite,*_edge1Sprite,*_edge2Sprite,*_edge3Sprite,*_edge4Sprite;
}

+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_ barCropWidth:(float)barCropWidth_;
+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_;
+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_;

-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_ barCropWidth:(float)barCropWidth_;
-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_;
-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_;

@property (nonatomic, retain) CCSprite *targetSprite;
@property (nonatomic, readwrite) CGSize edgeSize;
@property (nonatomic, readwrite) float barCropWidth;

@end