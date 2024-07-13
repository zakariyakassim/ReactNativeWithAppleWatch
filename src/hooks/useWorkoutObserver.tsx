import {useEffect, useState} from 'react';
import {NativeEventEmitter, NativeModules, Platform} from 'react-native';
import WatchConnectivity from 'react-native-watch-connectivity';

const useWorkoutObserver = () => {
  const [liveHeartRate, setLiveHeartRate] = useState(String);
  useEffect(() => {
    // WatchConnectivity.getIsPaired().then(isPaired => {
    //   console.log('Is Watch Paired?', isPaired);
    // });

    // WatchConnectivity.addListener('message', message => {
    //   console.log('Received message from Watch:', message);
    //   // Handle messages from the Watch here
    //   if (message.type === 'requestHealthData') {
    //     // Fetch HealthKit data and send back to the Watch
    //     fetchHealthKitData().then(data => {
    //       WatchConnectivity.sendMessage({ type: 'healthData', data });
    //     });
    //   }
    // });

    const eventEmitter = new NativeEventEmitter(NativeModules.AppleHealthKit);

    // if (Platform.OS === 'ios') {
    //   const watchEventEmitter = new NativeEventEmitter(
    //     NativeModules.WatchConnectivity,
    //   );
    //   watchEventEmitter.addListener('watchMessage', message => {
    //     console.log('Received message from Watch:', message);
    //     // Handle the heart rate update
    //   });
    // }

    const insulinDeliverySetupFailureListener = eventEmitter.addListener(
      'healthKit:InsulinDelivery:setup:failure',
      event => {
        console.log('Insulin Delivery setup failed', event);
        // Handle the failure here
      },
    );

    const labResultSetupSuccessListener = eventEmitter.addListener(
      'healthKit:LabResultRecord:setup:success',
      event => {
        console.log('Lab Result Record setup succeeded', event);
        // Handle the success
      },
    );

    const labResultSetupFailureListener = eventEmitter.addListener(
      'healthKit:LabResultRecord:setup:failure',
      event => {
        console.log('Lab Result Record setup failed', event);
        // Handle the failure
      },
    );

    const medicationRecordSetupSuccessListener = eventEmitter.addListener(
      'healthKit:MedicationRecord:setup:success',
      event => {
        console.log('Medication Record setup succeeded', event);
        // Handle the success
      },
    );

    const medicationRecordSetupFailureListener = eventEmitter.addListener(
      'healthKit:MedicationRecord:setup:failure',
      event => {
        console.log('Medication Record setup failed', event);
        // Handle the failure
      },
    );

    const procedureRecordSetupSuccessListener = eventEmitter.addListener(
      'healthKit:ProcedureRecord:setup:success',
      event => {
        console.log('Procedure Record setup succeeded', event);
        // Handle the success
      },
    );

    const procedureRecordSetupFailureListener = eventEmitter.addListener(
      'healthKit:ProcedureRecord:setup:failure',
      event => {
        console.log('Procedure Record setup failed', event);
        // Handle the failure
      },
    );

    const vitalSignRecordSetupSuccessListener = eventEmitter.addListener(
      'healthKit:VitalSignRecord:setup:success',
      event => {
        console.log('Vital Sign Record setup succeeded', event);
        // Handle the success
      },
    );

    const vitalSignRecordSetupFailureListener = eventEmitter.addListener(
      'healthKit:VitalSignRecord:setup:failure',
      event => {
        console.log('Vital Sign Record setup failed', event);
        // Handle the failure
      },
    );

    const insulinDeliverySetupSuccessListener = eventEmitter.addListener(
      'healthKit:InsulinDelivery:setup:success',
      event => {
        console.log('Insulin Delivery setup succeeded', event);
        // Handle the success
      },
    );

    const workoutSetupSuccessListener = eventEmitter.addListener(
      'healthKit:Workout:setup:success',
      async () => {
        console.log('--> observer triggered');
      },
    );

    const heartRateListener = eventEmitter.addListener(
      'healthKit:HeartRate:new',
      async () => {
        console.log('--> Heart rate observer triggered');
        // setLiveHeartRate(event);
      },
    );

    // Clean up the listeners on component unmount
    return () => {
      insulinDeliverySetupFailureListener.remove();
      labResultSetupSuccessListener.remove();
      labResultSetupFailureListener.remove();
      medicationRecordSetupSuccessListener.remove();
      medicationRecordSetupFailureListener.remove();
      procedureRecordSetupSuccessListener.remove();
      procedureRecordSetupFailureListener.remove();
      vitalSignRecordSetupSuccessListener.remove();
      vitalSignRecordSetupFailureListener.remove();
      insulinDeliverySetupSuccessListener.remove();
      workoutSetupSuccessListener.remove();
      heartRateListener.remove();
    //  heartRateFromWatchListerner.remove();
    };
  }, []);
  return {
    liveHeartRate,
  };
};

export default useWorkoutObserver;
