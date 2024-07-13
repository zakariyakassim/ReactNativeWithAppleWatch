#import "AppDelegate.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTBundleURLProvider.h>
//#import "HealthKitManager.h"
#import <React/RCTBridge.h>
//#import "RCTAppleHealthKit.h"
//#import <HealthKit/HealthKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "SimpleViewController.h"
#import "HealthDataEmitter.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.moduleName = @"healthApp";
    // You can add your custom initial props in the dictionary below.
    // They will be passed down to the ViewController used by React Native.
    self.initialProps = @{};

//    RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self
//                                              launchOptions:launchOptions];

   // [[RCTAppleHealthKit new] initializeBackgroundObservers:bridge];

//  if ([WCSession isSupported]) {
//      WCSession *session = [WCSession defaultSession];
//      session.delegate = self;
//      [session activateSession];
//      NSLog(@"WCSession activated: %@", session);
//  } else {
//      NSLog(@"WCSession is not supported on this device");
//  }

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    SimpleViewController *viewController = [[SimpleViewController alloc] init];
//    self.window.rootViewController = viewController;
//    [self.window makeKeyAndVisible];
//
//    if ([WCSession isSupported]) {
//        WCSession *session = [WCSession defaultSession];
//        session.delegate = self;
//        [session activateSession];
//        NSLog(@"WCSession activated: %@", session);
//    } else {
//        NSLog(@"WCSession is not supported on this device");
//    }
//
//    return YES;
//}


- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    return [self bundleURL];
}

- (NSURL *)bundleURL {
#if DEBUG
    return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
    return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

//- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error {
//    if (error) {
//        NSLog(@"WCSession activation failed with error: %@", error.localizedDescription);
//        return;
//    }
//    if (activationState == WCSessionActivationStateActivated) {
//        NSLog(@"WCSession activated successfully");
//        [self sendApplicationContext]; // Send application context after activation
//    } else {
//        NSLog(@"WCSession activation completed with state: %ld", (long)activationState);
//    }
//}
//
//- (void)sessionDidBecomeInactive:(WCSession *)session {
//    NSLog(@"WCSession became inactive");
//}
//
//- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *, id> *)userInfo {
//  @try {
//    NSLog(@"Received user info from Watch: %@", userInfo);
//    
//    // Handle user info data here
//    // You can also send the user info to the React Native side here
//  }
//  @catch (NSException *exception) {
//    NSLog(@"Exception when receiving user info: %@", exception);
//  }
//  @finally {
//    // Clean up or additional handling
//  }
//}
//- (void)sessionDidDeactivate:(WCSession *)session {
//    NSLog(@"WCSession deactivated, reactivating...");
//    [session activateSession];
//}
//
//
//- (void)sendApplicationContext {
//    NSDictionary *context = @{@"exampleKey": @"exampleValue"};
//    NSError *error = nil;
//    [[WCSession defaultSession] updateApplicationContext:context error:&error];
//    if (error) {
//        NSLog(@"Error updating application context: %@", error.localizedDescription);
//    }
//}
//
//
//
//
//- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext {
//  NSLog(@"Received application context from Watch: %@", applicationContext);
//  
//}
//
//- (void)session:(WCSession *)session didReceiveMessageData:(NSData *)messageData {
//  NSLog(@"Received message data from Watch");
//  
//}

//- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler {
//  NSLog(@"Received message with reply from Watch: %@", message);
//  
//  [HealthDataEmitter emitEventWithName:@"HealthDataReceived" andPayload:@{@"message": message}];
//
//  
//  // Handle the message and send a reply
//  NSDictionary *response = @{@"ResponseKey": @"ResponseValue"};
//  replyHandler(response);
//}


- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error { 
  
}

- (void)sessionDidBecomeInactive:(nonnull WCSession *)session { 

}

- (void)sessionDidDeactivate:(nonnull WCSession *)session { 
  
}

@end

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    SimpleViewController *viewController = [[SimpleViewController alloc] init];
//    self.window.rootViewController = viewController;
//    [self.window makeKeyAndVisible];
//
//    if ([WCSession isSupported]) {
//        WCSession *session = [WCSession defaultSession];
//        session.delegate = self;
//        [session activateSession];
//        NSLog(@"WCSession activated: %@", session);
//    } else {
//        NSLog(@"WCSession is not supported on this device");
//    }
//
//    return YES;
//}


//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//  self.moduleName = @"healthApp";
//  // You can add your custom initial props in the dictionary below.
//  // They will be passed down to the ViewController used by React Native.
//  self.initialProps = @{};
//
//  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self
//                                            launchOptions:launchOptions];
//
//  [[RCTAppleHealthKit new] initializeBackgroundObservers:bridge];
//
//  if ([WCSession isSupported]) {
//    WCSession *session = [WCSession defaultSession];
//    session.delegate = self;
//    [session activateSession];
//  }
//
//
//  return [super application:application didFinishLaunchingWithOptions:launchOptions];
//}
