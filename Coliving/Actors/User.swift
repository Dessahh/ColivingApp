//
//  User.swift
//  Coliving
//
//  Created by Andressa Aquino on 24/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

class User: NSObject {

	var id: String
	var name: String
	var email: String
	var phoneNumber: String
	var profilePictureURL: URL
	var houseGroup: String
	var adm: Bool

	init(id: String, name: String, email: String?, phoneNumber: String?, houseGroup: String?, adm: Bool) {
		self.id = id
		self.name = name
		self.adm = adm

		if let houseGroup = houseGroup {
			self.houseGroup = houseGroup
		} else {
			self.houseGroup = ""
		}

		if let email = email {
			self.email = email
		} else {
			self.email = ""
		}

		if let phoneNumber = phoneNumber {
			self.phoneNumber = phoneNumber
		} else {
			self.phoneNumber = ""
		}

		self.profilePictureURL = URL(string: "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1")!
	}
}
