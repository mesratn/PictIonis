//
//  DrawningView.swift
//  FirebaseTutorial
//
//  Created by Nada MESRATI on 29/08/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import Foundation

extension Notification.Name {
    
    static let callbackFromFirebase = Notification.Name("callbackFromFirebase")
    static let callbackResetDrawing = Notification.Name("callbackResetDrawing")
    static let callbackNewColor = Notification.Name("callbackNewColor")
    
}

class DrawningView: UIView {

    var currentTouch:UITouch?
    var currentPath: Array<CGPoint>?
    var currentSNSPath: SNSPath?
    var allPaths = Array<SNSPath>()
    var allKeys = Array<String>()
    var currentColor:UIColor?
    let firebase = SNSFirebase.sharedInstance
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(addFromFirebase(sender:)), name: Notification.Name.callbackFromFirebase, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetDrawing(sender:)), name: Notification.Name.callbackResetDrawing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNewColor(sender:)), name: Notification.Name.callbackNewColor, object: nil)
    }
    
    func recieveNewColor(sender: Notification){
        if let info = sender.userInfo as? Dictionary<String,String> {
            if let stringNewColor = info["newColor"]{
                let myCiColor = CIColor(string: stringNewColor)
                let myUiColor = UIColor(ciColor: myCiColor)
                currentColor = myUiColor
                print("Received new color \(stringNewColor)")
            }
        }
        
    }
    
    func resetDrawing(sender: Notification){
        allKeys.removeAll()
        allPaths.removeAll()
        firebase.resetValues()
        setNeedsDisplay()
        
    }
    
    func addFromFirebase(sender: Notification){
        if let info = sender.userInfo {
            let key = info["send"]
            let data = sender.object as! NSDictionary
            print("DATA : ", data)
            let firebaseKey = key as! String
            if !allKeys.contains(firebaseKey){
                let points = data.value(forKey: "points") as! NSArray
                let myColor = data.value(forKey: "color")
                print("My Color :", myColor)
                let mySColor = "\(String(describing: myColor))"
                let myCiColor = CIColor(string: mySColor as! String)
                let myUiColor = UIColor(ciColor: myCiColor)
                print("My SColor :", mySColor)
                print("My CIColor :", myCiColor)
                print("My UIColor :", myUiColor)
                

                let firstPoint = points.firstObject! as! NSDictionary
                let currentPoint = CGPoint(x: firstPoint.value(forKey: "x") as! Double, y: firstPoint.value(forKey: "y") as! Double)
                currentSNSPath = SNSPath(point: currentPoint, color: myUiColor)
                for point in points{
                    let point = point as! NSDictionary
                    let p = CGPoint(x: point.value(forKey: "x") as! Double, y: point.value(forKey: "y") as! Double)
                    currentSNSPath?.addPoint(point: p)
                }
                resetPatch(sendToFirebase: false)
                setNeedsDisplay()
            }
            
        }
    }
    
    
    //MARK: Drawning functions
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        if let context = context {
            context.setLineWidth(1.5)
            context.beginPath()
            
            for path in allPaths {
                let pathArray = path.points
                let color = path.color
                context.setStrokeColor(color.cgColor)
                if let firstPoint = pathArray.first {
                    context.move(to: CGPoint.init(x: firstPoint.x!, y: firstPoint.y!))
                    if (pathArray.count > 1) {
                        for index in 1...pathArray.count - 1{
                            let currentPoint = pathArray[index]
                            context.addLine(to: CGPoint.init(x: currentPoint.x!, y: currentPoint.y!))
                        }
                    }
                    context.drawPath(using: CGPathDrawingMode.stroke)
                }
            }
            
            if let firstPoint = currentPath?.first {
                context.move(to: firstPoint)
                if (currentPath!.count > 1) {
                    for index in 1...currentPath!.count - 1{
                        let currentPoint = currentPath![index]
                        context.addLine(to: currentPoint)
                    }
                }
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
        }
        

    }
    
    //MARK: Touch functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //currentColor = UIColor.black //FIXME
        if (currentPath == nil) {
            currentTouch = UITouch()
            currentTouch = touches.first
            let currentPoint = currentTouch?.location(in: self)
            if let currentPoint = currentPoint {
                currentPath = Array<CGPoint>()
                currentPath?.append(currentPoint)
                if let currentColor = self.currentColor {
                    currentSNSPath = SNSPath(point: currentPoint, color: currentColor)
                } else {
                    currentSNSPath = SNSPath(point: currentPoint, color: UIColor.red)
                }
            } else {
                print("Find an empty touch")
            }
        }
        setNeedsDisplay()
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        addTouch(touches: touches)
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetPatch(sendToFirebase: true)
        setNeedsDisplay()
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        addTouch(touches: touches)
        resetPatch(sendToFirebase: true)
        super.touchesEnded(touches, with: event)
    }
    
    func resetPatch(sendToFirebase:Bool) {
        currentTouch = nil
        currentPath = nil
        if let pathToSend = currentSNSPath {
            if sendToFirebase{
                let returnKey = firebase.addPathToSend(path: pathToSend)
                allKeys.append(returnKey)
            }
            allPaths.append(pathToSend)
        }
    }
    
    func addTouch(touches: Set<UITouch>) {
        if (currentPath != nil) {
            for touch in touches {
                if (currentTouch == touch){
                    let currentPoint = currentTouch?.location(in: self)
                    if let currentPoint = currentPoint{
                        currentPath?.append(currentPoint)
                        currentSNSPath?.addPoint(point: currentPoint)
                    } else{
                        print("Find an empty touch")
                    }
                }
            }
        }
        setNeedsDisplay()
    }

}
