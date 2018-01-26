//
//  SetHouseGroupViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 25/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class SetHouseGroupViewController: UIViewController {

	@IBOutlet weak var houseGroupTextField: UITextField!

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func setHouseGroup(_ sender: Any) {

		let name = self.houseGroupTextField.text

		if name != "" {

			DatabaseManager.checkHouseGroup(name: name!, completionHandler: {
				(exists) in

				if exists {
					MainUser.user?.houseGroup = name!
					self.performSegue(withIdentifier: "login2Segue", sender: nil)
				} else {
					DatabaseManager.addHouseGroup(name: name!, completionHandler: {
						(error) in

						guard error == nil else {
							print("Error in adding new house group on DB")
							return
						}

						MainUser.user?.houseGroup = name!

						DatabaseManager.updateUserHouseGroup(completionHandler: {
							(error) in

							guard error == nil else {
								print("Error in adding new house group on DB")
								return
							}
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
