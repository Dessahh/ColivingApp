//
//  ShoppingListTableViewCell.swift
//  Coliving
//
//  Created by Andressa Aquino on 15/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {

	@IBOutlet weak var itemLabel: UILabel!

	@IBOutlet weak var checkBox: BEMCheckBox!

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
