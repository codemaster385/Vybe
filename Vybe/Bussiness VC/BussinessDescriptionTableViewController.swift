//
//  BussinessDescriptionTableViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 19/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit
func openSansefontWithSize(size : CGFloat) -> UIFont {
    return UIFont(name : "OpenSans", size: size)!
}
class BussinessDescriptionTableViewController: UITableViewController , CameraImageDelegate{

    @IBOutlet weak var buttonCancel: UIBarButtonItem!
    @IBOutlet weak var buttonNext: UIBarButtonItem!
    @IBOutlet weak var textfieldNameofBusiness: UITextField!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var buttonAddLogo: UIButton!
    @IBOutlet weak var constraintHeightTextView : NSLayoutConstraint!
    
    @IBOutlet weak var labelTextViewPlaceHolder: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let color = UIColor(red: 212.0/255.0 , green:1.0 , blue:1.0 ,alpha:1.0)

        textfieldNameofBusiness.attributedPlaceholder = NSAttributedString(string: textfieldNameofBusiness.placeholder!,attributes:[NSForegroundColorAttributeName: color,NSFontAttributeName : UIFont(name : "OpenSans", size: 17.0)!])
        
        buttonCancel.setFont(openSansefontWithSize(17.0))
        buttonNext.setFont(openSansefontWithSize(17.0))

        buttonNext.enabled = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       @IBAction func actionCancel(sender: AnyObject) {
        dismissVC(sender)
    }
    @IBAction func addLogo(sender : UIButton)
    {
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
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }

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
 
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        tableView.setContentOffset(CGPointMake(0, tableView.contentInset.top), animated: false)
    }
    

    func clickedImage(image: UIImage) {
        let width = UIScreen.mainScreen().bounds.size.width

        let cropimage = image.crop(CGRectMake(0, 0, width, width))
        buttonAddLogo.setBackgroundImage(cropimage, forState: .Normal)
    }
}
extension BussinessDescriptionTableViewController : UITextFieldDelegate
{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        switch textField {
        case textfieldNameofBusiness:
            let finalString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            buttonNext.enabled = finalString.length > 0
            return true
        default:
           return true
        }
        
    }
}
extension BussinessDescriptionTableViewController: UINavigationControllerDelegate , UIImagePickerControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let width = UIScreen.mainScreen().bounds.size.width

        let cropimage = selectedImage.crop(CGRectMake(0, 0, width, width))
            buttonAddLogo.setBackgroundImage(cropimage, forState: .Normal)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
extension BussinessDescriptionTableViewController : UITextViewDelegate
{
    
    func textViewDidChange(textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: 200.0))
        let height = max(46.0, newSize.height)
        
        self.view.layoutIfNeeded()
        constraintHeightTextView.constant = height
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let finalString = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        labelTextViewPlaceHolder.hidden = finalString.length > 0
        return finalString.length <= 300
    }
}
extension String
{
    var length : Int {return self.characters.count}
    
}
extension UIBarButtonItem
{
    func setFont(font : UIFont)  {
        setTitleTextAttributes([NSFontAttributeName : font], forState: .Normal)
    }
}

extension UIImage
{
    func crop(rect:CGRect) -> UIImage
    {
        let scaleTransform : CGAffineTransform
        let origin = CGPointMake(0, 0)
        if self.size.width > self.size.height {
            let scaleRatio = rect.size.height / self.size.height
            scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio)
        }
        else
        {
            let scaleRatio = rect.size.width / self.size.width
            scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio)
        }
        let size = CGSizeMake(rect.size.width, rect.size.height)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextConcatCTM(context, scaleTransform)
        self.drawAtPoint(origin)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }

}
