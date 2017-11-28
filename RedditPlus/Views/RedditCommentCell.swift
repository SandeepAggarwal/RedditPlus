//
//  RedditCommentCell.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class RedditCommentCell: UITableViewCell
{
    var authorLabel: UILabel!
    var dateLabel: UILabel!
    var bodyLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let authorlabel = UILabel.init()
        authorlabel.font = UIFont.boldSystemFont(ofSize: 14)
        authorlabel.textColor = UIColor.lightGray
        self.authorLabel = authorlabel
        contentView.addSubview(authorlabel)
        
        let datelabel = UILabel.init()
        datelabel.font = UIFont.systemFont(ofSize: 14)
        datelabel.textColor = UIColor.lightGray
        self.dateLabel = datelabel
        contentView.addSubview(datelabel)
        
        let bodylabel = UILabel.init()
        bodylabel.font = UIFont.systemFont(ofSize: 15)
        bodylabel.numberOfLines = 0
        bodylabel.textColor = UIColor.black
        self.bodyLabel = bodylabel
        contentView.addSubview(bodylabel)
        
        let xPadding:CGFloat = 10.0
        let yPadding:CGFloat = 5.0
        
        authorlabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint.init(item: self.authorLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.authorLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.authorLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: yPadding))
        
        datelabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint.init(item: self.dateLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.dateLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: yPadding))
        
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint.init(item: self.bodyLabel, attribute: .leading, relatedBy: .equal, toItem: self.authorLabel, attribute: .leading, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.bodyLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.bodyLabel, attribute: .top, relatedBy: .equal, toItem: authorLabel, attribute: .bottom, multiplier: 1.0, constant: yPadding*0.2))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.bodyLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -yPadding))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel(_ comment : RedditCommentViewModel)
    {
        authorLabel.text = comment.authorName
        bodyLabel.text = comment.body
        dateLabel.text = comment.timeAgo
    }
}
