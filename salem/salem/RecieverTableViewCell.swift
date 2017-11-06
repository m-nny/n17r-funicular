//
//  RecieverTableViewCell.swift
//  salem
//
//  Created by Alibek Manabayev on 19.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class RecieverTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
