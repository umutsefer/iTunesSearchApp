//
//  SearchRequest.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 7.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import Foundation

class SearchRequest: RequestCompatible {
    
    var endpoint: Endpoint {
        
        return .search
    }
    
    var limit: String?
    var media: String?
    var term: String
    
    init(term: String) {
        self.term = term
    }
}
