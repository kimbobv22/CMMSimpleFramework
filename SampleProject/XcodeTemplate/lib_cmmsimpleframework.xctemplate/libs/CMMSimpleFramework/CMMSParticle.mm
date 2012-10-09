//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSParticle.h"

@implementation CMMSParticle
@synthesize particleName,particleType;

+(id)particleWithParticleName:(NSString *)particleName_{
	return [[[self alloc] initWithParticleName:particleName_] autorelease];
}

-(id)initWithTotalParticles:(NSUInteger)numberOfParticles{
	if(!(self = [super initWithTotalParticles:numberOfParticles])) return self;
	
	particleType = ParticleType_default;
	particleName = nil;
	[self resetSystem];
	
	return self;
}

-(id)initWithParticleName:(NSString *)particleName_{
	if(!(self = [super initWithFile:[NSString stringWithFormat:@"%@.plist",particleName_]])) return self;
	
	particleName = [particleName_ retain];
	
	return self;
}

-(void)resetSystem{
	[super resetSystem];
	[self setPositionType:kCCPositionTypeRelative]; // issue..
	[self setAutoRemoveOnFinish:YES];
}

//not allow update directly
-(void)scheduleUpdateWithPriority:(NSInteger)priority{}
-(void)scheduleUpdate{}

-(void)dealloc{
	[particleName release];
	[super dealloc];
}

@end

@implementation CMMSParticleFollow
@synthesize target;

-(id)initWithTotalParticles:(NSUInteger)numberOfParticles{
	if(!(self = [super initWithTotalParticles:numberOfParticles])) return self;
	
	particleType = ParticleType_follow;
	
	return self;
}

-(void)update:(ccTime)dt_{
	if(target) [self setPosition:target.position];
	[super update:dt_];
}

-(void)resetSystem{
	[super resetSystem];
	self.target = nil;
}

-(void)dealloc{
	[target release];
	[super dealloc];
}

@end
