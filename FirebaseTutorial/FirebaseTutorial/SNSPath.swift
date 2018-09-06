//
//  SNSPath.swift
//  FirebaseTutorial
//
//  Created by Nada MESRATI on 30/08/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

//MARK: SNSPoint Class
class SNSPoint:NSObject{
    var x:CGFloat?
    var y:CGFloat?
    init(point: CGPoint) {
        x = point.x
        y = point.y
    }
}

class SNSPath: NSObject {
    var points:Array<SNSPoint>
    var color:UIColor
    
    init(point:CGPoint, color:UIColor) {
        self.color = color
        self.points = Array<SNSPoint>()
        let newPoint = SNSPoint(point: point)
        points.append(newPoint)
        super.init()
    }
    
    func addPoint(point:CGPoint){
        let newPoint = SNSPoint(point: point)
        points.append(newPoint)
    }
    
    func serialize() -> NSDictionary{
        
        let dictionary = NSMutableDictionary()
        let cgcolor = color.cgColor
        dictionary["color"] = CIColor(cgColor: cgcolor).stringRepresentation
        let pointsOfPath = NSMutableArray()
        for point in points{
            let pointDictionary = NSMutableDictionary()
            pointDictionary["x"] = Int(point.x!)
            pointDictionary["y"] = Int(point.y!)
            pointsOfPath.add(pointDictionary)
        }
        dictionary["points"] = pointsOfPath
        return dictionary
    }
}
