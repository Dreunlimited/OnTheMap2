//
//  ListTableViewCell.swift
//  OnTheMap
//
//  Created by Dandre Ealy on 1/11/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pinImage: UIImageView!
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
