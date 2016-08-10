//
//  SelectGenderScreen.swift
//  Vybe
//
//  Created by paramvir singh on 09/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit





class SelectGenderScreen:UIViewController {
    
    
    
    @IBOutlet weak var selectGender: StepSlider!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    var selectedType : NSInteger = 0
    var dictSignUPInputs = [String : String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedType=1
    
        /*
        
       let pickerViewDay = AKPickerView(frame:CGRectMake(20, 20,self.view .frame.size.width,40 ))
        pickerViewDay.delegate = self
        pickerViewDay.dataSource = self
        
        
        let pickerViewMonth = AKPickerView(frame: CGRectMake(20, 20,self.view .frame.size.width,40 ))
        pickerViewMonth.delegate = self
        pickerViewMonth.dataSource = self
        
        
        let pickerViewYear = AKPickerView(frame: CGRectMake(20, 20,self.view .frame.size.width,40 ))
        pickerViewYear.delegate = self
        pickerViewYear.dataSource = self*/
        
        
        
    }
    
    
    //MARK: - Btn Actions
    
    @IBAction func changeGender(sender: StepSlider) {
        
      //  print("gender %ld",sender.index)
        
     //   let stepControl : UIStepper = sender as! UIStepper
       
        
     
        
        switch sender.index {
        case 0:
            selectedType=1
            selectGender.sliderCircleColor = UIColor.init(colorLiteralRed: 255.0/255.0, green: 62.0/255.0, blue: 127.0/255.0, alpha: 1.0)
            // 34/191/241
            break
            
        case 1:
            selectedType=2
            selectGender.sliderCircleColor = UIColor.init(colorLiteralRed: 34.0/255.0, green: 191.0/255.0, blue: 241.0/255.0, alpha: 1.0)
          //  255/62/127
            break
        default:
            break
        }
    }
    @IBAction func backBtnClicked(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func btnSkipClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("goToDOBScreenId", sender: nil)
        
    }
    
    @IBAction func btnMaleClicked(sender: AnyObject) {
        
        selectedType = 1
        
        let btnClicked = sender as! UIButton
        
        
         let imageMuch : UIImage = UIImage(named:"GenderMuchSelected")!
        
       
         let imageLips : UIImage = UIImage(named:"GenderLips")!
        btnClicked .setBackgroundImage(imageMuch, forState: UIControlState.Normal)
        
         btnFemale.setBackgroundImage(imageLips, forState: UIControlState.Normal)
        
       // btnClicked.backgroundColor=UIColor.lightGrayColor()
        
       // btnFemale.backgroundColor=UIColor.blackColor()
        
    }
    
    @IBAction func btnFemaleClicked(sender: AnyObject) {
        
        selectedType = 2
        
        let btnClicked = sender as! UIButton
        
         let imageLips : UIImage = UIImage(named:"GenderLipsSelected")!
         btnClicked .setBackgroundImage(imageLips, forState: UIControlState.Normal)
         let imageMuch : UIImage = UIImage(named:"GenderMuch")!
        
         btnMale .setBackgroundImage(imageMuch, forState: UIControlState.Normal)
        
       // btnClicked.backgroundColor=UIColor.lightGrayColor()
        //btnMale.backgroundColor=UIColor.blackColor()
        
    }
   
    @IBAction func btnNextClicked(sender: AnyObject) {
        
        if selectedType == 0{
      
            showAlertWithTitle(title: "Alert", message: "Please select gender", alertType: .Alert, actions: nil)
            
            return;

        }
        self.performSegueWithIdentifier("goToDOBScreenId", sender: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToDOBScreenId" {
            dictSignUPInputs["gender"] = selectedType == 1 ? "M" : selectedType == 2 ? "F" : ""
            let vc = segue.destinationViewController as! SelectDOBScreen
            vc.dictSignUPInputs = dictSignUPInputs
            
        }
    }
    
}
