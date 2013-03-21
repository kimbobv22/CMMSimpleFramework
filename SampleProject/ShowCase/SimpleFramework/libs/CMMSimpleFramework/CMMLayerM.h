//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayer.h"

@interface CMMLayerM : CMMLayer{
	CMMLayer *innerLayer;
}

-(void)addChildToInner:(CCNode *)node z:(NSInteger)z tag:(NSInteger)tag;
-(void)addChildToInner:(CCNode *)node z:(NSInteger)z;
-(void)addChildToInner:(CCNode *)node;

-(void)removeChildFromInner:(CCNode *)node cleanup:(BOOL)cleanup;
-(void)removeChildByTagFromInner:(NSInteger)tag cleanup:(BOOL)cleanup;

@property (nonatomic, readonly) CMMLayer *innerLayer;
@property (nonatomic, readonly) CMMTouchDispatcher *innerTouchDispatcher;
@property (nonatomic, readwrite, getter = isInnerLayerTouchEnable) BOOL innerLayerTouchEnable;

@end
