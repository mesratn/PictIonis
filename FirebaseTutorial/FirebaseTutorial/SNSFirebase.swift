//
//  SNSFirebase.swift
//  FirebaseTutorial
//
//  Created by Nada MESRATI on 30/08/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class SNSFirebase {
    let callbackFromFirebase = "callbackFromFirebase"
    static let sharedInstance = SNSFirebase()
    var chieldAddedHandler = DatabaseHandle()
    
    private init() {
    }
    
    let pathsInLine = NSMutableSet()
    var ref: DatabaseReference = Database.database().reference()
    
    func testUnit(text: String) {
            self.ref.setValue(text)
    }
    
    func addPathToSend(path: SNSPath)->String {
        let firebaseKey = self.ref.childByAutoId()
        pathsInLine.add(firebaseKey)
        firebaseKey.setValue(path.serialize(),
            withCompletionBlock: {
                (error:Error?, ref:DatabaseReference!) in
            if let error = error{
                print("Error saving path to firebase \(error.localizedDescription)")
            } else{
                self.pathsInLine.remove(firebaseKey)
            }
        })
        return firebaseKey.key
    }
    
    func resetValue() {
        self.ref.setValue("")
    }
}
