//
//  DatabaseManager.swift
//  Coliving
//
//  Created by Andressa Aquino on 14/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit
import CloudKit

class DatabaseManager: NSObject {

	static let databaseRef = CKContainer.default().database(with: .public)

	static func addShoppingItem(item: String, completionHandler: @escaping (Error?) -> Void){

		let newItem = CKRecord(recordType: "ShoppingList")
		newItem.setValue(item, forKey: "item")

		databaseRef.save(newItem) { (record, error) in

			guard (error == nil) else {
				completionHandler(error)
				return
			}


		}
	}

	static func fetchShoppingItem(completionHandler: @escaping([String]?, Error?) -> Void){

		let query = CKQuery(recordType: "ShoppingList", predicate: NSPredicate(value: true))

		databaseRef.perform(query, inZoneWith: nil) {
			(records, error) in

			guard (error == nil) else {
				completionHandler(nil, error)
				return
			}

			var itemsList = [String]()

			for i in records! {

				itemsList.append(i.value(forKey: "item") as! String)
			}

			completionHandler(itemsList, error)

		}
	}
}
