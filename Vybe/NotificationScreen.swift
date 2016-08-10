//
//  NotificationScreen.swift
//  Vybe
//
//  Created by paramvir singh on 07/05/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
//
//  ProfileScreen.swift
//  Vybe
//
//  Created by paramvir singh on 07/05/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit


class NotificationScreenCell: UITableViewCell {
    
    @IBOutlet weak var itemImgView: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var lblFemale: UILabel!
    
    @IBOutlet weak var cellAccessoryView: UIImageView!
}


class NotificationScreen:UIViewController {
    
    
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.separatorColor = UIColor.init(colorLiteralRed: 168/255.0, green: 181/255.0, blue: 211/255.0, alpha: 1.0)

        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) as! NotificationScreenCell
        
        
        
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
    }
    
    
    @IBAction func backBtnClicked(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
}
