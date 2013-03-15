//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMScene.h"

@class CMMCaremaManager;

@protocol CMMCaremaManagerDelegate <NSObject>

@required
-(void)cameraManager:(CMMCaremaManager *)cameraManger_ whenReturnedUIImage:(UIImage *)uIImage_;
-(void)cameraManager:(CMMCaremaManager *)cameraManger_ whenReturnedImageTexture:(CCTexture2D *)imageTexture_;

@optional
-(void)cameraManager_whenCancelled:(CMMCaremaManager *)cameraManger_;

@end

enum CMMCaremaManagerReturnType{
	CMMCaremaManagerReturnType_CCTexture2D,
	CMMCaremaManagerReturnType_UIImage,
};

#define cmmVarCMMCaremaManager_textureSeqName @"Image_CMMCaremaManager_"

@interface CMMCaremaManager : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
	id<CMMCaremaManagerDelegate> delegate;
	CGSize imageLimitSize;
	NSUInteger _IMAGE_SEQ_;
	
	CMMCaremaManagerReturnType returnType;
}

+(CMMCaremaManager *)sharedManager;

-(void)openCameraWithSourceType:(UIImagePickerControllerSourceType)sourceType_ callback:(void(^)(UIImagePickerController *picker_))callback_;
-(void)openCameraWithSourceType:(UIImagePickerControllerSourceType)sourceType_;

@property (nonatomic, assign) id<CMMCaremaManagerDelegate> delegate;
@property (nonatomic, readwrite) CGSize imageLimitSize;
@property (nonatomic, readwrite) CMMCaremaManagerReturnType returnType;

@end
