//
//  FaceEvaluationswift.swift
//  PhysicalDataReader
//
//  Created by Oliver Larsen on 21/02/2019.
//  Copyright © 2019 amsiq. All rights reserved.
//

import Foundation

public class FaceEvaluation {
    
    private var counts: [FaceState: Int] = [:]
    private var totalCount = 0
    private var lastExpression: FaceState?
    private var specialCases: [FaceState] = [.winking, .tongue_out]

    public init(){}
    
    public func addExpression(expression: FaceState) {
        
        if self.specialCases.contains(expression) && self.specialCases.contains(self.lastExpression ?? .not_determined) {
            return // this is made to not fill dict with winking and tongoue out.
        }
        
        self.counts[expression, default: 0] += 1
        self.totalCount += 1
        self.lastExpression = expression
    }
    
    public func evaluateSession() -> FaceEvaluationData? {
        
        let evaluationData = FaceEvaluationData (
            totalExpressions: self.totalCount,
            mostUsed: counts.max { a, b in a.value < b.value }?.key,
            counts: self.counts
        )
        return evaluationData
    }
}

public struct FaceEvaluationData {
    var totalExpressions: Int?
    public var mostUsed: FaceState?
    var counts: [FaceState: Int]?
    
    public func getNumberOfExpression(expression: FaceState, percentage:Bool) -> Int? {
        if let counts = self.counts, let value = counts[expression], let total = self.totalExpressions {
            return percentage ? getPercentage(value, total) : value
        } else { return 0 }
    }
    
    private func getPercentage(_ value: Int, _ max: Int) -> Int {
        return Int((Double(value) / Double(max)) * 100.0 )
    }
    
}
