//
//  TestFaceLib.swift
//  PhysicalDataReaderLibTests
//
//  Created by Oliver Larsen on 06/05/2019.
//  Copyright © 2019 Amsiq. All rights reserved.
//

import XCTest
import PhysicalDataReaderLib

class TestFaceLib: XCTestCase {

    func testEvaluatorFacePercentage() {
        let faceEval = FaceEvaluation()
        
        self.fillWithData(faceEval: faceEval, number: 199, expression: .surprised)
        self.fillWithData(faceEval: faceEval, number: 343, expression: .neutral)
        self.fillWithData(faceEval: faceEval, number: 444, expression: .smiling)
        
        let evaldata = faceEval.evaluateSession()
        let percent = evaldata?.getNumberOfExpression(expression: .smiling, percentage: true)
       
        XCTAssertEqual(percent, 45)
    }
    
    func testEvaluatorFaceMostUsed() {
        let faceEval = FaceEvaluation()
        
        self.fillWithData(faceEval: faceEval, number: 199, expression: .surprised)
        self.fillWithData(faceEval: faceEval, number: 343, expression: .neutral)
        self.fillWithData(faceEval: faceEval, number: 444, expression: .smiling)
        
        let evaldata = faceEval.evaluateSession()
        let percent = evaldata?.mostUsed
        
        XCTAssertEqual(percent, FaceState.smiling )
        
    }
    
    private func fillWithData(faceEval: FaceEvaluation, number: Int, expression: FaceState ) {
        for _ in 1...number {
            faceEval.addExpression(expression: expression)
        }

    }

}
