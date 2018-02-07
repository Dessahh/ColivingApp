//
//  CreateNewHouseGroupViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 28/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class CreateNewHouseGroupViewController: UIViewController {

	@IBOutlet weak var houseGroupNameTextField: UITextField!

	override func viewDidLoad() {
        super.viewDidLoad()

		self.configureTextField(houseGroupNameTextField)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func cancelPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func sendInvites() {

		/*let link = URL(string: "https://jr386.app.goo.gl/colivingApp")

		let attributedString = NSMutableAttributedString(string: "I'm inviting you to join our house group on Coliving App! Use this token to join our house group: \((MainUser.user?.houseGroup)!)")

		let foundRange = attributedString.mutableString.range(of: "Coliving App")
		if foundRange.location != NSNotFound {
			attributedString.addAttribute(.link, value: link, range: foundRange)
		}

		// set up activity view controller
		let textToShare = [ attributedString ]*/

		let textToShare = "I'm inviting you to join our house group on Coliving App! Use this token to join our house group: \((MainUser.user?.houseGroup)!)"
		let activityViewController = UIActivityViewController(activityItems: [ textToShare ], applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

		// exclude some activity types from the list (optional)
		activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]

		activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
			
			self.performSegue(withIdentifier: "financesSegue", sender: self)
		}

		// present the view controller
		activityViewController.popoverPresentationController?.sourceView = self.view
		self.present(activityViewController, animated: true, completion: nil)
	}
    
	@IBAction func buttonPressed(_ sender: Any) {

		let name = self.houseGroupNameTextField.text

		if name != "" {

			DatabaseManager.checkHouseGroup(name: name!, completionHandler: {
				(exists) in

				if exists {

					let alertController = UIAlertController(title: "This house group already exists",
															message: "Try a different house group name!",
															preferredStyle: UIAlertControllerStyle.alert)

					alertController.addAction(UIAlertAction(title: "Ok",
															style: UIAlertActionStyle.cancel,
															handler: { action in }))

					self.present(alertController, animated: true, completion: nil)

					
				} else {

					DatabaseManager.addHouseGroup(name: name!, completionHandler: {
						(id, error) in

						guard error == nil else {
							print("Error in adding new house group on DB")
							return
						}

						MainUser.user?.houseGroup = id!
						MainUser.user?.adm = true

						DatabaseManager.updateUser(completionHandler: {
							(error) in

							guard error == nil else {
								print("Error in updating user on DB")
								return
							}

							let alertController = UIAlertController(title: "House Group Created Succesfully!",
																	message: "Now you should invite the people you live with to the house group!",
																	preferredStyle: .alert)


							alertController.addAction(UIAlertAction(title: "Cancel",
																	style: .default,
																	handler: {
																		action in

																		self.performSegue(withIdentifier: "financesSegue", sender: self)

							}))

							alertController.addAction(UIAlertAction(title: "Invite",
																	style: .default,
																	handler: {
																		action in
																		self.sendInvites()

							}))





							self.present(alertController, animated: true, completion: nil)



						})
					})
				}
			})
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

extension CreateNewHouseGroupViewController: UITextFieldDelegate {


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
