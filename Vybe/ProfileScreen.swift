//
//  ProfileScreen.swift
//  Vybe
//
//  Created by paramvir singh on 07/05/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit



class ProfileScreen:UIViewController {
    @IBOutlet var pickerBday: UIDatePicker!
    
    @IBOutlet var pickerViewGender: UIPickerView!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var buttonDone : UIButton!
    weak var tempTextField : UITextField?
    @IBOutlet weak var imageView : UIImageView!
    let genders = ["Male","Female"]
    var arrItems = ["Param","Qwerty@yahoo.com","23/11/1990","Male"]
    let arryImg = ["username","email","dob","gender"]
    
      let size=UIScreen.mainScreen().bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.separatorColor = UIColor.init(colorLiteralRed: 168/255.0, green: 181/255.0, blue: 211/255.0, alpha: 1.0)

      
        
        self.tblView.tableFooterView = UIView()
        
        buttonDone.setTitle(isEditable ? "Done" : "Edit", forState: .Normal)
        
           }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let identifier = indexPath.row == 3 ? "cellGender" : "cell"
         let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ProfileCell
        
        let strname = String(arryImg[indexPath.row])
        let image : UIImage = UIImage(named:strname)!
        
        
        cell.imageViewType.image = image
        cell.textField.text = arrItems [indexPath.row]
     
        cell.textField.tag = indexPath.row
        
       
        cell.accessoryType = isEditable ? .DisclosureIndicator : .None
        cell.textField.enabled = isEditable
        
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
    }
    
  
    @IBAction func cancelBtnClicked(sender: AnyObject) {
    //dismissViewControllerToTop()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    var isEditable = false
    
    @IBAction func doneBtnClicked(sender: UIButton) {
       
        isEditable = !isEditable
        buttonDone.setTitle(isEditable ? "Done" : "Edit", forState: .Normal)
        if !isEditable {
            self.view.endEditing(true)
        }
        tblView.reloadData()

        
    }
    @IBAction func actionAddPhoto(sender: AnyObject) {
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) { (_) -> Void in
            self.openImagePickerControllerForSourceType(.Camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .Default) { (_) -> Void in
            self.openImagePickerControllerForSourceType(.PhotoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (_) -> Void in
            
        }
        showAlertWithTitle(title: "Select an option", message: nil, alertType: .ActionSheet, actions: [takePhoto , choosePhoto ,cancel])

    }
    @IBAction func actionDatePicker(sender: AnyObject) {
        DateFormetter.df.dateFormat = "dd/MM/yyyy"
        let dateStr = DateFormetter.df.stringFromDate(pickerBday.date)
        
        arrItems[2] = dateStr
        tempTextField?.text = dateStr
    }
    func indexPathForSender(view : UIView) -> NSIndexPath? {
        var sender : UIView? = view
        while sender != nil {
            if sender is ProfileCell {
                return tblView.indexPathForCell(sender as! ProfileCell)
            }
            else
            {
                sender = sender?.superview
            }
        }
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
}
extension ProfileScreen : UIPickerViewDataSource , UIPickerViewDelegate
{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempTextField?.text = genders[row]
    }
}
extension ProfileScreen : UITextFieldDelegate
{
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let indexPath = indexPathForSender(textField) {
            
            switch indexPath.row {
            case 2:
                textField.inputView = pickerBday
                textField.addToolBar()
            case  3:
                textField.inputView = pickerViewGender
                textField.addToolBar()
            default:
                break
            }
            
        }
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        tempTextField = textField
        if tempTextField?.tag == 2  {
            DateFormetter.df.dateFormat = "dd/MM/yyyy"
        let dateStr = DateFormetter.df.stringFromDate(pickerBday.date)
            
            arrItems[2] = dateStr
            tempTextField?.text = dateStr
            
        }
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let finalString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if let indexPath = indexPathForSender(textField) {
        arrItems[indexPath.row] = finalString
        }
        
        return true
    }
}
extension ProfileScreen : UINavigationControllerDelegate , UIImagePickerControllerDelegate
{
    private func openImagePickerControllerForSourceType(source : UIImagePickerControllerSourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source){
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = source
            imagePickerController.delegate = self
            
            imagePickerController.allowsEditing = true
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            imageView.image = selectedImage
            
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var imageViewType : UIImageView!
    @IBOutlet weak var textField : UITextField!
}
extension UITextField
{
    func addToolBar() -> () {
        let done = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(UIResponder.resignFirstResponder))
        let toolbar = UIToolbar()
        toolbar.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44.0)
        toolbar.items = [done]
        self.inputAccessoryView = toolbar
    }
}
