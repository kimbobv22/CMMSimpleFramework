//  Created by JGroup(kimbobv22@gmail.com)

#import "Box2D.h"
#import "ccTypes.h"
#import "CMMSType.h"

@class CMMStagePixel;
@class CMMSObject;

@interface CMMSPMapObjectFixture : NSObject{
@public
	float radians;
	b2Fixture *fixture;
}

+(id)fixutreWithRadians:(float)radians_ fixture:(b2Fixture *)fixture_;
-(id)initWithRadians:(float)radians_ fixture:(b2Fixture *)fixture_;

@end

@interface CMMSPMapObject : NSObject{
	CMMSObject *target;
	
	CCArray *fixtureList;
	CGPoint lastGenPoint;
	float lastRotate;
	BOOL doRecreate;

@public
	b2Body *mapBody;
	CMMb2ContactMask b2CMask;
}

+(id)pixelmapObjectWithTarget:(CMMSObject *)target_;
-(id)initWithTarget:(CMMSObject *)target_;

-(void)addFixture:(CMMSPMapObjectFixture *)fixture_;
-(CMMSPMapObjectFixture *)addFixtureWithRadians:(float)radians_ fixture:(b2Fixture *)fixture_;

-(void)removeFixture:(CMMSPMapObjectFixture *)fixture_;
-(void)removeFixtureAtRadians:(float)radians_;
-(void)removeAllFixtures;

-(CMMSPMapObjectFixture *)fixtureAtIndex:(NSUInteger)index_;
-(CMMSPMapObjectFixture *)fixtureAtRadians:(float)radians_;

-(NSUInteger)indexOfFixture:(CMMSPMapObjectFixture *)fixture_;
-(NSUInteger)indexOfRadians:(float)radians_;

@property (nonatomic, assign) CMMSObject *target;
@property (nonatomic, readonly) CCArray *fixtureList;
@property (nonatomic, readwrite) CGPoint lastGenPoint;
@property (nonatomic, readwrite) float lastRotate;
@property (nonatomic, readwrite) BOOL doRecreate;
@property (nonatomic, readonly) NSUInteger fixtureCount;

@end
