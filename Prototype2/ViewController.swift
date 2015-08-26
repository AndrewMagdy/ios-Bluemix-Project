//
//  ViewController.swift
//  Prototype2
//
//  Created by Andrew Magdy on 248//15.
//  Copyright (c) 2015 Andrew Magdy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
	
	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
 
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let moc = self.managedObjectContext {
			
			// Create some dummy data to work with
			let items = [
				("Best Animal", "Dog"),
				("Best Language","Swift"),
				("Worst Animal","Cthulu"),
				("Worst Language","LOLCODE")
			]
			
			// Loop through, creating items
			for (itemTitle, itemText) in items {
				// Create an individual item
				Company.createInManagedObjectContext(moc,
					name: itemTitle)
			}
		}
	
	
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		// Create a new fetch request using the LogItem entity
		let fetchRequest = NSFetchRequest(entityName: "Company")
		
		// Execute the fetch request, and cast the results to an array of LogItem objects
		if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest) as? [Company] {
			
			// Create an Alert, and set it's message to whatever the itemText is
			let alert = UIAlertController(title: fetchResults[0].name,
				message: "Hamada",
				preferredStyle: .Alert)
			
			// Display the alert
			self.presentViewController(alert,
				animated: true,
				completion: nil)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

