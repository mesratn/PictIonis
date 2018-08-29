//
//  DrawningView.swift
//  FirebaseTutorial
//
//  Created by Nada MESRATI on 29/08/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class DrawningView: UIView {

    var currentTouch:UITouch?
    var currentPath: Array<CGPoint>?
    
    //MARK: Drawning functions
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if (currentPath != nil) {
            let context = UIGraphicsGetCurrentContext()
            if let context = context {
                context.setLineWidth(1.5)
                context.beginPath()
                context.setStrokeColor(UIColor.black.cgColor)
                if let firstPoint = currentPath?.first {
                    context.move(to: firstPoint)
                    if (currentPath!.count > 1) {
                        for index in 1...currentPath!.count - 1{
                            let currentPoint = currentPath![index]
                            context.addLine(to: currentPoint)
                        }
                    }
                    context.drawPath(using: CGPathDrawingMode.stroke)
                    print(" --> did draw line in context")
                }
            }
        }
    }
    
    //MARK: Touch functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (currentPath == nil) {
            currentTouch = UITouch()
            currentTouch = touches.first
            let currentPoint = currentTouch?.location(in: self)
            if let currentPoint = currentPoint {
                currentPath = Array<CGPoint>()
                currentPath?.append(currentPoint)
                print("Start a new path with point \(currentPoint)")
            } else {
                print("Find an empty touch")
            }
        }
        setNeedsDisplay()
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        addTouch(touches: touches)
        setNeedsDisplay()
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTouch = nil
        currentPath = nil
        print("Touch cancelled")
        setNeedsDisplay()
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (currentPath != nil) {
            for touch in touches {
                if (currentTouch == touch){
                    let currentPoint = currentTouch?.location(in: self)
                    if let currentPoint = currentPoint{
                        currentPath?.append(currentPoint)
                        print("End path with point \(currentPoint)")
                    } else{
                        print("Find an empty touch")
                    }
                }
            }
        }
        setNeedsDisplay()
        currentTouch = nil
        currentPath = nil
        super.touchesEnded(touches, with: event)
    }
    
    func addTouch(touches: Set<UITouch>) {
        if (currentPath != nil) {
            for touch in touches {
                if (currentTouch == touch){
                    let currentPoint = currentTouch?.location(in: self)
                    if let currentPoint = currentPoint{
                        currentPath?.append(currentPoint)
                        print("Append a new path with point \(currentPoint)")
                    } else{
                        print("Find an empty touch")
                    }
                }
            }
        }
    }

}
