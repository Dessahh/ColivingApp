//
//  InviteViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 26/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit

class InviteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()



        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
	@IBAction func inviteButtonPressed(_ sender: Any) {
		print("Invite button tapped")

		let inviteDialog:FBSDKAppInviteDialog = FBSDKAppInviteDialog()
		if(inviteDialog.canShow()){
			let appLinkUrl:NSURL = NSURL(string: "http://yourwebpage.com")!
			let previewImageUrl:NSURL = NSURL(string: "http://yourwebpage.com/preview-image.png")!

			let inviteContent:FBSDKAppInviteContent = FBSDKAppInviteContent()
			inviteContent.appLinkURL = appLinkUrl as URL!
			inviteContent.appInvitePreviewImageURL = previewImageUrl as URL!

			inviteDialog.content = inviteContent
			inviteDialog.delegate = self
			inviteDialog.show()
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

// MARK: - App Invite

extension InviteViewController: FBSDKAppInviteDialogDelegate {
	func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
		let resultObject = NSDictionary(dictionary: results)

		if let didCancel = resultObject.value(forKey: "completionGesture")
		{
			if (didCancel as AnyObject).caseInsensitiveCompare("Cancel") == ComparisonResult.orderedSame
			{
				print("User Canceled invitation dialog")
			}
		}
	}

	func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
		print("Error tool place in appInviteDialog \(error)")
	}


}
