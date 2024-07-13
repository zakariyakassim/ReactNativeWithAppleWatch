import WatchKit
import Foundation
import HealthKit
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
    
  }
  
    var workoutManager = WorkoutManager()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
  


    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
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
}


