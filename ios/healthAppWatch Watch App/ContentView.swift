import SwiftUI
import HealthKit
import WatchConnectivity

struct ContentView: View {
    @State private var heartRate: Int = 0
    @State private var distance: Double = 0.0
    @State private var steps: Int = 0
    @State private var activeEnergyBurned: Double = 0.0
    @State private var basalEnergyBurned: Double = 0.0
    @State private var isMonitoring: Bool = false
    @State private var startTime: Date = Date()
    @State private var elapsedTime: TimeInterval = 0.0
    @State private var timer: Timer? = nil

    @State private var initialDistance: Double = 0.0
    @State private var initialSteps: Int = 0
    @State private var initialActiveEnergy: Double = 0.0
    @State private var initialBasalEnergy: Double = 0.0

    private var healthStore = HKHealthStore()

    var body: some View {
        VStack {
            if isMonitoring {
                VStack {
                    Text("Heart Rate: \(heartRate) BPM")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                    
                    Text("Distance: \(distance, specifier: "%.2f") km")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                    
                    Text("Steps: \(steps)")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                        .padding(.top, 10)

                    Text("Active Energy Burned: \(activeEnergyBurned, specifier: "%.2f") kcal")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                        .padding(.top, 10)
                    
                    Text("Basal Energy Burned: \(basalEnergyBurned, specifier: "%.2f") kcal")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                        .padding(.top, 10)
                    
                    Text("Time: \(formatElapsedTime(elapsedTime))")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
            }
            
            Spacer()
            
            HStack {
                if !isMonitoring {
                    Button(action: startMonitoring) {
                        Text("Start")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }

                if isMonitoring {
                    Button(action: stopMonitoring) {
                        Text("Stop")
                            .font(.title)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear(perform: checkHealthAuthorization)
        .onAppear(perform: setupWCSession)
    }
  
    private func setupWCSession() {
//        if WCSession.isSupported() {
//            let session = WCSession.default
//            session.delegate = SessionDelegate.shared
//            session.activate()
//         
//            let context = ["exampleKey": "exampleValue"]
//            do {
//                try WCSession.default.updateApplicationContext(context)
//            } catch {
//                print("Error updating application context: \(error.localizedDescription)")
//            }
//        }
    }

    private func checkHealthAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let basalEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        
        let dataTypes: Set<HKQuantityType> = [heartRateType, distanceType, stepCountType, activeEnergyType, basalEnergyType]
        
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) in
            if success {
                // Authorization was successful
            }
        }
    }

    private func startMonitoring() {
        isMonitoring = true
        resetData()
        startTime = Date()
        startTimer()
        fetchInitialValues()
        sendHealthDataToPhone()
    }

    private func stopMonitoring() {
        isMonitoring = false
        timer?.invalidate()
        timer = nil
    }

    private func resetData() {
        heartRate = 0
        distance = 0.0
        steps = 0
        activeEnergyBurned = 0.0
        basalEnergyBurned = 0.0
        elapsedTime = 0.0
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime = Date().timeIntervalSince(self.startTime)
        }
    }

    private func formatElapsedTime(_ elapsedTime: TimeInterval) -> String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func sendHealthDataToPhone() {
        let healthData: [String: Any] = [
            "eventType": "HealthDataReceived",
            "heartRate": "\(heartRate)",
            "distance": "\(distance)",
            "steps": "\(steps)",
            "activeEnergyBurned": "\(activeEnergyBurned)",
            "basalEnergyBurned": "\(basalEnergyBurned)",
            "testData": "testing123"
        ]
      WCSession.default.transferUserInfo(healthData)
//        if WCSession.default.isReachable {
//            WCSession.default.sendMessage(healthData, replyHandler: { response in
//                print("Successfully sent health data to React Native: \(response)")
//            }, errorHandler: { error in
//                print("Failed to send health data to React Native: \(error.localizedDescription)")
//            })
//        } else {
//            print("WCSession is not reachable")
//        }
    }

    private func fetchInitialValues() {
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let basalEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let distanceQuery = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            let distanceUnit = HKUnit.meterUnit(with: .kilo)
            self.initialDistance = sum.doubleValue(for: distanceUnit)
            self.subscribeToHealthDataChanges()
        }

        let stepsQuery = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            self.initialSteps = Int(sum.doubleValue(for: HKUnit.count()))
            self.subscribeToHealthDataChanges()
        }
        
        let activeEnergyQuery = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            self.initialActiveEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
            self.subscribeToHealthDataChanges()
        }
        
        let basalEnergyQuery = HKStatisticsQuery(quantityType: basalEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            self.initialBasalEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
            self.subscribeToHealthDataChanges()
        }
        
        healthStore.execute(distanceQuery)
        healthStore.execute(stepsQuery)
        healthStore.execute(activeEnergyQuery)
        healthStore.execute(basalEnergyQuery)
    }

    private func subscribeToHealthDataChanges() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let basalEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { _, _, error in
            if error == nil {
                self.fetchLatestHeartRate()
            }
        }
        
        let distanceQuery = HKObserverQuery(sampleType: distanceType, predicate: nil) { _, _, error in
            if error == nil {
                self.fetchCumulativeDistance()
            }
        }
        
        let stepsQuery = HKObserverQuery(sampleType: stepCountType, predicate: nil) { _, _, error in
            if error == nil {
                self.fetchCumulativeSteps()
            }
        }
        
        let activeEnergyQuery = HKObserverQuery(sampleType: activeEnergyType, predicate: nil) { _, _, error in
            if error == nil {
                self.fetchCumulativeActiveEnergy()
            }
        }
        
        let basalEnergyQuery = HKObserverQuery(sampleType: basalEnergyType, predicate: nil) { _, _, error in
            if error == nil {
                self.fetchCumulativeBasalEnergy()
            }
        }
        
        healthStore.execute(query)
        healthStore.execute(distanceQuery)
        healthStore.execute(stepsQuery)
        healthStore.execute(activeEnergyQuery)
        healthStore.execute(basalEnergyQuery)
    }

    private func fetchLatestHeartRate() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let samples = results as? [HKQuantitySample], let sample = samples.first else { return }
            let heartRateUnit = HKUnit(from: "count/min")
            let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
            DispatchQueue.main.async {
                self.heartRate = Int(heartRate)
                self.sendHealthDataToPhone()
            }
        }
        
        healthStore.execute(query)
    }

    private func fetchCumulativeDistance() {
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            let distanceUnit = HKUnit.meterUnit(with: .kilo)
            let distance = sum.doubleValue(for: distanceUnit)
            DispatchQueue.main.async {
                self.distance = distance - self.initialDistance
                self.sendHealthDataToPhone()
            }
        }
        
        healthStore.execute(query)
    }

    private func fetchCumulativeSteps() {
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            DispatchQueue.main.async {
                self.steps = steps - self.initialSteps
                self.sendHealthDataToPhone()
            }
        }
        
        healthStore.execute(query)
    }
  
    private func fetchCumulativeActiveEnergy() {
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            let activeEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
            DispatchQueue.main.async {
                self.activeEnergyBurned = activeEnergy - self.initialActiveEnergy
                self.sendHealthDataToPhone()
            }
        }
        
        healthStore.execute(query)
    }

    private func fetchCumulativeBasalEnergy() {
        let basalEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: basalEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            let basalEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
            DispatchQueue.main.async {
                self.basalEnergyBurned = basalEnergy - self.initialBasalEnergy
                self.sendHealthDataToPhone()
            }
        }
        
        healthStore.execute(query)
    }
}
