//
//  MainCameraViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 27/06/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit
import AVFoundation
class MainCameraViewController: AVCamViewController {

    @IBOutlet weak var viewCamera: AVCamPreviewView!
    @IBOutlet weak var buttonCamera: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    
    
    var timer = NSTimer()
    
    var timerCount = NSInteger()
    
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        
        self.previewView = viewCamera
        
        super.viewDidLoad()
        labelDescription.text = "Clicking the button will take a picture\nHolding it down will take a video up to 15 seconds"
        
        timerCount=0
        
        buttonCamera.layer.cornerRadius = 40
        
        
        
        
        
        self.view.bringSubviewToFront(self.buttonCamera)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x:40,y:40), radius: CGFloat(43), startAngle: CGFloat(-M_PI_2), endAngle:CGFloat((M_PI * 2.0) - M_PI_2), clockwise: true)
        
        //let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        //you can change the stroke color
        
        //you can change the line width
        shapeLayer.strokeColor = UIColor(red: 42.0/255.0 , green:183.0/255.0 , blue: 216.0/255.0 , alpha: 1.0).CGColor
        shapeLayer.lineWidth = 5.0
        shapeLayer.strokeEnd = 0.0
        
        buttonCamera.layer.addSublayer(shapeLayer)
        
        
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    @IBAction func action(sender : UIButton)
    {
        
        switch sender.tag {
        case 0:
            selectIndex(0)
        default:
          selectIndex(2)
        }
    }
    func selectIndex(index : Int) -> () {
        let mainVC = self.parentViewController?.parentViewController as! MainPageViewController
       mainVC.selectIndex(index)
            
    }
    @IBAction func actionFlash(sender: UIButton) {
        
        sender.selected = !sender.selected
        self.setFlashCurrentMode()
    }
//    func pushViewLikePop() -> () {
//        
//        let transition = CATransition()
//        transition.duration = 0.4
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        transition.type = kCATransitionMoveIn
//        transition.subtype = kCATransitionFromLeft
//        navigationController?.view.layer.addAnimation(transition, forKey: nil)
//        let vc = storyboard?.instantiateViewControllerWithIdentifier("SettingScreen") as! SettingScreen
//        navigationController?.pushViewController(vc, animated: false)
//       
//    }
    func stopAnimation(){
        
        shapeLayer.speed = 0.0;
        
        shapeLayer.timeOffset = shapeLayer.convertTime(CACurrentMediaTime(), fromLayer:nil );
        
    }
    
  
    
    func animateCircle(duration: NSTimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = 15.0
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue =  1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        shapeLayer.strokeEnd = 1.0
        
        // Do the actual animation
        shapeLayer.addAnimation(animation, forKey: "animateCircle")
    }
    
 
    @IBAction func longTapHandel(sender: AnyObject) {
        if sender.state==UIGestureRecognizerState.Began{
           

            shapeLayer.strokeColor = UIColor(red: 42.0/255.0 , green:183.0/255.0 , blue: 216.0/255.0 , alpha: 1.0).CGColor
            print("long start");
            timerCount = 0
            
            self.animateCircle(15.0)
            self.performSelector(#selector(MainCameraViewController.animateCircle(_:)), withObject: 15.0, afterDelay: 0.0)
            self.toggleMovieRecording(nil)
            
             timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MainCameraViewController.updateTimerLbl), userInfo: nil, repeats: true)
           
            
            
        }
        else if sender.state == UIGestureRecognizerState.Ended{
            print("long end");
            
            stopVideoAtInstance()
        }
    }
    func updateTimerLbl(sender: AnyObject!)
    {
        timerCount += 1
        
        if timerCount >= 15 {
            timer.invalidate()
        
            stopVideoAtInstance()
        }
    }
    @IBAction func actionChangeCameraMode(sender: UIButton) {
        sender.selected = !sender.selected
        self.changeCamera(nil)
    }
    @IBAction func clickPhoto(sender: AnyObject) {
        
       // cameraManagerVar.cameraOutputMode = .StillImage
        self.captureImage { (image, error) in
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageEditingScreen") as! ImageEditingScreen
            viewController.fromMainCamera = true
            viewController.ImageToEdit = image!
            
            //viewController.title = "TableView&CollectionView"
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
      

    }
    func stopVideoAtInstance() -> () {
        
        shapeLayer.strokeColor = UIColor.clearColor().CGColor
        self.capturedVideo { (videoURL, error) in
            print(videoURL!)
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageEditingScreen") as! ImageEditingScreen
            viewController.fromMainCamera = true
            viewController.VideoPath = videoURL!
            //viewController.title = "TableView&CollectionView"
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
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

public extension UIViewController {
    
    func pushViewControllerFromTop(viewController vc: UIViewController) {
        vc.view.alpha = 0
        self.presentViewController(vc, animated: false) { () -> Void in
            vc.view.frame = CGRectMake(0, -vc.view.frame.height, vc.view.frame.width, vc.view.frame.height)
            vc.view.alpha = 1
            UIView.animateWithDuration(1, animations: { () -> Void in
                vc.view.frame = CGRectMake(0, 0, vc.view.frame.width, vc.view.frame.height)
                },
                                       completion: nil)
        }
    }
    
    func dismissViewControllerToTop() {
        if let vc = self.presentingViewController {
            UIView.animateWithDuration(1, animations: { () -> Void in
                vc.view.frame = CGRectMake(0, -vc.view.frame.height, vc.view.frame.width, vc.view.frame.height)
                }, completion: { (complete) -> Void in
                    if complete == true {
                        self.dismissViewControllerAnimated(false, completion: nil)
                    }
            })
        }
    }
    @IBAction func backToPreviousView(sender:AnyObject)
    {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func dismissVC(sender:AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func goToProfile(sender:UIButton)
    {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ProfileScreen")
        
        
        
        presentViewController(vc!, animated: true, completion: nil)
    }
    func pushToVC(vc : UIViewController)  {
        navigationController?.pushViewController(vc, animated: true)
    }
}
