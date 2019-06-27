//
//  TestWatchLib.swift
//  PhysicalDataReaderLibTests
//
//  Created by Oliver Larsen on 06/05/2019.
//  Copyright © 2019 Amsiq. All rights reserved.
//

import XCTest
import PhysicalDataReaderLib


class TestWatchLib: XCTestCase {

    func testEvaluatorWatchAverageHR() {
        let HR_eval = HeartRateEvaluation()
        
        //fill with heartrates
        HR_eval.heartRates.append(67)
        HR_eval.heartRates.append(69)
        HR_eval.heartRates.append(78)
        HR_eval.heartRates.append(85)
        HR_eval.heartRates.append(89)
        
        //end session
        let eval_data = HR_eval.evaluateSession()
        let avgHR = eval_data.averageHR
        
        //exspects to get average of 77
        XCTAssertEqual(avgHR, 77)

    }
    
    
    func testEvaluatorWatchHRRaise() {
        let HR_eval = HeartRateEvaluation()
        
        //fill with heartrates
        HR_eval.heartRates.append(67)
        HR_eval.heartRates.append(69)
        HR_eval.heartRates.append(78)
        HR_eval.heartRates.append(85)
        HR_eval.heartRates.append(89)
        
        //end session
        let eval_data = HR_eval.evaluateSession()
        let increaseHR = eval_data.increaseHR
        
        //exspects to get 22 (89-67 )
        XCTAssertEqual(increaseHR, 22)
        
    }



}
