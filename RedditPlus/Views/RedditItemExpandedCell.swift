//
//  RedditItemExpandedCell.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class RedditItemExpandedCell: UITableViewCell
{
    var imgView: UIImageView!
    var authorLabel: UILabel!
    var titleLabel: UILabel!
    let imageSide:CGFloat = 80.0
    let xPadding:CGFloat = 10.0
    let yPadding:CGFloat = 5.0
    var imageWidthConstraint : NSLayoutConstraint!
    var imageHeightConstraint : NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
        self.imgView = imageView
        contentView.addSubview(imageView)
        
        let authorlabel = UILabel.init()
        authorlabel.font = UIFont.systemFont(ofSize: 12)
        authorlabel.textColor = UIColor.lightGray
        self.authorLabel = authorlabel
        contentView.addSubview(authorlabel)
        
        let titlelabel = UILabel.init()
        titlelabel.font = UIFont.systemFont(ofSize: 15)
        titlelabel.numberOfLines = 0
        titlelabel.textColor = UIColor.black
        self.titleLabel = titlelabel
        contentView.addSubview(titlelabel)
        
    
        authorlabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint.init(item: self.authorLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.authorLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.authorLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: yPadding))
        
        
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint.init(item: self.titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.authorLabel, attribute: .leading, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: authorLabel, attribute: .bottom, multiplier: 1.0, constant: yPadding*0.2))
        
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint.init(item: self.imgView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.imgView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.imgView, attribute: .top, relatedBy: .equal, toItem: titlelabel, attribute: .bottom, multiplier: 1.0, constant: yPadding*0.2))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.imgView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -yPadding))
        
        imageWidthConstraint = NSLayoutConstraint.init(item: self.imgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: imageSide)
        contentView.addConstraint(imageWidthConstraint)
        
        imageHeightConstraint = NSLayoutConstraint.init(item: self.imgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: imageSide)
        imageHeightConstraint.priority = .defaultHigh
        imageHeightConstraint.isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel(_ item : RedditItemViewModel)
    {
        authorLabel.text = item.author
        titleLabel.text = item.title
        
        if let url = item.thumnailURL
        {
            let aspectRatio:CGFloat = item.thumbnailHeight!/item.thumbnailWidth!
            let width = contentView.bounds.size.width - 2*xPadding
            let height = width*aspectRatio
            imageWidthConstraint.constant = width
            imageHeightConstraint.constant = height
            imgView.layer.borderWidth = 1.0
            imgView?.sd_setImageWithPreviousCachedImage(with: url, placeholderImage: nil, options: SDWebImageOptions.cacheMemoryOnly, progress: nil, completed: nil)
        }
        else
        {
            imgView.layer.borderWidth = 0.0
            imgView.image = nil
            imageWidthConstraint.constant = 0
            imageHeightConstraint.constant = 0
        }
        
        contentView.setNeedsLayout()
        
        UIView.animate(withDuration: 0.4) {
            self.contentView.layoutIfNeeded()
        }
        
    }
}
