//
//  AppSettingOptionViewController.swift
//  Vybe
//
//  Created by Mohit Jain  on 5/29/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class AppSettingOptionViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    var titleNav = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTitle.text = titleNav
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnBackTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
