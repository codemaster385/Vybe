//
//  BusinessScheduleSelectionViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 23/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit
protocol SelectTimeDelegate : NSObjectProtocol {
    func updateTime() -> () }

class BusinessScheduleSelectionViewController: UIViewController {

    weak var delegate : SelectTimeDelegate?
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelSelectionTimeType: UILabel!
    @IBOutlet weak var collectionDays: UICollectionView!
    
    var currentDay : ScheduleModel!
    var isStartTime = true
    var arrSchedule = [ScheduleModel]()
    var selectedSchedule = [ScheduleModel]()
    var selectedTime = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
       self.setupModelAndUI()
        // Do any additional setup after loading the view.
    }
private func setupModelAndUI()
{
    labelSelectionTimeType.text = isStartTime ? "Open Time" : "Close Time"
    DateFormetter.df.dateFormat = "hh:mm a"
    selectedTime = DateFormetter.df.stringFromDate(NSDate())
    labelDay.text = currentDay.day
    arrSchedule = arrSchedule.filter({ (a) -> Bool in
        return a.day != currentDay.day && a.staus
    })
    }
    @IBAction func actionClose(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: { 
            var rect = self.view.bounds
            rect.origin.y = rect.size.height
            self.view.frame = rect
            }) { (isFinished) in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    @IBAction func actionDone(sender: AnyObject) {
        if isStartTime
        {
            currentDay.openingTime = selectedTime
        }
        else
        {
            currentDay.closingTime = selectedTime
        }
        for schedule in selectedSchedule {
            if isStartTime
            {
                schedule.openingTime = selectedTime
            }
            else
            {
                schedule.closingTime = selectedTime
            }
        }
        if isStartTime {
            isStartTime = false
            selectedSchedule.removeAll()
            self.setupModelAndUI()
            collectionDays.reloadData()
            
        }
        else
        {
        
        actionClose(sender)
        }
        self.delegate?.updateTime()
    }
    @IBAction func actionDatePicker(sender: UIDatePicker) {
        DateFormetter.df.dateFormat = "hh:mm a"
        selectedTime = DateFormetter.df.stringFromDate(sender.date)
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
    deinit
    {
        print("deallocated")
    }

}
extension BusinessScheduleSelectionViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = UIScreen.mainScreen().bounds.size.width / 6 - 10
        return CGSizeMake(width, width)
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSchedule.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("day", forIndexPath: indexPath) as! DaysCollectionViewCell
        let model = arrSchedule[indexPath.item]
        cell.labelDay.text = (model.day as NSString).substringToIndex(3)
        if selectedSchedule.contains({ (a) -> Bool in
            return a.day == model.day
        }) {
            cell.labelDay.backgroundColor = UIColor(red: 0.0 , green: 171.0/255.0 , blue: 198.0/255.0 , alpha:1.0)
            cell.labelDay.textColor = UIColor(white: 1.0 , alpha: 0.7)
        }
        else
        {
            cell.labelDay.backgroundColor = UIColor.whiteColor()
            cell.labelDay.textColor = labelDay.textColor
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = arrSchedule[indexPath.item]
       
            if let index = selectedSchedule.indexOf({ (a) -> Bool in
                return a.day == model.day
            })
            {
                selectedSchedule.removeAtIndex(index)
            }
        
        else {
            selectedSchedule += [model]
        }
        collectionView.reloadItemsAtIndexPaths([indexPath])
        
    }
   
   
}
class DaysCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelDay : UILabel!
    override func awakeFromNib() {
        self.labelDay.round(self.bounds.size.height/2)
        self.labelDay.addBorderColor(UIColor(red: 0.0 , green: 171.0/255.0 , blue: 198.0/255.0 , alpha:1.0))
    }

}
struct DateFormetter {
    static let df = NSDateFormatter()
}
