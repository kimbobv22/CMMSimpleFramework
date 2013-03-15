//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMPacket.h"

@implementation CMMPacket
@synthesize mainData;

+(id)packet{
	return [[[self alloc] init] autorelease];
}

-(id)initWithCoder:(NSCoder *)decoder_{
	if(!(self = [super init])) return self;
	
	[self setMainData:[decoder_ decodeObjectForKey:cmmVarCMMPacket_keyName_mainData]];
	
	return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder_{
	[encoder_ encodeObject:mainData forKey:cmmVarCMMPacket_keyName_mainData];
}
-(id)copyWithZone:(NSZone *)zone_{
	CMMPacket *packet_ = [[[self class] allocWithZone:zone_] init];
	[packet_ setMainData:[[mainData copy] autorelease]];
	return packet_;
}

-(void)dealloc{
	[mainData release];
	[super dealloc];
}

@end

@implementation CMMPacket(MainData)

-(NSArray *)packetFromSplitMaindataByUnit:(uint)unit_{
	NSMutableArray *archivedDataList_ = [NSMutableArray array];
	
	NSData *tempMainData_ = [[mainData retain] autorelease];
	uint tempMainDataLength_ = 0;
	if(tempMainData_){
		tempMainDataLength_ = [tempMainData_ length];
	}
	
	[self setMainData:nil];
	int transferUnit_ = MIN(unit_,tempMainDataLength_);
	NSRange range_ = NSMakeRange(0, 0);
	
	for(int i=0;i<tempMainDataLength_;i+=transferUnit_){
		range_.location = i;
		range_.length = transferUnit_;
		
		if(range_.location+range_.length>tempMainDataLength_)
			range_.length = tempMainDataLength_ - range_.location;
		
		CMMPacket *packet_ = [[self copy] autorelease];
		[packet_ setMainData:[tempMainData_ subdataWithRange:range_]];
		[archivedDataList_ addObject:packet_];
	}
	
	[self setMainData:tempMainData_];
	return [NSArray arrayWithArray:archivedDataList_];
}

@end