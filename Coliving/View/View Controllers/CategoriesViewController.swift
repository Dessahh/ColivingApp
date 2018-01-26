//
//  CategoriesViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 23/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

	@IBOutlet weak var category1TextField: UITextField!
	@IBOutlet weak var category2TextField: UITextField!
	@IBOutlet weak var category3TextField: UITextField!
	@IBOutlet weak var category4TextField: UITextField!
	@IBOutlet weak var category5TextField: UITextField!




	override func viewDidLoad() {
        super.viewDidLoad()

		self.configureTextField(category1TextField, 0)
		self.configureTextField(category2TextField, 1)
		self.configureTextField(category3TextField, 2)
		self.configureTextField(category4TextField, 3)
		self.configureTextField(category5TextField, 4)


		self.category1TextField.text = categoryArray[0]
		self.category2TextField.text = categoryArray[1]
		self.category3TextField.text = categoryArray[2]
		self.category4TextField.text = categoryArray[3]
		self.category5TextField.text = categoryArray[4]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func testInput(_ category1: String?, _ category2: String?, _ category3: String?, _ category4: String?, _ category5: String?) -> Bool {

		guard category1 != "" && category1 != nil else {
			print("Error: no category1 defined")
			return false
		}

		guard category2 != "" && category2 != nil  else {
			print("Error: no category2 defined")
			return false
		}

		guard category3 != "" && category3 != nil else {
			print("Error: no category3 defined")
			return false
		}

		guard category4 != "" && category4 != nil else {
			print("Error: no category4 defined")
			return false
		}

		guard category5 != "" && category5 != nil else {
			print("Error: no category5 defined")
			return false
		}

		return true

	}

	@IBAction func saveButtonPressed(_ sender: Any) {

		let category1 = self.category1TextField.text
		let category2 = self.category2TextField.text
		let category3 = self.category3TextField.text
		let category4 = self.category4TextField.text
		let category5 = self.category5TextField.text

		/// Test if any input is blank, if so show an alert saying to the user fill the rest of the fields
		if testInput(category1, category2, category3, category4, category5) == false {

			let alertController = UIAlertController(title: "Alert",
													message: "You should fill all fields!",
													preferredStyle: UIAlertControllerStyle.alert)

			alertController.addAction(UIAlertAction(title: "Ok",
													style: UIAlertActionStyle.cancel,
													handler: { action in }))

			self.present(alertController, animated: true, completion: nil)

			return
		}

		var somethingChanged = false

		/// Check wich category changed and update on DB
		if category1 != categoryArray[0] {

			//Change on DB
			somethingChanged = true
			categoryArray[0] = category1!
		}

		if category2 != categoryArray[1] {

			//Change on DB
			somethingChanged = true
			categoryArray[1] = category2!
		}

		if category3 != categoryArray[2] {

			//Change on DB
			somethingChanged = true
			categoryArray[2] = category3!
		}

		if category4 != categoryArray[3] {

			//Change on DB
			somethingChanged = true
			categoryArray[3] = category4!
		}

		if category5 != categoryArray[4] {

			//Change on DB
			somethingChanged = true
			categoryArray[4] = category5!
		}

		if somethingChanged {
			DatabaseManager.updateCategories(completionHandler: {
				(error) in

				guard error == nil else {
					print("Error on updating categories on BD")
					return
				}
			})
		}

		

		self.navigationController?.popViewController(animated: true)
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

// MARK: - Textfield Delegate

extension CategoriesViewController: UITextFieldDelegate {


	func configureTextField(_ textField: UITextField, _ textTag: Int){

		textField.textColor = UIColor(red:0.89, green:0.00, blue:0.00, alpha:1.0)
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

	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.textColor = UIColor.black
	}


}
