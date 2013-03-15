//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSParticle.h"

@implementation CMMSParticle
@synthesize particleName,target;

+(id)particleWithParticleName:(NSString *)particleName_{
	return [[[self alloc] initWithParticleName:particleName_] autorelease];
}

-(id)initWithTotalParticles:(NSUInteger)numberOfParticles{
	if(!(self = [super initWithTotalParticles:numberOfParticles])) return self;
	
	particleName = nil;
	[self resetSystem];
	
	return self;
}

-(id)initWithParticleName:(NSString *)particleName_{
	if(!(self = [super initWithFile:[NSString stringWithFormat:@"%@.plist",particleName_]])) return self;
	
	particleName = [particleName_ copy];
	
	return self;
}

-(void)resetSystem{
	[super resetSystem];
	[self setPositionType:kCCPositionTypeRelative]; // issue..
	[self setAutoRemoveOnFinish:YES];
	[self setTarget:nil];
}

-(void)update:(ccTime)dt_{
	if(target) [self setPosition:[target position]];
	[super update:dt_];
}

//not allow update directly
-(void)scheduleUpdateWithPriority:(NSInteger)priority{}
-(void)scheduleUpdate{}

-(void)dealloc{
	[target release];
	[particleName release];
	[super dealloc];
}

@end