//
//  RedditItemsViewController.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation
import UIKit

class RedditItemsViewController: UIViewController
{
    struct Constants
    {
        static let cellIdentifier = "RedditcellIdentifier "
    }
    
    let viewModel = RedditItemsViewModel()
    var tableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        title = "Reddit Plus"
        
        let tableVC = UITableViewController()
        addChildViewController(tableVC)
        view.addSubview(tableVC.view)
        tableView = tableVC.tableView
        customiseTable()
        registerCells()
        tableVC.didMove(toParentViewController: self)
        
        viewModel.delegate = self
        viewModel.getData()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

private extension RedditItemsViewController
{
    func customiseTable()
    {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
    }
    
    func registerCells()
    {
        tableView.register(RedditItemCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
}

extension RedditItemsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberReddits()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let url = viewModel.imageURLForItem(at: index)
        let thumbnailWidth = viewModel.thumbnailWidthForItem(at: index)
        let thumbnailHeight = viewModel.thumbnailHeightForItem(at: index)
        let author = viewModel.authorNameForItem(at: index)
        let title = viewModel.titleForItem(at: index)
        
        let cell: RedditItemCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! RedditItemCell
        cell.bindModel(url: url, thumbWidth: thumbnailWidth, thumbHeight: thumbnailHeight , author: author,title: title)
        return cell
    }
}

extension RedditItemsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == viewModel.numberReddits() - 1
        {
            viewModel.getData()
        }
    }
}

extension RedditItemsViewController: RedditItemsViewModelDelegate
{
    func newRedditsAvailable(_ count: Int)
    {
        let lastCount = viewModel.numberReddits() - count
        var indexPaths = [IndexPath]()
        for row in 0 ..< count
        {
            indexPaths.append(IndexPath.init(row: lastCount + row, section: 0))
        }
        tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
    }
}
