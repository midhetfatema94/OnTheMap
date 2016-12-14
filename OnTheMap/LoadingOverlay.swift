//
//  LoadingOverlay.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 13/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    open class LoadingOverlay {
        
        var overlayView = UIView()
        var activityIndicator = UIActivityIndicatorView()
        
        class var shared: LoadingOverlay {
            struct Static {
                static let instance: LoadingOverlay = LoadingOverlay()
            }
            return Static.instance
        }
        
        func showOverlay(_ view: UIView) {
            
            print("show loader")
            overlayView = UIView(frame: view.frame)
            overlayView.center = view.center
            overlayView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
            overlayView.clipsToBounds = true
            overlayView.layer.cornerRadius = 10
            overlayView.layer.zPosition = 10000
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            activityIndicator.activityIndicatorViewStyle = .whiteLarge
            activityIndicator.center = overlayView.center
            
            overlayView.addSubview(activityIndicator)
            view.addSubview(overlayView)
            
            activityIndicator.startAnimating()
        }
        
        func hideOverlayView() {
            
            print("hide overlay")
            activityIndicator.stopAnimating()
            overlayView.removeFromSuperview()
        }
        
    }
}
