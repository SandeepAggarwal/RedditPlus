//
//  RedditCommentViewModel.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation

class RedditCommentViewModel
{
    let id: String
    let body: String
    let authorName: String
    
    init(id: String, body: String, authorName: String)
    {
        self.id = id
        self.body = body
        self.authorName = authorName
    }
}
