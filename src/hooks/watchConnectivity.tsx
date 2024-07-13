import {NativeModules, NativeEventEmitter} from 'react-native';

const watchConnectivityModule = NativeModules.WatchConnectivityModule;
const watchConnectivityEmitter = new NativeEventEmitter(
  watchConnectivityModule,
);

interface HealthData {
  // Define the structure of your health data here
  heartRate: number;
  // ... other properties
}

export default {
  subscribeToHealthData(callback: (healthData: HealthData) => void) {
    watchConnectivityEmitter.addListener('HealthDataReceived', callback);
  },
  // ... other methods
};
