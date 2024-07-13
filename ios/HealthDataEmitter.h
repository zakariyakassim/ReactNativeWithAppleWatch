#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

@interface HealthDataEmitter : RCTEventEmitter <RCTBridgeModule>
+ (void)emitEventWithName:(NSString *)name andPayload:(NSDictionary *)payload;
@end
