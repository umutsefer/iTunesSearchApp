//
//  RequestCompatible.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 7.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import Foundation

protocol RequestCompatible: Codable {
    var endpoint: Endpoint { get }
}

extension RequestCompatible {
    
    
    /// Builds a request url with request parameters.
    ///
    /// - Returns: Returns a URL object which contains all of the request.
    /// - Throws: Throws when an error occures.
    func build() throws -> URL {

        var urlString: String = ""
      
        /// Parameters convert to the dictionary to add url as a parameter.
        if let parameters = self.dictionary {
            for (key, value) in parameters {
                urlString.append("&\(key)=\(value)")
            }
        }
        
        guard let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { throw Errors.urlNotConvertable }
        let baseUrlString = ServiceConfig.baseServiceUrl + endpoint.rawValue + "?" + encodedUrl
        guard let url = URL(string: baseUrlString) else { throw Errors.urlNotConvertable }
        return url
    }
}


//https://stackoverflow.com/questions/45209743/how-can-i-use-swift-s-codable-to-encode-into-a-dictionary

// MARK: - This extension converts a data model struct to a dictionary.
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
