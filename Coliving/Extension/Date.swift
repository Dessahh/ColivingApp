//
//  Date.swift
//  Coliving
//
//  Created by Andressa Aquino on 21/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

extension Date {

	func getMonthName() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM"
		let strMonth = dateFormatter.string(from: self)
		return strMonth
	}

	func getDay() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd"
		let strDay = dateFormatter.string(from: self)
		return strDay
	}

	func getYear() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		let strDay = dateFormatter.string(from: self)
		return strDay
	}

	static func dateToString(date: Date) -> String {

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		let dateString = dateFormatter.string(from: date)

		return dateString
	}

	static func stringToDate(dateString: String) -> Date {

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"

		let date = dateFormatter.date(from: dateString)

		return date!
	}

}
