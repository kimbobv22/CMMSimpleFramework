//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScene.h"

@class CMMCaremaManager;

@protocol CMMCaremaManagerDelegate <NSObject>

-(void)cameraManager:(CMMCaremaManager *)cameraManger_ whenReturnedImageTexture:(CCTexture2D *)imageTexture_;
-(void)cameraManager_whenCancelled:(CMMCaremaManager *)cameraManger_;

@end

#define cmmVarCMMCaremaManager_textureSeqName @"Image_CMMCaremaManager_"

@interface CMMCaremaManager : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
	id<CMMCaremaManagerDelegate> delegate;
	CGSize imageLimitSize;
	NSUInteger _IMAGE_SEQ_;
}

+(CMMCaremaManager *)sharedManager;

-(void)openCameraWithSourceType:(UIImagePickerControllerSourceType)sourceType_;

@property (nonatomic, retain) id<CMMCaremaManagerDelegate> delegate;
@property (nonatomic, readwrite) CGSize imageLimitSize;

@end
