//
//  NewsTableViewCell.swift
//  SmoothenTableView
//
//  Created by MINATO on 9/2/18.
//  Copyright © 2018 MINATO. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with news: News?) {
        textLabel?.text = news?.title
        detailTextLabel?.text = news?.url
    }
    
    func truncateCell() {
        textLabel?.text = "Loading..."
        detailTextLabel?.text = "Loading..."
    }

}
