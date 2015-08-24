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
		
		self.presentViewController(titlePrompt,
			animated: true,
			completion: nil)
	}
	
	func saveNewItem(name : String) {
		
		let newCompany = Company.createInManagedObjectContext(self.managedObjectContext!, name: name)
		self.fetchLog()
		
		if let newItemIndex = companies.indexOf(newCompany) {
			let newCompanyIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
			CompanyTableView.insertRowsAtIndexPaths([ newCompanyIndexPath ], withRowAnimation: .Automatic)
		}
	}
	

	
    // MARK: - Table view data source
	
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
