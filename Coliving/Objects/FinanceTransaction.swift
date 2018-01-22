//
//  FinanceTransaction.swift
//  Coliving
//
//  Created by Andressa Aquino on 18/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class FinanceTransaction: NSObject {

	var id: String?
	var title: String
	var name: String
	var	value: Double
	var category: CategoryEnum
	var date: Date

	init(id: String?, title: String, name: String, value: Double, category: CategoryEnum, date: Date) {

		self.id = id
		self.title = title
		self.name = name
		self.value = value
		self.category = category
		self.date = date
	}

}
