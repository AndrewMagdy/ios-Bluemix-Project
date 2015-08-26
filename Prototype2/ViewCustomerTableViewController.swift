//
//  ViewCustomerTableViewController.swift
//  Prototype2
//
//  Created by Andrew Magdy on 268//15.
//  Copyright © 2015 Andrew Magdy. All rights reserved.
//

import UIKit

class ViewCustomerTableViewController: UITableViewController {
	
	@IBOutlet weak var supportingDocument: UIImageView!
	@IBOutlet weak var CompanyName: UITextField!
	@IBOutlet weak var CustomerName: UITextField!
	@IBOutlet weak var MobileNo: UITextField!
	@IBOutlet weak var Salary: UITextField!
	@IBOutlet weak var ID: UITextField!
	@IBOutlet weak var LoanLimit: UITextField!
	@IBOutlet weak var CreditLimit: UITextField!
	@IBOutlet weak var UnlimitedCredit: UISwitch!
	@IBOutlet weak var CheckBook: UISwitch!
	
	var selectedCustomer:Customer?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.supportingDocument.image = UIImage(data: selectedCustomer!.supportingDocument!)
		self.CompanyName.text = selectedCustomer!.companyName
		self.CustomerName.text = selectedCustomer!.customerName
		self.MobileNo.text = selectedCustomer!.mobileno
		self.Salary.text = selectedCustomer!.salary?.description
		self.ID.text = selectedCustomer!.id
		self.LoanLimit.text = selectedCustomer!.loanLimit?.description
		self.CreditLimit.text = selectedCustomer!.creditLimit?.description
		self.UnlimitedCredit.on = selectedCustomer!.hasUnlimitedCredit!.boolValue
		self.CheckBook.on = selectedCustomer!.hasCheckBook!.boolValue

    }

}
