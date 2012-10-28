//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMLayerPopup.h"
#import "CMMScene.h"

@implementation CMMLayerPopup

-(id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(!(self = [super initWithColor:color width:w height:h])) return self;
	
	[self setIsTouchEnabled:YES];
	
	return self;
}

-(id)init{
	return [self initWithColor:ccc4(0, 0, 0, 180)];
}

-(void)closeWithSendData:(id)data_{
	[[CMMScene sharedScene] closePopup:self withData:data_];
}
-(void)close{
	[self closeWithSendData:nil];
}

@end