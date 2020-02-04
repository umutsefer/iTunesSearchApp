//
//  BaseVC.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 8.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import UIKit


/// Navigation Type Adjusts Custom Navigation Controller Buttons
///
/// - none: Hides navigation bar
/// - rightFilter: Adds a "Filter" button to the right side of the navigation bar
/// - rightDone: Adds a "Done" button to the right side of the navigation bar
/// - leftBackAndRightDelete: Adds a "Delete" button to the right side of the navigation bar. And still back button is shown.

enum NavigationType {
    case none
    case rightFilter
    case rightDone
    case leftBackAndRightDelete
}


/// Base Class of all view controllers
class BaseVC: UIViewController {

    var navigationType: NavigationType = .none {
        didSet {
            setNavigationItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    /// Overrides from all sub classes for adjusting some UI changes.
    func setupUI() {}
    
    
    /// Sets navigation bar buttons
    func setNavigationItems() {
        switch navigationType {
            
            case .none:
                navigationController?.setNavigationBarHidden(true, animated: true)

            case .rightFilter:
                navigationItem.setRightBarButton(createRightBarButtonItem(title: AppStrings.filter.rawValue), animated: true)
            
            case .rightDone:
                navigationItem.setRightBarButton(createRightBarButtonItem(title: AppStrings.done.rawValue), animated: true)

            case .leftBackAndRightDelete:
                navigationItem.setRightBarButton(createRightBarButtonItem(title: AppStrings.delete.rawValue), animated: true)
        }
    }
    
    
    /// Creates a custom UIBarButton
    ///
    /// - Parameter title: Title for button
    /// - Returns: Returns setted a UIBarButton
    func createRightBarButtonItem (title: String) -> UIBarButtonItem {
        
        let rightButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(rightButtonClicked(sender:)))
        navigationItem.setRightBarButton(rightButton, animated: true)
        return rightButton
    }
    
    
    /// Action of the custom right navigation button.
    ///
    /// - Parameter sender: sender
    @objc func rightButtonClicked(sender: UIBarButtonItem) {}
    
    
}
