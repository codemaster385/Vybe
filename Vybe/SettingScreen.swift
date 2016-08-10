//
//  SettingScreen.swift
//  Vybe
//
//  Created by paramvir singh on 07/05/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit

class SettingScreen:UIViewController,TTRangeSliderDelegate {
    
    @IBOutlet weak var tblView: UITableView!
  
    @IBOutlet weak var distanceSlider: StepSlider!
    
    @IBOutlet weak var currencySlider: TTRangeSlider!
    
    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var buttonFreeValue: UIButton!
    
    var arrayMiles = NSArray()
    var arrayMoney = NSArray()
    let tblViewItems = ["View Profile","Notifications","My Favs","App Settings"]
    
     let size=UIScreen.mainScreen().bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shouldValueBeFree(true)
         self.tblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tblView.tableFooterView = UIView()
        
        let view = UIView()
        view.frame = CGRectMake(0,0,10,40)
        
       
         arrayMiles = ["3 mi","5 mi","10 mi","25 mi","50 mi"]
         arrayMoney = ["Free","$10","$20","$50","More"]
       

        for i in 0 ..< 5 {
            
            // CGFloat stepWidth       = contentFrame.size.width / (self.maxCount - 1);
            // trackCircle.position = CGPointMake(contentFrame.origin.x + stepWidth * i, contentFrame.size.height / 2.f);
            
            let valueX = 30 + (size.width-40)/4 * CGFloat( i )
            
            let lblMile = UILabel()
            lblMile.frame = CGRectMake(valueX - (i == 0 ? 20 : 30) ,145, 40, 15)
            lblMile.translatesAutoresizingMaskIntoConstraints = true
            lblMile.text = arrayMiles[i] as? String
            lblMile.font = UIFont.systemFontOfSize(13.0)
            lblMile.textAlignment = NSTextAlignment.Center
            lblMile.textColor = UIColor.lightGrayColor()
            self.view .addSubview(lblMile)
        }
        
      
        let attrs11 = [
            NSFontAttributeName : UIFont.systemFontOfSize(13.0),
            NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        
        let attrs22 = [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(15.0),
            NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        
        
        
        let attributedString1 = NSMutableAttributedString(string:"Distance: ",attributes:attrs11)
        
        
        let buttonTitleStr1 = NSMutableAttributedString(string:(arrayMiles[2] as? String)!, attributes:attrs22)
        
        attributedString1.appendAttributedString(buttonTitleStr1)
        
        lblDistance.attributedText = attributedString1
        
        
        for i in 0 ..< 5 {
            
            // CGFloat stepWidth       = contentFrame.size.width / (self.maxCount - 1);
            // trackCircle.position = CGPointMake(contentFrame.origin.x + stepWidth * i, contentFrame.size.height / 2.f);
            
            let valueX = 30 + (size.width-40)/4 * CGFloat( i )
            
            let lblMile = UILabel()
            lblMile.frame = CGRectMake(valueX - (i == 0 ? 20 : 30) ,250, 40, 15)
            lblMile.translatesAutoresizingMaskIntoConstraints = true
            lblMile.text = arrayMoney[i] as? String
            lblMile.font = UIFont.systemFontOfSize(13.0)
            lblMile.textAlignment = NSTextAlignment.Center
            lblMile.textColor = UIColor.lightGrayColor()
            self.view .addSubview(lblMile)
                   }


        let attributedString2 = NSMutableAttributedString(string:"Price: ",attributes:attrs11)
        
        let buttonTitleStr2 = NSMutableAttributedString(string:"From $10 to $50", attributes:attrs22)
        
        attributedString2.appendAttributedString(buttonTitleStr2)
        
        lblPrice.attributedText = attributedString2
        
        
        //currency range slider
        self.currencySlider.delegate = self;
        self.currencySlider.minValue = 0;
        self.currencySlider.maxValue = 100;
        self.currencySlider.selectedMinimum = 25;
        self.currencySlider.selectedMaximum = 75;
        
        
        self.currencySlider.step = 25.0
        self.currencySlider.enableStep = true
       // self.currencySlider.handleColor = UIColor.greenColor();
        
       // self.currencySlider.handleDiameter = 30;
       // self.currencySlider.selectedHandleDiameterMultiplier = 1.3;
        
      //  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
      //  formatter.numberStyle = NSNumberFormatterCurrencyStyle;
     //   self.currencySlider.numberFormatterOverride = formatter;
      
      
    }
//    func popViewLikePush() -> () {
//        
//        let transition = CATransition()
//        transition.duration = 0.4
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        transition.type = kCATransitionMoveIn
//        transition.subtype = kCATransitionFromRight
//        navigationController?.view.layer.addAnimation(transition, forKey: nil)
//    
//        navigationController?.popViewControllerAnimated(true)
//        
//    }
    func shouldValueBeFree(free : Bool) -> () {
        buttonFreeValue.selected = free
//        currencySlider.tintColor = free ? UIColor.lightGrayColor() : UIColor(red: 253.0/255.0, green: 153.0/255.0 , blue: 50.0/255.0, alpha: 1.0)
        currencySlider.enabled = !free
        self.currencySlider.tintColorBetweenHandles = free ? UIColor.lightGrayColor() : UIColor(red: 255.0/255.0, green: 169.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        
        self.currencySlider.minLabelColour = free ? UIColor.lightGrayColor() : UIColor(red: 255.0/255.0, green: 169.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        self.currencySlider.maxLabelColour = free ? UIColor.lightGrayColor() : UIColor(red: 255.0/255.0, green: 169.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tblView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.tblViewItems[indexPath.row]
        cell.textLabel?.textColor = UIColor.init(red: 89.0/255.0, green: 99.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.font = UIFont(name: "OpenSans-Regular", size: 16)

        if indexPath.row == 1 {
            let notifLbl = UILabel()
            notifLbl.frame = CGRectMake(size.width-80,12, 36, 20)
            notifLbl.text = "2"
            notifLbl.backgroundColor = UIColor.init(red: 255.0/255.0, green: 169.0/255.0, blue: 84.0/255.0, alpha: 1.0)
            notifLbl.textColor = UIColor.whiteColor()
            notifLbl.textAlignment = NSTextAlignment.Center
            notifLbl.layer.cornerRadius = 7.0
            notifLbl.layer.masksToBounds = true
            notifLbl.clipsToBounds = true
            cell.contentView .addSubview(notifLbl)
            //255/169/84

        }

        cell.selectionStyle = .None
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            self.performSegueWithIdentifier("ShowProfileScreenID", sender: nil)
            break
        case 1:
            self.performSegueWithIdentifier("NotificationScreenID", sender: nil)
            break
        case 2:
            self.performSegueWithIdentifier("MyFavScreenID", sender: nil)
            break
        case 3:
            self.performSegueWithIdentifier("AppSettingID", sender: nil)
        default:
            break
            
        }
    }
    
    //MRAK: Change slider
    
    @IBAction func backBtnClicked(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    @IBAction func distanceSliderChangeValue(sender: StepSlider) {
        
        print("sender %ld",sender.index)
        
        
        
        let attrs11 = [
            NSFontAttributeName : UIFont.systemFontOfSize(15.0),
            NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        
        let attrs22 = [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(17.0),
            NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        
        
        
        let attributedString1 = NSMutableAttributedString(string:"Distance: ",attributes:attrs11)
        
    let index = Int(sender.index)
        
        let buttonTitleStr1 = NSMutableAttributedString(string:(arrayMiles[index] as? String)!, attributes:attrs22)
        
        attributedString1.appendAttributedString(buttonTitleStr1)
        
        lblDistance.attributedText = attributedString1
        
    }
    
    func rangeSlider(sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        
         print("Currency slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        
        
        let attrs11 = [
            NSFontAttributeName : UIFont.systemFontOfSize(15.0),
            NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        
        let attrs22 = [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(17.0),
            NSForegroundColorAttributeName : UIColor.darkGrayColor()]
        let attributedString2 = NSMutableAttributedString(string:"Price: ",attributes:attrs11)
        
        let index1 = Int (selectedMinimum/25.0)
        let index2 = Int (selectedMaximum/25.0)
        
        let str1 = String(format:"From %@ to ",arrayMoney[index1] as! NSString)
        
        let str2 = arrayMoney[index2]
        
        let formatText = str1 + (str2 as! String)
        
        let buttonTitleStr2 = NSMutableAttributedString(string:formatText, attributes:attrs22)
        
        attributedString2.appendAttributedString(buttonTitleStr2)
        
        lblPrice.attributedText = attributedString2
        
    }
    
    @IBAction func actionGoToBusiness(sender: AnyObject) {
        let navVC = storyboard?.instantiateViewControllerWithIdentifier("BussinessNavigationViewController") as! UINavigationController
        if sharedInstance.isBusinessCreated {
            let rootVC = storyboard?.instantiateViewControllerWithIdentifier("BussinessTableViewController") as! BussinessTableViewController
            navVC.setViewControllers([rootVC], animated: false)
        }
        else
        {
           let rootVC = storyboard?.instantiateViewControllerWithIdentifier("BussinessDescriptionTableViewController") as! BussinessDescriptionTableViewController
            navVC.setViewControllers([rootVC], animated: false)
        }
        presentViewController(navVC, animated: true, completion: nil)
        
    }
    @IBAction func actionFreeValue(sender: UIButton) {
        shouldValueBeFree(!sender.selected)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}