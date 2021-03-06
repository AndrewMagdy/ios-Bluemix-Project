//
//  CompanyTableViewController.swift
//  Prototype2
//
//  Created by Andrew Magdy on 248//15.
//  Copyright (c) 2015 Andrew Magdy. All rights reserved.
//

import UIKit
import CoreData

class CompanyTableViewController: UITableViewController {
	
	@IBOutlet var CompanyTableView: UITableView!
	
	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	var companies = [Company]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		fetchLog()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
	
	func fetchLog()  {
		let fetchRequest = NSFetchRequest(entityName: "Company")
		
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		do
		{			
		let fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [Company]
			companies = fetchResults
		}
		catch
		{
			print(error)
		}
	}
	
	func saveNewItem(name : String) {
		
		if (name.characters.count > 0)
		{
		let newCompany = Company.createInManagedObjectContext(self.managedObjectContext!, name: name)
		self.fetchLog()
		
		if let newItemIndex = companies.indexOf(newCompany) {
			let newCompanyIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
			CompanyTableView.insertRowsAtIndexPaths([ newCompanyIndexPath ], withRowAnimation: .Automatic)
			save()
		}
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
	
	// MARK: - Actions
	
	@IBAction func addNewItem(sender: UIBarButtonItem) {
		
		let titlePrompt = UIAlertController(title: "New Company",
			message: "Enter Company Name",
			preferredStyle: .Alert)
		
		var titleTextField: UITextField?
		titlePrompt.addTextFieldWithConfigurationHandler {
			(textField) -> Void in
			titleTextField = textField
			textField.placeholder = "Name"
		}
		
		
		titlePrompt.addAction(UIAlertAction(title: "Ok",
			style: .Default,
			handler: { (action) -> Void in
				if let textField = titleTextField {
					self.saveNewItem(textField.text!)
				}
		}))
		
		titlePrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
		
		
		self.presentViewController(titlePrompt,
			animated: true,
			completion: nil)
	}
    // MARK: - Table view data source
	/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
	*/

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyCell", forIndexPath: indexPath)
		
		let company = companies[indexPath.row]
		
		cell.textLabel?.text = company.name

        return cell
    }
	

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

	
    // MARK: - Navigation
	

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "ShowCustomers") {
			let controller = (segue.destinationViewController as! CustomerTableViewController)
			let row = (sender as! NSIndexPath).row; //we know that sender is an NSIndexPath here.
			let company = companies[row] 
			controller.selectedCompany = company
		}
	}
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("ShowCustomers", sender: indexPath);
	}


}
