//  Created by JGroup(kimbobv22@gmail.com)

#import "cocos2d.h"
#import "CMMMacro.h"

#define cmmVarCMMLoadingObject_defaultLoadingFormatter @"loadingProcess%03d"

@class CMMLoadingObject;

@protocol CMMLoadingObjectDelegate <NSObject>

@optional
-(void)loadingObject_whenLoadingStart:(CMMLoadingObject *)loadingObject_;
-(void)loadingObject_whenLoadingEnded:(CMMLoadingObject *)loadingObject_;

@end

@interface CMMLoadingObject : NSObject{
	id<CMMLoadingObjectDelegate> delegate;
	
	id _loadingTarget;
	NSString *_loadingMethodFormatter;
	uint _curSequence;
}

+(id)loadingObject;

-(void)startLoadingWithMethodFormatter:(NSString *)methodFormatter_ target:(id)target_;
-(void)startLoadingWithMethodFormatter:(NSString *)methodFormatter_;
-(void)startLoadingWithTarget:(id)target_;
-(void)startLoading;

@property (nonatomic, assign) id<CMMLoadingObjectDelegate> delegate;

@end
