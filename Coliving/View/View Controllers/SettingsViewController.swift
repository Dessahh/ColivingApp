//
//  SettingsViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 28/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	let section1 = ["Categories", "About"]
	let section2 = ["Invite People", "Users Manager"]
	let section3 = ["Sign Out From House Group"]
	let section4 = ["Log Out"]
	let section4logIn = ["Log In"]

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return section1.count
		} else if section == 1 {
			return section2.count
		} else if section == 2 {
			return section3.count
		}
		return section4.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell

		if indexPath.section == 0 {
			cell.optionLabel.text = section1[indexPath.row]

		} else if indexPath.section == 1 {
			cell.optionLabel.text = section2[indexPath.row]

			// Only admins can use section 2
			if MainUser.user?.adm == false ||  MainUser.user == nil {
				cell.optionLabel.alpha = 0.25
				cell.isUserInteractionEnabled = false
			}

		} else if indexPath.section == 2 {
			cell.optionLabel.text = section3[indexPath.row]
			cell.optionLabel.textColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)

			// If user isn`t log in
			if MainUser.user == nil {
				cell.optionLabel.alpha = 0.25
				cell.isUserInteractionEnabled = false
			}
		} else if indexPath.section == 3 {

			cell.optionLabel.textColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)

			// If user isn`t log in
			if MainUser.user == nil {
				cell.optionLabel.text = section4logIn[indexPath.row]
			} else {
				cell.optionLabel.text = section4[indexPath.row]
			}

		}

		cell.selectionStyle = .none

		return cell
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		if(indexPath.section == 0) {
			switch indexPath.row {
			case 0:
				self.performSegue(withIdentifier: "categoriesSegue", sender: self)
			case 1:
				self.performSegue(withIdentifier: "aboutSegue", sender: self)
			default:
				print("Out of index")
			}
		} else if (indexPath.section == 1) {
			switch indexPath.row {
			case 0:
				self.performSegue(withIdentifier: "inviteSegue", sender: self)
			case 1:
				self.performSegue(withIdentifier: "usersManagerSegue", sender: self)
			default:
				print("Out of index")
			}

		} else if indexPath.section == 2 {
			switch indexPath.row {
			case 0:
				self.signOutFromHouseGroup()
			default:
				print("Out of index")
			}

		} else if indexPath.section == 3 {
			switch indexPath.row {
			case 0:
				self.logOut()
			default:
				print("Out of index")
			}

		}



		print("Section: \(indexPath.section) Row: \(indexPath.row)")
	}


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func invitePeople () {
		print("invite")
	}

	func signOutFromHouseGroup() {

		let alertController = UIAlertController(title: "Are you sure do you want to sign out from your house group?",
												message: "",
												preferredStyle: UIAlertControllerStyle.alert)

		alertController.addAction(UIAlertAction(title: "Ok",
												style: .default,
												handler: {
													action in

													self.removeUserFromHouseGroup()
		}))

		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
		}))

		self.present(alertController, animated: true, completion: nil)

	}

	func removeUserFromHouseGroup() {

		DatabaseManager.removeUserFromHouseGroup(id: (MainUser.user?.id)!) {
			(error) in

			guard error == nil else {
				print("Error signing out from house group")
				return
			}

			MainUser.user?.houseGroup = ""
			MainUser.user?.adm = false

			DatabaseManager.updateUser(completionHandler: {
				(error) in

				guard error == nil else {
					print("Error on updating user")
					return
				}


				///PASS TO INTRO
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let vc = storyboard.instantiateViewController(withIdentifier: "houseGroupVC") as! IntroHouseGroupViewController
				self.present(vc, animated: true, completion: nil)
			})
		}

	}

	func logOut () {

		if MainUser.anonymousUser != nil {
			self.dismiss(animated: false, completion: nil)
			let root = self.view.window?.rootViewController
			self.present(root!, animated: true, completion: nil)
		} else {

			let alertController = UIAlertController(title: "Are you sure do you want to logout?",
													message: "You won`t be able to access your house group.",
													preferredStyle: UIAlertControllerStyle.alert)

			alertController.addAction(UIAlertAction(title: "Ok",
													style: .default,
													handler: {
														action in
														print("a")
														LoginServices.logOut()
														self.dismiss(animated: false, completion: nil)
														let root = self.view.window?.rootViewController
														self.present(root!, animated: true, completion: nil)
			}))

			alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
			}))

			self.present(alertController, animated: true, completion: nil)

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
