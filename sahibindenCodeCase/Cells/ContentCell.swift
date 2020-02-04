//
//  ContentCell.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 8.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import UIKit

class ContentCell: BaseCollectionViewCell {
    
    @IBOutlet weak var lblContentName: UILabel!
    @IBOutlet weak var imgContentThumbnail: BaseImageView!
    
    
    /// Content will assigned from HomeVC
    var content: ContentModel? {
        
        didSet {
            
            if let trackName = content?.trackName {
                lblContentName.text = trackName
            }
            
            if let thumbnailUrl = content?.artworkUrl100 {
                imgContentThumbnail.loadImageUsingUrl(urlString: thumbnailUrl)
            }
            
            /// Sets cell background color for visited contents.
            if let isVisited = content?.isVisited, isVisited {
                
                backgroundColor = .lightGray
            }
        }
    }
    
    override func prepareForReuse() {
        backgroundColor = .white
    }
}
