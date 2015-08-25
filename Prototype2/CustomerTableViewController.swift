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
	
	func saveNewItem( companyName: String,
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
	 employeeCompany: Company) {
		
		let newCustomer = Customer.createInManagedObjectContext(self.managedObjectContext!,companyName: companyName,
			id:id,
			customerName: customerName,
			mobileno: mobileno,
			salary: salary,
			customerType: customerType,
			canHaveCheckBook: canHaveCheckBook,
			canHaveUnlimitedCredit: canHaveUnlimitedCredit,
			hasCheckBook: hasCheckBook,
			hasUnlimitedCredit: hasUnlimitedCredit,
			loanLimit: loanLimit,
			creditLimit: creditLimit,
			maxCreditLimit: maxCreditLimit,
			maxLoanLimit: maxLoanLimit,
			employeeCompany: employeeCompany)
		
		self.fetchLog()
		
		if let newItemIndex = customers.indexOf(newCustomer) {
			let newCustomerIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
			customerTableView.insertRowsAtIndexPaths([ newCustomerIndexPath ], withRowAnimation: .Automatic)
			save()
		}
	}
	
	func save() {
		do
		{
			try managedObjectContext!.save()
		}
		catch
		{
			print(error)
		}
		
	}



    // MARK: - Table view data source
	
	/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
	*/

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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
