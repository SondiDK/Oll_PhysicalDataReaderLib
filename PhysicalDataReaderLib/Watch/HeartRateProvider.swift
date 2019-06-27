//
//  HeartRateProvider.swift
//  TestMessageWatch WatchKit Extension
//
//  Created by Oliver Larsen on 07/03/2019.
//  Copyright © 2019 amsiq. All rights reserved.
//

import Foundation
import HealthKit

typealias HKQueryUpdateHandler = ((HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Swift.Void)

protocol HeartRateProviderDelegate: class {
    func heartRate(didChangeTo newHeartRate: Double)
}

class HeartRateProvider {
    
    private let healthStore = HKHealthStore()
    weak var delegate: HeartRateProviderDelegate?
    private var activeQueries = [HKQuery]()
    
    init() {
        self.requestAuthorization { (success) in
            print(success)
        }
    }
    
    func startQuery() {
        debugPrint("HR start")
        // need hr
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        // Create query to receive continiuous heart rate samples.
        let datePredicate = HKQuery.predicateForSamples(withStart: Date(), end: nil, options: .strictStartDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let queryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        
        let updateHandler: HKQueryUpdateHandler = { [weak self] query, samples, deletedObjects, queryAnchor, error in
            
            if let quantitySamples = samples as? [HKQuantitySample] {
                self?.process(samples: quantitySamples)
            }
        }
        let query = HKAnchoredObjectQuery(type: quantityType, predicate: queryPredicate, anchor: nil, limit: HKObjectQueryNoLimit,
                                          resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        
        self.healthStore.execute(query)
        self.activeQueries.append(query)
    }
    
    func stop() {
        self.activeQueries.forEach { healthStore.stop($0) }
        self.activeQueries.removeAll()
    }
    
    private func process(samples: [HKQuantitySample]) {
        samples.forEach { processHR(sample: $0) }
    }
    
    private func processHR(sample: HKQuantitySample) {
        if sample.quantityType != HKObjectType.quantityType(forIdentifier: .heartRate) {
            return
        }
        let heartRateUnit = HKUnit(from: "count/min")
        let count = sample.quantity.doubleValue(for: heartRateUnit)
        debugPrint("HR: \(count)")
        self.delegate?.heartRate(didChangeTo: count)
    }
    
    func requestAuthorization(completionHandler: @escaping ((_ success: Bool) -> Void)) {
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("no healthdata.")
            completionHandler(false)
            return
        }
        
        guard let heartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completionHandler(false)
            return
        }
        // Request authorization to read heart rate data.
        self.healthStore.requestAuthorization(toShare: nil, read: [heartRateQuantityType]) { (success, error) -> Void in
            guard error == nil else {
                completionHandler(false)
                return
            }
            completionHandler(success)
        }
    }
}
