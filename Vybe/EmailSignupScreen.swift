//
//  EmailSignupScreen.swift
//  Vybe
//
//  Created by paramvir singh on 09/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit



class EmailSignupScreen:UIViewController,UINavigationControllerDelegate,UINavigationBarDelegate {
    
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldEmailId: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.interactivePopGestureRecognizer!.enabled = true
       // self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        let view = UIView()
        view.frame = CGRectMake(0,0,10,40)
        txtFieldFirstName.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtFieldFirstName.leftViewMode = UITextFieldViewMode.Always
        txtFieldFirstName.leftView = view
        
        let view1 = UIView()
        view1.frame = CGRectMake(0,0,10,40)
        txtFieldLastName.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtFieldLastName.leftViewMode = UITextFieldViewMode.Always
        txtFieldLastName.leftView = view1
        
        let view2 = UIView()
        view2.frame = CGRectMake(0,0,10,40)
        txtFieldEmailId.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtFieldEmailId.leftViewMode = UITextFieldViewMode.Always
        txtFieldEmailId.leftView = view2
        
        let view3 = UIView()
        view3.frame = CGRectMake(0,0,10,40)
        txtFieldPassword.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtFieldPassword.leftViewMode = UITextFieldViewMode.Always
        txtFieldPassword.leftView = view3
        
        
        let attrs11 = [
            NSFontAttributeName : UIFont.systemFontOfSize(15.0),
            NSForegroundColorAttributeName : UIColor.whiteColor()]
        let attrs22 = [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(15.0),
            NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        
        
        let attributedString1 = NSMutableAttributedString(string:"Already have an account?",attributes:attrs11)
        
        let buttonTitleStr1 = NSMutableAttributedString(string:" Sign in!", attributes:attrs22)
        
        attributedString1.appendAttributedString(buttonTitleStr1)
        
        self.btnLogin.setAttributedTitle(attributedString1, forState: .Normal)
        
        
        self.btnFacebook.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnFacebook.layer.borderWidth = 1.0
        
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    //MARK: - Btn action
    @IBAction func btnFacebookClicked(sender: AnyObject) {
        
    }
    
    @IBAction func signinBtnClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    @IBAction func btnSignupClicked(sender: AnyObject) {
        
        
        if txtFieldFirstName.text?.length == 0{

            showAlertWithTitle(title: "Alert", message: "Please enter First name", alertType: .Alert, actions: nil)
            
            return;
            
        }
        
        else if !self.isValidEmail(txtFieldEmailId.text!){

            showAlertWithTitle(title: "Alert", message: "Please enter Valid email id", alertType: .Alert, actions: nil)
            return;
            
        }
        else if txtFieldLastName.text?.length == 0{
            
         
            showAlertWithTitle(title: "Alert", message: "Please enter Last name", alertType: .Alert, actions: nil)
            return;

            
        }else if txtFieldEmailId.text?.length == 0{
        
            showAlertWithTitle(title: "Alert", message: "Please enter Email", alertType: .Alert, actions: nil)
            
            return;

            
        }else if txtFieldPassword.text?.length == 0{
          
             showAlertWithTitle(title: "Alert", message: "Please enter password", alertType: .Alert, actions: nil)
            
            return;

            
        }
        
        
       self .performSegueWithIdentifier("PushToGenderScreenID", sender: nil)
        
    }
    //MARK: Email Validation
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    //MARK UITextfiled Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField==txtFieldFirstName {
            txtFieldLastName .becomeFirstResponder()
        }else if textField==txtFieldLastName{
            txtFieldEmailId.becomeFirstResponder()
        }else if textField==txtFieldEmailId{
            txtFieldPassword.becomeFirstResponder()
        }else if textField==txtFieldPassword{
            txtFieldPassword.resignFirstResponder()
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushToGenderScreenID"
        {
            let inputs = ["fname":txtFieldFirstName.text!,"lname":txtFieldLastName.text!,"email":txtFieldEmailId.text!,"password":txtFieldPassword.text!]
            let vc = segue.destinationViewController as! SelectGenderScreen
            vc.dictSignUPInputs = inputs
        }
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

