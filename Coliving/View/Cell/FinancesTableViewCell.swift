//
//  FinancesTableViewCell.swift
//  Coliving
//
//  Created by Andressa Aquino on 17/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class FinancesTableViewCell: UITableViewCell {

	@IBOutlet weak var responsableLabel: UILabel!
	@IBOutlet weak var subjectLabel: UILabel!
	@IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
