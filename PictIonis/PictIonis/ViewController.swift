//
//  ViewController.swift
//  PictIonis
//
//  Created by Wildine Anthony on 15/08/2018.
//  Copyright © 2018 etna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
    if (!isUserLoggedIn) {
      self.performSegue(withIdentifier: "loginView", sender: self);
    }
  }


}

