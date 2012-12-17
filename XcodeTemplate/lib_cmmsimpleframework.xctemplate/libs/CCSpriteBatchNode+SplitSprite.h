#import "cocos2d.h"

@interface CCSpriteBatchNode(SplitSprite)

-(CCSprite *)addSplitSpriteToRect:(CGRect)rect_;
-(void)addSplitSprite:(CGSize)splitUnit_;

@end