//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSPMapObject.h"
#import "CMMSObject.h"
#import "CMMStagePXL.h"

static CMMSimpleCache *_CMMSPMapObjectFixtureCache_ = nil;

@implementation CMMSPMapObjectFixture

+(id)fixutreWithRadians:(float)radians_ fixture:(b2Fixture *)fixture_{
	return [[[self alloc] initWithRadians:radians_ fixture:fixture_] autorelease];
}
-(id)initWithRadians:(float)radians_ fixture:(b2Fixture *)fixture_{
	if(!(self = [super init])) return self;
	
	radians = radians_;
	fixture = fixture_;
	
	return self;
}

@end

@implementation CMMSPMapObject
@synthesize target,fixtureList,lastGenPoint,lastRotate,doRecreate,fixtureCount;

+(id)pixelmapObjectWithTarget:(CMMSObject *)target_{
	return [[[self alloc] initWithTarget:target_] autorelease];
}
-(id)initWithTarget:(CMMSObject *)target_{
	if(!(self = [super init])) return self;
	
	target = target_;
	
	fixtureList = [[CCArray alloc] init];
	mapBody = NULL;
	b2CMask = CMMb2ContactMask();
	lastGenPoint = CGPointZero;
	lastRotate = 0.0f;
	doRecreate = YES;
	
	return self;
}

-(NSUInteger)fixtureCount{
	return [fixtureList count];
}

-(void)addFixture:(CMMSPMapObjectFixture *)fixture_{
	[self removeFixture:[self fixtureAtRadians:fixture_->radians]];
	[fixtureList addObject:fixture_];
}
-(CMMSPMapObjectFixture *)addFixtureWithRadians:(float)radians_ fixture:(b2Fixture *)fixture_{
	if(!_CMMSPMapObjectFixtureCache_){
		_CMMSPMapObjectFixtureCache_ = [[CMMSimpleCache alloc] init];
	}
	
	CMMSPMapObjectFixture *tFixture_ = [_CMMSPMapObjectFixtureCache_ cachedObject];
	if(!tFixture_)
		tFixture_ = [CMMSPMapObjectFixture fixutreWithRadians:0.0f fixture:nil];
	
	tFixture_->radians = radians_;
	tFixture_->fixture = fixture_;
	
	[self addFixture:tFixture_];
	return tFixture_;
}

-(void)removeFixture:(CMMSPMapObjectFixture *)fixture_{
	if(!fixture_) return;
	b2Fixture *tFixture_ = fixture_->fixture;
	if(mapBody && tFixture_) mapBody->DestroyFixture(tFixture_);
	[_CMMSPMapObjectFixtureCache_ cacheObject:fixture_];
	[fixtureList removeObjectAtIndex:[self indexOfFixture:fixture_]];
}
-(void)removeFixtureAtRadians:(float)radians_{
	[self removeFixture:[self fixtureAtRadians:radians_]];
}
-(void)removeAllFixtures{
	ccArray *data_ = fixtureList->data;
	for(int index_ = data_->num-1;index_ >= 0;--index_){
		CMMSPMapObjectFixture *fixture_ = data_->arr[index_];
		[self removeFixture:fixture_];
	}
}

-(CMMSPMapObjectFixture *)fixtureAtIndex:(NSUInteger)index_{
	if(index_ == NSNotFound) return nil;
	return [fixtureList objectAtIndex:index_];
}
-(CMMSPMapObjectFixture *)fixtureAtRadians:(float)radians_{
	return [self fixtureAtIndex:[self indexOfRadians:radians_]];
}

-(NSUInteger)indexOfFixture:(CMMSPMapObjectFixture *)fixture_{
	return [fixtureList indexOfObject:fixture_];
}
-(NSUInteger)indexOfRadians:(float)radians_{
	ccArray *data_ = fixtureList->data;
	NSUInteger count_= data_->num;
	for(NSUInteger index_=0;index_<count_;++index_){
		CMMSPMapObjectFixture *fixture_ = data_->arr[index_];
		if(fixture_->radians == radians_)
			return index_;
	}
	
	return NSNotFound;
}
-(void)dealloc{
	[self removeAllFixtures];
	[fixtureList release];
	[super dealloc];
}

@end
