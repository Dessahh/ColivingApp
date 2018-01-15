//
//  ShoppingListTableViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 11/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class ShoppingListTableViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIGestureRecognizerDelegate, BEMCheckBoxDelegate {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var tableView: UITableView!

	var shoppingList = [ShoppingItem]()

	override func viewDidLoad() {
        super.viewDidLoad()

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

		DatabaseManager.fetchShoppingItem {
			(shoppingList) in

			guard (shoppingList != nil) else {
				print("Error on fetching shopping list of DB.")
				return
			}

			self.shoppingList = shoppingList!

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
	// MARK: - Table view data source

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as! ShoppingListTableViewCell

		cell.itemLabel.text = shoppingList[indexPath.row].name

		cell.checkBox.onAnimationType = .fill
		cell.checkBox.offAnimationType = .fill
		cell.checkBox.tag = indexPath.row
		cell.checkBox.delegate = self
		
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

	// MARK: - Add and Remove item
	func addItem(_ item: String){

		DatabaseManager.addShoppingItem(item: item) {
			(id, error) in

			guard (error == nil) else {
				print("Error on adding item to DB. Error: \(error.debugDescription)")
				return
			}

			let newItem = ShoppingItem(name: item, id: id!, checked: false)
			self.shoppingList.append(newItem)

			self.tableView.reloadData()
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

		}

		self.shoppingList.remove(at: index)
		self.tableView.reloadData()


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
