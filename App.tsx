/* eslint-disable react/react-in-jsx-scope */
import {useEffect, useState} from 'react';
import {
  Button,
  NativeEventEmitter,
  NativeModules,
  StyleSheet,
  Text,
  View,
} from 'react-native';

const {WatchConnectivityModule, WatchModule} = NativeModules;
const watchSessionManagerEmitter = new NativeEventEmitter(
  WatchConnectivityModule,
);

export default function App() {
  const [heartRate, setHeartRate] = useState(0);
  const [distance, setDistance] = useState(0);
  const [activeEnergyBurned, setActiveEnergyBurned] = useState(0);
  const [basalEnergyBurned, setBasalEnergyBurned] = useState(0);
  const [elapsedTime, setElapsedTime] = useState(0);
  const [paused, setPaused] = useState(false);
  const [stopped, setStopped] = useState(false);
  const [workoutType, setWorkoutType] = useState('');

  useEffect(() => {
    const subscription = watchSessionManagerEmitter.addListener(
      'HealthDataReceived',
      message => {
        console.log('Received Health Data:', message);
        setHeartRate(message.heartRate);
        setDistance(message.distance);
        setActiveEnergyBurned(message.activeEnergyBurned);
        setBasalEnergyBurned(message.basalEnergyBurned);
        setElapsedTime(message.elapsedTime);
        setPaused(message.paused);
        setStopped(message.stopped);
        setWorkoutType(message.workoutType);
      },
    );

    WatchConnectivityModule.activateWatchSession();

    return () => {
      subscription.remove();
    };
  }, []);

  const handleStartRunningWorkout = () => {
    WatchModule.activateWatchApp();
    // WatchConnectivityModule.sendMessage({
    //   command: 'startWorkout',
    //   workoutType: 'running',
    // });
  };

  const handleStartCyclingWorkout = () => {
    WatchModule.activateWatchApp();
    WatchConnectivityModule.sendMessage({
      command: 'startWorkout',
      workoutType: 'cycling',
    });
  };

  const handleStopWorkout = () => {
    WatchModule.activateWatchApp();
  };

  return (
    <View style={styles.container}>
      <View style={styles.values}>
        <Button title="Init Watch" onPress={handleStopWorkout} />
        <Button
          title="Start Running Workout"
          onPress={handleStartRunningWorkout}
        />
        <Button
          title="Start Cycling Workout"
          onPress={handleStartCyclingWorkout}
        />

        <Text style={styles.text}>Live Heart Rate: {heartRate} bpm</Text>
        <Text style={styles.text}>Distance: {distance} km</Text>
        <Text style={styles.text}>
          Active Energy Burned: {activeEnergyBurned} kcal
        </Text>
        <Text style={styles.text}>
          Basal Energy Burned: {basalEnergyBurned} kcal
        </Text>
        <Text style={styles.text}>Elapsed Time: {elapsedTime} sec</Text>
        <Text style={styles.text}>Paused: {paused ? 'Yes' : 'No'}</Text>
        <Text style={styles.text}>Stopped: {stopped ? 'Yes' : 'No'}</Text>
        <Text style={styles.text}>Workout Type: {workoutType}</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  text: {
    color: 'white',
    fontSize: 20,
    marginVertical: 5,
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  values: {
    alignItems: 'center',
  },
});
