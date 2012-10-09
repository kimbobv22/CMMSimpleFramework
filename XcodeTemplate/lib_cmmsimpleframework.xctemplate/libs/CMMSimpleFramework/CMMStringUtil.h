#import "cocos2d.h"

@interface CMMStringUtil : NSObject

+(NSString *)replace:(NSString *)targetStr_ searchStr:(NSString *)searchStr_ replaceStr:(NSString *)replaceStr_;

+(NSString *)stringPathOfResoruce:(NSString *)fileName_ extension:(NSString *)extension_;
+(NSString *)stringPathOfResoruce:(NSString *)fileName_;
+(NSString *)stringPathOfResoruce;

+(NSString *)stringPathOfDocument:(NSString *)fileName_ extension:(NSString *)extension_;
+(NSString *)stringPathOfDocument:(NSString *)fileName_;
+(NSString *)stringPathOfDocument;

+(NSString *)stringPathWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_ extension:(NSString *)extension_;
+(NSString *)stringPathWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_;

+(NSString *)stringTimeStyleFromccTime:(ccTime)dt_;
+(NSString *)stringDecimalStyleFromNumber:(float)number_;

@end
