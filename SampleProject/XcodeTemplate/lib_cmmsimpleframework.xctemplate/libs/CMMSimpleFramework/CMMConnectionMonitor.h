//  Created by JGroup(kimbobv22@gmail.com)
/*
  IMPORTANT : AS-IS 'Reachability' source from Apple inc.
 */

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum {
	CMMConnectionStatus_noConnection,
	CMMConnectionStatus_WiFi,
	CMMConnectionStatus_WWAN,
} CMMConnectionStatus;

#define cmmVarCMMConnectionMonitor_reachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

@interface CMMConnectionMonitor : NSObject{
	SCNetworkReachabilityRef _reachability;
}

+(CMMConnectionMonitor *)sharedMonitor;

-(void)addObserverForConnectionStatus:(id)target_ selector:(SEL)selector_;
-(void)removeObserverForConnectionStatus:(id)target_;

@property (nonatomic, readonly) CMMConnectionStatus connectionStatus;

@end