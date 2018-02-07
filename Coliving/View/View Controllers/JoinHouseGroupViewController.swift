//
//  JoinHouseGroupViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 28/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class JoinHouseGroupViewController: UIViewController {

	@IBOutlet weak var tokenTextField: UITextField!

	override func viewDidLoad() {
        super.viewDidLoad()

		self.configureTextField(tokenTextField)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func cancelPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func joinButtonPressed(_ sender: Any) {

		if tokenTextField.text != "" {

			DatabaseManager.joinHouseGroup(id: tokenTextField.text!) {
				(success) in

				guard success == true else {

					let alertController = UIAlertController(title: "Check your token",
															message: "Error on finding your token house group!",
															preferredStyle: UIAlertControllerStyle.alert)

					alertController.addAction(UIAlertAction(title: "Ok",
															style: UIAlertActionStyle.cancel,
															handler: { action in }))

					self.present(alertController, animated: true, completion: nil)


					print("Error on joining house group")
					return
				}

				MainUser.user?.houseGroup = self.tokenTextField.text!
				DatabaseManager.updateUser(completionHandler: {
					(error) in

					guard error == nil else {
						print("Error on joining house group")
						return
					}

					self.performSegue(withIdentifier: "finances2Segue", sender: self)
				})
			}
		}

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

extension JoinHouseGroupViewController: UITextFieldDelegate {


	func configureTextField(_ textField: UITextField){

		textField.tintColor = UIColor(red:0.89, green:0.00, blue:0.00, alpha:1.0)
		textField.layer.borderColor = UIColor(red:0.74, green:0.73, blue:0.76, alpha:1.0).cgColor
		textField.layer.borderWidth = 0.5

		/// Shift the placeholder and the text of textfield to the right by 15px
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 60))
		textField.leftView = paddingView
		textField.leftViewMode = .always

		textField.delegate = self
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		// remove keyboard
		textField.resignFirstResponder()

		// Do not add a line break
		return false
	}


}

