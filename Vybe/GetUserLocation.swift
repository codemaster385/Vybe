//
//  GetUserLocation.swift
//  Vybe
//
//  Created by paramvir singh on 13/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class GetUserLocation: UIViewController,UIActionSheetDelegate {
    
    var manager: OneShotLocationManager?
    var dictSignUPInputs = [String : String]()
    @IBOutlet weak var doneView: UIView!
    //var doneView :UIView?
    var latitude = ""
    var longitude = ""
    @IBOutlet weak var lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let screenSize = UIScreen.mainScreen().bounds.size
    
    }
    // MARK - custom methods
    @IBAction func btnBackClicked(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func btnNextClicked(sender: AnyObject) {
        
        let actionSheet = UIActionSheet(title: "Vybe", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil , otherButtonTitles: "Allow")
        actionSheet.showInView(self.view)
        
    }
   
    //MARK - Action sheet delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 0:
            NSLog("cancel");
            
            break;
        case 1:
            NSLog("Allow");
            manager = OneShotLocationManager()
            manager!.fetchWithCompletion {location, error in
                
                // fetch location or an error
                if let loc = location {
                    
                    
                    UIView.animateWithDuration(0.2, delay: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                       // self.doneView?.alpha=1.0
                        }, completion:{ finished in
                            
                            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                            dispatch_after(delayTime, dispatch_get_main_queue()) {
                            
                                self.latitude = "\(loc.coordinate.latitude)"
                                self.longitude = "\(loc.coordinate.longitude)"
                                self.completeSignUPProcess()
                            }

                            
                          
                            
                        }
                    )
                } else if let err = error {
                    print(err.localizedDescription)
                }
                self.manager = nil
            }

            break;
        default:
            NSLog("Default");
            break;
            //Some code here..
            
        }
    }
    func completeSignUPProcess() -> () {
        dictSignUPInputs["lattitude"] = latitude
        dictSignUPInputs["longitude"] = longitude
        
        sharedInstance.showLoaderWithText("Signing up. Please Wait...", onView: self.navigationController?.view)
        ServiceManager.manager.signUpWebservice(dictSignUPInputs) { (json, error) in
            sharedInstance.hideLoader()
            if let response = json
            {
                let model = Registration(response : response)
                if model.status == "true"
                {self.performSegueWithIdentifier("goToSelectCategoryScreen", sender: nil)}
                else
                {
                    self.showAlertWithTitle(title: "Message", message: model.message, alertType: .Alert, actions: nil)
                }
            }
            else
            {
               self.showAlertWithTitle(title: "Alert", message: error?.localizedDescription, alertType: .Alert, actions: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}