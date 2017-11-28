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
    
    init(item: RedditItem)
    {
        self.id = item.id;
        self.thumnailURL = item.thumbnailURL
        self.thumbnailWidth = item.thumbnailWidth
        self.thumbnailHeight = item.thumbnailHeight
        self.author = item.author
        self.title = item.title
    }
    
    func redditCommentsViewModel() -> RedditCommentsViewModel
    {
        return RedditCommentsViewModel(itemViewModel: self)
    }
}
