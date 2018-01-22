//
//  FinancesViewController.swift
//  Coliving
//
//  Created by Andressa Aquino on 17/01/18.
//  Copyright © 2018 Andressa Aquino. All rights reserved.
//

import UIKit
import Charts


struct Section {
	var name: String
	var list: [FinanceTransaction]
}


class FinancesViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

	@IBOutlet weak var pieChart: PieChartView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var categoryTextField: UITextField!

	var categoryPickerView = UIPickerView()
	
	var financesList = [FinanceTransaction]()
	var sectionArray = [Section]()

	var categoryOneArray = [Section]()
	var categoryTwoArray = [Section]()
	var categoryThreeArray = [Section]()
	var categoryFourArray = [Section]()
	var categoryFiveArray = [Section]()

	var totalCost: Double = 0.0
	var categoryCosts: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0]

	var categorySelected = CategoryEnum.All
	var categoryList = categoryArray

	override func viewWillAppear(_ animated: Bool) {
		self.categoryList.append("All")
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		self.configureTextField(categoryTextField)

		/// Picker View initial configuration

		self.categoryPickerView.delegate = self

		categoryTextField.inputView = categoryPickerView

		/// Allows tap gesture inside the picker view, this way the user the tap on the selected row
		let tapCategory = UITapGestureRecognizer(target: self, action: #selector(pickerTapped(_:)))
		tapCategory.cancelsTouchesInView = false
		tapCategory.delegate = self

		categoryPickerView.addGestureRecognizer(tapCategory)

		categoryTextField.text = "Category: All"


        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {

		DatabaseManager.addObserverToFinancesList {
			(list) in

			guard (list != nil) else {
				print("Error on fetching finances list of DB.")
				return
			}

			self.financesList = (list?.sorted(by: {$0.date > $1.date}))!
			//notes.sort({$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow})

			for f in self.financesList {

				var contains = false

				for sIndex in 0..<self.sectionArray.count {

					if self.sectionArray[sIndex].name == f.date.getYear() {
						self.sectionArray[sIndex].list.append(f)
						contains = true
					}
				}

				if contains == false {
					let section = Section(name: f.date.getYear(), list: [f])
					self.sectionArray.append(section)
				}

				self.totalCost += f.value
				self.categoryCosts[f.category.categoryNumber - 1] += f.value
			}

			DispatchQueue.main.async {
				self.pieChartUpdate()
				self.tableView.reloadData()
			}

		}
	}

	func divideInSections() -> Void {

		// Cleans the section array
		self.sectionArray.removeAll()

		// Divide list by the year in sections
		for f in financesList {

			if(f.category == self.categorySelected || self.categorySelected == CategoryEnum.All) {
				var contains = false

				for sIndex in 0..<self.sectionArray.count {

					if self.sectionArray[sIndex].name == f.date.getYear() {
						self.sectionArray[sIndex].list.append(f)
						contains = true
					}
				}

				if contains == false {
					let section = Section(name: f.date.getYear(), list: [f])
					self.sectionArray.append(section)
				}

			}
		}

		self.tableView.reloadData()

	}


	// MARK: - TableView

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sectionArray[section].list.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "financesCell", for: indexPath) as! FinancesTableViewCell

		cell.heightAnchor.constraint(equalToConstant: 60.0)

		cell.dateLabel.text = "\(sectionArray[indexPath.section].list[indexPath.row].date.getMonthName().uppercased()) \(sectionArray[indexPath.section].list[indexPath.row].date.getDay())"

		cell.responsableLabel.text = sectionArray[indexPath.section].list[indexPath.row].name
		cell.subjectLabel.text = sectionArray[indexPath.section].list[indexPath.row].title
		cell.valueLabel.text = "R$ \(sectionArray[indexPath.section].list[indexPath.row].value)"

		cell.subjectLabel.textColor = sectionArray[indexPath.section].list[indexPath.row].category.color
		print(financesList[indexPath.row].date.getYear())

		return cell
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return self.sectionArray.count
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "  \(self.sectionArray[section].name)"
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

// MARK: - Gesture Recognizer Delegate

extension FinancesViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}

// MARK: - Picker View Delegate

extension FinancesViewController: UIPickerViewDataSource, UIPickerViewDelegate {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

		if pickerView == categoryPickerView {
			return 6
		} else {
			return 0
		}

	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

		if pickerView == categoryPickerView {
			return categoryList[row]
		} else {
			return ""
		}

	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

		if pickerView == categoryPickerView {
			categoryTextField.text = "Category: \(categoryList[row])"
			self.categorySelected = CategoryEnum.getCategory(category: categoryList[row])!
			self.divideInSections()
			print(categorySelected.categoryName)
		}
	}

	@objc func pickerTapped(_ tapRecognizer: UIGestureRecognizer) {

		var pickerView: UIPickerView?
		var textField: UITextField?
		var array: [String]?

		if tapRecognizer.view == categoryPickerView.inputView {
			pickerView = categoryPickerView
			textField = categoryTextField
			array = categoryList
		}

		if (tapRecognizer.state == .ended && pickerView != nil) {

			let rowHeight : CGFloat  = pickerView!.rowSize(forComponent: 0).height

			let selectedRowFrame: CGRect = CGRect(x: 0, y: ((pickerView!.frame.height/2) - rowHeight) , width: pickerView!.frame.width, height: rowHeight)

			let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: pickerView))

			if userTappedOnSelectedRow {

				let selectedRow = pickerView?.selectedRow(inComponent: 0)
				textField?.text = "Category: \(String(describing: array![selectedRow!]))"
				self.categorySelected = CategoryEnum.getCategory(category: array![selectedRow!])!
				self.divideInSections()


			}
		}
	}

}

// MARK: - Pie Chart

extension FinancesViewController {

	func pieChartUpdate () {
		//future home of pie chart code
		let entry1 = PieChartDataEntry(value: Double(categoryCosts[0]), label: CategoryEnum.category1.categoryName)
		let entry2 = PieChartDataEntry(value: Double(categoryCosts[1]), label: CategoryEnum.category2.categoryName)
		let entry3 = PieChartDataEntry(value: Double(categoryCosts[2]), label: CategoryEnum.category3.categoryName)
		let entry4 = PieChartDataEntry(value: Double(categoryCosts[3]), label: CategoryEnum.category4.categoryName)
		let entry5 = PieChartDataEntry(value: Double(categoryCosts[4]), label: CategoryEnum.category5.categoryName)
		let dataSet = PieChartDataSet(values: [entry1, entry2, entry3, entry4, entry5], label: "")
		let data = PieChartData(dataSet: dataSet)
		pieChart.data = data
		pieChart.chartDescription?.text = ""

		//All other additions to this function will go here
		dataSet.colors = ChartColorTemplates.vordiplom()
		dataSet.valueColors = [UIColor.black]
		pieChart.legend.font = UIFont(name: "Futura", size: 10)!
		//pieChart.chartDescription?.font = UIFont(name: "Futura", size: 12)!


		//This must stay at end of function
		pieChart.notifyDataSetChanged()
	}
}

extension FinancesViewController: UITextFieldDelegate {

	func configureTextField(_ textField: UITextField) {

		textField.tintColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.0)
		textField.layer.borderColor = UIColor(red:0.74, green:0.73, blue:0.76, alpha:1.0).cgColor
		textField.layer.borderWidth = 0.5
		textField.textColor = UIColor(red:0.89, green:0.00, blue:0.00, alpha:1.0)

		/// Shift the placeholder and the text of textfield to the right by 15px
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 60))
		textField.leftView = paddingView
		textField.leftViewMode = .always

		textField.delegate = self
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}


