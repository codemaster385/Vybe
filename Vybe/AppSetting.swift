//
//  AppSetting.swift
//  Vybe
//
//  Created by paramvir singh on 08/05/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit

class AppSetting:UIViewController {
    
    
    @IBOutlet weak var tblView: UITableView!
    
    let arryItems = ["Privacy Policy","Terms Of Service","Licenses","FAQ","Feedback","Rate"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tblView.separatorColor = UIColor.init(colorLiteralRed: 168/255.0, green: 181/255.0, blue: 211/255.0, alpha: 1.0)

        self.tblView.tableFooterView = UIView()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) 
        
        cell.textLabel?.text = arryItems[indexPath.row]
        cell.textLabel?.font = UIFont(name: "OpenSans-Regular", size: 16)

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.textColor = UIColor.grayColor()
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("AppSettingOption") as? AppSettingOptionViewController
        switch indexPath.row {
        case 0:
            vc?.titleNav = "Privacy Policy"
            self.navigationController?.pushViewController(vc!, animated: true)
        case 1:
            vc?.titleNav = "Terms of Service"
            self.navigationController?.pushViewController(vc!, animated: true)
        case 2:
            vc?.titleNav = "Licenses"
            self.navigationController?.pushViewController(vc!, animated: true)
        case 3:
            vc?.titleNav = "FAQ"
            self.navigationController?.pushViewController(vc!, animated: true)
        case 4:
            self.performSegueWithIdentifier("FeedBackScreenID", sender: nil)
        default:
            break
        }
        
    }
    
    
    @IBAction func backBtnClicked(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
}
