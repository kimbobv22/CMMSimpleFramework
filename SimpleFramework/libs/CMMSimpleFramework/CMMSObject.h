//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMType.h"
#import "CMMSprite.h"
#import "CMMSSpecObject.h"
#import "CMMSStateObject.h"

@class CMMStage;

@interface CMMSObject : CMMSprite{
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

-(void)whenCollisionWithObject:(CMMb2FixtureType)fixtureType_ otherObject:(CMMSObject *)otherObject_  otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_;
-(void)whenCollisionWithStage:(CMMb2FixtureType)fixtureType_ stageFixtureType:(CMMb2FixtureType)stageFixtureType_ contactPoint:(CGPoint)contactPoint_;

-(void)doContactingWithObject:(CMMb2FixtureType)fixtureType_ otherObject:(CMMSObject *)otherObject_  otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_ dt:(ccTime)dt_;
-(void)doContactingWithStage:(CMMb2FixtureType)fixtureType_ stageFixtureType:(CMMb2FixtureType)stageFixtureType_ contactPoint:(CGPoint)contactPoint_ dt:(ccTime)dt_;

-(void)updateBodyWithPosition:(CGPoint)point_ andRotation:(float)tRotation_;
-(void)updateBodyWithPosition:(CGPoint)point_;

@end

@interface CMMSObject(Stage)

-(void)whenAddedToStage;
-(void)whenRemovedToStage;

@end