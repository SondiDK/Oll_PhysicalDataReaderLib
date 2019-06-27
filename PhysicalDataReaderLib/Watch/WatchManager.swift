//
//  WatchManager.swift
//  Watch Extension
//
//  Created by Oliver Larsen on 18/03/2019.
//  Copyright © 2019 amsiq. All rights reserved.
//
#if os(watchOS)
import Foundation
import WatchConnectivity
import WatchKit

public protocol WatchManagerDelegate: class {
    func getLatestHeartRate(newHeartRate: Double)
}
public class WatchManager: NSObject {
    
    private weak var delegate: WatchManagerDelegate?
    private var session = WCSession.default
    private let sessionManager = SessionManager()
    
    public func setupSession(delegate: WatchManagerDelegate) {
        self.delegate = delegate
        self.sessionManager.delegate = self
        self.session.delegate = self
        self.session.activate()
        
    }
    
    private func sendToApp(count: Double) {
        
        if self.session.isReachable {
            self.session.sendMessage(["HeartRate": count], replyHandler: nil, errorHandler: { error in print("Error sending message", error) })
        } else {
            print("Phone is not reachable")
        }
    }
    public func forceStart(){
        self.sessionManager.startWorkout()
    }
    
}
extension WatchManager: SessionManagerDelegate {
    
    public func sessionManager(_ manager: SessionManager, didChangeHeartRateTo newHeartRate: Double) {
        self.sendToApp(count: newHeartRate)
        self.delegate?.getLatestHeartRate(newHeartRate: newHeartRate)
    }
}

extension WatchManager: WCSessionDelegate {
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if let message = message["Setup"] as? String {
            print("lets:  \(message)")
            self.sessionManager.startWorkout()
        }
        if let message = message["Start"] as? String {
            self.sessionManager.startWorkout()
            print("hello  \(message)")
        } else if let message = message["End"] as? String {
            self.sessionManager.stop()
            print(message)
        }
    }
    
}
#endif
