//
//  AddNewValueViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 17/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class AddNewValueViewController: UIViewController {

	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var valueTextField: UITextField!
	@IBOutlet weak var categoryTextField: UITextField!

	@IBOutlet weak var datePicker: UIDatePicker!

	var signPickerView = UIPickerView()
	//let categoryArray = FinanceCategorys.getCategorys()

	var categoryPickerView = UIPickerView()

	override func viewDidLoad() {
        super.viewDidLoad()

		/// Text fields initial configuration (tintColor, border, placeholder padding, delegate and tag)

		self.configureTextField(titleTextField, 0)
		self.configureTextField(nameTextField, 1)
		self.configureTextField(valueTextField, 2)
		self.configureTextField(categoryTextField, 3)
		

		/// Picker View initial configuration

		self.categoryPickerView.delegate = self

		categoryTextField.inputView = categoryPickerView

		/// Allows tap gesture inside the picker view, this way the user the tap on the selected row
		let tapCategory = UITapGestureRecognizer(target: self, action: #selector(pickerTapped(_:)))
		tapCategory.cancelsTouchesInView = false
		tapCategory.delegate = self

		categoryPickerView.addGestureRecognizer(tapCategory)


		self.datePicker.backgroundColor = UIColor.white
		self.datePicker.maximumDate = Date()

        // Do any additional setup after loading the view.
    }

	func testInput(_ title: String?, _ name: String?, _ value: String?, _ category: String?) -> Bool {

		guard title != "" && title != nil else {
			print("Error: no title defined")
			return false
		}

		guard name != "" && name != nil  else {
			print("Error: no name defined")
			return false
		}

		guard value != "" && value != nil else {
			print("Error: no value defined")
			return false
		}

		guard category != "" && category != nil else {
			print("Error: no category defined")
			return false
		}

		return true

	}

	// MARK: - IBAction

	@IBAction func saveButtonPressed(_ sender: Any) {

		let title = self.titleTextField.text
		let name = self.nameTextField.text
		let valueText = self.valueTextField.text
		let categoryText = self.categoryTextField.text

		/// Test if any input is blank, if so show an alert saying to the user fill the rest of the fields
		if testInput(title, name, valueText, categoryText) == false {

			let alertController = UIAlertController(title: "Alert",
													message: "You should fill all fields!",
													preferredStyle: UIAlertControllerStyle.alert)

			alertController.addAction(UIAlertAction(title: "Ok",
													style: UIAlertActionStyle.cancel,
													handler: { action in }))

			self.present(alertController, animated: true, completion: nil)

			return
		}

		let category = CategoryEnum.getCategory(category: categoryText!)

		let date = datePicker.date

		let value = Double((valueText?.myDoubleConverter)!)

		let transaction = FinanceTransaction(id: nil, title: title!, name: name!, value: value, category: category!, date: date)

		DatabaseManager.addFinanceTransaction(transaction: transaction) {
			(error) in

			guard (error == nil) else {
				print("Error on adding a transaction to DB. Error: \(error.debugDescription)")
				return
			}

			self.navigationController?.popViewController(animated: true)
		}
	}

	// MARK: - Navigation

	/*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "saveSegue" {
			if let financeViewController = segue.destination as? FinancesViewController {
				financeViewController.financesList
			}
		}
	}*/
}

// MARK: - Gesture Recognizer Delegate

extension AddNewValueViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}

// MARK: - Textfield Delegate

extension AddNewValueViewController: UITextFieldDelegate {


	func configureTextField(_ textField: UITextField, _ textTag: Int){

		textField.tintColor = UIColor(red:0.89, green:0.00, blue:0.00, alpha:1.0)
		textField.layer.borderColor = UIColor(red:0.74, green:0.73, blue:0.76, alpha:1.0).cgColor
		textField.layer.borderWidth = 0.5

		/// Shift the placeholder and the text of textfield to the right by 15px
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 60))
		textField.leftView = paddingView
		textField.leftViewMode = .always

		textField.delegate = self
		textField.tag = textTag
	}

	/// Pass to the next field
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		// Try to find next responder
		if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
			nextField.becomeFirstResponder()
		} else {
			// Not found, so remove keyboard.
			textField.resignFirstResponder()
		}
		// Do not add a line break
		return false
	}


}

// MARK: - Picker View Delegate

extension AddNewValueViewController: UIPickerViewDataSource, UIPickerViewDelegate {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

		if pickerView == categoryPickerView {
			return 5
		} else {
			return 0
		}

	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

		if pickerView == categoryPickerView {
			return categoryArray[row]
		} else {
			return ""
		}

	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

		if pickerView == categoryPickerView {
			categoryTextField.text = categoryArray[row]
		}
	}

	@objc func pickerTapped(_ tapRecognizer: UIGestureRecognizer) {

		var pickerView: UIPickerView?
		var textField: UITextField?
		var array: [String]?

		if tapRecognizer.view == categoryPickerView.inputView {
			pickerView = categoryPickerView
			textField = categoryTextField
			array = categoryArray
		}

		if (tapRecognizer.state == .ended && pickerView != nil) {

			let rowHeight : CGFloat  = pickerView!.rowSize(forComponent: 0).height

			let selectedRowFrame: CGRect = CGRect(x: 0, y: ((pickerView!.frame.height/2) - rowHeight) , width: pickerView!.frame.width, height: rowHeight)

			let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: pickerView))

			if userTappedOnSelectedRow {

				let selectedRow = pickerView?.selectedRow(inComponent: 0)
				textField?.text = array?[selectedRow!]

			}
		}
	}

}

extension String {
	var myDoubleConverter: Double {
		let converter = NumberFormatter()

		converter.decimalSeparator = ","
		if let result = converter.number(from: self) {
			return result.doubleValue

		} else {

			converter.decimalSeparator = "."
			if let result = converter.number(from: self) {
				return result.doubleValue
			}
		}
		return 0
	}
}
