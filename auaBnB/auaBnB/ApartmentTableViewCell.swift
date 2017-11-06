//
//  ApartmentTableViewCell.swift
//  auaBnB
//
//  Created by Alibek Manabayev on 15.06.16.
//  Copyright © 2016 Alibek Manabayev. All rights reserved.
//

import UIKit

class ApartmentTableViewCell: UITableViewCell {

    @IBOutlet weak var apartmentImageView: UIImageView!
    @IBOutlet weak var apartmentTitleLabel: UILabel!
    @IBOutlet weak var apartmentPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
