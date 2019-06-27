//
//  OverallEvaluation.swift
//  PhysicalDataReaderLib
//
//  Created by Oliver Larsen on 22/03/2019.
//  Copyright © 2019 Amsiq. All rights reserved.
//

import Foundation

public enum OverallResult {
    case very_good
    case good
    case average
    case bad
    case very_bad
}

public class OverallEvaluation: NSObject   {
    
    public func overallEvaluation(facedata: FaceEvaluationData?, heartdata: HeartEvaluationData? ) -> OverallResult {
        var score = 0
        
        if let smilePercentage = facedata?.getNumberOfExpression(expression: .smiling, percentage: true) {
            debugPrint("Smile: \(smilePercentage)")
            score += self.scoreCalculatorFace(number: smilePercentage)
        }
        if let heartRaise = heartdata?.increaseHR {
            debugPrint("heartRaise: \(heartRaise)")
            score += self.scoreCalculatorHR(number: heartRaise)
        } else {
            score *= 2 // if watch not used
        }
        
        debugPrint("TotalScore: \(score)")
        switch score {
        case 0...5:
            return .very_bad
        case 5...10:
            return .bad
        case 10...25:
            return .average
        case 25...50:
            return .good
        case 50...100:
            return .very_good
        default:
            return .average
        }
    }
    
    private func scoreCalculatorFace(number: Int)-> Int{
        switch number {
        case 1...10:
            return 10
        case 10...25:
            return 20
        case 25...50:
            return 30
        case 50...75:
            return 40
        case 75...100:
            return 50
        default:
            return  0
        }
    }
    
    private func scoreCalculatorHR(number: Int)-> Int{
        switch number {
        case 1...2:
            return 10
        case 2...4:
            return 20
        case 4...6:
            return 30
        case 6...10:
            return 40
        case 10...100:
            return 50
        default:
            return 0
        }
        
    }
}
