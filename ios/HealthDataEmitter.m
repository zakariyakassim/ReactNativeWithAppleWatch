#import "HealthDataEmitter.h"

static HealthDataEmitter *sharedInstance = nil;

@implementation HealthDataEmitter

RCT_EXPORT_MODULE();

+ (id)allocWithZone:(NSZone *)zone {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}

+ (void)emitEventWithName:(NSString *)name andPayload:(NSDictionary *)payload {
  if (sharedInstance != nil) {
    [sharedInstance sendEventWithName:name body:payload];
  }
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"HealthDataReceived"];
}

@end
