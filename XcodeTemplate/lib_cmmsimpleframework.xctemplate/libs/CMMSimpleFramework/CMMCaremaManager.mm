//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMCaremaManager.h"

static CMMCaremaManager *_sharedCMMCaremaManager_ = nil;

@implementation CMMCaremaManager
@synthesize delegate,imageLimitSize;

+(CMMCaremaManager *)sharedManager{
	if(!_sharedCMMCaremaManager_){
		_sharedCMMCaremaManager_ = [[CMMCaremaManager alloc] init];
	}
	
	return _sharedCMMCaremaManager_;
}

-(id)init{
	if(!(self = [super init])) return self;
	
	_IMAGE_SEQ_ = 0;
	imageLimitSize = [[CCDirector sharedDirector] winSize];
	
	return self;
}

-(void)openCameraWithSourceType:(UIImagePickerControllerSourceType)sourceType_{
	UIImagePickerController *imagePicker_ = [[[UIImagePickerController alloc] init] autorelease];
	[imagePicker_ setSourceType:sourceType_];
	[imagePicker_ setDelegate:self];
	
	[[CMMScene sharedScene] presentViewController:imagePicker_ animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(cameraManager:whenReturnedImageTexture:))){
		UIImage *targetImage_ = [info objectForKey:UIImagePickerControllerOriginalImage];
		CGSize targetImageSize_ = [targetImage_ size];

		//resize
		float resultResizeRate_ = 1.0f;
		if(imageLimitSize.width < targetImageSize_.width){
			resultResizeRate_ = imageLimitSize.width / targetImageSize_.width;
		}
		if(imageLimitSize.height < targetImageSize_.height){
			float tempRate_ = imageLimitSize.height / targetImageSize_.height;
			if(tempRate_<resultResizeRate_){
				resultResizeRate_ = tempRate_;
			}
		}
		
		targetImageSize_ = CGSizeMult(targetImageSize_, resultResizeRate_);
#if COCOS2D_DEBUG >= 1
		CCLOG(@"CMMCaremaManager : UIImage resize [ %1.1f x %1.1f, resize ratio : %1.1f ]",targetImageSize_.width,targetImageSize_.height,resultResizeRate_);
#endif
		
		CGRect resizeRect_ = CGRectMake(0.0f, 0.0f, targetImageSize_.width * CC_CONTENT_SCALE_FACTOR(), targetImageSize_.height * CC_CONTENT_SCALE_FACTOR());
		UIGraphicsBeginImageContext(resizeRect_.size);
		[targetImage_ drawInRect:resizeRect_];
		targetImage_ = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		NSString *textureKey_ = [NSString stringWithFormat:@"%@%04d",cmmVarCMMCaremaManager_textureSeqName,++_IMAGE_SEQ_];
		CCTexture2D *imageTexture_ = [[CCTextureCache sharedTextureCache] addCGImage:[targetImage_ CGImage]  forKey:textureKey_];
#if COCOS2D_DEBUG >= 1
		CCLOG(@"CMMCaremaManager : add texture from UIImage [ %@ ]",textureKey_);
#endif
		
		[delegate cameraManager:self whenReturnedImageTexture:imageTexture_];
	}

	[picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	if(cmmFuncCommon_respondsToSelector(delegate, @selector(cameraManager_whenCancelled:))){
		[delegate cameraManager_whenCancelled:self];
	}
	
	[picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
	[delegate release];
	[super dealloc];
}

@end
