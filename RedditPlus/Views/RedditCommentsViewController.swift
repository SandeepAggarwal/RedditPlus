//
//  RedditCommentsViewController.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

enum RedditCommentsViewControllerSection: Int
{
    case Item = 0
    case Comments
    case TotalSections
}

class RedditCommentsViewController: UIViewController
{
    struct Constants
    {
        static let itemCellIdentifier = "RedditItemCellIdentifier"
        static let commentCellIdentifier = "RedditCommentCellIdentifier"
    }
    
    var viewModel : RedditCommentsViewModel!
    var tableView: UITableView!
    
    init(viewModel : RedditCommentsViewModel)
    {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = viewModel.postTitle
        view.backgroundColor = .white
        
        
        let tableVC = UITableViewController()
        addChildViewController(tableVC)
        view.addSubview(tableVC.view)
        tableView = tableVC.tableView
        customiseTable()
        registerCells()
        tableVC.didMove(toParentViewController: self)
        
        viewModel.delegate = self
        viewModel.loadComments()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

private extension RedditCommentsViewController
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
        tableView.allowsSelection = false
    }
    
    func registerCells()
    {
        tableView.register(RedditItemExpandedCell.self, forCellReuseIdentifier: Constants.itemCellIdentifier)
        tableView.register(RedditCommentCell.self, forCellReuseIdentifier: Constants.commentCellIdentifier)
    }
}

extension RedditCommentsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count = 0
        switch section
        {
            case RedditCommentsViewControllerSection.Item.rawValue:
                count = 1
            break
            
            case RedditCommentsViewControllerSection.Comments.rawValue:
                count = viewModel.numberComments()
            break
        
            default:
            break
        }
        
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RedditCommentsViewControllerSection.TotalSections.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        if section == RedditCommentsViewControllerSection.Item.rawValue
        {
            let cell: RedditItemExpandedCell = tableView.dequeueReusableCell(withIdentifier: Constants.itemCellIdentifier, for: indexPath) as! RedditItemExpandedCell
            cell.bindViewModel(viewModel.itemViewModel)
            return cell
        }
        else
        {
            let index = indexPath.row
            
            let cell: RedditCommentCell = tableView.dequeueReusableCell(withIdentifier: Constants.commentCellIdentifier, for: indexPath) as! RedditCommentCell
            cell.bindViewModel(viewModel.redditCommentViewModel(at: index))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var title: String? = nil
        if section == RedditCommentsViewControllerSection.Comments.rawValue
        {
            title = "Top Comments"
        }
        return title
    }
}

extension RedditCommentsViewController: UITableViewDelegate
{
    
}


extension RedditCommentsViewController: RedditCommentsViewModelDelegate
{
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
    
    func newCommentsAvailable(_ count: Int)
    {
        let totalComments = viewModel.numberComments()
        
        if totalComments > 0
        {
            let lastCount = totalComments - count
            var indexPaths = [IndexPath]()
            for row in 0 ..< count
            {
                indexPaths.append(IndexPath.init(row: lastCount + row, section: RedditCommentsViewControllerSection.Comments.rawValue))
            }
            tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
}
