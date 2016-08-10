//
//  BussinessTableViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 17/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit
let isIphone5 = UIScreen.mainScreen().bounds.size.height == 568
let isIphone6 = UIScreen.mainScreen().bounds.size.height == 667
let isIphone6Plus = UIScreen.mainScreen().bounds.size.height == 736

class BussinessTableViewController: UITableViewController,CameraImageDelegate {

    @IBOutlet weak var buttonAddLogo: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",style: .Plain , target: nil , action: nil)
        shouldInteractiveGestureofNavigationBeActivated = false
    }
    @IBAction func addLogoAction(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Select an option" , message: "" , preferredStyle: .ActionSheet)
        let actionGallery = UIAlertAction(title: "Gallery",style: .Default , handler: {(action) -> Void in
        let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = .PhotoLibrary
            pickerVC.allowsEditing = false
            self.presentViewController(pickerVC, animated: true, completion: nil)
        })
        let actionCamera = UIAlertAction(title: "Camera",style: .Default , handler: {(action) -> Void in
            self.performSegueWithIdentifier("segueCamera", sender: nil)
        })
        let actionCancel = UIAlertAction(title: "Cancel",style: .Cancel , handler: {(action) -> Void in
        })
        actionSheet.addAction(actionGallery)
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionCancel)
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToCameraScreen(sender: AnyObject) {
        let cameraVC = storyboard?.instantiateViewControllerWithIdentifier("CameraVIewId") as! CameraViewScreen
        navigationController?.pushViewController(cameraVC, animated: true)
    }
    // MARK: - Table view data source

   

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return isIphone6 ? 345 : isIphone6Plus ? 383 :  305
        default:
            return isIphone6 ? 54 :isIphone6Plus ? 59 : 44
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rows = tableView.numberOfRowsInSection(0)
        switch indexPath.row {
        case rows-1:
            dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
    }
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueCamera" {
            let vc = segue.destinationViewController as! BussinessLogocameraViewController
            vc.delegate = self
        }

    }
    func clickedImage(image: UIImage) {
        let width = UIScreen.mainScreen().bounds.size.width
        let cropimage = image.crop(CGRectMake(0, 0, width, width))
        buttonAddLogo.setImage(cropimage, forState: .Normal)
    }

}
extension BussinessTableViewController : UINavigationControllerDelegate , UIImagePickerControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
             let width = UIScreen.mainScreen().bounds.size.width
       let image = selectedImage.crop(CGRectMake(0, 0, width, width))
        buttonAddLogo.setImage(image, forState: .Normal)
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
