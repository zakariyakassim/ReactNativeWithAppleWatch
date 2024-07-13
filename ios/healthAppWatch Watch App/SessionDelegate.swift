//import WatchConnectivity
//
//class SessionDelegate: NSObject, WCSessionDelegate {
//    static let shared = SessionDelegate()
//    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        if let error = error {
//            print("WCSession activation failed with error: \(error.localizedDescription)")
//            return
//        }
//        print("WCSession activated with state: \(activationState.rawValue)")
//    }
//    
//    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
//        // Handle receiving user info
//        print("Received user info: \(userInfo)")
//        
//        // Example: Notify other parts of the app about the received data
//        NotificationCenter.default.post(name: NSNotification.Name("HealthDataReceived"), object: userInfo)
//    }
//    
//    // Implement the method to handle received messages
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        print("Received message: \(message)")
//        
//        // Process the message and send a reply if necessary
//        let response = ["response": "Message received"]
//        replyHandler(response)
//    }
//    
//    // Implement the method to handle received message data
//    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
//        print("Received message data")
//        
//        // Process the message data and send a reply if necessary
//        let responseData = "Message data received".data(using: .utf8)!
//        replyHandler(responseData)
//    }
//    
//    // Implement the method to handle background task requests
//    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
//        print("Received application context: \(applicationContext)")
//    }
//    
//    // Implement the method to handle file transfers
//    func session(_ session: WCSession, didReceive file: WCSessionFile) {
//        print("Received file: \(file)")
//    }
//    
//    // Implement the method to handle file transfers in the background
//    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
//        if let error = error {
//            print("File transfer failed with error: \(error.localizedDescription)")
//        } else {
//            print("File transfer finished successfully")
//        }
//    }
//}


import WatchConnectivity

class SessionDelegate: NSObject, WCSessionDelegate {
    static let shared = SessionDelegate()
  
  var workoutManager = WorkoutManager()
  
//  override func awake(withContext context: Any?) {
//      super.awake(withContext: context)
//      if WCSession.isSupported() {
//          let session = WCSession.default
//          session.delegate = self
//          session.activate()
//      }
//  }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Handle received message
        print("Received message: \(message)")
      
      if let command = message["command"] as? String {
          if command == "startWorkout" {
              if let workoutType = message["workoutType"] as? String {
                  if workoutType == "running" {
                      workoutManager.startWorkout(activityType: .running)
                  } else if workoutType == "cycling" {
                      workoutManager.startWorkout(activityType: .cycling)
                  }
              }
          }
      }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        if session.isReachable {
            print("WCSession is reachable")
        } else {
            print("WCSession is not reachable")
        }
    }
  
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    
  }

}
