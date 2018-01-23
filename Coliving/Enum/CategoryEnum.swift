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
	case All

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
		case.All:
			return "All"
		}
	}

	var color: UIColor {
		switch self {
		case.category1:
			return UIColor(red:0.00, green:1.00, blue:0.20, alpha:1.0)
		case.category2:
			return UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
		case.category3:
			return UIColor(red:1.00, green:0.61, blue:0.00, alpha:1.0)
		case.category4:
			return UIColor(red:0.05, green:0.84, blue:1.00, alpha:1.0)
		case.category5:
			return UIColor(red:1.00, green:0.06, blue:0.60, alpha:1.0)
		case.All:
			return UIColor(red:0.89, green:0.00, blue:0.00, alpha:1.0)


		}
	}

	var categoryNumber: Int {
		switch self {
		case.category1:
			return 1
		case.category2:
			return 2
		case.category3:
			return 3
		case.category4:
			return 4
		case.category5:
			return 5
		case.All:
			return 0
		}
	}

	static func getCategory(category: String) -> CategoryEnum? {

		switch category {
		case categoryArray[0]:
			return .category1
		case categoryArray[1]:
			return .category2
		case categoryArray[2]:
			return .category3
		case categoryArray[3]:
			return .category4
		case categoryArray[4]:
			return .category5
		case "All":
			return .All
		default:
			return nil

		}
	}

	static func getCategoryByNumber(category: Int) -> CategoryEnum? {
		switch category {
		case 1:
			return .category1
		case 2:
			return .category2
		case 3:
			return .category3
		case 4:
			return .category4
		case 5:
			return .category5
		default:
			return nil
		}
	}
}
