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
    
    var tableView: UITableView!
    var redditItems = [RedditItem]()
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
        
        loadData()
        
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

private extension RedditItemsViewController
{
    func loadData()
    {
        NetworkManager.shared.getNewReddits(onSuccess:
        {[weak self] (reddits) in
            self?.redditItems = reddits
            self?.tableView.reloadData()
        }) { (error) in
            print("error: \(error)")
        }
    }
    
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
        return redditItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = redditItems[indexPath.row]
        
        let cell: RedditItemCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! RedditItemCell
        cell.bindModel(item)
        return cell
    }
}

extension RedditItemsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
