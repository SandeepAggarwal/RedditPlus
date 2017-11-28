//
//  RedditItemViewModel.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class RedditItemViewModel
{
    let id: String
    let thumnailURL: URL?
    let thumbnailWidth: CGFloat?
    let thumbnailHeight: CGFloat?
    let author: String
    let title: String
    
    init(id: String, thumnailURL: URL?, thumbnailWidth: CGFloat?, thumbnailHeight: CGFloat?, author: String, title: String)
    {
        self.id = id;
        self.thumnailURL = thumnailURL
        self.thumbnailWidth = thumbnailWidth
        self.thumbnailHeight = thumbnailHeight
        self.author = author
        self.title = title
    }
    
    func redditCommentsViewModel() -> RedditCommentsViewModel
    {
        return RedditCommentsViewModel(postID: id, postTitle: title)
    }
}
