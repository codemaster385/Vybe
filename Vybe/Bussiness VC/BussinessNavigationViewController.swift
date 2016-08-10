//
//  BussinessNavigationViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 17/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class BussinessNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = true
       navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name : "OpenSans", size: 18.0)! , NSForegroundColorAttributeName : UIColor.whiteColor()]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIViewController : UIGestureRecognizerDelegate
{
    var shouldInteractiveGestureofNavigationBeActivated : Bool{
        get{return false}
        set(activate)
        {
            navigationController?.interactivePopGestureRecognizer?.delegate = activate ? self : nil
          navigationController?.interactivePopGestureRecognizer?.enabled = activate
        }
    }
    
    func showAlertWithTitle(title title : String? , message: String? , alertType: UIAlertControllerStyle , actions : [UIAlertAction]?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertType)
        if let allAction = actions
        {
            for action in allAction
            {
                alertController.addAction(action)
            }
        }
        else
        {
            let OK = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OK)
        }
        
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
