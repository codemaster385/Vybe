//
//  FeedbackScreen.swift
//  Vybe
//
//  Created by paramvir singh on 08/05/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit

class FeedbackScreen:UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var imgview: UIImageView!
    let bottomView = UIView()
    
    let imgArry = NSMutableArray()
   
    let imagePicker = UIImagePickerController()
      let size=UIScreen.mainScreen().bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
         imagePicker.delegate = self
        
        
        
        
        bottomView.frame = CGRectMake(0, size.height-50, size.width,50)
        bottomView.backgroundColor = UIColor.init(red: 220.0/255.0, green: 229.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        self.view.addSubview(bottomView)
        
        //220/229/253
        
        let camBtn = UIButton()
        camBtn.frame = CGRectMake(size.width/2-20,5, 40,40)
         let image : UIImage = UIImage(named:"CameraBtn")!
        camBtn.setImage(image, forState: UIControlState.Normal)
        camBtn.addTarget(self, action: #selector(FeedbackScreen.camClicked), forControlEvents: UIControlEvents.TouchUpInside)
    
        
        bottomView .addSubview(camBtn)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeedbackScreen.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeedbackScreen.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            bottomView.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            bottomView.frame.origin.y += keyboardSize.height
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            imgArry .addObject(pickedImage)
            
          self.setupView()
            
           // imgview.contentMode = .ScaleAspectFit
            //imgview.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupView() {
        
        for view in bottomView.subviews {
            view.removeFromSuperview()
        }
        
        bottomView.frame.size.height = 100
        bottomView.frame.origin.y = size.height-100
        
        let scrollview = UIScrollView()
        scrollview.frame = CGRectMake(0, 0, bottomView.frame.size.width, bottomView.frame.size.height)
        bottomView.addSubview(scrollview)
        
        var x = CGFloat(10)
        
        for i in 1...imgArry.count+1 {
            
            if i-1 < imgArry.count {
                let imgView = UIImageView()
                imgView.image = imgArry[i-1] as? UIImage
                imgView.frame = CGRectMake( x , 10,80,80)
                imgView.layer.cornerRadius = 5.0
                imgView.layer.masksToBounds = true
                imgView.clipsToBounds = true
                scrollview.addSubview(imgView)
  
            }else{
                let camBtn = UIButton()
                camBtn.frame = CGRectMake( x , 10,85,80)
                let image : UIImage = UIImage(named:"addImg")!
                camBtn.setImage(image, forState: UIControlState.Normal)
                camBtn.addTarget(self, action: #selector(FeedbackScreen.camClicked), forControlEvents: UIControlEvents.TouchUpInside)
                
                
                scrollview .addSubview(camBtn)
            }
            
            x += 95
            
        }
        
        scrollview.contentSize.width = 95 * CGFloat( imgArry.count + 1 )
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func camClicked() {
        
        txtView .resignFirstResponder()
        let alert = UIAlertController(title: "Select Option", message: nil, preferredStyle: .ActionSheet)
        let alertActionGallery = UIAlertAction(title: "Gallery", style: .Default) { (action : UIAlertAction) -> Void in
            self.openImagePickerControllerForSourceType(.PhotoLibrary)
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            
        }
        let alertActionCamera = UIAlertAction(title: "Camera", style: .Default) { (action : UIAlertAction) -> Void in
            
            self.openImagePickerControllerForSourceType(.Camera)
            alert.dismissViewControllerAnimated(true, completion: nil)
            
            
            
        }
        
        let alertActionDefault = UIAlertAction(title: "Cancel", style: .Cancel) { (action : UIAlertAction) -> Void in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alert.addAction(alertActionGallery)
        alert.addAction(alertActionCamera)
        alert.addAction(alertActionDefault)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    private func openImagePickerControllerForSourceType(source : UIImagePickerControllerSourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source){
            
            
            imagePicker.sourceType = source
            imagePicker.delegate = self
            
            imagePicker.allowsEditing = false
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            
            
        }
    }

    @IBAction func addScreenShot(sender: AnyObject) {
        
        let actionSheet = UIActionSheet(title: "Vybe", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil , otherButtonTitles: "Camera","Gallery")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 0:
            NSLog("cancel");
            
            break;
        case 1:
            NSLog("Allow");
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .Camera
            
            presentViewController(imagePicker, animated: true, completion: nil)
            break;
        case 2:
            NSLog("Allow");
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            
            presentViewController(imagePicker, animated: true, completion: nil)
            break;
   
        default:
            NSLog("Default");
            break;
            //Some code here..
            
        }
    }
    @IBAction func cancelBtnClicked(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func sendBtnClicked(sender: AnyObject) {
        
     
        if txtView.text?.characters.count == 0 {
            let alert = UIAlertController(title: "Vybe", message: "Please enter Feedback", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return;

        }
        
        
         self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        
        if text == "\n" {
            textView .resignFirstResponder()
            return false
        }
        
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
}
