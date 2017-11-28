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
    
    
    func getNewReddits(after: String?, onSuccess: @escaping (([RedditItem], _ after: String?) -> Void), onError: @escaping ((Error) -> Void) )
    {
        var endPoint = Endpoint.base + Endpoint.newReddits
        if let after = after
        {
            endPoint.append("?after=\(after)")
        }
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
                    
                    var after = data_root["after"]
                    if after is NSNull
                    {
                        after = nil
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
                    onSuccess(redditItems,after as? String)
                    return
                }
                else
                {
                    print("empty!!!")
                    onSuccess([],nil)
                    return
                }
            }
        }
        
        task.resume()
    }
    
}
