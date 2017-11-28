//
//  RedditCommentsViewModel.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation

protocol RedditCommentsViewModelDelegate: class
{
    func newCommentsAvailable(_ count: Int)
    func requestStateChanged(_ state: NetworkRequestState)
}

enum NetworkRequestState
{
    case Idle
    case Fetching
    case FetchingCompleted
    case FetchError(Error)
}

class RedditCommentsViewModel
{
    fileprivate var after: String?
    weak var delegate: RedditCommentsViewModelDelegate?
    let postTitle: String
    private let postID: String
    private var comments = [RedditComment]()
    private var requestState:NetworkRequestState = .Idle
    let itemViewModel: RedditItemViewModel
    
    init(itemViewModel: RedditItemViewModel)
    {
        self.itemViewModel = itemViewModel
        self.postID = itemViewModel.id
        self.postTitle = itemViewModel.title
        requestState = .Idle
    }
    
    func numberComments() -> Int {
        return comments.count
    }
    
    func redditCommentViewModel(at index: Int) -> RedditCommentViewModel
    {
        let comment = comments[index]
        return RedditCommentViewModel(id: comment.id,body: comment.body, authorName: comment.authorName, time_utc: comment.created_utc)
    }
    
    func loadComments()
    {
        if case NetworkRequestState.Fetching = requestState
        {
            return
        }
        
        requestState = .Fetching

        delegate?.requestStateChanged(.Fetching)
        NetworkManager.shared.getComments(id: postID, after: after, onSuccess:
        {[weak self] (comments) in
            
            self?.comments.append(contentsOf: comments)
            self?.delegate?.newCommentsAvailable(comments.count)
            self?.requestState = .FetchingCompleted
            self?.delegate?.requestStateChanged(.FetchingCompleted)
        })
        {[weak self] (error) in
            print("error: \(error)")
            self?.requestState = .FetchError(error)
            self?.delegate?.requestStateChanged(.FetchError(error))
        }
    }
}

