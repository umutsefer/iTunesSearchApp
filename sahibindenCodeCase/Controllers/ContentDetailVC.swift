//
//  ContentDetailVC.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 11.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import UIKit

class ContentDetailVC: BaseVC {

    @IBOutlet private weak var lblContentName: UILabel!
    @IBOutlet private weak var imgContentThumbnail: BaseImageView!
    @IBOutlet private weak var txtViewDescription: UITextView!
    
    
    /// content parameter will be setted from HomeVC
    var content: ContentModel?
    let si_unwindToHome = "SI_UndwindToHome"

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func setupUI() {

        super.setupUI()
        navigationType = .leftBackAndRightDelete
    }
    
    
    func loadData() {
        
        if let trackName = content?.trackName {
            lblContentName.text = trackName
        }
        
        if let thumbnailUrl = content?.artworkUrl100 {
            imgContentThumbnail.loadImageUsingUrl(urlString: thumbnailUrl)
        }
        
        if let desc = content?.longDescription {
            txtViewDescription.text = desc
        }
    }
    
    
    override func rightButtonClicked(sender: UIBarButtonItem) {
        
        AlertManager.shared.showMessage(type: .confirmation, title: AppStrings.alertConfirmTitle.rawValue, message: AppStrings.alertContentDeleteMessage.rawValue, okButtonHandler: {
           
            self.performSegue(withIdentifier: self.si_unwindToHome, sender: nil)
        })
    }
}
