//
//  Customer+CoreDataProperties.swift
//  Prototype2
//
//  Created by Andrew Magdy on 258//15.
//  Copyright © 2015 Andrew Magdy. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Customer {

    @NSManaged var companyName: String?
    @NSManaged var id: String?
    @NSManaged var customerName: String?
    @NSManaged var mobileno: String?
    @NSManaged var salary: NSNumber?
    @NSManaged var customerType: String?
    @NSManaged var canHaveCheckBook: NSNumber?
    @NSManaged var canHaveUnlimitedCredit: NSNumber?
    @NSManaged var hasCheckBook: NSNumber?
    @NSManaged var hasUnlimitedCredit: NSNumber?
    @NSManaged var loanLimit: NSNumber?
    @NSManaged var creditLimit: NSNumber?
    @NSManaged var maxCreditLimit: NSNumber?
    @NSManaged var maxLoanLimit: NSNumber?
    @NSManaged var employeeCompany: Company?

}
