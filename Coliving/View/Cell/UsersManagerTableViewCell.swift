//
//  UsersManagerTableViewCell.swift
//  Coliving
//
//  Created by Andressa Aquino on 28/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class UsersManagerTableViewCell: UITableViewCell {

	@IBOutlet weak var admSwitch: UISwitch!
	@IBOutlet weak var admLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
