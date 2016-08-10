//
//  BusinessScheduleTableViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 23/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class BusinessScheduleTableViewController: UITableViewController {
    var arrSchedules = [ScheduleModel]()
    var isChangigMode  = false
    @IBOutlet weak var rightBarButton : UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let arr = [["day" : "Monday" , "status" : "open"],
                   ["day" : "Tuesday" , "status" : "open"],
                   ["day" : "Wednesday" , "status" : "open"],
                   ["day" : "Thursday" , "status" : "open"],
                   ["day" : "Friday" , "status" : "open"],
                   ["day" : "Saturday" , "status" : "open"],
                   ["day" : "Sunday" , "status" : "close"]]
        for dict in arr {
            arrSchedules += [ScheduleModel(dict:dict)]
        }
        let image = UIImage(named: "bussinessBG")!
        let imageView = UIImageView(image: image)
        imageView.frame = self.tableView.bounds
        self.tableView.backgroundView = imageView
     
        rightBarButton.title = isChangigMode ? "Done" : "Next"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "segueParking" {
            if isChangigMode {
              performSegueWithIdentifier("unwindSegue", sender: nil)
                return false
            }
            
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrSchedules.count
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
   override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("schedule", forIndexPath: indexPath) as! ScheduleTableViewCell
        let model = arrSchedules[indexPath.row]
        cell.switchStatus.on = model.staus
        cell.labelDayName.text = model.day
        cell.buttonOpeningTime.setTitle(model.openingTime, forState: .Normal)
        cell.buttonClosingTime.setTitle(model.closingTime, forState: .Normal)
        cell.buttonOpeningTime.addTarget(self, action: #selector(self.actionOpenTime(_:)), forControlEvents: .TouchUpInside)
        cell.buttonClosingTime.addTarget(self, action: #selector(self.actionClosingTime(_:)), forControlEvents: .TouchUpInside)

        cell.switchStatus.addTarget(self, action: #selector(self.actionSwitch(_:)), forControlEvents: .ValueChanged)
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.clearColor() : UIColor(white: 1.0 , alpha: 0.2)
        cell.selectionStyle = .None
        return cell
    }
   
    func getIndexPathForSender(sender : UIView) -> NSIndexPath? {
        var currentView : UIView? = sender
        while currentView != nil {
            if currentView! is ScheduleTableViewCell
            {
               return tableView.indexPathForCell(currentView as! ScheduleTableViewCell)
            }
            else
            {
                currentView = currentView?.superview
            }
        }
        
        return nil
    }
    func actionSwitch(sender : UISwitch) -> () {
        if let indexPath = getIndexPathForSender(sender) {
            let model = arrSchedules[indexPath.row]
            model.staus = sender.on
            if !model.staus {
                model.closingTime = "00:00 PM"
                model.openingTime = "00:00 AM"
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
        }
    }
    func actionOpenTime(sender : UIButton) -> () {
        
        if let indexPath = getIndexPathForSender(sender) {
            let model = arrSchedules[indexPath.row]
            if !model.staus {return}
            showTimeSelectionView(true, model: model)
        }
 
    }
    private func showTimeSelectionView(isOpenTime : Bool , model : ScheduleModel)
    {
        let timeSelectionVC = storyboard?.instantiateViewControllerWithIdentifier("BusinessScheduleSelectionViewController") as! BusinessScheduleSelectionViewController
        timeSelectionVC.arrSchedule = arrSchedules
        timeSelectionVC.currentDay = model
        timeSelectionVC.isStartTime = isOpenTime
        timeSelectionVC.delegate = self
        var rect = UIScreen.mainScreen().bounds
        rect.origin.y = UIScreen.mainScreen().bounds.size.height
        timeSelectionVC.view.frame = rect
        
        self.navigationController?.view.addSubview(timeSelectionVC.view)
        self.navigationController?.addChildViewController(timeSelectionVC)
        timeSelectionVC.didMoveToParentViewController(self.navigationController!)
        
        UIView.animateWithDuration(0.3, animations: {
            var currentrect = timeSelectionVC.view.frame
            currentrect.origin.y = 0
            timeSelectionVC.view.frame = currentrect
        })

    }
    func actionClosingTime(sender : UIButton) -> () {
        
        if let indexPath = getIndexPathForSender(sender) {
            let model = arrSchedules[indexPath.row]
            if !model.staus {return}
            showTimeSelectionView(false, model: model)
        }
        
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BusinessScheduleTableViewController : SelectTimeDelegate
{
func updateTime()
{
 tableView.reloadData()
    }
}

class ScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var switchStatus : UISwitch!
     @IBOutlet weak var labelDayName : UILabel!
     @IBOutlet weak var buttonOpeningTime : UIButton!
     @IBOutlet weak var buttonClosingTime : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
class ScheduleModel {
    var staus = true
    let day : String
    var openingTime = "00:00 AM"
    var closingTime = "00:00 PM"
    init(dict : [String : String])
    {
        self.staus = dict["status"] == "open"
        self.day = dict["day"] ?? ""
    }
}
