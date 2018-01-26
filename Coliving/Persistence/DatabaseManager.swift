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

	// MARK: - User

	///Adds user object to database
	static func addUser(_ user: User, completionHandler: @escaping (Error?) -> Void) {
		self.fetchUser(userID: user.id) {
			(userFetched) in

			if (userFetched != nil) {
				print("User was already included in the DB. Updating his name and email informations.")
			}

			let userRef = ref.child("users").child(user.id)

			let userDict: [String : AnyObject] = [
				"name": user.name as AnyObject,
				"email": user.email as AnyObject,
				"houseGroup": user.houseGroup as AnyObject,
				"phoneNumber": user.phoneNumber as AnyObject,
			]

			userRef.setValue(userDict) {
				(error, _) in

				guard (error == nil) else {
					completionHandler(error)
					return
				}

				completionHandler(nil)
			}
		}
	}

	///Builds main user object from users' database information
	static func fetchUser(userID: String, completionHandler: @escaping (User?) -> Void) {

		let userRef = ref.child("users/\(userID)")

		userRef.observeSingleEvent(of: .value) {
			(userSnapshot) in

			//Getting user's information dictionary
			guard var userDictionary = userSnapshot.value as? [String: AnyObject] else {
				print("User ID fetched returned a nil snapshot from DB.")
				completionHandler(nil)
				return
			}

			userDictionary["id"] = userID as AnyObject

			//Fetching user's basic information

			guard let user = readUserDictionary(userDictionary: userDictionary) else {
				print("Error on fetching user's (\(userID)) basic profile information.")
				completionHandler(nil)
				return
			}

			//TODO: why cant I polymorph User -> MainUser?

			completionHandler(user)

		}

	}

	///Fetches user's basic profile information (id, name, email, phone number) from dictionary built by database snapshot.
	static func readUserDictionary(userDictionary: [String : AnyObject]) -> User? {

		guard let userID = userDictionary["id"] as? String else {
			print("Fetching user's id from DB returns nil.")
			return nil
		}

		guard let userName = userDictionary["name"] as? String else {
			print("Fetching user's name from DB returns nil.")
			return nil
		}

		guard let userEmail = userDictionary["email"] as? String else {
			print("Fetching user's email from DB returns nil.")
			return nil
		}

		guard let userHouseGroup = userDictionary["houseGroup"] as? String else {
			print("Fetching user's house group from DB returns nil.")
			return nil
		}

		guard let userPhoneNumber = userDictionary["phoneNumber"] as? String else {
			print("Fetching user's phone number from DB returns nil.")
			return nil
		}

		let user = User(id: userID, name: userName, email: userEmail, phoneNumber: userPhoneNumber, houseGroup: userHouseGroup)
		print("User (\(user.name)) fetched successfully.")

		return user
	}


	static func updateUserHouseGroup(completionHandler: @escaping (Error?) -> Void) {

		let userHouseGroupRef = ref.child("users/\((MainUser.user?.id)!)").child("houseGroup")

		userHouseGroupRef.setValue(MainUser.user?.houseGroup) {
			(error, _) in

			guard (error == nil) else {
				completionHandler(error)
				return
			}

			completionHandler(nil)
		}
	}

	// MARK: - House Group

	static func checkHouseGroup(name: String, completionHandler: @escaping (Bool) -> Void){

		let houseGroupRef = ref.child("House Groups")

		houseGroupRef.observeSingleEvent(of: .value) {
			(snapshot) in

			if snapshot.hasChild(name) {
				completionHandler(true)
			}

			completionHandler(false)
		}
	}

	static func addHouseGroup(name: String, completionHandler: @escaping (Error?) -> Void){

		let houseGroupRef = ref.child("House Groups").child(name)

		let categoryDict: [String : AnyObject] = [
			"Category 1": "Rent" as AnyObject,
			"Category 2": "Bills" as AnyObject,
			"Category 3": "Market" as AnyObject,
			"Category 4": "House Fix" as AnyObject,
			"Category 5": "Others" as AnyObject,
		]

		let userDict: [String : AnyObject] = [
			(MainUser.user?.id)!: "adm" as AnyObject
		]

		let houseDict: [String: AnyObject] = [
			"users": userDict as AnyObject,
			"Categories": categoryDict as AnyObject,
			"ShoppingList": "" as AnyObject,
			"FinanceList": "" as AnyObject

		]

		houseGroupRef.setValue(houseDict) {
			(error, _) in

			guard (error == nil) else {
				completionHandler(error)
				return
			}

			completionHandler(nil)

		}


	}

	// MARK: - Shopping List

	static func readShoppingDict(snapshot: DataSnapshot) -> [ShoppingItem]? {

		if let snapList = snapshot.children.allObjects as? [DataSnapshot]{

			guard (snapList.count != 0) else {
				print("No item found on Shoppint List on DB")
				return nil
			}

			var shoppingList = [ShoppingItem]()

			for i in snapList {

				/// shoppingDict = [
				/// 		"name" = itemName,
				///			"checked" = checkBoll
				///	]
				guard let shoppingDict = i.value as? [ String : AnyObject ] else {
					print("Error on fetching item`s dictionary on DB.")
					return nil
				}

				/// Catch the id autogenerated
				guard let itemId = i.key as? String else {
					print("Error on fetching item`s id on DB.")
					return nil
				}

				guard let itemName = shoppingDict["name"] as? String else {
					print("Error on fetching item`s name on DB.")
					return nil
				}

				guard let checked = shoppingDict["checked"] as? String  else {
					print("Error on fetching item`s checked boolean on DB.")
					return nil
				}

				var checkBool: Bool

				if checked == "false" {
					checkBool = false
				} else {
					checkBool = true
				}

				let shoppingItem = ShoppingItem(name: itemName, id: itemId, checked: checkBool)

				shoppingList.append(shoppingItem)
			}

			return shoppingList

		}

		return nil

	}

	static func fetchShoppingItem(completionHandler: @escaping([ShoppingItem]?) -> Void){

		let shoppingListRef = ref.child("House Groups").child((MainUser.user?.houseGroup)!).child("ShoppingList")

		shoppingListRef.observeSingleEvent(of: .value) {
			(snapshot) in

			guard let shoppingList = DatabaseManager.readShoppingDict(snapshot: snapshot) else {
				print("Error on fetching shopping list from DB")
				completionHandler(nil)
				return
			}

			completionHandler(shoppingList)

		}

	}

	static func addObserverToShoppingItems(completionHandler: @escaping([ShoppingItem]?) -> Void){

		ref.child("House Groups").child((MainUser.user?.houseGroup)!).child("ShoppingList").observe(.value) {
			(snapshot) in

			guard let shoppingList = DatabaseManager.readShoppingDict(snapshot: snapshot) else {
				print("Error on fetching shopping list from DB")
				completionHandler(nil)
				return
			}

			completionHandler(shoppingList)
		}
	}


	static func addShoppingItem(item: String, completionHandler: @escaping (String?, Error?) -> Void){

		let childRef = ref.child("House Groups").child((MainUser.user?.houseGroup)!).child("ShoppingList").childByAutoId()

		let shoppingDict: [String : String] = [
			"name": item,
			"checked": "false"
		]

		childRef.setValue(shoppingDict) {
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

		let itemRef = ref.child("House Groups").child((MainUser.user?.houseGroup)!).child("ShoppingList").child(item.id!)

		itemRef.removeValue {
			(error, _) in

			guard (error == nil) else {
				completionHandler(error)
				return
			}

			completionHandler(nil)
		}

	}

	static func changeCheckItemStatus(item: ShoppingItem, newStatus: String, completionHandler: @escaping(Error?) -> Void){

		let checkRef = ref.child("House Groups").child((MainUser.user?.houseGroup)!).child("ShoppingList").child(item.id!).child("checked")

		checkRef.setValue(newStatus) {
			(error, _) in

			guard (error == nil) else {
				completionHandler(error)
				return
			}

			completionHandler(nil)
		}
	}

	// MARK: - Finances

	static func addFinanceTransaction(transaction: FinanceTransaction, completionHandler: @escaping(Error?) -> Void){

		let childRef = ref.child("House Groups").child((MainUser.user?.houseGroup)!).child("FinanceList").childByAutoId()

		let dateString = Date.dateToString(date: transaction.date)

		let financeDict: [String : Any] = [
				"title" : transaction.title,
				"name" : transaction.name,
				"category" : transaction.category.categoryNumber,
				"value" : String(transaction.value),
				"date": dateString
		]

		childRef.setValue(financeDict) {
			(error, _) in

			guard (error == nil) else {
				completionHandler(error)
				return
			}

			let itemID = childRef.key
			transaction.id = itemID

			completionHandler(nil)
		}

	}

	static func removeFinanceTransaction(transaction: FinanceTransaction, completionHandler: @escaping(Error?) -> Void) {

		let financesRef = ref.child("House Groups").child((MainUser.user?.houseGroup)!).child("FinanceList").child(transaction.id!)

		financesRef.removeValue {
			(error, _) in

			guard (error == nil) else {
				completionHandler(error)
			return
			}

			completionHandler(nil)
		}

	}

	static func addObserverToFinancesList(completionHandler: @escaping([FinanceTransaction]?) -> Void){

		ref.child("House Groups").child((MainUser.user?.houseGroup)!).child("FinanceList").observe(.value) {
			(snapshot) in

			guard let financesList = DatabaseManager.readFinancesDict(snapshot: snapshot) else {
				print("Error on fetching finances list from DB")
				completionHandler(nil)
				return
			}

			completionHandler(financesList)
		}
	}

	static func readFinancesDict(snapshot: DataSnapshot) -> [FinanceTransaction]? {

		if let snapList = snapshot.children.allObjects as? [DataSnapshot]{

			guard (snapList.count != 0) else {
				print("No item found on Finances List on DB")
				return nil
			}

			var financesList = [FinanceTransaction]()

			for i in snapList {

				/* financeDict = [
						"title" : transaction.title,
						"name" : transaction.name,
						"category" : transaction.category.categoryNumber,
						"value" : String(transaction.value),
						"date": "\(transaction.date)"
				]*/
				guard let financesDict = i.value as? [ String : AnyObject ] else {
					print("Error on fetching item`s dictionary on DB.")
					return nil
				}

				/// Catch the id autogenerated
				guard let itemId = i.key as? String else {
					print("Error on fetching item`s id on DB.")
					return nil
				}

				guard let title = financesDict["title"] as? String else {
					print("Error on fetching finances title on DB.")
					return nil
				}

				guard let name = financesDict["name"] as? String else {
					print("Error on fetching finances name on DB.")
					return nil
				}

				guard let categoryInt = financesDict["category"] as? Int else {
					print("Error on fetching finances category on DB.")
					return nil
				}

				guard let valueString = financesDict["value"] as? String else {
					print("Error on fetching finances value on DB.")
					return nil
				}

				guard let dateString = financesDict["date"] as? String else {
					print("Error on fetching finances date on DB.")
					return nil
				}


				let category = CategoryEnum.getCategoryByNumber(category: categoryInt)

				let value = Double(valueString)

				let date = Date.stringToDate(dateString: dateString)

				let financeTransaction = FinanceTransaction(id: itemId, title: title, name: name, value: value!, category: category!, date: date)

				financesList.append(financeTransaction)
			}

			return financesList

		}

		return nil

	}

	// MARK: - Categories

	static func updateCategories(completionHandler: @escaping(Error?) -> Void) {

		let categoriesRef = ref.child("House Groups").child((MainUser.user?.houseGroup)!).child("Categories")

		let categoryDict: [String : AnyObject] = [
			"Category 1": categoryArray[0] as AnyObject,
			"Category 2": categoryArray[1] as AnyObject,
			"Category 3": categoryArray[2] as AnyObject,
			"Category 4": categoryArray[3] as AnyObject,
			"Category 5": categoryArray[4] as AnyObject,
			]

		categoriesRef.setValue(categoryDict) {
			(error, _) in

			guard (error == nil) else {
				completionHandler(error)
				return
			}

			completionHandler(nil)
		}


	}

	static func addObserverToCategories(completionHandler: @escaping([String]?) -> Void){
		ref.child("House Groups").child((MainUser.user?.houseGroup)!).child("Categories").observe(.value) {
			(snapshot) in

			guard let categories = DatabaseManager.readCategoriesDict(snapshot: snapshot) else {
				print("Error on fetching categories from DB")
				completionHandler(nil)
				return
			}

			completionHandler(categories)
		}
	}

	static func readCategoriesDict(snapshot: DataSnapshot) -> [String]? {

		if let snapList = snapshot.children.allObjects as? [DataSnapshot]{

			guard (snapList.count != 0) else {
				print("No item found on Categories on DB")
				return nil
			}

			var categories = [String]()

			for i in snapList {
				categories.append(i.value as! String) 
			}
			return categories
		}

		return nil
	}
	
}
