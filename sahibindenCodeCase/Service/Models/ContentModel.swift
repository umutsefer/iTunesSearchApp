//
//  ContentModel.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 7.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import Foundation

struct ContentModel: ModelCompatible {
    
    var wrapperType: String?
    var kind: String?
    var trackId: Double?
    var artistName: String?
    var trackName: String?
    var artworkUrl100: String?
    var longDescription: String?
    
    //custom parameters
    var isVisited: Bool?
    
}
