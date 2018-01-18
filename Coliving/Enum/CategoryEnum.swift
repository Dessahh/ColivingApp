//
//  CategoryEnum.swift
//  Coliving
//
//  Created by Andressa Aquino on 18/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

var categoryArray = ["Rent", "Bills", "Market", "House Fix", "Others"]

enum CategoryEnum {
	case category1
	case category2
	case category3
	case category4
	case category5

	var categoryName: String {
		switch self {
		case.category1:
			return categoryArray[0]
		case.category2:
			return categoryArray[1]
		case.category3:
			return categoryArray[2]
		case.category4:
			return categoryArray[3]
		case.category5:
			return categoryArray[4]
		}
	}
}
