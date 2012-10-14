//  Created by JGroup(kimbobv22@gmail.com)

#define cmmVarCMMPacket_keyName_mainData @"_md"

@interface CMMPacket : NSObject<NSCopying,NSCoding>{
	id mainData;
}

+(id)packet;

@property (nonatomic, retain) id mainData;

@end

@interface CMMPacket(MainData)

-(NSArray *)packetFromSplitMaindataByUnit:(uint)unit_;

@end
