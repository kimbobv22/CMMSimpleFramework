#import "cocos2d.h"

@interface CCSpriteBatchNode(SplitSprite)

-(CCSprite *)addSplitSpriteToRect:(CGRect)rect_ blendFunc:(ccBlendFunc)tBlendFunc_;

-(void)addSplitSprite:(CGSize)splitUnit_ blendFunc:(ccBlendFunc)tBlendFunc_;
-(void)addSplitSprite:(CGSize)splitUnit_;

@end