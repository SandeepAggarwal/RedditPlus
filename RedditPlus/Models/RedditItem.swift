//
//  RedditItem.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation
import CoreGraphics

struct RedditItem
{
    let author: String
    let title: String
    let thumbnailURL : URL?
    let thumbnailWidth: CGFloat?
    let thumnailHeight: CGFloat?
    
    static func objectFromDictionary(dict: [String:AnyObject]) -> RedditItem?
    {
        let author = dict["author"] as! String
        let title = dict["title"] as! String
        let thumbnailString = dict["thumbnail"] as? String
        let thumnailWidth = dict["thumbnail_width"] as? CGFloat
        let thumnailHeight = dict["thumbnail_height"] as? CGFloat
        
        var thumbnailURL: URL?
        if let string = thumbnailString
        {
            thumbnailURL = URL.init(string: string)
            if !isValidURL(thumbnailURL)
            {
                thumbnailURL = nil
            }
        }
        
        return RedditItem(author: author, title: title, thumbnailURL: thumbnailURL, thumbnailWidth: thumnailWidth, thumnailHeight: thumnailHeight)
    }
    
}

private extension RedditItem
{
    static func isValidURL(_ url: URL?) -> Bool
    {
        if url?.host != nil
       {
            return true
       }
        
        return false
    }
}
