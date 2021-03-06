//
//  RedditComment.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation


struct RedditComment
{
    let id: String
    let body: String
    let authorName: String
    let created_utc: Int
    let after: String?
    
    static func objectFromDictionary(dict: [String:AnyObject], after: String?) -> RedditComment?
    {
        guard let bodyString = dict["body"] as? String else {
            return nil
        }
        
        let id = dict["id"] as! String
        let author = dict["author"] as! String
        let created_at = dict["created_utc"] as! Int
        
        return RedditComment(id: id, body: bodyString, authorName: author, created_utc: created_at, after: after)
    }
}
