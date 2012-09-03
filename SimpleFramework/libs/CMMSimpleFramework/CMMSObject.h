//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSType.h"
#import "CMMSprite.h"
#import "CMMSSpecObject.h"
#import "CMMSStateObject.h"

@class CMMStage;

@interface CMMSObject : CMMSprite<CMMSContactProtocol>{
	int objectTag;
	
	CMMSSpecObject *spec;
	CMMSStateObject *state;
	
	b2Body *body;
	CMMb2ContactMask b2CMask;
	CMMStage *stage;
}

-(void)buildupObject;
-(void)update:(ccTime)dt_;

@property (nonatomic, readwrite) int objectTag;
@property (nonatomic, retain) CMMSSpecObject *spec;
@property (nonatomic, retain) CMMSStateObject *state;
@property (nonatomic, readwrite) b2Body *body;
@property (nonatomic, readwrite) CMMb2ContactMask b2CMask;
@property (nonatomic, assign) CMMStage *stage;

@end

@interface CMMSObject(Box2d)

-(void)buildupBody;

-(void)updateBodyWithPosition:(CGPoint)point_ andRotation:(float)tRotation_;
-(void)updateBodyWithPosition:(CGPoint)point_;

@end

@interface CMMSObject(Stage)

-(void)whenAddedToStage;
-(void)whenRemovedToStage;

@end