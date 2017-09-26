//
//  HealthKitSetupAssistant.swift
//  CaffineTracker
//
//  Created by EL on 9/24/17.
//  Copyright © 2017 el. All rights reserved.
//

import HealthKit

class HealthKitStuff {
    
    private enum HealthKitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeHealthKit(completion: @escaping(Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitSetupError.notAvailableOnDevice)
            return
        }
        
        guard   let caffType = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine) else {
            completion(false, HealthKitSetupError.dataTypeNotAvailable)
            return
        }
        
        let healthKitTypesToWrite: Set<HKSampleType> = [caffType]
        
        let healthKitTypesToRead: Set<HKObjectType> = [caffType]
        
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
                                                completion(success, error)}
    }
    
    class func getCaffData(completion: @escaping(Int, Date) -> Swift.Void) {
        guard let caffType = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine) else {
            print("Caffine not available")
            return
        }
        
        
        let calendar = Calendar.current
        let last_midnight = calendar.startOfDay(for: Date())
        
        let today_predicate = HKQuery.predicateForSamples(withStart: last_midnight, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        
        let sampleQuery = HKSampleQuery(sampleType: caffType, predicate: today_predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            DispatchQueue.main.async {
                if error != nil {
                    print("Couldn't get samples \(error!)")
                    return
                }
                
                guard let samples = samples as? [HKQuantitySample] else {
                    print("Error: Couldn't unwrap and cast samples")
                    return;
                }
                
                var total = 0.0;
                for sample in samples {
                    total += sample.quantity.doubleValue(for: HKUnit.gramUnit(with: HKMetricPrefix.milli))
                }
                
                
                let mostRecentSample = samples.first
                let start = mostRecentSample?.startDate ?? Date()
                completion(Int(total), start)
                
            }
            
        }
        HKHealthStore().execute(sampleQuery)
    }
    
    class func logDose(dose: Double) {
        guard let caffType = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine) else {
            print("Caffine not available")
            return
        }
        
        let quantity = HKQuantity(unit: HKUnit.gramUnit(with: HKMetricPrefix.milli), doubleValue: dose)
        
        let caffSample = HKQuantitySample(type: caffType, quantity: quantity, start: Date(), end: Date())
        
        HKHealthStore().save(caffSample) { (success, error) in
            if error != nil {
                print("Error saving: \(error!)")
            }
        }
    }
}

