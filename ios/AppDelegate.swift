//import UIKit
//import WatchConnectivity
//import React
//
//@UIApplicationMain // Marks this class as the app's entry point
//class AppDelegate: UIResponder, UIApplicationDelegate, RCTBridgeDelegate {
//
//    var window: UIWindow? // Reference to the app's main window
//    var moduleName = "healthApp"
//    var initialProps: [String: Any]? = [:]
//    var bridge: RCTBridge?
//
//    // MARK: - App Launch
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
////        
////        let bridge = RCTBridge(delegate: self, launchOptions: launchOptions)
////        RCTAppleHealthKit.new().initializeBackgroundObservers(bridge!)
//      
//      bridge = RCTBridge(delegate: self, launchOptions: nil)
//      RCTAppleHealthKit().initializeBackgroundObservers(bridge)
//
//        if WCSession.isSupported() {
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//        }
//
//        if WCSession.isSupported() { // Check if Watch Connectivity is available
//            let session = WCSession.default
//            session.delegate = self // Set this class as the session delegate
//            session.activate()     // Activate the session
//        }
//
//        return true // Signal successful launch
//    }
//    
//    // MARK: - Watch Connectivity Delegate
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        if let receivedMessage = message["HealthDataReceived"] as? String {
//            print("Received message from Watch: \(receivedMessage)")
//            // Send this message to React Native side using a bridge or event emitter if needed.
//        }
//    }
//
//    // (Other required WCSessionDelegate methods would be implemented here)
//    
//    // MARK: - Required Methods
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
//    func sessionDidBecomeInactive(_ session: WCSession) {}
//    func sessionDidDeactivate(_ session: WCSession) {}
//    
//    // MARK: - React Native Configuration
//    func sourceURL(for bridge: RCTBridge!) -> URL! {
//        return bundleURL()
//    }
//    
//    private func bundleURL() -> URL! {
//        #if DEBUG
//            return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
//        #else
//            return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
//        #endif
//    }
//}
