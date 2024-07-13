#import "WatchConnectivityModule.h"
#import <React/RCTLog.h>

@implementation WatchConnectivityModule

RCT_EXPORT_MODULE();

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        if ([WCSession isSupported]) {
//            WCSession *session = [WCSession defaultSession];
//            session.delegate = self;
//            [session activateSession];
//            RCTLogInfo(@"WCSession activated: %@", session);
//        } else {
//            RCTLogInfo(@"WCSession is not supported on this device");
//        }
//    }
//    return self;
//}

- (instancetype)init {
  self = [super init];
  if (self) {
    if ([WCSession isSupported]) {
      WCSession *session = [WCSession defaultSession];
      session.delegate = self;
      [session activateSession];
    }
  }
  return self;
}

RCT_EXPORT_METHOD(activateWatchSession)
{
  if ([WCSession isSupported]) {
    WCSession *session = [WCSession defaultSession];
    session.delegate = self; // Assuming your class implements WCSessionDelegate methods
    [session activateSession];
  }
}

//RCT_EXPORT_METHOD(activateWatchSession) {
//  if ([WCSession isSupported]) {
//    [[WCSession defaultSession] activateSession];
//  }
//}

RCT_EXPORT_METHOD(launchWatchApp) {
  if ([WCSession isSupported]) {
    [[WCSession defaultSession] sendMessage:@{@"command": @"launchApp"} replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
      RCTLogError(@"Error launching Watch app: %@", error);
    }];
  }
}

RCT_EXPORT_METHOD(sendMessage:(NSDictionary *)message) {
  if ([WCSession isSupported]) {
    [[WCSession defaultSession] sendMessage:message replyHandler:nil errorHandler:^(NSError * _Nonnull error) {
      RCTLogError(@"Error sending message to Watch: %@", error);
    }];
  }
}


//RCT_EXPORT_METHOD(activateWatchSession)
//{
//  if ([WCSession isSupported]) {
//    WCSession *session = [WCSession defaultSession];
//    session.delegate = self; // Assuming your class implements WCSessionDelegate methods
//    [session activateSession];
//  }
//}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"HealthDataReceived"];
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler {
  NSLog(@"Received message with reply from Watch: %@", message);
  
 // [self sendEventWithName:@"HealthDataReceived" body:message];
  // Handle the message and send a reply
  NSDictionary *response = @{@"ResponseKey": @"ResponseValue"};
  replyHandler(response);
}


- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error {
    if (error) {
        NSLog(@"WCSession activation failed with error: %@", error.localizedDescription);
        return;
    }
    if (activationState == WCSessionActivationStateActivated) {
        NSLog(@"WCSession activated successfully");
        [self sendApplicationContext]; // Send application context after activation
    } else {
        NSLog(@"WCSession activation completed with state: %ld", (long)activationState);
    }
}

- (void)sessionDidBecomeInactive:(WCSession *)session {
    NSLog(@"WCSession became inactive");
}

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *, id> *)userInfo {
  @try {
    NSLog(@"Received user info from Watch: %@", userInfo);
    NSString *eventType = userInfo[@"eventType"];
       if (eventType) {
         [self sendEventWithName:eventType body:userInfo];
       } else {
         [self sendEventWithName:@"UnknownEvent" body:userInfo];
       }
    // Handle user info data here
    // You can also send the user info to the React Native side here
  }
  @catch (NSException *exception) {
    NSLog(@"Exception when receiving user info: %@", exception);
  }
  @finally {
    // Clean up or additional handling
  }
}
- (void)sessionDidDeactivate:(WCSession *)session {
    NSLog(@"WCSession deactivated, reactivating...");
    [session activateSession];
}


- (void)sendApplicationContext {
    NSDictionary *context = @{@"exampleKey": @"exampleValue"};
    NSError *error = nil;
    [[WCSession defaultSession] updateApplicationContext:context error:&error];
    if (error) {
        NSLog(@"Error updating application context: %@", error.localizedDescription);
    }
}




- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext {
  NSLog(@"Received application context from Watch: %@", applicationContext);
  
}

- (void)session:(WCSession *)session didReceiveMessageData:(NSData *)messageData {
  NSLog(@"Received message data from Watch");
  
}

@end
