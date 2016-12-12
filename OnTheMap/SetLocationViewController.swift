//
//  SetLocationViewController.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 11/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit

class SetLocationViewController: UIViewController {

    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationView: UIView!
    
    @IBAction func findLocation(_ sender: UIButton) {
        
        performSegue(withIdentifier: "addLinkSegue", sender: nil)
//        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelAdd(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findButton.layer.cornerRadius = 5
        
        locationTextField.attributedPlaceholder = NSAttributedString(string:"Enter Your Location Here", attributes:[NSForegroundColorAttributeName: UIColor.white])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isDismissed {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addLinkSegue" {
            
            let findLocVC = segue.destination as! AddLinkViewController
            
            if locationTextField.text != "" && locationTextField.text != "Add Your Location Here" {
                findLocVC.myLocation = locationTextField.text!
            }
        }
    }
}
