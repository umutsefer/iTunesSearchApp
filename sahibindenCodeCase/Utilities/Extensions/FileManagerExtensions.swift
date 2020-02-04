//
//  FileManagerExtensions.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 11.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import Foundation


// MARK: - Uses for file operations. 
extension FileManager {
    
    @nonobjc static func fileExists(atUrl url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    @nonobjc static var applicationSupportDirectory: URL = {
        let manager = FileManager.default
        var url = try! manager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let appName = ProcessInfo.processInfo.processName
        url = url.appendingPathComponent(appName, isDirectory:true)
        try? manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return url
    }()
    
    @nonobjc static var userDirectory: URL = {
        let manager = FileManager.default
        let url = applicationSupportDirectory.appendingPathComponent("user", isDirectory: true)
        try? manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return url
    }()
    
    @nonobjc static var dataDirectory: URL = {
        let manager = FileManager.default
        let url = FileManager.userDirectory.appendingPathComponent("data", isDirectory:true)
        try? manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return url
    }()
    
}
