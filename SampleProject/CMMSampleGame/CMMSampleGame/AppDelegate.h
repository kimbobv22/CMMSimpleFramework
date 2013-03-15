//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface MyViewController : UINavigationController<CCDirectorDelegate>

@end

@interface AppController : NSObject <UIApplicationDelegate>{
	UIWindow *window_;
	MyViewController *navController_;
	
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyViewController *navController;
@property (readonly) CCDirectorIOS *director;

@end
