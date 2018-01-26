//
//  LoginViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 24/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

	var loginButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()

		self.loginButton = FBSDKLoginButton()
		self.loginButton.readPermissions = ["public_profile", "email"]
		self.loginButton.delegate = self

		view.addSubview(loginButton)
		self.loginButton.frame = CGRect(x: 16, y: 40, width: view.frame.width - 32, height: 50)


		//checking if user is already logged in
		if (FBSDKAccessToken.current() != nil) {
			self.userDidLogIn()
		}


        // Do any additional setup after loading the view.
    }

	func userDidLogIn() {
		LoginServices.handleUserLoggedIn {
			(successful) in

			guard (successful == true) else {
				print("Couldn't fetch user's facebook or database information.")
				return
			}

			print("Login successful")

			// If user don`t have any house group, give the option to create or join one
			//self.performSegue(withIdentifier: "always", sender: self)
			if MainUser.user?.houseGroup == "" {
				self.performSegue(withIdentifier: "houseGroupSegue", sender: nil)
			} else {
				self.performSegue(withIdentifier: "loginSegue", sender: nil)
			}
			
		}
	}


}

extension LoginViewController: FBSDKLoginButtonDelegate {

	func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

		guard (error == nil) else {
			print("Error on clicking facebook login button.")
			return
		}

		if result.isCancelled {
			print("Facebook login has been cancelled.")
			return
		}

		self.userDidLogIn()
	}

	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
		print("App did log out of facebook.")
	}


}
