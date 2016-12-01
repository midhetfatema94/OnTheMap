//
//  ViewController.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 28/11/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit
import FacebookLogin

class ViewController: UIViewController {

    @IBOutlet weak var signUpStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [.publicProfile])
//        loginButton.center = view.center
        signUpStack.addArrangedSubview(loginButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

