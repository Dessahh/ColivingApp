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
	@IBOutlet weak var signTextField: UITextField!
	@IBOutlet weak var valueTextField: UITextField!
	@IBOutlet weak var categoryTextField: UITextField!

	@IBOutlet weak var datePicker: UIDatePicker!
	override func viewDidLoad() {
        super.viewDidLoad()

		self.configureTextField(titleTextField, 0)
		self.configureTextField(nameTextField, 1)
		self.configureTextField(signTextField, 2)
		self.configureTextField(valueTextField, 3)
		self.configureTextField(categoryTextField, 4)

		self.datePicker.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
