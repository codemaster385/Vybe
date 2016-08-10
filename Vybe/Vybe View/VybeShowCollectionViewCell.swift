//
//  VybeShowCollectionViewCell.swift
//  Vybe
//
//  Created by Arun Kumar on 6/7/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class VybeShowCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var circularProgress: CircleProgressView!
    @IBOutlet weak var viewOuterSide: UIView!
//    @IBOutlet weak var viewInnerSide: UIView!
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var buttonNext : UIButton!
    @IBOutlet weak var buttonDetail : UIButton!
    @IBOutlet weak var buttonRepeat : UIButton!
    @IBOutlet weak var buttonAddPost : UIButton!
    @IBOutlet weak var buttonShare : UIButton!
    @IBOutlet weak var viewButtons : UIView!
     var shouldStopProgress = false
    private var duration = 0.0
//    let  shapeLayer = CAShapeLayer()
//    func configureTimer()  {
//        viewOuterSide?.round(15.0)
//        viewInnerSide.round(10.0)
//        
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x:15,y:15), radius: CGFloat(10), startAngle: CGFloat(1.5*M_PI), endAngle:CGFloat((M_PI * 2.0) - M_PI_2), clockwise: true)
//        
//        shapeLayer.path = circlePath.CGPath
//        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
//        shapeLayer.fillColor = UIColor.clearColor().CGColor
//        
//        shapeLayer.lineWidth = 5.0
//        shapeLayer.strokeEnd = 0.0
//        viewOuterSide.layer.addSublayer(shapeLayer)
//    }
//    func stopAnimation()
//    {
//        shapeLayer.strokeColor = UIColor.clearColor().CGColor
//        
//    }
//    func animateCircle(duration: NSTimeInterval) {
//        // We want to animate the strokeEnd property of the circleLayer
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        
//        // Set the animation duration appropriately
//        animation.duration = duration
//        
//        // Animate from 0 (no circle) to 1 (full circle)
//        animation.fromValue = 0
//        animation.toValue = duration == 0.0 ? 0 : 1
//        
//        // Do a linear animation (i.e. the speed of the animation stays the same)
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        
//        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
//        // right value when the animation ends.
//        shapeLayer.strokeEnd = duration == 0.0 ? 0.0 : 1.0
//        
//        // Do the actual animation
//        shapeLayer.addAnimation(animation, forKey: "animateCircle")
//    }
    
    func animateProgress(duration : Double) -> () {
        viewOuterSide.hidden = false
                self.duration = duration
       setProgress()
        
    }
    func setProgress() -> () {
        
        if Int(circularProgress.progress) == 1 || shouldStopProgress
        {
            circularProgress.progress = 1.0
            return
        }
        circularProgress.progress = circularProgress.progress + 0.01
        self.performSelector(#selector(VybeShowCollectionViewCell.setProgress), withObject: nil, afterDelay: 0.01*self.duration)
      
    }
    func stopProgress() -> ()
    {
        shouldStopProgress = true
        viewOuterSide.hidden = true
    }
    @IBAction func actionAdd(sender : UIButton)
  {
    NSNotificationCenter.defaultCenter().postNotificationName("kNotificationAddClick", object: nil)
    }
}

extension UIView
{
    func round(radius : CGFloat)  {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    func addBorderColor(color : UIColor)  {
         self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.CGColor
    }
}
