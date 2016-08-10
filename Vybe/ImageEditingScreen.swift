//
//  ImageEditingScreen.swift
//  Vybe
//
//  Created by paramvir singh on 17/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

/*
 
 SPUserResizableViewDelegate
 
 let instanceOfCustomObject: SPUserResizableView = SPUserResizableView(frame:CGRectMake(50, 50, 200, 150))
 let view = UIView(frame:CGRectMake(50, 50, 200, 150))
 view.backgroundColor=UIColor.redColor()
 instanceOfCustomObject.contentView=view
 instanceOfCustomObject.delegate = self;
 self.view .addSubview(instanceOfCustomObject)
 
 -hideEditingHandles.
 
 */

import Foundation
import UIKit
import AVFoundation


class ImageEditingScreen: UIViewController,UITextViewDelegate,SPUserResizableViewDelegate {
    
    @IBOutlet weak var button_publish: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonText: UIButton!
    @IBOutlet weak var buttonEmoji: UIButton!
    @IBOutlet weak var viewPublish: UIView!
    @IBOutlet weak var constraintHeightTextView: NSLayoutConstraint!
    
    var ImageToEdit = UIImage?()
    var VideoPath   = NSURL()
    @IBOutlet weak  var txtBackgroundView : UIView!
    @IBOutlet weak var textView : UITextView!
    
    @IBOutlet weak var imageviewToSetImage : UIImageView!
    
    @IBOutlet weak var labelselectedtimer: UILabel!
    var fromMainCamera = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtBackgroundView.hidden = true
      
        
        if (ImageToEdit != nil) {
       imageviewToSetImage.hidden = false
            imageviewToSetImage.image = ImageToEdit
            imageviewToSetImage.userInteractionEnabled = true
          
            
        }
        else{
            imageviewToSetImage.hidden = true
          //  let videoURL = (string:NSBundle.mainBundle().pathForResource("saveVideo", ofType: "mov")!)
           let player = AVPlayer(URL: VideoPath)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.backgroundColor = UIColor.blueColor().CGColor
            playerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(playerLayer)
            player.play()

        }



        
        
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    @IBAction func handelPan(sender: UIPanGestureRecognizer) {
        
        let point = sender.locationInView(self.view)
        let boundRect = self.view.bounds
        
        if CGRectContainsPoint(boundRect, point) {
            
                var centerPoint = point
                centerPoint.x = self.view.center.x
                sender.view?.center = centerPoint
           
            if (sender.state == .Ended) {
            
                if !CGRectContainsRect(boundRect, sender.view!.frame) {
                    let viewCenter = sender.view!.center;
                    var txtViewrect = sender.view!.frame
                    let direction = self.getDirectionByPoint(viewCenter)
                    switch direction {
                    case 0:
                        txtViewrect.origin.y = 0
                    default:
                        txtViewrect.origin.y = UIScreen.mainScreen().bounds.size.height - txtViewrect.size.height
                    }
                    
                    UIView.animateWithDuration(0.2, animations: {
                        sender.view!.frame = txtViewrect
                    })
                }
                
                
            }
           
        }
    }
    func getDirectionByPoint(point : CGPoint) -> Int32 {
        
        var dir = INT_MAX;
        var min = MAXFLOAT;
        if (Float(fabs(point.y - 0)) < min) {
            min = Float(fabs(point.y - 0))
            dir =  0
        }
        if (Float(fabs(self.view.frame.size.height - point.y)) < min) {
            min = Float(fabs(UIScreen.mainScreen().bounds.size.width - point.x));
            dir = 2;
        }
        return dir
    }
  @IBAction func addText(sender:UIButton!){
        
    txtBackgroundView.hidden = false
    textView.becomeFirstResponder()
    
        
    }
    @IBAction func addEmoji(sender:UIButton)
    {
         let emojiVC = storyboard?.instantiateViewControllerWithIdentifier("EmojiCollectionViewController") as! EmojiCollectionViewController
        navigationController?.pushViewController(emojiVC, animated: false)
    }
    @IBAction func back(sender:UIButton)
    {
        navigationController?.popViewControllerAnimated(true)
    }
   @IBAction func addTextOverImage(sender:UIButton!){
        
        self.view.endEditing(true)
        
    txtBackgroundView.hidden = true
    
        let lbl = UILabel.init(frame: CGRectMake(0, 0, 200, 60))
        lbl.textAlignment = NSTextAlignment.Center
        lbl.numberOfLines = 0
        lbl.textColor = UIColor .whiteColor()
        lbl.text = textView.text
        
        textView.text = ""
        
        
        let instanceOfCustomObject: SPUserResizableView = SPUserResizableView(frame:CGRectMake(50, 50, 200, 60))
        instanceOfCustomObject.contentView=lbl
        instanceOfCustomObject.delegate = self;
        self.view.addSubview(instanceOfCustomObject)
         instanceOfCustomObject.showEditingHandles()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ImageEditingScreen.longTapAction(_:)))
        instanceOfCustomObject.addGestureRecognizer(longPressRecognizer)

        
    }
    
    func longTapAction(sender: UITapGestureRecognizer) {
        if sender.state==UIGestureRecognizerState.Began{
            print("long start");
            
            
            // create the alert
            let alert = UIAlertController(title: "Alert", message: "Do you want to delete this ?", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                let view = sender.view
                
                view?.removeFromSuperview()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            
           
            
        }else if sender.state==UIGestureRecognizerState.Ended{
            print("long end");
            
        }
        
    }
    
    @IBAction func unwindSegueForEmojiVC(segue : UIStoryboardSegue)
    {
        let emojiVC = segue.sourceViewController as! EmojiCollectionViewController
      
        createNewEmojiLabel(emojiVC.emoji)
    }
    
    func createNewEmojiLabel(emoji : String) -> () {
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = self.view.center
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(50.0)
        label.text = emoji
        label.sizeToFit()
        label.userInteractionEnabled = true
        let longTapGesture = UILongPressGestureRecognizer(target: self , action: #selector(ImageEditingScreen.emojiLongTapGestureHandel(_:)))
        let pangesture = UIPanGestureRecognizer(target: self , action: #selector(ImageEditingScreen.emojiPanHandel(_:)))
        label.addGestureRecognizer(pangesture)
        label.addGestureRecognizer(longTapGesture)
        self.view.addSubview(label)
    }
    
    func emojiLongTapGestureHandel(gesture : UILongPressGestureRecognizer) -> () {
        switch gesture.state {
        case .Began:
            let yes = UIAlertAction(title: "YES" , style: .Default , handler: {(action) in
                gesture.view?.removeFromSuperview()
                
            })
            let no = UIAlertAction(title: "NO" , style: .Default , handler: nil)
            let alert = UIAlertController(title: "Message" , message: "Delete this?" , preferredStyle: .Alert )
            alert.addAction(yes)
            alert.addAction(no)
            presentViewController(alert, animated: true, completion: nil)
        default: break
        }
        
    }
    func emojiPanHandel(gesture : UIScreenEdgePanGestureRecognizer) -> () {
        
        let point = gesture.locationInView(self.view)
        let bound = self.view.bounds
        if CGRectContainsPoint(bound, point) {
            gesture.view?.center = point
        }
           }
    @IBAction func closePublishView(sender : AnyObject)
    {
        timerForClosingPublishView?.invalidate()
        timerForClosingPublishView = nil
        navigationController?.popViewControllerAnimated(false)

      
    }
    var timerForClosingPublishView : NSTimer?
    @IBAction func publish(sender: AnyObject) {
        
        if self.navigationController is BussinessNavigationViewController
        {
            let imageInfoVC = storyboard?.instantiateViewControllerWithIdentifier("BusinessImageInfoTableViewController") as! BusinessImageInfoTableViewController
            imageInfoVC.capturedImage = ImageToEdit
            pushToVC(imageInfoVC)
            return
        }
        if fromMainCamera {
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("VybePostLocationViewController") as! VybePostLocationViewController
            viewController.VideoPath = VideoPath
            viewController.imagePost = ImageToEdit
            
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }
        
        self.view.bringSubviewToFront(self.viewPublish)
        self.viewPublish.hidden = false
        self.viewPublish.alpha = 0.0
        UIView.animateWithDuration(1.5, delay: 0.0, options: .TransitionCrossDissolve, animations: {
            self.shouldPublishViewBeHidden(false)
            
            }, completion: nil)
        timerForClosingPublishView = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(ImageEditingScreen.closePublishView(_:)), userInfo: nil, repeats: false)
    }
    func shouldPublishViewBeHidden(hide : Bool) -> () {
        viewPublish.alpha = hide ? 0.0 : 1.0
        buttonText.alpha = !hide ? 0.0 : 1.0
        buttonEmoji.alpha = !hide ? 0.0 : 1.0
        buttonClose.alpha = !hide ? 0.0 : 1.0
        button_publish.alpha = !hide ? 0.0 : 1.0
    }
    func textViewDidChange(textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: 400.0))
      
        let height = max(50.0, newSize.height)
        
        self.view.layoutIfNeeded()
        constraintHeightTextView.constant = height
        UIView.animateWithDuration(0.2) { 
          self.view.layoutIfNeeded()  
        }
        
    }
    @IBAction func actionTimer(sender : UIButton)
    {
        let alert = UIAlertController(title: "Select option",message: nil , preferredStyle: .ActionSheet)
        let arr = ["1 second","2 seconds","3 seconds","4 seconds","5 seconds","6 seconds","Cencel",]
        for time in arr {
            let handeler : ((UIAlertAction) -> Void)?
            if time == "Cencel" {
               handeler = nil
            }
            else
            {
                handeler = {(a) -> Void in
                    let title = a.title ?? ""
                    let selectedTime = title.componentsSeparatedByString(" ").first
                    self.labelselectedtimer.text = selectedTime
                }
            }
            let action = UIAlertAction(title: time,style: .Default,handler: handeler)
            alert.addAction(action)
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text).characters.count <= 50
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


