#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface WatchConnectivityModule : RCTEventEmitter <RCTBridgeModule, WCSessionDelegate>
@end
