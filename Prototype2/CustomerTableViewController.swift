//
//  CustomerTableViewController.swift
//  Prototype2
//
//  Created by Andrew Magdy on 258//15.
//  Copyright © 2015 Andrew Magdy. All rights reserved.
//

import UIKit
import CoreData

class CustomerTableViewController: UITableViewController {
	
	@IBOutlet var customerTableView: UITableView!
	
	var selectedCompany:Company?
	
	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	var customers = [Customer]()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		fetchLog();

    }
	
	func fetchLog()  {
		let fetchRequest = NSFetchRequest(entityName: "Customer")
		
		let sortDescriptor = NSSortDescriptor(key: "customerName", ascending: true)
		
		let predicate = NSPredicate(format: "employeeCompany == %@", selectedCompany!)
		
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		fetchRequest.predicate = predicate
		
		do
		{
			let fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [Customer]
			customers = fetchResults
		}
		catch
		{
			print(error)
		}
	}
	
	



    // MARK: - Table view data source
	


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customers.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomerCell", forIndexPath: indexPath)

		
		let customer = customers[indexPath.row]
		
		cell.textLabel?.text = customer.customerName

        return cell
    }


	
    // MARK: - Navigation
	
	@IBAction func unwindToCustomerTable(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.sourceViewController as? NewCustomerTableViewController  {
		fetchLog()
		let newCustomer = sourceViewController.newCustomer
			
		if let newItemIndex = customers.indexOf(newCustomer!){
			// Create an NSIndexPath from the newItemIndex
			let newCustomerIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
			// Animate in the insertion of this row
			customerTableView.insertRowsAtIndexPaths([ newCustomerIndexPath ], withRowAnimation: .Automatic)
			}
		}
	}

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
			if (segue.identifier == "ShowCustomer") {
				let controller = (segue.destinationViewController as! ViewCustomerTableViewController)
				let row = (sender as! NSIndexPath).row; //we know that sender is an NSIndexPath here.
				let customer = customers[row]
				controller.selectedCustomer = customer
			}
			else if (segue.identifier == "AddCustomer"){
				let controller = (segue.destinationViewController as! NewCustomerTableViewController)
				controller.selectedCompany = self.selectedCompany
		}
		
    }
		override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
			self.performSegueWithIdentifier("ShowCustomer", sender: indexPath);
		}
	

}
