//
//  NetworkManager.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation
import AFNetworking
import ResponseDetective

class NetworkManager
{
    struct Endpoint
    {
        static let base = "https://www.reddit.com/"
        static let newReddits = "r/all/new.json"
    }
    
    private let sessionManager: AFURLSessionManager
    
    static let shared: NetworkManager = {
        let configuration = URLSessionConfiguration.default
        ResponseDetective.enable(inConfiguration: configuration)
        let sessionManager = AFURLSessionManager.init(sessionConfiguration: configuration)
        let instance = NetworkManager(sessionManager)
        return instance
    }()
    
    private init(_ sessionManager : AFURLSessionManager)
    {
        self.sessionManager = sessionManager
    }
    
    
    func getNewReddits( onSuccess: @escaping (([RedditItem]) -> Void), onError: @escaping ((Error) -> Void) )
    {
        let endPoint = Endpoint.base + Endpoint.newReddits
        let url = URL.init(string: endPoint)
        let request = URLRequest.init(url: url!)
        
        
        let task = sessionManager.dataTask(with: request)
        { (response, responseObject, error) in
            
            if let error = error
            {
                onError(error)
                return
            }
            else
            {
                if let dictionary = responseObject as? [String:AnyObject]
                {
                    guard let data_root = dictionary["data"] as? [String:AnyObject] else {
                        onError(NSError(domain: "com.RedditPlus", code: 0, userInfo: [NSLocalizedDescriptionKey : "No data"]))
                        return
                    }
                    
                    guard let children = data_root["children"] as? [[String:AnyObject]] else {
                        onError(NSError(domain: "com.RedditPlus", code: 0, userInfo: [NSLocalizedDescriptionKey : "No children"]))
                        return
                    }
                    
                    var redditItems = [RedditItem]()
                    for dict in children
                    {
                        guard let data = dict["data"] as? [String:AnyObject] else {
                            continue
                        }
                        
                        if let item = RedditItem.objectFromDictionary(dict: data)
                        {
                            redditItems.append(item)
                        }
                    }
                    onSuccess(redditItems)
                    return
                }
                else
                {
                    print("empty!!!")
                    onSuccess([])
                    return
                }
            }
        }
        
        task.resume()
    }
    
}
