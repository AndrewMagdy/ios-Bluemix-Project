//
//  Company.swift
//  
//
//  Created by Andrew Magdy on 248//15.
//
//

import Foundation
import CoreData

class Company: NSManagedObject {

    @NSManaged var name: String
	
	class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String) -> Company {
		let newItem = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: moc) as! Company
		newItem.name = name
		
		return newItem
	}

}
