//
//  ShoppingListTableViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 11/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class ShoppingListTableViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIGestureRecognizerDelegate {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var tableView: UITableView!

	var shoppingList = [ShoppingItem]()
	var selectedList = [Int]()

	var refresh: UIRefreshControl!

	override func viewDidLoad() {
        super.viewDidLoad()

		self.refresh = UIRefreshControl()
		self.refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
		self.tableView.addSubview(refresh)

		/// Design the textfield
		self.textField.tintColor = UIColor(red:0.89, green:0.00, blue:0.00, alpha:1.0)
		self.textField.layer.borderColor = UIColor(red:0.74, green:0.73, blue:0.76, alpha:1.0).cgColor
		self.textField.layer.borderWidth = 1.0

		/// Shift the placeholder and the text of textfield to the right by 15px
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.textField.frame.height))
		self.textField.leftView = paddingView
		textField.leftViewMode = .always

		/// Hide empty cells separator
		self.tableView.tableFooterView = UIView()

		self.textField.delegate = self

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem

    }

	override func viewDidAppear(_ animated: Bool) {

		DatabaseManager.addObserverToShoppingItems {
			(list) in

			guard (list != nil) else {
				print("Error on fetching shopping list of DB.")
				return
			}

			self.shoppingList = list!

			/// Check for selected items and update the selectedList
			for i in 0..<self.shoppingList.count{
				if self.shoppingList[i].checked == true {
					self.selectedList.append(i)
				}
			}

			DispatchQueue.main.async {
				self.tableView.reloadData()
			}

		}

	}

	override func viewWillAppear(_ animated: Bool) {

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(gestureRecognizer:)))

		/// This line make possible to the tableview recognize the tap gesture and peform its action at the same time the gesture is recognized to dismiss the keyboard
		tapGestureRecognizer.cancelsTouchesInView = false

		tapGestureRecognizer.delegate = self
		view.addGestureRecognizer(tapGestureRecognizer)
	}

	@objc func tapGesture(gestureRecognizer: UITapGestureRecognizer){

		/// if tap ouside the keyboard, dimiss it
		self.textField.endEditing(true)

	}

	// MARK: - IBAction

	@IBAction func addButtonPressed(_ sender: Any) {

		/// if button pressed when keyboard is closed, open keyboard
		/// else, just keep it open (the keyboard actually closes and opens but the user doesn't see, it closes beacause of the tap gesture and opens because of the following code)
		/// if there is something written of the textfield, add as a item
		if textField.text == "" {
			self.textField.becomeFirstResponder()
		} else if textField.text != "" {
			self.addItem(textField.text!)
		}

	}

	@IBAction func doneButtonPressed(_ sender: Any) {
		self.refreshAction()
	}

	// MARK: - Table view data source

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as! ShoppingListTableViewCell

		cell.itemLabel.text = shoppingList[indexPath.row].name

		cell.checkBox.onAnimationType = .fill
		cell.checkBox.offAnimationType = .fill

		/// Set the tag to catch the index of selected item afterwards
		cell.checkBox.tag = indexPath.row

		cell.checkBox.delegate = self

		cell.checkBox.setOn(shoppingList[indexPath.row].checked!, animated: false)

		return cell
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return shoppingList.count
	}

	///delete row from the table view
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

		if editingStyle == UITableViewCellEditingStyle.delete {
			let index = indexPath.row
			removeItem(index)
		}
	}

	// MARK: - Control Items
	func addItem(_ item: String){

		DatabaseManager.addShoppingItem(item: item) {
			(id, error) in

			guard (error == nil) else {
				print("Error on adding item to DB. Error: \(error.debugDescription)")
				return
			}

			//let newItem = ShoppingItem(name: item, id: id!, checked: false)
			//self.shoppingList.append(newItem)

			//self.tableView.reloadData()
			self.textField.text = ""
		}
	}

	///remove item and update table view
	func removeItem(_ index: Int){

		let item = shoppingList[index]

		DatabaseManager.removeShoppingItem(item: item) {
			(error) in

			guard (error == nil) else {
				print("Error on removing item to DB. Error: \(error.debugDescription)")
				return
			}

			if let selectedIndex = self.selectedList.index(of: index) {
				self.selectedList.remove(at: selectedIndex)
			}

			//self.shoppingList.remove(at: index)
			//self.tableView.reloadData()
		}

	}

	///remove selected itens and update table view
	@objc func refreshAction() {

		selectedList.sort(by: >)
		for i in selectedList{
			removeItem(i)
		}

		selectedList.removeAll()

		self.refresh.endRefreshing()
	}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShoppingListTableViewController: BEMCheckBoxDelegate {

    ///add or remove the selected item on the list
	func didTap(_ checkBox: BEMCheckBox) {

		if checkBox.on == true {

			let item = shoppingList[checkBox.tag]

			/// Change the check status on DB, this way the other users will keep updated
			DatabaseManager.changeCheckItemStatus(item: item, newStatus: "true", completionHandler: {
				(error) in

				guard (error == nil) else {
					print("Error on changing the item status on DB. Error: \(error.debugDescription)")
					return
				}

				self.selectedList.append(checkBox.tag)
				//self.shoppingList[checkBox.tag].checked = true

			})

		}
		else {

			let item = shoppingList[checkBox.tag]

			/// Change the check status on DB, this way the other users will keep updated
			DatabaseManager.changeCheckItemStatus(item: item, newStatus: "false", completionHandler: {
				(error) in

				guard (error == nil) else {
					print("Error on changing the item status on DB. Error: \(error.debugDescription)")
					return
				}

				//self.shoppingList[checkBox.tag].checked = false
				let index = self.selectedList.index(of: checkBox.tag)
				self.selectedList.remove(at: index!)

			})

		}
	}
}

extension ShoppingListTableViewController: UITextFieldDelegate {

	/// Hide keyboard pressing the return key
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		self.addItem(textField.text!)
		return true
	}

}

/*
/// Change the color of the clear button on the text field
extension UITextField {
	func modifyClearButtonWithImage(image : UIImage) {
		let clearButton = UIButton(type: .custom)
		clearButton.setImage(image, for: .normal)
		clearButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
		clearButton.contentMode = .scaleAspectFit
		clearButton.addTarget(self, action: #selector(self.clear(sender:)), for: .touchUpInside)

		self.rightView = clearButton
		self.rightViewMode = .whileEditing
	}

	@objc func clear(sender : AnyObject) {
		self.text = ""
	}
}*/
