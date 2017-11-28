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
    enum Endpoint
    {
        case  base
        case newReddits
        case comments(id: String)
        
        var rawValue: String
        {
            switch self
            {
                case .base:
                    return "https://www.reddit.com/"
                
                case .newReddits:
                    return "r/all/new.json"
                
                case .comments(let id):
                    return "r/all/comments/\(id).json"
            }
        }
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
        var endPoint = Endpoint.base.rawValue + Endpoint.newReddits.rawValue
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
    
    func getComments(id: String, after: String?, onSuccess: @escaping (([RedditComment]) -> Void), onError: @escaping ((Error) -> Void))
    {
        var endPoint = Endpoint.base.rawValue + Endpoint.comments(id: id).rawValue
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
                if let array = responseObject as? [[String:AnyObject]]
                {
                    var redditComments = [RedditComment]()
                    for dictionary in array
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
                        
                        for dict in children
                        {
                            guard let data = dict["data"] as? [String:AnyObject] else {
                                continue
                            }
                            
                            if let comment = RedditComment.objectFromDictionary(dict: data, after: after as? String)
                            {
                                redditComments.append(comment)
                            }
                        }
                    }
                    
                    onSuccess(redditComments)
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
