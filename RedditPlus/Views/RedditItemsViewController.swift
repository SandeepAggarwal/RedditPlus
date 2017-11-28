//
//  RedditItemsViewController.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

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
        view.backgroundColor = .white
        
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
        
        let cell: RedditItemCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! RedditItemCell
        cell.bindViewModel(viewModel.redditItemViewModel(at: index))
        return cell
    }
}

extension RedditItemsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = indexPath.row
        
        let vc = RedditCommentsViewController(viewModel: viewModel.redditItemViewModel(at: index).redditCommentsViewModel())
        show(vc, sender: nil)
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
    
    func requestStateChanged(_ state: NetworkRequestState)
    {
        switch state
        {
        case .Idle:
            break
            
        case .Fetching:
            SVProgressHUD.show()
            break
            
        case .FetchingCompleted:
            SVProgressHUD.dismiss()
            break
            
        case .FetchError(_):
            SVProgressHUD.dismiss()
            break
        }
    }
}
