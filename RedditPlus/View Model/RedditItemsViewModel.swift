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
}

class RedditItemsViewModel
{
    fileprivate var after: String?
    weak var delegate: RedditItemsViewModelDelegate?
    private var redditItems = [RedditItem]()
    private var pendingRequest: Bool = false
   
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
        if pendingRequest
        {
            return
        }
        
        pendingRequest = true
        NetworkManager.shared.getNewReddits(after: after, onSuccess:
        {[weak self] (reddits, next) in
            self?.after = next
            self?.redditItems.append(contentsOf: reddits)
            self?.delegate?.newRedditsAvailable(reddits.count)
            self?.pendingRequest = false
        })
        {[weak self] (error) in
            print("error: \(error)")
            self?.pendingRequest = false
        }
    }
}
