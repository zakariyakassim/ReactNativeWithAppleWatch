//#import <RCTAppDelegate.h>
//#import <UIKit/UIKit.h>
//#import <WatchConnectivity/WatchConnectivity.h>
//
//@interface AppDelegate : RCTAppDelegate <WCSessionDelegate>
//
//@end

#import <UIKit/UIKit.h>
#import <React/RCTBridgeDelegate.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <RCTAppDelegate.h>

@interface AppDelegate : RCTAppDelegate <UIApplicationDelegate, RCTBridgeDelegate, WCSessionDelegate>

//@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *messageQueue;

@end


//#import <UIKit/UIKit.h>
//#import <WatchConnectivity/WatchConnectivity.h>
//
//@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate>
//
//@property (strong, nonatomic) UIWindow *window;
//
//- (void)sendApplicationContext;
//
//@end
