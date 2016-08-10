//
//  CameraViewScreen.swift
//  Vybe
//
//  Created by paramvir singh on 09/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit




class CameraViewScreen:AVCamViewController {
    @IBOutlet weak var labelDiscription: UILabel!
    
    @IBOutlet weak var viewCamera: AVCamPreviewView!
    
    
    var timer = NSTimer()
    
    var timerCount = NSInteger()
    
    let shapeLayer = CAShapeLayer()


    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var lblTimer: UILabel!
    
    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = true
//    }
//    override func viewWillDisappear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
//    }

    
    override func viewDidLoad() {
        self.previewView = viewCamera

        
        super.viewDidLoad()

        labelDiscription.text = "Clicking the button will take a picture\nHolding it down will take a video up to 15 seconds"
        
        lblTimer.hidden = true
        timerCount=0
        
        btnCamera.layer.cornerRadius = 40
        
        
        
        self.view.bringSubviewToFront(self.btnCamera)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x:40,y:40), radius: CGFloat(43), startAngle: CGFloat(-M_PI_2), endAngle:CGFloat((M_PI * 2.0) - M_PI_2), clockwise: true)
        
        //let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor(red: 42.0/255.0 , green:183.0/255.0 , blue: 216.0/255.0 , alpha: 1.0).CGColor
        //you can change the line width
        shapeLayer.lineWidth = 5.0
        shapeLayer.strokeEnd = 0.0
        
        btnCamera.layer.addSublayer(shapeLayer)
        
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    func stopAnimation(){
        
//    shapeLayer.speed = 0.0;
//    
//    shapeLayer.timeOffset = shapeLayer.convertTime(CACurrentMediaTime(), fromLayer:nil );
        
    }
    
    func animateCircle(duration: NSTimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = 15.0
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        shapeLayer.strokeEnd = 1.0
        
        // Do the actual animation
        shapeLayer.addAnimation(animation, forKey: "animateCircle")
    }
    @IBAction func actionChangeCameraMode(sender: UIButton) {
        sender.selected = !sender.selected
        self.changeCamera(nil)
    }
    @IBAction func singleTapAction(sender: AnyObject) {
        
         lblTimer.hidden = true
        self.captureImage { (image, error) in
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageEditingScreen") as! ImageEditingScreen
            viewController.fromMainCamera = true
            viewController.ImageToEdit = image!
            
            //viewController.title = "TableView&CollectionView"
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
       
    }
    @IBAction func longTapAction(sender: AnyObject) {
        
         lblTimer.hidden = false
        if sender.state==UIGestureRecognizerState.Began{
            print("long start");
            timerCount = 0
             self.animateCircle(15.0)
            self.toggleMovieRecording(nil)

             timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CameraViewScreen.updateTimerLbl), userInfo: nil, repeats: true)
           
            
        }
        else if sender.state == UIGestureRecognizerState.Ended{
            print("long end");
           
           stopVideoAtInstance()
        }

    }
    
    func updateTimerLbl(sender: AnyObject!)
    {
        timerCount += 1
        lblTimer.text = String(format: "0:%i", timerCount)
        
        if timerCount >= 15 {
           
            stopVideoAtInstance()
        }
    }
    @IBAction func actionFlash(sender: UIButton) {
        
    sender.selected = !sender.selected
        self.setFlashCurrentMode()
    }
    
    @IBAction func sipeToBackView(sender: AnyObject) {
        
        self.backToPreviousView(sender)
    }
    /*
     + (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
     {
     NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
     AVCaptureDevice *captureDevice = [devices firstObject];
     
     for (AVCaptureDevice *device in devices)
     {
     if ([device position] == position)
     {
     captureDevice = device;
     break;
     }
     }
     
     return captureDevice;
     }

     */
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    func stopVideoAtInstance() -> () {
        timerCount = 0
        timer.invalidate()
        lblTimer.text = String(format: "0:%i", timerCount)
        shapeLayer.strokeColor = UIColor.clearColor().CGColor
        self.capturedVideo { (videoURL, error) in
            print(videoURL!)
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageEditingScreen") as! ImageEditingScreen
            viewController.fromMainCamera = true
            viewController.VideoPath = videoURL!
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
