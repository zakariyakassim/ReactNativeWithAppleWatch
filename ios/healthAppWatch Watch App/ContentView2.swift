import SwiftUI
import HealthKit
import WatchConnectivity
import WatchKit

struct ContentView2: View {
    @ObservedObject private var workoutManager = WorkoutManager()
    
   // @State private var isMonitoring: Bool = false

    var body: some View {
        VStack {
          if workoutManager.isMonitoring {
                VStack {
                    Text("Heart Rate: \(workoutManager.heartRate) BPM")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                    
                    Text("Distance: \(workoutManager.distance, specifier: "%.2f") km")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                    
                    Text("Active Energy Burned: \(workoutManager.activeEnergyBurned, specifier: "%.2f") kcal")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                        .padding(.top, 10)
                    
                    Text("Basal Energy Burned: \(workoutManager.basalEnergyBurned, specifier: "%.2f") kcal")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                        .padding(.top, 10)
                    
                    Text("Time: \(formatElapsedTime(workoutManager.elapsedTime))")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                    
                  Text("Workout Type: \(workoutManager.workoutTypeString(for: workoutManager.workoutType))")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                    
                    Text("Paused: \(workoutManager.paused ? "Yes" : "No")")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                        .padding(.top, 10)
                    
                    Text("Stopped: \(workoutManager.stopped ? "Yes" : "No")")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            
            Spacer()
            
            VStack {
              if !workoutManager.isMonitoring {
                    Button(action: startRunning) {
                        Text("Running")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                    
                    Button(action: startCycling) {
                        Text("Cycling")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }

              if workoutManager.isMonitoring {
                    Button(action: stopMonitoring) {
                        Text("Stop")
                            .font(.title)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                    
                    Button(action: pauseOrResume) {
                        Text(workoutManager.paused ? "Resume" : "Pause")
                            .font(.title)
                            .padding()
                            .background(workoutManager.paused ? Color.blue : Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear(perform: setupWCSession)
    }
  
    private func setupWCSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = SessionDelegate.shared
            session.activate()
         
            let context = ["exampleKey": "exampleValue"]
            do {
                try WCSession.default.updateApplicationContext(context)
            } catch {
                print("Error updating application context: \(error.localizedDescription)")
            }
        }
    }

    private func startRunning() {
      workoutManager.isMonitoring = true
        workoutManager.startWorkout(activityType: .running)
    }
    
    private func startCycling() {
      workoutManager.isMonitoring = true
        workoutManager.startWorkout(activityType: .cycling)
    }

    private func stopMonitoring() {
      workoutManager.isMonitoring = false
        workoutManager.stopWorkout()
    }

    private func pauseOrResume() {
        if workoutManager.paused {
            workoutManager.resumeWorkout()
        } else {
            workoutManager.pauseWorkout()
        }
    }

    private func formatElapsedTime(_ elapsedTime: TimeInterval) -> String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
