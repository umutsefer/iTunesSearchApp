//
//  LoadingManager.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 12.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import Foundation
import UIKit

let loadingIndicatorSize = 50
let loadingIndicatorTopMargin = 150
let loadingIndicatorXPos = (Int(UIScreen.main.bounds.size.width) - loadingIndicatorSize) / 2


/// Shows a loading indicator to the top of the setted component(UIView or UIView of the UIViewController).
class LoadingManager {
    
    static let shared = LoadingManager()
    
    private init () {}

    
    /// Create a loading indiator.
    lazy var loadingIndicator: UIActivityIndicatorView = {
        
        let indicatorView = UIActivityIndicatorView(style: .white)
        indicatorView.frame = CGRect(x: loadingIndicatorXPos, y: loadingIndicatorTopMargin, width: loadingIndicatorSize, height: loadingIndicatorSize)
        indicatorView.startAnimating()
        indicatorView.backgroundColor = .lightGray
        indicatorView.layer.cornerRadius = 4.0
        indicatorView.layer.masksToBounds = true
        return indicatorView
    }()
    
    
    /// Adds a loading to the intended component
    ///
    /// - Parameter component: Where indicator wants to show.
    func addLoading (on component: Any?) {
        
        if let vc = component as? BaseVC {
            vc.view.addSubview(loadingIndicator)
            vc.view.bringSubviewToFront(loadingIndicator)
            
        } else if let view = component as? UIView {
            view.addSubview(loadingIndicator)
            view.bringSubviewToFront(loadingIndicator)
        }
    }
    
    
    /// removes the indicator from view.
    func removeLoading () {
        
        DispatchQueue.main.async {
            self.loadingIndicator.removeFromSuperview()
        }
    }
}
