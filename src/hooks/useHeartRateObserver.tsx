import {useEffect} from 'react';
import {NativeEventEmitter, NativeModules, Platform} from 'react-native';

const useHeartRateObserver = () => {
  useEffect(() => {
    const eventEmitter = new NativeEventEmitter(NativeModules.AppleHealthKit);
    const listener = eventEmitter.addListener(
      'healthKit:HeartRate:new',
      async () => {
        console.log('--> observer triggered');
      },
    );

    // Clean up the listener on component unmount
    return () => {
      listener.remove();
    };
  }, []); // Empty dependency array to ensure this runs only once
};

export default useHeartRateObserver;
