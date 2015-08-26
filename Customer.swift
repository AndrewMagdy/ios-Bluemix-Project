//
//  Customer.swift
//  Prototype2
//
//  Created by Andrew Magdy on 258//15.
//  Copyright © 2015 Andrew Magdy. All rights reserved.
//

import Foundation
import CoreData

class Customer: NSManagedObject {
	
	
	class func createInManagedObjectContext(moc: NSManagedObjectContext,  companyName: String,
	 id: String,
	 customerName: String,
	 mobileno: String,
	 salary: NSNumber,
	 customerType: String,
	 canHaveCheckBook: NSNumber,
	 canHaveUnlimitedCredit: NSNumber,
	 hasCheckBook: NSNumber,
	 hasUnlimitedCredit: NSNumber,
	 loanLimit: NSNumber,
	 creditLimit: NSNumber,
	 maxCreditLimit: NSNumber,
	 maxLoanLimit: NSNumber,
	 supportingDocument: NSData,
	 employeeCompany: Company) -> Customer {
		
		let newItem = NSEntityDescription.insertNewObjectForEntityForName("Customer", inManagedObjectContext: moc) as! Customer
		
		newItem.companyName = companyName
		newItem.id = id
		newItem.customerName = customerName
		newItem.mobileno = mobileno
		newItem.salary = salary
		newItem.customerType = customerType
		newItem.canHaveCheckBook = canHaveCheckBook
		newItem.canHaveUnlimitedCredit = canHaveUnlimitedCredit
		newItem.loanLimit = loanLimit
		newItem.creditLimit = creditLimit
		newItem.maxCreditLimit = maxCreditLimit
		newItem.maxLoanLimit = maxLoanLimit
		newItem.supportingDocument = supportingDocument
		newItem.employeeCompany = employeeCompany

		
		return newItem
	}
	
}
