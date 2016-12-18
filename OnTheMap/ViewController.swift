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

class ViewController: UIViewController, LoginButtonDelegate, UITextFieldDelegate {

    @IBOutlet weak var signUpStack: UIStackView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var accessTkn: AccessToken!
    let loginManager = LoginManager()
    var loginButton: LoginButton!
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        request.loginUserUdacity(username: emailField.text!, password: passwordField.text!, controller: self, completion: {response in
            
            DispatchQueue.main.async {
                
                if response["status"] != nil {
                    
                    print("response error!")
                    helper.giveErrorAlerts(response: response, vc: self)
                    
                }
                else if let error = response["error"] as? String {
                    
                    print("response error: \(error)")
                    helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error, vc: self)
                }
                else if response != nil {
                    
                    DispatchQueue.main.async(execute: {
                        
                        print("pushing map vc")
                        self.goToMap(response: response)
                    })
                }
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        
        mainNav = self.navigationController!
        
        loginButton = LoginButton(readPermissions: [.publicProfile])
        signUpStack.addArrangedSubview(loginButton)
        
        if let accessToken = AccessToken.current {
            
            accessTkn = accessToken
        }
        
        loginButton.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        loginManager.logOut()
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        switch result {
        case .cancelled:
            print("cancelled login")
            break
        case .failed(let error):
            print("login failed: \(error)")
            helper.giveErrorAlerts(errorString: "Login Failed!", errorMessage: error.localizedDescription, vc: self)
            break
        case .success(grantedPermissions: _, declinedPermissions: _, token: let accesstoken):
            print("login successful!")
            getFBDetails(accessToken: accesstoken)
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getFBDetails(accessToken: AccessToken) {
        
        request.loginUserFb(accessToken: accessToken.authenticationToken, controller: self, completion: {response in
            
            DispatchQueue.main.async {
                
                if let error = response["error"] as? String {
                    
                    print("response error: \(error)")
                    helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error, vc: self)
                }
                else if response["session"] != nil {
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.goToMap(response: response)
                    })
                }
                else {
                    
                    print("response error!")
                    helper.giveErrorAlerts(response: response, vc: self)
                }
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
        print("logged out")
    }
    
    func goToMap(response: [String: Any]) {
        
        currentUser = response
        let tabVC = self.storyboard!.instantiateViewController(withIdentifier: "tabBar")
        self.navigationController!.pushViewController(tabVC, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
}

