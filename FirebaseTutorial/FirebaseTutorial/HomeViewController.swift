//
//  HomeViewController.swift
//  FirebaseTutorial
//
//  Created by James Dacombe on 16/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import NKOColorPickerView


class HomeViewController: UIViewController {
 
    var colorPickerView = NKOColorPickerView()
    var currentColor = String()
    var firebase = SNSFirebase.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    @IBAction func clearButton(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.callbackResetDrawing, object: nil)
    }
    
    @IBOutlet weak var drawningView: DrawningView!
    
    @IBOutlet weak var changeColorOutlet: UIButton!
    @IBAction func changeColorButton(_ sender: Any) {
        if changeColorOutlet.titleLabel?.text == "Change Color"{
            let frame = drawningView.frame
            colorPickerView = NKOColorPickerView(frame: frame, color: UIColor.white) { (color:UIColor!) -> Void in
                let myCgColor = color.cgColor
                self.currentColor = CIColor(cgColor: myCgColor).stringRepresentation
            }
            view.addSubview(colorPickerView)
            changeColorOutlet.setTitle("Dismiss", for: .normal)
        } else{
            colorPickerView.removeFromSuperview()
            changeColorOutlet.setTitle("Change Color", for: .normal)
            NotificationCenter.default.post(name: Notification.Name.callbackNewColor, object: nil, userInfo: ["newColor":self.currentColor])
        }
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
