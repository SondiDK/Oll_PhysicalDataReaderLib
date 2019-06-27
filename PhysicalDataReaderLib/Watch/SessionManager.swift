//
//  SessionManager.swift
//  T
//
//  Created by Oliver Larsen on 07/03/2019.
//  Copyright © 2019 amsiq. All rights reserved.
//
#if os(watchOS)
import Foundation
import HealthKit

public protocol SessionManagerDelegate: class {
    func sessionManager(_ manager: SessionManager, didChangeHeartRateTo newHeartRate: Double)
}

public class SessionManager: NSObject {
    
    private let healthStore = HKHealthStore()
    private let heartRateProvider = HeartRateProvider()
    weak var delegate: SessionManagerDelegate?
    private var session: HKWorkoutSession?
    
    override init() {
        super.init()
        self.heartRateProvider.delegate = self
    }
    
    func startWorkout() {
        if (session != nil) { return }
        
        debugPrint("Sesssion started")
        let heartConfiguration = HKWorkoutConfiguration()
        heartConfiguration.activityType = .other
        
        do {
            self.session = try HKWorkoutSession(configuration: heartConfiguration)
        } catch {
            fatalError("Unable to create Workout Session!")
        }
        
        self.healthStore.start(session!)
        self.heartRateProvider.startQuery()
        
    }
    func stop() {
        self.heartRateProvider.stop()
    }
}
// MARK: - Heart Rate Delegate
extension SessionManager: HeartRateProviderDelegate {
    public func heartRate(didChangeTo newHeartRate: Double) {
        self.delegate?.sessionManager(self, didChangeHeartRateTo: newHeartRate)
    }
    
}
#endif
