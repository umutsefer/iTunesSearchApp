//
//  ServiceConstants.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 7.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import Foundation

enum ServiceConfig {
    
    static let baseServiceUrl = "https://itunes.apple.com/"
    
}

enum Endpoint: String {
    case search = "search"
    case lookup = "lookup"
}

enum Errors: String, Error {
    
    case urlNotConvertable = "Url was given not convertable"
    case serialazationError = "Serialazation error"
    case buildRequestError = "Request build error"
}

