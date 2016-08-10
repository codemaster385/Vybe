//
//  BussinessAccountDetailController.swift
//  Vybe
//
//  Created by Arun Kumar on 17/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class BussinessAccountDetailController: UITableViewController {

    @IBOutlet weak var barbuttonRight: UIBarButtonItem!
    @IBOutlet weak var textFieldBusiName : UITextField!
    @IBOutlet weak var textFieldBusiAddress : UITextField!
    @IBOutlet weak var textFieldBusiURL : UITextField!
    @IBOutlet weak var textFieldBusiPhone : UITextField!
    @IBOutlet weak var textViewBusiInfo : UITextView!
    @IBOutlet weak var labelParkingStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
shouldInteractiveGestureofNavigationBeActivated = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        editingEnable = false
    }
    var isEditable = false
    var editingEnable : Bool {
        get{
            return isEditable
        }
        set(enable)
        {
            isEditable = enable
            if(!enable){self.view.endEditing(true)}
            barbuttonRight.title = enable ?  "Done" :"Edit"
            textFieldBusiName.enabled = enable
            textFieldBusiAddress.enabled = enable
            textFieldBusiURL.enabled = enable
            textFieldBusiPhone.enabled = enable
            textViewBusiInfo.editable = enable
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    @IBAction func actionRightBarButton(sender: UIBarButtonItem) {
        editingEnable = !isEditable
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return isIphone6 ? 345-105 : isIphone6Plus ? 383-105 :  305-105
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if isEditable {
 
    switch indexPath.row {
    case 4:
        let businessScheduleVC = self.storyboard?.instantiateViewControllerWithIdentifier("BusinessScheduleTableViewController") as! BusinessScheduleTableViewController
        businessScheduleVC.isChangigMode = true
        pushToVC(businessScheduleVC)
        case 6:
            let businessParkingVC = self.storyboard?.instantiateViewControllerWithIdentifier("ParkingTableViewController") as! ParkingTableViewController
            businessParkingVC.isChangigMode = true
            pushToVC(businessParkingVC)
    default:break
    }
    }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindSegueForTiming(segue : UIStoryboardSegue)
    {
        
    }
    @IBAction func unwindSegueForParking(segue : UIStoryboardSegue)
    {
        
    }

}
