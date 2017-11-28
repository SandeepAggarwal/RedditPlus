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

class RedditCommentsViewController: UIViewController
{
    struct Constants
    {
        static let cellIdentifier = "RedditCommentCellIdentifier "
    }
    
    var viewModel : RedditCommentsViewModel!
    var tableView: UITableView!
    var noCommentsLabel:UILabel!
    
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
        
        noCommentsLabel = UILabel()
        noCommentsLabel.font = UIFont.systemFont(ofSize: 18)
        noCommentsLabel.textColor = UIColor.black
        noCommentsLabel.text = "No comments yet"
        noCommentsLabel.isHidden = true
        view.addSubview(noCommentsLabel)
        
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
        
        noCommentsLabel.sizeToFit()
        noCommentsLabel.center = view.center
        
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
        tableView.register(RedditCommentCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
}

extension RedditCommentsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberComments()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        let cell: RedditCommentCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! RedditCommentCell
        cell.bindViewModel(viewModel.redditCommentViewModel(at: index))
        return cell
    }
}

extension RedditCommentsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == viewModel.numberComments() - 1
        {
            viewModel.loadComments()
        }
    }
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
        
        if totalComments == 0
        {
            noCommentsLabel.isHidden = false
        }
        else
        {
            noCommentsLabel.isHidden = true
            let lastCount = totalComments - count
            var indexPaths = [IndexPath]()
            for row in 0 ..< count
            {
                indexPaths.append(IndexPath.init(row: lastCount + row, section: 0))
            }
            tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
}
