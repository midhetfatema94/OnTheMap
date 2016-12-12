//
//  ViewController.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 28/11/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FacebookShare
import SwiftyJSON

let request = Model()

class ViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet weak var signUpStack: UIStackView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var accessTkn: AccessToken!
    let loginManager = LoginManager()
    var loginButton: LoginButton!
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        request.loginUserUdacity(username: emailField.text!, password: passwordField.text!, completion: {response in
            
            DispatchQueue.main.async {
                
                if response.error != nil {
                    
                    print("response error: \(response.error?.localizedDescription)")
                }
                else if response != JSON.null {
                    
                    DispatchQueue.main.async(execute: {
                        
                        print("pushing map vc")
                        self.goToMap(response: response)
                    })
                }
                else {
                    
                    print("response error!")
                }
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        
        loginButton = LoginButton(readPermissions: [.publicProfile])
        signUpStack.addArrangedSubview(loginButton)
        
        if let accessToken = AccessToken.current {
            
            accessTkn = accessToken
        }
        
        loginButton.delegate = self
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        switch result {
        case .cancelled:
            print("cancelled login")
            break
        case .failed(let error):
            print("login failed: \(error)")
            break
        case .success(grantedPermissions: let grantedPersmissions, declinedPermissions: let declinedPermission, token: let accesstoken):
            print("login successful!")
            getFBDetails(accessToken: accesstoken)
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getFBDetails(accessToken: AccessToken) {
        
        request.loginUserFb(accessToken: accessToken.authenticationToken, completion: {response in
            
            DispatchQueue.main.async {
                
                if response.error != nil {
                    
                    print("response error: \(response.error?.localizedDescription)")
                }
                else if response["session"] != JSON.null {
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.goToMap(response: response)
                    })
                }
                else {
                    
                    print("response error!")
                }
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
        print("logged out")
    }
    
    func goToMap(response: JSON) {
        
        currentUser = response
        let tabVC = self.storyboard!.instantiateViewController(withIdentifier: "tabBar")
        self.navigationController!.pushViewController(tabVC, animated: true)
    }
}

