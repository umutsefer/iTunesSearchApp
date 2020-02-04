//
//  AlertManager.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 12.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import Foundation
import UIKit


/// Type of the alert view.
///
/// - dismiss: Provides alert view with a one button for simple messages.
/// - confirmation: Provides a alert view with two buttons for confirmation requests.
enum AlertType {
    case dismiss
    case confirmation
}


/// Callback for alert button handlers.
typealias AlertAction = () -> Void


/// Alertmanager uses for show an alert to the user.
class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    
    
    /// Show Message function calls for show an alert message.
    ///
    /// - Parameters:
    ///   - type: Type of the alert (dismiss or confirmation)
    ///   - title: Title of the alert view
    ///   - message: Message
    ///   - okButtonHandler: A callback for Ok Button. When Ok button taps, returns handler
    ///   - cancelButtonHandler: A callback for Cancel Button. When Cancel button taps, returns handler
    ///   - okButtonTitle: It can be setted for Ok button. It is an optional value. If it is not set takes a default text.
    ///   - cancelButtonTitle: It can be setted for Cancel button. It is an optional value. If it is not set takes a default text.
    
    func showMessage(type: AlertType = .dismiss, title:String? = nil, message: String? = nil, okButtonHandler: AlertAction? = nil, cancelButtonHandler: AlertAction? = nil, okButtonTitle: String? = nil, cancelButtonTitle: String? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonTitle ?? AppStrings.done.rawValue, style: .default, handler: {action in
            okButtonHandler?()
        }))

        if type == .confirmation{
            alert.addAction(UIAlertAction(title: cancelButtonTitle ?? AppStrings.cancel.rawValue, style: .cancel,  handler: {action in
                cancelButtonHandler?()
            }))
        }
        
        if let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            if let topController = nav.topViewController as? BaseVC {
                DispatchQueue.main.async {
                    topController.present(alert, animated: true)
                }
            }
        }
    }
}
