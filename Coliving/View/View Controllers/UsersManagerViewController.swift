//
//  UsersManagerViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 28/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class UsersManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var users = [User]()
	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
        super.viewDidLoad()

		/// Hide empty cells separator
		self.tableView.tableFooterView = UIView()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func viewWillAppear(_ animated: Bool) {
		DatabaseManager.fetchHouseGroupUsers {
			(usersList) in

			guard usersList != nil else {
				print("Error on fetching users list on DB")
				return
			}

			self.users = usersList!

			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.users.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "usersManagerCell", for: indexPath) as! UsersManagerTableViewCell

		cell.nameLabel.text = users[indexPath.row].name
		cell.admLabel.text = "Admin user"
		cell.admSwitch.tag = indexPath.row
		if users[indexPath.row].adm == true {
			cell.admSwitch.isOn = true
			cell.admLabel.alpha = 1.0
		} else {
			cell.admSwitch.isOn = false 
			cell.admLabel.alpha = 0.25
		}

		return cell
	}

	///delete row from the table view
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

		if editingStyle == UITableViewCellEditingStyle.delete {
			let index = indexPath.row
			DatabaseManager.removeUserFromHouseGroup(id: users[indexPath.row].id, completionHandler: {
				(error) in

				guard error == nil else {
					print("Error on removing user from house group on DB")
					return
				}

				self.users.remove(at: indexPath.row)
				self.tableView.reloadData()
			})
		}
	}

	@IBAction func switchPressed(_ sender: UISwitch) {
		DatabaseManager.updateAdmSettings(id: users[sender.tag].id, adm: sender.isOn) {
			(error) in

			guard error == nil else {
				print("Error on updating adm settings")
				return
			}

			self.users[sender.tag].adm = sender.isOn
			self.tableView.reloadData()
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
