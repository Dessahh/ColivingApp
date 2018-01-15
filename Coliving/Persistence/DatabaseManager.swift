//
//  DatabaseManager.swift
//  Coliving
//
//  Created by Andressa Aquino on 14/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

import FirebaseDatabase

class DatabaseManager: NSObject {

	//FIRDatabaseReference for the root of Coliving's Firebase Database
	static var ref: DatabaseReference = Database.database().reference()

	private override init() {}

	///Checks connection with Firebase Database backend
	static func checkConnection(completionHandler: @escaping (Bool) -> Void) {
		let connectedRef = Database.database().reference(withPath: ".info/connected")

		connectedRef.observeSingleEvent(of: .value) {
			snapshot in
			if let connected = snapshot.value as? Bool, connected {
				print("Connected")
			} else {
				print("Not connected")
			}
		}
	}



	static func fetchShoppingItem(completionHandler: @escaping([ShoppingItem]?) -> Void){

		let shoppingListRef = ref.child("ShoppingList")

		shoppingListRef.observeSingleEvent(of: .value) {
			(snapshot) in

			if let snapList = snapshot.children.allObjects as? [DataSnapshot]{

				guard (snapList.count != 0) else {
					print("No item found on Shoppint List on DB")
					completionHandler(nil)
					return

				}

				var shoppingList = [ShoppingItem]()

				for i in snapList {

					guard let itemName = i.value as? String else {
						print("Error on fetching item`s name on DB.")
						completionHandler(nil)
						return
					}

					guard let itemId = i.key as? String else {
						print("Error on fetching item`s id on DB.")
						completionHandler(nil)
						return
					}

					let shoppingItem = ShoppingItem(name: itemName, id: itemId, checked: false)

					shoppingList.append(shoppingItem)
				}

				completionHandler(shoppingList)

			}

		}

	}

	static func addShoppingItem(item: String, completionHandler: @escaping (String?, Error?) -> Void){

		let childRef = ref.child("ShoppingList").childByAutoId()

		childRef.setValue(item) {
			(error, _) in

			guard (error == nil) else {
				completionHandler(nil, error)
				return
			}

			let itemID = childRef.key

			completionHandler(itemID, nil)
		}

	}

	static func removeShoppingItem(item: ShoppingItem, completionHandler: @escaping(Error?) -> Void){

		let itemRef = ref.child("ShoppingList").child(item.id!)

		itemRef.removeValue {
			(error, _) in

			guard (error == nil) else {
				completionHandler(error)
				return
			}

			completionHandler(nil)
		}

	}
}
