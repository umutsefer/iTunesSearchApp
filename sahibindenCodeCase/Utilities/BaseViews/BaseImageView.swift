//
//  BaseImageView.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 11.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

/// Base ImageView for all UIIMageView objects. It provides a image view which can load and cached from a url.
class BaseImageView: UIImageView {

    var imageUrlString: String?
    
    func loadImageUsingUrl(urlString: String) {
        
        guard let url = URL(string: urlString) else {
            image = nil
            return
        }
        
        
        /// Bring Image from cache if it is exists.
        if let imageFromCache = imageCache.object(forKey: (urlString as AnyObject) as! NSString) {
            
            self.image = imageFromCache
            
            return
        }
        
        imageUrlString = urlString
        image = nil
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil
            {
                print(error!)
                return
            }
            
            guard let data = data, let imageToCache = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else { return }
                
                
                if strongSelf.imageUrlString == urlString {
                    strongSelf.image = imageToCache
                }
                
                imageCache.setObject(imageToCache, forKey: (urlString as AnyObject) as! NSString)
            }
            
        }.resume()
    }
}
