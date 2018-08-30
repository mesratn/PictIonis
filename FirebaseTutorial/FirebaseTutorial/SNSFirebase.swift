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
    let firebase = Database.database().reference()
    
    static let sharedInstance = SNSFirebase()
    
    private init() {}
    
    func testUnit(text: String) {
            firebase.setValue(text)
    }
}
