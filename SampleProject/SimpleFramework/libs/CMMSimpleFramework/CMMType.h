//  Created by JGroup(kimbobv22@gmail.com)

#import <Foundation/Foundation.h>

@protocol CMMApplicationProtocol <NSObject>

@optional
-(void)applicationDidBecomeActive;
-(void)applicationWillResignActive;

-(void)applicationWillTerminate;
-(void)applicationDidEnterBackground;
-(void)applicationWillEnterForeground;

-(void)applicationDidReceiveMemoryWarning;

@end