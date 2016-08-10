//
//  SelectDOBScreen.swift
//  Vybe
//
//  Created by paramvir singh on 09/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit



class SelectDOBScreen:UIViewController,AKPickerViewDelegate,AKPickerViewDataSource {
    
    @IBOutlet var dayPicker : AKPickerView!
    @IBOutlet var monthPicker : AKPickerView!
    @IBOutlet var yearPicker : AKPickerView!
    
    var dictSignUPInputs = [String : String]()
    
    var daysArry = [String]()
    var monthArry = [String]()
    var yearArry = [String]()
    
    var day = "0"
    var month = ""
    var year = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//       let  dayPickerTemp = AKPickerView(frame:CGRectMake(0,80,size.width,60))
//        dayPickerTemp.backgroundColor = UIColor.lightGrayColor()
//        //dayPickerTemp.tag = 100
//       // dayPickerTemp.delegate = self
//        //dayPickerTemp.dataSource = self
//        dayPickerTemp.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
//        dayPickerTemp.highlightedFont = UIFont(name: "HelveticaNeue", size: 23)!
//        dayPickerTemp.pickerViewStyle = .Wheel
//        dayPickerTemp.maskDisabled = false
//        dayPickerTemp.hidden = true
//        self.view .addSubview(dayPickerTemp)
//        dayPickerTemp.reloadData()
        
        let font = UIFont(name: "HelveticaNeue-Light", size: 22)!
        let  highlightedFont = UIFont(name: "HelveticaNeue", size: 25)!

        
        dayPicker.backgroundColor = UIColor.clearColor()
        dayPicker.tag = 100
        dayPicker.delegate = self
        dayPicker.dataSource = self
        dayPicker.font = font
        dayPicker.highlightedFont = highlightedFont
        dayPicker.pickerViewStyle = .Wheel
       
       
        
//        let image : UIImage = UIImage(named:"DatePickerLine")!
//        
//        let doneImageView = UIImageView(image: image)
//        doneImageView.frame = CGRectMake(0,150, size.width,13)
//        doneImageView.contentMode=UIViewContentMode.Center
//        self.view.addSubview(doneImageView)

        
        monthPicker.backgroundColor = UIColor.clearColor()
        monthPicker.tag = 101
        monthPicker.delegate = self
        monthPicker.dataSource = self
        monthPicker.font = font
        monthPicker.highlightedFont = highlightedFont
        monthPicker.pickerViewStyle = .Wheel
       
       
        
//        let doneImageView1 = UIImageView(image: image)
//        doneImageView1.frame = CGRectMake(0,230, size.width,13)
//        doneImageView1.contentMode=UIViewContentMode.Center
//        self.view.addSubview(doneImageView1)
        
        
        yearPicker.backgroundColor = UIColor.clearColor()
        yearPicker.tag = 102
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.font = font
        yearPicker.highlightedFont = highlightedFont
        yearPicker.pickerViewStyle = .Wheel
        
    
        
//        let doneImageView3 = UIImageView(image: image)
//        doneImageView3.frame = CGRectMake(0,310, size.width,13)
//        doneImageView3.contentMode=UIViewContentMode.Center
//        self.view.addSubview(doneImageView3)

        self.setupPickers()
       
    }
    
    @IBAction func btnNextClicket(sender: AnyObject) {
        self.performSegueWithIdentifier("goToCurrentLocationScreen", sender: nil)
    }
    func setupPickers() {
    
        
        
       	for i in 1 ..< 32 {
            
            daysArry.append(String (i))
        }
         dayPicker.reloadData()
        dayPicker.selectItem(16)
        day = daysArry[16]
       monthArry = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
       monthPicker.reloadData()
        monthPicker.selectItem(6)
        month = monthArry[6]
       /*
         
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat:@"yyyy"];
         NSString *yearString = [formatter stringFromDate:[NSDate date]];
 */
      let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy"
        
        let yearStr = dateFormatter.stringFromDate(NSDate())
        let myNumber = NSNumberFormatter().numberFromString(yearStr)

        
        for i in 1940 ..< myNumber!.integerValue {
            yearArry.append(String (i))
            }
            yearPicker.reloadData()
        
            yearPicker.selectItem(40)
        year = yearArry[40]
        
    }
    //MARK Picker Delegaet
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
    
        switch pickerView.tag {
        case 100:
            return daysArry.count
        case 101:
            return monthArry.count
        default:
            return yearArry.count
        }
        
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        
        switch pickerView.tag {
        case 100:
            return daysArry[item]
        case 101:
            return monthArry[item]
        default:
            return yearArry[item]
        }
       
        
    }

	func pickerView(pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int) {
	label.textColor = UIColor.lightGrayColor()
        
         //171,151,213
	label.highlightedTextColor = UIColor.init(colorLiteralRed: 171.0/255.0, green: 151.0/255.0, blue: 213.0/255.0, alpha: 1.0)
	}
 
	func pickerView(pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
	return CGSizeMake(40, 20)
	}

    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        
        switch pickerView.tag  {
        case 100:
            day = daysArry[item]
        case 101:
            month = monthArry[item]
        default:
            year = yearArry[item]
            
        }
        

        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToCurrentLocationScreen" {
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "dd/MMM/yyyy"
            var dobString = "\(day)/\(month)/\(year)"
            let date = dateformatter.dateFromString(dobString)
            dateformatter.dateFormat = "dd/MM/yyyy"
            dobString = dateformatter.stringFromDate(date!)
            dictSignUPInputs["bday"] = dobString
            let vc = segue.destinationViewController as! GetUserLocation
            vc.dictSignUPInputs = dictSignUPInputs
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
