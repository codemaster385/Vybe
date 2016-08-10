//
//  ForgotPassword.swift
//  Vybe
//
//  Created by paramvir singh on 30/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit

class ForgotPassword:UIViewController {
    
    @IBOutlet weak var doneView: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.frame = CGRectMake(0,0,10,40)
        
          let size=UIScreen.mainScreen().bounds.size
        
        txtEmail.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtEmail.leftViewMode = UITextFieldViewMode.Always
        txtEmail.leftView = view
        
         self.doneView.contentMode=UIViewContentMode.Center
        
        
        let image : UIImage = UIImage(named:"DoneBtn")!
        
        let doneImageView = UIImageView(image: image)
        doneImageView.frame = CGRectMake(size.width/2-85,100, 170, 170)
        doneImageView.contentMode=UIViewContentMode.Center
        self.doneView.addSubview(doneImageView)
        
        let doneLbl = UILabel()
        doneLbl.text = "Your new password sent to your mail.\n You can change it in Profile."
        doneLbl.textAlignment = NSTextAlignment.Center;
        doneLbl.numberOfLines = 0
        doneLbl.font = UIFont.systemFontOfSize(16)
        doneLbl.textColor = UIColor.whiteColor()
        doneLbl.frame = CGRectMake(15,360,size.width-30, 40)
        self.doneView.addSubview(doneLbl)
        

    }
    
    @IBAction func dismissBtnClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func resetBtnClicked(sender: AnyObject) {
        
        
        if txtEmail.text?.characters.count==0{
            let alert = UIAlertController(title: "Vybe", message: "Please enter email", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        UIView.animateWithDuration(0.2, delay: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.doneView?.alpha=1.0
            }, completion:{ finished in
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                
                
                
            }
        )
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        txtEmail.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
         txtEmail.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}