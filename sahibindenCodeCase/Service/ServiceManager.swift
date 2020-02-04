//
//  ServiceManager.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 6.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import Foundation

class ServiceManager {
    
    static let shared = ServiceManager()
    
    private init() {}
    
    
    /// It is a generic Request Method. Gives parameters and makes a request call to the given request.
    ///
    /// - Parameters:
    ///   - request: Request Model with setted parameters.
    ///   - loadingOn: Where loading indicator wants to show.
    ///   - completion: Returns an array when returns a successfull response.
    func get (request: RequestCompatible, loadingOn: Any?, completion: @escaping ([ContentModel]) ->()){
        
        do {
            let url = try request.build()
            LoadingManager.shared.addLoading(on: loadingOn)
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                
                LoadingManager.shared.removeLoading()
                
                if err != nil
                {
                    print (err ?? "error")
                    completion([])
                    AlertManager.shared.showMessage(type: .dismiss, message: err?.localizedDescription)
                    return
                }
                
                guard let data = data
                    else {  completion([])
                            return
                        }
                do {
                    
                    let result = try JSONDecoder().decode(BaseResponse.self, from: data)
                    let results = result.results ?? []
                    completion(results)
                    
                } catch let jsonError {
                    
                    print("\(Errors.serialazationError.rawValue) : \(jsonError)")
                    completion([])
                }
                
            }.resume()
        }
        catch {
            print("\(Errors.buildRequestError.rawValue) \(error.localizedDescription)")
            completion([])
        }
    }
    
    func search (request:SearchRequest, loadingOn: Any?, completion: @escaping ([ContentModel]) ->()) {
        get(request: request, loadingOn: loadingOn, completion: completion)
    }
}
