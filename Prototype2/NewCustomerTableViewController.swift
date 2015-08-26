//
//  NewCustomerTableViewController.swift
//  Prototype2
//
//  Created by Andrew Magdy on 258//15.
//  Copyright © 2015 Andrew Magdy. All rights reserved.
//

import UIKit
import SystemConfiguration

class NewCustomerTableViewController: UITableViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	
	
	let url : String = "https://brsv2-6c316cbf.ng.bluemix.net/DecisionService/rest/tiersRuleApp/1.0/tiersRuleProject/1.0"
	
	let pass: String = "Basic cmVzQWRtaW46czR2NXU1YTU4OGM5"
	
	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	var selectedCompany:Company?
	
	var newCustomer:Customer?
	
	var customerData:AnyObject?
	
	var supportingDocument:UIImage?
	
	
	
	@IBOutlet weak var NameTextField: UITextField!
	@IBOutlet weak var IdTextField: UITextField!
	@IBOutlet weak var MobileNoTextField: UITextField!
	@IBOutlet weak var SalaryTextField: UITextField!
	@IBOutlet weak var LoanSwitch: UISwitch!
	@IBOutlet weak var CreditCardSwitch: UISwitch!
	@IBOutlet weak var CheckBookSwitch: UISwitch!
	@IBOutlet weak var UnlimitedCreditSwitch: UISwitch!
	@IBOutlet weak var CreditLimitTextField: UITextField!
	@IBOutlet weak var LoanLimitTextField: UITextField!
	@IBOutlet weak var VerifyButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "New Customer at \(selectedCompany!.name)"
		
		NameTextField.delegate = self
		IdTextField.delegate = self
		MobileNoTextField.delegate = self
		SalaryTextField.delegate = self
		CreditLimitTextField.delegate = self
		LoanLimitTextField.delegate = self
	}
	
	func saveNewItem() {
		
		let companyName: String = self.selectedCompany!.name
		let customerName: String = self.NameTextField.text!
		let customerId: String = self.IdTextField.text!
		let mobileno: String = self.MobileNoTextField.text!
		
		let annualSalary: Double = customerData!["salary"] as! Double
		let customerType: String = customerData!["customerType"] as! String
		
		let CreditLimit: Double = customerData!["requestedCreditCardLimit"] as! Double
		let LoanLimit: Double = customerData!["requestedLoanLimit"] as! Double
		
		let hasCheckBook: Bool   = customerData!["requestedCheckBook"] as! Bool
		let hasUnlimitedCredit: Bool = customerData!["requestedUnlimitedCreditCard"] as! Bool
		
		let canHaveCheckBook: Bool = customerData!["hasCheckBook"] as! Bool
		let canHaveUnlimitedCredit: Bool = customerData!["hasUnlimitedCreditCard"] as! Bool
		
		let maxCreditLimit: Double =  customerData!["limitOfCreditCard"] as! Double
		let maxLoanLimit :Double =  customerData!["limitOfLoan"] as! Double
		
		
		
		let supportingDocument = UIImageJPEGRepresentation(self.supportingDocument! ,1 )
		
		newCustomer = Customer.createInManagedObjectContext(self.managedObjectContext!,companyName: companyName,
			id:customerId,
			customerName: customerName,
			mobileno: mobileno,
			salary: annualSalary,
			customerType: customerType,
			canHaveCheckBook: canHaveCheckBook,
			canHaveUnlimitedCredit: canHaveUnlimitedCredit,
			hasCheckBook: hasCheckBook,
			hasUnlimitedCredit: hasUnlimitedCredit,
			loanLimit: LoanLimit,
			creditLimit: CreditLimit,
			maxCreditLimit: maxCreditLimit,
			maxLoanLimit: maxLoanLimit,
			supportingDocument : supportingDocument!,
			employeeCompany: selectedCompany!)
		
		save()
		self.performSegueWithIdentifier("ShowCustomerTable",sender:self);
		
	}
	
	func addImage()
	{
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .Camera
		imagePickerController.delegate = self
		self.presentViewController(imagePickerController, animated: true, completion: nil)
		
	}
	func checkInternet ()
	{
		dispatch_async(dispatch_get_main_queue()) {
			let titlePrompt = UIAlertController(title: "Error Connecting To IBM BlueMix",
				message: "Please Check Internet Connection And Try Again",
				preferredStyle: .Alert)
			
			titlePrompt.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
			
			self.presentViewController(titlePrompt,
				animated: true,
				completion: nil)
		}
	}
	
	func verifyFail ()
	{
		print(customerData)
		if let messageArray: [String]  = customerData!["messages"] as? [String]
		{
			var messages :String = ""
			
			for message in messageArray {
				messages += message + "\n"
			}
			let titlePrompt = UIAlertController(title: "Error Verifying Customer",
				message: messages,
				preferredStyle: .Alert)
			
			titlePrompt.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
			
			self.presentViewController(titlePrompt,
				animated: true,
				completion: nil)
			
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
	func setupJson () ->[NSObject: AnyObject]
	{
		
		
		let salary:String = self.SalaryTextField.text ?? "0"
		let requestedCreditCardLimit:String = self.CreditLimitTextField.text ?? "0"
		let requestedLoanLimit:String = self.LoanLimitTextField.text ?? "0"
		let requestedCheckBook:String = self.CheckBookSwitch.on.description
		let requestedUnlimitedCreditCard:String = self.UnlimitedCreditSwitch.on.description
		
		let jsonRequest: [NSObject: AnyObject]  = [
			"theCustomer": [
				"salary": salary,
				"requestedCreditCardLimit" : requestedCreditCardLimit,
				"requestedLoanLimit" : requestedLoanLimit,
				"requestedCheckBook" : requestedCheckBook ,
				"requestedUnlimitedCreditCard" : requestedUnlimitedCreditCard
			]
		]
		
		return jsonRequest
	}
	
	func parseJson (json:NSDictionary?)
	{
		
		if let parseJSON = json {
			if let customerData: AnyObject = parseJSON["theCustomer"] {
				self.customerData = customerData
				if let approved   = customerData["approved"] as? Bool {
					if approved  {
						dispatch_async(dispatch_get_main_queue()) {
						self.addImage()
						}
					}
					else{
						dispatch_async(dispatch_get_main_queue()) {
							self.verifyFail()
						}
					}
				}
					
				else {
					print("Error could not parse JSON")
				}
			}
		}
		
	}
	
	func post () {
		
		let request : NSMutableURLRequest = NSMutableURLRequest()
		let session = NSURLSession.sharedSession()
		let jsonRequest = setupJson()
		
		request.URL = NSURL(string: url)
		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue(pass, forHTTPHeaderField: "Authorization")
		
		
		do {
			request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonRequest, options: [])
		} catch  {
			request.HTTPBody = nil
		}
		
		
		let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
			if let rData = data
			{
				do
				{
					let json  = try NSJSONSerialization.JSONObjectWithData(rData, options: .MutableLeaves) as?NSDictionary
					self.parseJson(json)
				}
				catch
				{
					dispatch_async(dispatch_get_main_queue()) {
						self.checkInternet()
					}
				}
			}
			
			
			
		})
		
		task.resume()
		
	}
	
	// MARK: UITextFieldDelegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		// Hide the keyboard.
		if textField == self.NameTextField {
			self.IdTextField.becomeFirstResponder()
		}
		else if textField == self.IdTextField {
			self.MobileNoTextField.becomeFirstResponder()
		}
		else if textField == self.MobileNoTextField {
			self.SalaryTextField.becomeFirstResponder()
		}
		else {
			textField.resignFirstResponder()
		}
		return true
	}
	
	// MARK: UIImagePickerControllerDelegate
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		supportingDocument = info[UIImagePickerControllerOriginalImage] as? UIImage
		self.saveNewItem()
		//dismissViewControllerAnimated(true, completion: nil)

	}
	
	// MARK: - Actions
	
	@IBAction func VerifyBarButton(sender: UIBarButtonItem) {
		let textFields = [NameTextField,IdTextField,SalaryTextField,MobileNoTextField]
		var canVerify = true
		for textField in textFields
		{
			if (textField.text!.isEmpty)
			{
				textField.layer.borderColor = UIColor.redColor().CGColor
				textField.layer.borderWidth = 2
				textField.placeholder = "Field Required"
				canVerify = false
			}
		}
		if CreditCardSwitch.on && CreditLimitTextField.text!.isEmpty && !UnlimitedCreditSwitch.on
		{
			CreditLimitTextField.layer.borderColor = UIColor.redColor().CGColor
			CreditLimitTextField.layer.borderWidth = 2
			CreditLimitTextField.placeholder = "Field Required"
			canVerify = false
		}
		
		if LoanSwitch.on && LoanLimitTextField.text!.isEmpty
		{
			LoanLimitTextField.layer.borderColor = UIColor.redColor().CGColor
			LoanLimitTextField.layer.borderWidth = 2
			LoanLimitTextField.placeholder = "Field Required"
			canVerify = false
		}
		
		
		if (canVerify)
		{
			post()
		}
		else
		{
			let titlePrompt = UIAlertController(title: "Incomplete Form",
				message: "Please Fill The Required Fields",
				preferredStyle: .Alert)
			
			titlePrompt.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
			
			self.presentViewController(titlePrompt,
				animated: true,
				completion: nil)
		}
	}
	
	@IBAction func ChangedSwitch(sender: UISwitch) {
		if (sender == self.LoanSwitch)
		{
			if (self.LoanSwitch.on)
			{
				self.LoanLimitTextField.enabled = true
			}
			else
			{
				self.LoanLimitTextField.enabled = false
				self.LoanLimitTextField.layer.borderWidth = 0
				self.LoanLimitTextField.placeholder = ""
				self.LoanLimitTextField.text = ""

			}
		}
		else
		{
			if (self.UnlimitedCreditSwitch.on)
			{
				self.CreditCardSwitch.on = true
				self.CreditLimitTextField.enabled = false
				self.CreditLimitTextField.layer.borderWidth = 0
				self.CreditLimitTextField.placeholder = ""
				self.CreditLimitTextField.text = ""
				
			}
				
			else if (self.CreditCardSwitch.on)
			{
				self.CreditLimitTextField.enabled = true
			}
			else
			{
				self.CreditLimitTextField.enabled = false
				self.CreditLimitTextField.layer.borderWidth = 0
				self.CreditLimitTextField.placeholder = ""
			}
		}
		
	}
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "ShowCustomerTable") {
			let controller = (segue.destinationViewController as! CustomerTableViewController)
			let company = self.selectedCompany
			controller.selectedCompany = company
		}
	}
	
	
}
