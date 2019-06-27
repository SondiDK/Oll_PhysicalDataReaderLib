# Oll_PhysicalDataReaderLib
My cocoapod 

install
pod 'PhysicalDataReaderLib'

import PhysicalDataReaderLib


How to use Face:

Create instance of the FaceController:

```private var fc = FaceController()```

call setup & start:

```self.facecontroller.setup(delegate: self)```
```self.facecontroller.startSession()```

Implement facedelegate:


```extension Viewcontroller: FaceDelegate {
     func detectExpression(expression: FaceState) {
       //acces the current expression 
    }
    
   func didDetectFace(detected: Bool) {
    //lets you know if face is detected
    }```
