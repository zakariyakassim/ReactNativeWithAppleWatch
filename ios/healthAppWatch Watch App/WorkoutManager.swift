import HealthKit
import WatchConnectivity
import WatchKit
import SwiftUI

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    var workoutManager = WorkoutManager()

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    }

  func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        // Handle the workout configuration
    workoutManager.startWorkout(with: workoutConfiguration)
    }
}


class WorkoutManager: NSObject, ObservableObject {
    private var healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    
    @Published var heartRate: Int = 0
    @Published var distance: Double = 0.0
    @Published var activeEnergyBurned: Double = 0.0
    @Published var basalEnergyBurned: Double = 0.0
    @Published var elapsedTime: TimeInterval = 0.0
    @Published var workoutType: HKWorkoutActivityType = .running
    @Published var paused: Bool = false
    @Published var stopped: Bool = false
    
    private var startTime: Date?
    private var timer: Timer?
  
    @Published var isMonitoring: Bool = false

    override init() {
        super.init()
        if HKHealthStore.isHealthDataAvailable() {
            let typesToShare: Set = [
                HKObjectType.workoutType()
            ]
            
            let typesToRead: Set = [
                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
            ]
            
            healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
                if !success {
                    // Handle error
                }
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: WKExtension.applicationDidEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: WKExtension.applicationWillEnterForegroundNotification, object: nil)
        }
    }
  
   func workoutTypeString(for type: HKWorkoutActivityType) -> String {
      switch type {
      case .running:
          return "Running"
      case .cycling:
          return "Cycling"
      default:
          return "Other"
      }
  }
  
  func startWorkout(activityType: HKWorkoutActivityType) {
       let workoutConfiguration = HKWorkoutConfiguration()
       workoutConfiguration.activityType = activityType
       startWorkout(with: workoutConfiguration)
   }
  
  func startWorkout(with configuration: HKWorkoutConfiguration) {
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
            
            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
            
            workoutSession?.delegate = self
            workoutBuilder?.delegate = self
            
            let startDate = Date()
            workoutSession?.startActivity(with: startDate)
            workoutBuilder?.beginCollection(withStart: startDate) { (success, error) in
                if let error = error {
                    print("Error starting workout: \(error.localizedDescription)")
                }
            }
            
            startTime = startDate
            startTimer()
            subscribeToHealthDataChanges()
            sendHealthDataToPhone() // Initial call to send data
        } catch {
            print("Error creating workout session: \(error.localizedDescription)")
        }
    }
    
//    func startWorkout(activityType: HKWorkoutActivityType) {
//        let workoutConfiguration = HKWorkoutConfiguration()
//        workoutConfiguration.activityType = activityType
//        workoutConfiguration.locationType = .outdoor
//        
//        self.workoutType = activityType
//        self.paused = false
//        self.stopped = false
//        self.isMonitoring = true;
//        
//        do {
//            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
//            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
//            
//            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutConfiguration)
//            
//            workoutSession?.delegate = self
//            workoutBuilder?.delegate = self
//            
//            let startDate = Date()
//            workoutSession?.startActivity(with: startDate)
//            workoutBuilder?.beginCollection(withStart: startDate) { (success, error) in
//                if let error = error {
//                    print("Error starting workout: \(error.localizedDescription)")
//                }
//            }
//            
//            startTime = startDate
//            startTimer()
//            subscribeToHealthDataChanges()
//            sendHealthDataToPhone() // Initial call to send data
//        } catch {
//            print("Error creating workout session: \(error.localizedDescription)")
//        }
//    }
    
    func stopWorkout() {
        workoutSession?.end()
        workoutBuilder?.endCollection(withEnd: Date()) { (success, error) in
            self.workoutBuilder?.finishWorkout { (workout, error) in
                if let error = error {
                    print("Error finishing workout: \(error.localizedDescription)")
                }
            }
        }
        self.stopped = true
        self.paused = false
        timer?.invalidate()
        timer = nil
        sendHealthDataToPhone() // Final call to send data
    }
    
    func pauseWorkout() {
        workoutSession?.pause()
        self.paused = true
        sendHealthDataToPhone() // Update paused state
    }
    
    func resumeWorkout() {
        workoutSession?.resume()
        self.paused = false
        sendHealthDataToPhone() // Update paused state
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }

    @objc private func appDidEnterBackground() {
        // Handle entering background
        timer?.invalidate()
        sendHealthDataToPhone() // Send data before going to background
    }
    
    @objc private func appWillEnterForeground() {
        // Handle entering foreground
        if !self.stopped && !self.paused {
            startTimer() // Restart the timer if workout is still running
        }
    }
    
    private func sendHealthDataToPhone() {
        let currentTime = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .long)
        let healthData: [String: Any] = [
            "eventType": "HealthDataReceived",
            "heartRate": "\(heartRate)",
            "distance": "\(distance)",
            "activeEnergyBurned": "\(activeEnergyBurned)",
            "basalEnergyBurned": "\(basalEnergyBurned)",
            "elapsedTime": "\(elapsedTime)",
            "currentTime": currentTime,
            "paused": paused,
            "stopped": stopped,
            "workoutType": workoutTypeString(for: workoutType)
        ]
        WCSession.default.transferUserInfo(healthData)
    }
    
    private func subscribeToHealthDataChanges() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let basalEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        
        let updateHandler: (HKObserverQuery, @escaping HKObserverQueryCompletionHandler, Error?) -> Void = { query, completionHandler, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.fetchLatestHealthData()
                }
            }
            completionHandler()
        }
        
        let heartRateQuery = HKObserverQuery(sampleType: heartRateType, predicate: nil, updateHandler: updateHandler)
        let distanceQuery = HKObserverQuery(sampleType: distanceType, predicate: nil, updateHandler: updateHandler)
        let activeEnergyQuery = HKObserverQuery(sampleType: activeEnergyType, predicate: nil, updateHandler: updateHandler)
        let basalEnergyQuery = HKObserverQuery(sampleType: basalEnergyType, predicate: nil, updateHandler: updateHandler)
        
        healthStore.execute(heartRateQuery)
        healthStore.execute(distanceQuery)
        healthStore.execute(activeEnergyQuery)
        healthStore.execute(basalEnergyQuery)
        
        healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { success, error in
            if let error = error {
                print("Error enabling background delivery for heart rate: \(error.localizedDescription)")
            }
        }
        healthStore.enableBackgroundDelivery(for: distanceType, frequency: .immediate) { success, error in
            if let error = error {
                print("Error enabling background delivery for distance: \(error.localizedDescription)")
            }
        }
        healthStore.enableBackgroundDelivery(for: activeEnergyType, frequency: .immediate) { success, error in
            if let error = error {
                print("Error enabling background delivery for active energy: \(error.localizedDescription)")
            }
        }
        healthStore.enableBackgroundDelivery(for: basalEnergyType, frequency: .immediate) { success, error in
            if let error = error {
                print("Error enabling background delivery for basal energy: \(error.localizedDescription)")
            }
        }
    }

    private func fetchLatestHealthData() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let basalEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        
        let types: [HKQuantityType] = [heartRateType, distanceType, activeEnergyType, basalEnergyType]
        
        for type in types {
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, error in
                if let error = error {
                    print("Error fetching \(type.identifier): \(error.localizedDescription)")
                    return
                }
                if let sample = results?.first as? HKQuantitySample {
                    DispatchQueue.main.async {
                        switch type {
                        case heartRateType:
                            let heartRateUnit = HKUnit(from: "count/min")
                            self.heartRate = Int(sample.quantity.doubleValue(for: heartRateUnit))
                        case distanceType:
                            let meterUnit = HKUnit.meter()
                            self.distance = sample.quantity.doubleValue(for: meterUnit) / 1000
                        case activeEnergyType:
                            let kilocalorieUnit = HKUnit.kilocalorie()
                            self.activeEnergyBurned = sample.quantity.doubleValue(for: kilocalorieUnit)
                        case basalEnergyType:
                            let kilocalorieUnit = HKUnit.kilocalorie()
                            self.basalEnergyBurned = sample.quantity.doubleValue(for: kilocalorieUnit)
                        default:
                            break
                        }
                    }
                }
            }
            healthStore.execute(query)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WorkoutManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        // Handle state changes
        if toState == .ended {
            workoutBuilder?.endCollection(withEnd: date) { (success, error) in
                self.workoutBuilder?.finishWorkout { (workout, error) in
                    if let error = error {
                        print("Error finishing workout: \(error.localizedDescription)")
                    }
                }
            }
            timer?.invalidate()
            timer = nil
            sendHealthDataToPhone() // Send final data
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed with error: \(error.localizedDescription)")
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Handle workout events
    }
  
  
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        DispatchQueue.main.async {
            // Handle data collection updates
            if collectedTypes.contains(HKObjectType.quantityType(forIdentifier: .heartRate)!) {
                if let statistics = workoutBuilder.statistics(for: HKQuantityType.quantityType(forIdentifier: .heartRate)!) {
                    let heartRateUnit = HKUnit(from: "count/min")
                    self.heartRate = Int(statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0)
                }
            }
            if collectedTypes.contains(HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!) {
                if let statistics = workoutBuilder.statistics(for: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!) {
                    let meterUnit = HKUnit.meter()
                    self.distance = (statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0) / 1000
                }
            }
            if collectedTypes.contains(HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!) {
                if let statistics = workoutBuilder.statistics(for: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!) {
                    let kilocalorieUnit = HKUnit.kilocalorie()
                    self.activeEnergyBurned = statistics.sumQuantity()?.doubleValue(for: kilocalorieUnit) ?? 0
                }
            }
            if collectedTypes.contains(HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!) {
                if let statistics = workoutBuilder.statistics(for: HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!) {
                    let kilocalorieUnit = HKUnit.kilocalorie()
                    self.basalEnergyBurned = statistics.sumQuantity()?.doubleValue(for: kilocalorieUnit) ?? 0
                }
            }
            self.sendHealthDataToPhone() // Send updated data
        }
    }
}
