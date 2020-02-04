//
//  CacheManager.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 11.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import Foundation


/// Enum for the deleted contents and visited contents file names.
enum CacheKeys: String {
    case deletedContentsArray = "CK_AAA"
    case visitedContentsArray = "CK_AAB"
    
    var fileUrl: URL {
        return FileManager.dataDirectory.appendingPathComponent(self.rawValue, isDirectory: false)
    }
}


/// Cache Manager writes or read datas to the file.
class CacheManager {
    
    static let shared = CacheManager()
    private init() {}

    private var cachedValues = [String:Any]()
    
    // MARK: Internal Methods
    func value<T:Decodable>(forKey key:CacheKeys) -> T? {
        if let value = cachedValues[key.rawValue] {
            return value as? T
        }
        else {
            if FileManager.fileExists(atUrl: key.fileUrl) {
                do  {
                    let data = try Data(contentsOf: key.fileUrl)
                    let value = try JSONDecoder().decode(T.self, from: data)
                    cachedValues[key.rawValue] = value
                    return value
                }
                catch {
                    print("decoding file error \(error)")
                    return nil
                }
            }
            else {
                return nil
            }
        }
    }
    
    func setValue<T:Encodable>(_ value:T?, forKey key:CacheKeys) {
        cachedValues[key.rawValue] = value
        guard let value = value else {
            try? FileManager.default.removeItem(at: key.fileUrl)
            return
        }
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: key.fileUrl)
        }
        catch {
            print("writing/encoding file error \(error)")
        }
    }
}
