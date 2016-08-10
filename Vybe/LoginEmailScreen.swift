//
//  LoginEmailScreen.swift
//  Vybe
//
//  Created by paramvir singh on 08/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit

class LoginEmailScreen:UIViewController {
    
    
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.frame = CGRectMake(0,0,10,40)
        
        txtFieldEmail.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtFieldEmail.leftViewMode = UITextFieldViewMode.Always
        txtFieldEmail.leftView = view
      
        
        let view1 = UIView()
        view1.frame = CGRectMake(0,0,10,40)
        txtFieldPassword.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtFieldPassword.leftViewMode = UITextFieldViewMode.Always
        txtFieldPassword.leftView = view1
        
        
        let attrs = [
            NSFontAttributeName : UIFont.systemFontOfSize(15.0),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSUnderlineStyleAttributeName : 1]
        
        let attributedString = NSMutableAttributedString(string:"")
    
        let buttonTitleStr = NSMutableAttributedString(string:"Forgot Password?", attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        
        self.btnForgetPassword.setAttributedTitle(attributedString, forState: .Normal)
        
        let attrs11 = [
            NSFontAttributeName : UIFont.systemFontOfSize(15.0),
            NSForegroundColorAttributeName : UIColor.whiteColor()]
        let attrs22 = [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(15.0),
            NSForegroundColorAttributeName : UIColor.whiteColor()  ]

        
        
        let attributedString1 = NSMutableAttributedString(string:"Don't have an account?",attributes:attrs11)
        
        let buttonTitleStr1 = NSMutableAttributedString(string:" Signup!", attributes:attrs22)
        
        attributedString1.appendAttributedString(buttonTitleStr1)
        
        self.btnSignup.setAttributedTitle(attributedString1, forState: .Normal)
        
        
        self.btnFacebook.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnFacebook.layer.borderWidth = 1.0
              // self.btnForgetPassword.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        

        
    }
    
    //MARK: - Login btn action
    @IBAction func loginBtnClicked(sender: AnyObject) {
        
        if txtFieldEmail.text?.length==0{

        showAlertWithTitle(title: "Alert", message: "Please enter email", alertType: .Alert, actions: nil)
            return

        }
        else if txtFieldPassword.text?.length==0{

            showAlertWithTitle(title: "Alert", message: "Please enter password", alertType: .Alert, actions: nil)
            return;
 
        }
        let input = ["email":txtFieldEmail.text!,"password":txtFieldPassword.text!]
        sharedInstance.showLoaderWithText("Login. Please Wait...", onView: self.navigationController?.view)
        ServiceManager.manager.loginWebservice(input) { (json, error) in
            sharedInstance.hideLoader()
         if let response = json
         {
            let model = Registration(response:response)
            if model.status == "true"
            {
            let viewCtrl = self.storyboard? .instantiateViewControllerWithIdentifier("MainPageViewController")
            
            self.navigationController?.pushViewController(viewCtrl!, animated: true)
            }
            else
            {
                self.showAlertWithTitle(title: "Alert", message: model.message, alertType: .Alert, actions: nil)
            }
            }
            else
         {
            self.showAlertWithTitle(title: "Alert", message: error?.localizedDescription, alertType: .Alert, actions: nil)
            }
        }
     
        
    }
    
    @IBAction func faceBtnClicked(sender: AnyObject) {
        
    }
    @IBAction func btnSignupClicked(sender: AnyObject) {
    }
    @IBAction func btnForgotClicked(sender: AnyObject) {
    }
     //MARK: - Textfiled delegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField==txtFieldEmail {
            txtFieldPassword .becomeFirstResponder()
        }else if textField==txtFieldPassword{
            txtFieldPassword.resignFirstResponder()
        }
        
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
}