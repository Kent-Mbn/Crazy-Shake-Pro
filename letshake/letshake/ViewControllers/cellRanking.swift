//
//  cellRanking.swift
//  letshake
//
//  Created by CHAU HUYNH on 9/9/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

import UIKit

class cellRanking: UITableViewCell {

    
    //MARK: PROTOTYPE
    @IBOutlet weak var lblStt: UILabel!
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var imvFlag: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var imgMedal: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
