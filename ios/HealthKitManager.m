#import "HealthKitManager.h"

@implementation HealthKitManager

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
  return @[@"healthKit:Workout:setup:success"];
}

RCT_EXPORT_METHOD(startWorkout)
{
  // Code to start the workout...

  // Emitting the event
  [self sendEventWithName:@"healthKit:Workout:setup:success" body:@{@"status": @"success"}];
}

@end
