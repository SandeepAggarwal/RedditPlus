//
//  RedditItemsViewModel.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation
import CoreGraphics

protocol RedditItemsViewModelDelegate : class
{
    func newRedditsAvailable(_ count: Int)
    func requestStateChanged(_ state: NetworkRequestState)
}

class RedditItemsViewModel
{
    fileprivate var after: String?
    weak var delegate: RedditItemsViewModelDelegate?
    private var redditItems = [RedditItem]()
    private var requestState:NetworkRequestState = .Idle
   
    func getData()
    {
        loadData()
    }
    
    func numberReddits() -> Int {
        return redditItems.count
    }
    
    func redditItemViewModel(at index: Int) -> RedditItemViewModel
    {
        let item = redditItems[index]
        return RedditItemViewModel(id: item.id, thumnailURL: item.thumbnailURL, thumbnailWidth: item.thumbnailWidth, thumbnailHeight: item.thumnailHeight, author: item.author, title: item.title)
    }
    
    
}

private extension RedditItemsViewModel
{
    func loadData()
    {
        if case NetworkRequestState.Fetching = requestState
        {
            return
        }
        
        requestState = .Fetching
        delegate?.requestStateChanged(.Fetching)
        NetworkManager.shared.getNewReddits(after: after, onSuccess:
        {[weak self] (reddits, next) in
            self?.after = next
            self?.redditItems.append(contentsOf: reddits)
            self?.requestState = .FetchingCompleted
            self?.delegate?.newRedditsAvailable(reddits.count)
            self?.delegate?.requestStateChanged(.FetchingCompleted)
        })
        {[weak self] (error) in
            print("error: \(error)")
            self?.requestState = .FetchError(error)
            self?.delegate?.requestStateChanged(.FetchError(error))
        }
    }
}
