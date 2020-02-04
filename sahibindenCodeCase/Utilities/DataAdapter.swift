//
//  DataAdapter.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 11.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import Foundation


/// Provides a bridge between cache mechanism and UI.
class DataAdapter {
    
    static let shared = DataAdapter()
    private init() {}
    
    
    /// Reads all visited contents identifiers from file through CacheManager
    ///
    /// - Returns: Returns trackId List. It means this content(Ids) visited before.
    func getVisitedContentsIdList () -> [Double] {
        
        guard let visitedContentIds: [Double] = CacheManager.shared.value(forKey: .visitedContentsArray) else { return [] }
        return visitedContentIds
    }
    
    /// Reads all deleted contents identifiers from file through CacheManager
    ///
    /// - Returns: Returns trackId List. It means this content(Ids) deleted before.

    func getDeletedContentsIdList () -> [Double] {
        
        guard let deletedContentIds: [Double] = CacheManager.shared.value(forKey: .deletedContentsArray) else { return [] }
        return deletedContentIds
    }
    
    
    /// Returns an array which contains all visited content models by a flag
    ///
    /// - Parameter contents: Contents from web service
    /// - Returns: An array contains all contents and visited flag with them.
    func getVisitedContentsList (contents: [ContentModel]) -> [ContentModel] {
        
        let visitedContentIds = getVisitedContentsIdList()
        
        var contents = contents
        
        for index in 0..<contents.count {
            if visitedContentIds.contains(where: ({$0 == contents[index].trackId})) {
                contents[index].isVisited = true
            }
        }
        
        return contents
        
    }
    
    /// Filters data source by deleted Ids and returns an array which contains content models.
    ///
    /// - Parameter contents: Contents from web service
    /// - Returns: An array filtered from deleted contents.

    func getDeletedContentsList (contents: [ContentModel]) -> [ContentModel] {
        
        var contents = contents
        
        let deletedContentIds = getDeletedContentsIdList()
        
        for trackId in deletedContentIds {
            contents = contents.filter({$0.trackId != trackId})
        }
        
        return contents
    }
    
    
    /// Returnes a clean array which quitted from deleted items and contains flagged as visited Content Models.
    ///
    /// - Parameter contents: Contents from web service
    /// - Returns: A clean array for UI.
    func getFilteredList (contents: [ContentModel]) -> [ContentModel] {
        
        //visited Ids marked as visited
        let visitedMarked = getVisitedContentsList(contents: contents)
        
        //deleted Ids filtered from base array
        let filtered = getDeletedContentsList(contents: visitedMarked)
        
        //return clean and filtered array for data source
        return filtered
    }
    
    
    /// Add file a viaited content's trackId
    ///
    /// - Parameter content: Model of visited content.
    func addContentForVisited (content: ContentModel) {
        
       addContent(forList: .visitedContentsArray, content: content)
    }
    
    /// Add file a deleted content's trackId
    ///
    /// - Parameter content: Model of deleted content.
    func addContentForDeleted (content: ContentModel) {
        
      addContent(forList: .deletedContentsArray, content: content)
    }
    
    func addContent(forList: CacheKeys, content: ContentModel){
        
        guard let trackId = content.trackId else { return }
        
        var existsContentIds:[Double] = []
        
        switch forList {
            case .visitedContentsArray:
                existsContentIds = getVisitedContentsIdList()
      
            case .deletedContentsArray:
                existsContentIds = getDeletedContentsIdList()
        }
        
        if !existsContentIds.contains(where: ({$0 == content.trackId})) {
            
            existsContentIds.append(trackId)
        }
        
        CacheManager.shared.setValue(existsContentIds, forKey: forList)
        
    }
}
