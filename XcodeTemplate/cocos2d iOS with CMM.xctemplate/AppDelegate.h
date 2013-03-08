//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface MyViewController : UINavigationController

@end

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
