#import "CCMutableTexture2D.h"

@interface CCMutableTexture2D(Private)

-(void)_fixRect:(CGRect *)targetRect_;

@end

@implementation CCMutableTexture2D(Private)

-(void)_fixRect:(CGRect *)targetRect_{
	CGPoint targetPoint_ = targetRect_->origin;
	CGSize targetSize_ = targetRect_->size;
	
	if(targetPoint_.x < 0.0f){
		targetSize_.width += targetPoint_.x;
		targetPoint_.x = 0.0f;
	}else if(targetPoint_.x+targetSize_.width > width_){
		targetSize_.width -= (targetPoint_.x+targetSize_.width) - (CGFloat)width_;
	}
	
	if(targetPoint_.y < 0.0f){
		targetSize_.height += targetPoint_.y;
		targetPoint_.y = 0.0f;
	}else if(targetPoint_.y+targetSize_.height > height_){
		targetSize_.height -= (targetPoint_.y+targetSize_.height) - (CGFloat)height_;
	}
	
	targetRect_->origin = targetPoint_;
	targetRect_->size = targetSize_;
}

@end

@implementation CCMutableTexture2D

-(id)initWithData:(const void *)data pixelFormat:(CCTexture2DPixelFormat)pixelFormat pixelsWide:(NSUInteger)width pixelsHigh:(NSUInteger)height contentSize:(CGSize)size{
	if(!(self = [super initWithData:data pixelFormat:pixelFormat pixelsWide:width pixelsHigh:height contentSize:size])) return self;
	
	_data = (void *)data;
	NSUInteger pixelDataLength_ = width_ * height_ * ([self bitsPerPixelForFormat]/8);
	_orgData = malloc(pixelDataLength_);
	memcpy(_orgData,data,pixelDataLength_);
	
	return self;
}

-(void)releaseData:(void*)data{}

-(ccColor4B)pixelAtPoint:(CGPoint)point_{
	ccColor4B pixelInfo_ = {0, 0, 0, 0};
	if(!_data) return pixelInfo_;
	NSInteger x_ = (NSInteger)point_.x, y_ = height_-((NSInteger)ceilf(point_.y));
	if(x_ < 0 || x_ >= width_ || y_ < 0 || y_ >= height_) return pixelInfo_;
	
	switch(format_){
		case kCCTexture2DPixelFormat_RGBA8888:{
			uint *pixel = (uint *)_data;
			pixel = pixel + (y_ * width_) + x_;
			pixelInfo_.r = *pixel & 0xff;
			pixelInfo_.g = (*pixel >> 8) & 0xff;
			pixelInfo_.b = (*pixel >> 16) & 0xff;
			pixelInfo_.a = (*pixel >> 24) & 0xff;
			break;
		}
		case kCCTexture2DPixelFormat_RGBA4444:{
			GLushort *pixel = (GLushort *)_data;
			pixel = pixel + (y_ * width_) + x_;
			pixelInfo_.a = ((*pixel & 0xf) << 4) | (*pixel & 0xf);
			pixelInfo_.b = (((*pixel >> 4) & 0xf) << 4) | ((*pixel >> 4) & 0xf);
			pixelInfo_.g = (((*pixel >> 8) & 0xf) << 4) | ((*pixel >> 8) & 0xf);
			pixelInfo_.r = (((*pixel >> 12) & 0xf) << 4) | ((*pixel >> 12) & 0xf);
			break;
		}
		case kCCTexture2DPixelFormat_RGB5A1:{
			GLushort *pixel = (GLushort *)_data;
			pixel = pixel + (y_ * width_) + x_;
			pixelInfo_.r = ((*pixel >> 11) & 0x1f)<<3;
			pixelInfo_.g = ((*pixel >> 6) & 0x1f)<<3;
			pixelInfo_.b = ((*pixel >> 1) & 0x1f)<<3;
			pixelInfo_.a = (*pixel & 0x1)*255;
			break;
		}
		case kCCTexture2DPixelFormat_RGB565:{
			GLushort *pixel = (GLushort *)_data;
			pixel = pixel + (y_ * width_) + x_;
			pixelInfo_.b = (*pixel & 0x1f)<<3;
			pixelInfo_.g = ((*pixel >> 5) & 0x3f)<<2;
			pixelInfo_.r = ((*pixel >> 11) & 0x1f)<<3;
			pixelInfo_.a = 255;
			break;
		}
		case kCCTexture2DPixelFormat_A8:{
			GLubyte *pixel = (GLubyte *)_data;
			pixelInfo_.a = pixel[(y_ * width_) + x_];
			// Default white
			pixelInfo_.r = 255;
			pixelInfo_.g = 255;
			pixelInfo_.b = 255;
			break;
		}
		default: break;
	}
	
	return pixelInfo_;
}

-(void)setPixelAtPoint:(CGPoint)point_ pixel:(ccColor4B)pixel_{
	NSInteger x_ = (NSInteger)point_.x, y_ = height_-((NSInteger)ceilf(point_.y));
	if(x_ < 0 || x_ >= width_ || y_ < 0 || y_ >= height_) return;
	
	switch(format_){
		case kCCTexture2DPixelFormat_RGBA8888:{
			uint *tempData_ = (uint *)_data;
			tempData_[(y_ * width_) + x_] = (pixel_.a << 24) | (pixel_.b << 16) | (pixel_.g << 8) | pixel_.r;
			break;
		}
		case kCCTexture2DPixelFormat_RGBA4444:{
			GLushort *tempData_ = (GLushort *)_data;
			tempData_ = tempData_ + (y_ * width_) + x_;
			*tempData_ = ((pixel_.r >> 4) << 12) | ((pixel_.g >> 4) << 8) | ((pixel_.b >> 4) << 4) | (pixel_.a >> 4);
			break;
		}
		case kCCTexture2DPixelFormat_RGB5A1:{
			GLushort *tempData_ = (GLushort *)_data;
			tempData_ = tempData_ + (y_ * width_) + x_;
			*tempData_ = ((pixel_.r >> 3) << 11) | ((pixel_.g >> 3) << 6) | ((pixel_.b >> 3) << 1) | (pixel_.a > 0);
			break;
		}
		case kCCTexture2DPixelFormat_RGB565:{
			GLushort *tempData_ = (GLushort *)_data;
			tempData_ = tempData_ + (y_ * width_) + x_;
			*tempData_ = ((pixel_.r >> 3) << 11) | ((pixel_.g >> 2) << 5) | (pixel_.b >> 3);
			break;
		}
		case kCCTexture2DPixelFormat_A8:{
			GLubyte *tempData_ = (GLubyte *)_data;
			tempData_[(y_ * width_) + x_] = pixel_.a;
			break;
		}
		default: break;
	}
}
-(void)setPixelCircleAtPoint:(CGPoint)point_ radius:(float)radius_ pixel:(ccColor4B)pixel_{
	for(NSInteger xIndex_ = (NSInteger)-radius_; xIndex_<(NSInteger)radius_; ++xIndex_){
		NSInteger yLimitValue_ = (NSInteger)sqrtf(radius_*radius_-xIndex_*xIndex_);
		for(NSInteger yIndex_ = ABS(yLimitValue_); yIndex_>-yLimitValue_; --yIndex_)
			[self setPixelAtPoint:CGPointMake(point_.x+xIndex_,point_.y+yIndex_) pixel:pixel_];
	}
}

-(void)apply{
	if(!_data) return;
	ccGLBindTexture2D(name_);
	
	switch(format_){
		case kCCTexture2DPixelFormat_RGBA8888:
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width_, height_, 0, GL_RGBA, GL_UNSIGNED_BYTE, _data);
			break;
		case kCCTexture2DPixelFormat_RGBA4444:
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width_, height_, 0, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, _data);
			break;
		case kCCTexture2DPixelFormat_RGB5A1:
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width_, height_, 0, GL_RGBA, GL_UNSIGNED_SHORT_5_5_5_1, _data);
			break;
		case kCCTexture2DPixelFormat_RGB565:
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width_, height_, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, _data);
			break;
		case kCCTexture2DPixelFormat_A8:
			glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width_, height_, 0, GL_ALPHA, GL_UNSIGNED_BYTE, _data);
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@""];
	}
	
	ccGLBindTexture2D(0);
}
-(void)applyPixelAtRect:(CGRect)rect_{
	[self _fixRect:&rect_];
	
	CGSize targetSize_ = rect_.size;
	CGPoint targetPoint_ = rect_.origin;
	
	if(targetSize_.width <= 0.0f || targetSize_.height <= 0.0f){
		return;
	}
	
	NSUInteger targetPixelLength_ = ((NSUInteger)targetSize_.width) * ((NSUInteger)targetSize_.height) * ([self bitsPerPixelForFormat]/8);
	void * targetPixelData_ = malloc(targetPixelLength_);
	
	for(NSUInteger targetXindex_=0; targetXindex_<(NSUInteger)targetSize_.width;++targetXindex_){
		NSUInteger sourceXIndex_ = targetXindex_ + (NSUInteger)targetPoint_.x;
		for(NSUInteger targetYindex_=0; targetYindex_<(NSUInteger)targetSize_.height;++targetYindex_){
			NSUInteger sourceYIndex_ = height_ - (targetYindex_ + (NSUInteger)targetPoint_.y);
			
			NSUInteger sourceIndex_ = (sourceYIndex_ * width_) + sourceXIndex_;
			NSUInteger targetIndex_ = (((((NSUInteger)targetSize_.height)-targetYindex_)-1) * (NSInteger)targetSize_.width)+targetXindex_;
			
			switch(format_){
				case kCCTexture2DPixelFormat_RGBA8888:{
					uint *targetPixel_ = (uint *)targetPixelData_;
					uint *pixel_ = (uint *)_data;
					targetPixel_[targetIndex_] = pixel_[sourceIndex_];
					break;
				}
				case kCCTexture2DPixelFormat_RGBA4444:{
					uint *targetPixel_ = (uint *)targetPixelData_;
					GLushort *pixel_ = (GLushort *)_data;
					targetPixel_[targetIndex_] = pixel_[sourceIndex_];
					break;
				}
				case kCCTexture2DPixelFormat_RGB5A1:{
					uint *targetPixel_ = (uint *)targetPixelData_;
					GLushort *pixel_ = (GLushort *)_data;
					targetPixel_[targetIndex_] = pixel_[sourceIndex_];
					break;
				}
				case kCCTexture2DPixelFormat_RGB565:{
					uint *targetPixel_ = (uint *)targetPixelData_;
					GLushort *pixel_ = (GLushort *)_data;
					targetPixel_[targetIndex_] = pixel_[sourceIndex_];
					break;
				}
				case kCCTexture2DPixelFormat_A8:{
					uint *targetPixel_ = (uint *)targetPixelData_;
					GLubyte *pixel_ = (GLubyte *)_data;
					targetPixel_[targetIndex_] = pixel_[sourceIndex_];
					break;
				}
				default: break;
			}
			
		}
	}
	
	ccGLBindTexture2D(name_);
	
	switch(format_){
		case kCCTexture2DPixelFormat_RGBA8888:
			glTexSubImage2D(GL_TEXTURE_2D, 0, targetPoint_.x, height_-(NSUInteger)(targetPoint_.y+targetSize_.height), targetSize_.width, targetSize_.height, GL_RGBA, GL_UNSIGNED_BYTE, targetPixelData_);
			break;
		case kCCTexture2DPixelFormat_RGBA4444:
			glTexSubImage2D(GL_TEXTURE_2D, 0, targetPoint_.x, height_-(NSUInteger)(targetPoint_.y+targetSize_.height), targetSize_.width, targetSize_.height, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, targetPixelData_);
			break;
		case kCCTexture2DPixelFormat_RGB5A1:
			glTexSubImage2D(GL_TEXTURE_2D, 0, targetPoint_.x, height_-(NSUInteger)(targetPoint_.y+targetSize_.height), targetSize_.width, targetSize_.height, GL_RGBA, GL_UNSIGNED_SHORT_5_5_5_1, targetPixelData_);
			break;
		case kCCTexture2DPixelFormat_RGB565:
			glTexSubImage2D(GL_TEXTURE_2D, 0, targetPoint_.x, height_-(NSUInteger)(targetPoint_.y+targetSize_.height), targetSize_.width, targetSize_.height, GL_RGBA, GL_UNSIGNED_SHORT_5_6_5, targetPixelData_);
			break;
		case kCCTexture2DPixelFormat_A8:
			glTexSubImage2D(GL_TEXTURE_2D, 0, targetPoint_.x, height_-(NSUInteger)(targetPoint_.y+targetSize_.height), targetSize_.width, targetSize_.height, GL_RGBA, GL_UNSIGNED_BYTE, targetPixelData_);
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@""];
	}
	
	ccGLBindTexture2D(0);
	free(targetPixelData_);
}

-(void)restore{
	memcpy(_data, _orgData, width_*height_*([self bitsPerPixelForFormat]/8));
	[self apply];
}

-(void)dealloc{
	free(_data);
	free(_orgData);
	[super dealloc];
}

@end
