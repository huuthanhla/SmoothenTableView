//
//  CoinTableViewCell.swift
//  SmoothenTableView
//
//  Created by MINATO on 9/1/18.
//  Copyright © 2018 MINATO. All rights reserved.
//

import UIKit

class CoinTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCell(with coin: CoinElement) {
        textLabel?.text = coin.name
        detailTextLabel?.text = String(describing: coin.quotes?.usd?.price)
    }
}
