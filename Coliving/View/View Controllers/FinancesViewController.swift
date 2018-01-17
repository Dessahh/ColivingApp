//
//  FinancesViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 17/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit

/// Default: Rent, Bills, Market, House Fix, Others
enum categorys {
	case category1, category2, category3, category4, category5
}

class FinancesViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "financesCell", for: indexPath) as! FinancesTableViewCell

		cell.heightAnchor.constraint(equalToConstant: 60.0)

		cell.dateLabel.text = "MAR 21"
		cell.responsableLabel.text = "Andressa"
		cell.subjectLabel.text = "Mercado"
		cell.valueLabel.text = "R$ 420,00"

		return cell
	}


    override func viewDidLoad() {
        super.viewDidLoad()

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
