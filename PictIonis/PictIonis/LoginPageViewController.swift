//
//  LoginPageViewController.swift
//  PictIonis
//
//  Created by Wildine Anthony on 15/08/2018.
//  Copyright © 2018 etna. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

  @IBOutlet weak var userEmailTextFiel: UITextField!
  @IBOutlet weak var userPasswordTextField: UITextField!
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func LoginButtonPatted(_ sender: Any) {
    let userEmail = userEmailTextFiel.text;
    let userPassword = userPasswordTextField.text;
    
    let userEmailStored = UserDefaults.standard.string(forKey:"userEmail");
    let userPasswordStored = UserDefaults.standard.string(forKey:"userPassword");
    
    if (userEmailStored == userEmail && userPasswordStored == userPassword) {
      //Login is sucessfull
      UserDefaults.standard.bool(forKey: "Is user logged in");
      UserDefaults.standard.synchronize();
      self.dismiss(animated: true, completion: nil);
    }
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
