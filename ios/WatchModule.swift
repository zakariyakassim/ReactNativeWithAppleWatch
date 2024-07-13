import Foundation;
import WatchConnectivity;
import HealthKit
@objc(WatchModule)
class WatchModule: NSObject {
  //
  //    @objc func activateWatchApp() {
  //        if WCSession.default.isWatchAppInstalled {
  //            let message = ["request": "activateWatchApp"]
  //            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
  //                print("Error sending message to Watch: \(error)")
  //            })
  //        } else {
  //            print("Watch app is not installed")
  //        }
  //    }
  //}
  
  
  @objc func activateWatchApp() {
    guard HKHealthStore.isHealthDataAvailable() else { return }
    
    let healthStore = HKHealthStore()
    
    // 1. Request Authorization (replace with your specific types)
    let healthDataTypes = Set([
      HKObjectType.workoutType(),
      HKObjectType.quantityType(forIdentifier: .heartRate)!,
      // ... other types as needed
    ])
    
    healthStore.requestAuthorization(toShare: healthDataTypes, read: healthDataTypes) { (success, error) in
      if success {
        // 2. Create Workout Configuration
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running // Or your desired type
        configuration.locationType = .outdoor
        
        // 3. Launch and Start
        healthStore.startWatchApp(with: configuration) { (success, error) in
          if success {
            print("Workout started on Apple Watch!")
          } else {
            // Handle errors (e.g., watch not reachable)
            print("Error starting workout: \(error?.localizedDescription ?? "Unknown error")")
          }
        }
      } else {
        // Handle authorization failure
      }
    }
  }
  
}
