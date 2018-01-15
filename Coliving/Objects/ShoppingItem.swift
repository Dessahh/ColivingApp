//
//  ShoppingItem.swift
//  Coliving
//
//  Created by Andressa Aquino on 15/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class ShoppingItem: NSObject {

	var name: String?
	var id: String?
	var checked: Bool?

	init(name: String, id: String, checked: Bool) {
		self.name = name
		self.id = id
		self.checked = checked
	}

}
