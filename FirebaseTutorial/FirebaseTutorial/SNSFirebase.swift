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
    static let sharedInstance = SNSFirebase()
    var chieldAddedHandler = DatabaseHandle()
    let pathsInLine = NSMutableSet()
    var ref: DatabaseReference = Database.database().reference()
    
    private init() {
        chieldAddedHandler = ref.observe(.childAdded, with: { (snapshot: DataSnapshot) in
            let myKey = snapshot.key
            let myValue = snapshot.value as? NSDictionary
            NotificationCenter.default.post(name: Notification.Name.callbackFromFirebase, object: myValue, userInfo: ["send" : myKey])
        })
    }
    
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
    
    func resetValues() {
        self.ref.setValue("")
    }
}
