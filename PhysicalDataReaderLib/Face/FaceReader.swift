//
//  FaceReader.swift
//  PhysicalDataReader
//
//  Created by Oliver Larsen on 12/02/2019.
//  Copyright © 2019 amsiq. All rights reserved.
//
#if canImport(ARKit)
import ARKit


import Foundation

class FaceReader: NSObject {
    
    private var face: ARFaceAnchor?
    func intelligentFaceDecoding(anchors: [ARAnchor]) -> FaceState {
        
        if let faceAnchor = anchors.first as? ARFaceAnchor { self.face = faceAnchor }
        
        if self.isSmiling() {
            return .smiling
        } else if self.isFrowning() {
            return .frowning
        } else if self.isWinking() {
            return .winking
        } else if self.isStickingTongueOut() {
            return .tongue_out
        } else if self.isSurprised() {
            return .surprised
        }
        return .neutral
    }
    
    private func isSmiling() -> Bool {
        guard let smileLeft = self.face?.blendShapes[.mouthSmileLeft], let smileRight = self.face?.blendShapes[.mouthSmileRight] else { return false }
        return smileLeft.floatValue > SMILE_LEFT_VALUE && smileRight.floatValue > SMILE_RIGHT_VALUE
    }
    
    private func isWinking() -> Bool {
        guard let eyeBlinkLeft = self.face?.blendShapes[.eyeBlinkLeft], let eyeBlinkRight = self.face?.blendShapes[.eyeBlinkRight] else { return false }
        return (eyeBlinkLeft.floatValue > BLINK_VALUE && eyeBlinkRight.floatValue < OPEN_EYE) || (eyeBlinkRight.floatValue > BLINK_VALUE && eyeBlinkLeft.floatValue < OPEN_EYE)
    }
    
    private func isStickingTongueOut() -> Bool {
        guard let tongue = self.face?.blendShapes[.tongueOut] else { return false }
        return tongue.floatValue > TONGUE_VALUE
    }
    
    private func isSurprised() -> Bool {
        guard let eyebrowsRaised = self.face?.blendShapes[.browInnerUp] else { return false }
        return eyebrowsRaised.floatValue > EYEBROW_VALUE
    }
    
    func isFaceTracked() -> Bool {
        if let isFaceTracked = self.face?.isTracked {
            return isFaceTracked
        }
        return false
    }
    
    private func isFrowning() -> Bool {
        guard let frownLeft = self.face?.blendShapes[.mouthFrownLeft], let frownRight = self.face?.blendShapes[.mouthFrownRight] else { return false }
        return frownLeft.floatValue > FROWN_LEFT_VALUE && frownRight.floatValue > FROWN_RIGHT_VALUE
    }
}
#endif
