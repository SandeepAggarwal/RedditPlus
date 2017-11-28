//
//  RedditItemCell.swift
//  RedditPlus
//
//  Created by Sandeep Aggarwal on 28/11/17.
//  Copyright © 2017 CMM. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class RedditItemCell: UITableViewCell
{
    var imgView: UIImageView!
    var authorLabel: UILabel!
    var titleLabel: UILabel!
    let imageSide:CGFloat = 80.0
    var imageWidthConstraint : NSLayoutConstraint!
    
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
        
        
        let xPadding:CGFloat = 10.0
        let yPadding:CGFloat = 5.0
        
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint.init(item: self.imgView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.imgView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: yPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.imgView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -yPadding))
        
        
        imageWidthConstraint = NSLayoutConstraint.init(item: self.imgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: imageSide)
        contentView.addConstraint(imageWidthConstraint)
        
        let heightconstarint = NSLayoutConstraint.init(item: self.imgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: imageSide)
        heightconstarint.priority = .defaultHigh
        heightconstarint.isActive = true
        
        authorlabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint.init(item: self.authorLabel, attribute: .leading, relatedBy: .equal, toItem: self.imgView, attribute: .trailing, multiplier: 1.0, constant: xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.authorLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.authorLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0))
        
        
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint.init(item: self.titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.authorLabel, attribute: .leading, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -xPadding))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: authorLabel, attribute: .bottom, multiplier: 1.0, constant: yPadding*0.2))
        contentView.addConstraint(NSLayoutConstraint.init(item: self.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -yPadding))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindModel(url: URL?, thumbWidth: CGFloat?, thumbHeight: CGFloat?, author: String, title: String)
    {
        authorLabel.text = author
        titleLabel.text = title
        
        if let url = url
        {
            let aspectRatio:CGFloat = thumbHeight!/thumbWidth!
            imageWidthConstraint.constant = min(imageSide/aspectRatio, bounds.size.width*0.5)
            imgView.layer.borderWidth = 1.0
            imgView?.sd_setImageWithPreviousCachedImage(with: url, placeholderImage: nil, options: SDWebImageOptions.cacheMemoryOnly, progress: nil, completed: nil)
        }
        else
        {
            imgView.layer.borderWidth = 0.0
            imgView.image = nil
            imageWidthConstraint.constant = 0
        }
        
        contentView.setNeedsLayout()
        
        UIView.animate(withDuration: 0.4) {
            self.contentView.layoutIfNeeded()
        }
        
    }
}
