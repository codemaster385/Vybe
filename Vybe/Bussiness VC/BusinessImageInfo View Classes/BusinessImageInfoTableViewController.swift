//
//  BusinessImageInfoTableViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 31/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class BusinessImageInfoTableViewController: UITableViewController {

    var capturedImage : UIImage?
    @IBOutlet weak var lableBadgeValue: UILabel!
    @IBOutlet weak var lableHours: UILabel!
    @IBOutlet weak var collectionAddedTags: UICollectionView!
    @IBOutlet weak var collectionTags: UICollectionView!
    @IBOutlet weak var labelTagsCount: UILabel!
    var  tags = ["Coffee","Happy Hour","Restaurants","Nightlife","Lunch","Health & Fitness","Beauty & spas","Breakfast","Brunch","Live Music","Outdoors","Shopping","Art & Movies"]
    var addedTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       if let image = capturedImage
       {
        let imageView = UIImageView(image: image)
        imageView.frame = self.tableView.bounds
        self.tableView.backgroundView = imageView
        imageView.addBlurrView()
        }

        
        
        lableBadgeValue.text = "Free"
        lableHours.text = "24 hours"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
       
 

    }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionNext(sender : UIBarButtonItem)
    {
        let doneVC = storyboard?.instantiateViewControllerWithIdentifier("BusinessDoneViewController") as! BusinessDoneViewController
        doneVC.captureImage = capturedImage
        doneVC.shouldGoToMyVybe = true
        pushToVC(doneVC)
    }
   override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            goToStoryInfoVC(true, currentValue: lableBadgeValue.text ?? "")
        case 1:
           goToStoryInfoVC(false, currentValue: lableHours.text ?? "")
        default:
            break
        }
    }
    func goToStoryInfoVC(isBadge : Bool , currentValue : String) -> () {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BusinessViewingInfoTableViewController") as! BusinessViewingInfoTableViewController
        vc.isBadge = isBadge
        vc.capturedImage = capturedImage
        vc.currentValue = currentValue
        pushToVC(vc)
    }
    // MARK: - Table view data source
 /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    @IBAction func unwindSegueForStoryInfo(segue : UIStoryboardSegue)
    {
        let vc = segue.sourceViewController as! BusinessViewingInfoTableViewController
        if vc.isBadge {
            lableBadgeValue.text = vc.currentValue
        }
        else
        {
            lableHours.text = vc.currentValue
        }
    }

}
extension BusinessImageInfoTableViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let additionalWidth : CGFloat = collectionView == collectionAddedTags ? 44.0 : 16.0
        let string = collectionView == collectionAddedTags ? addedTags[indexPath.row] : tags[indexPath.row]
        let size = (string as NSString).boundingRectWithSize(CGSizeMake(CGFloat.max, 18.0), options: NSStringDrawingOptions(rawValue : 0), attributes: [NSFontAttributeName : openSansefontWithSize(14.0)], context: nil).size
        return CGSizeMake(size.width + additionalWidth, 30.0)
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == collectionTags ? tags.count : addedTags.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionAddedTags:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! AddedTagCollectionCell
             cell.labelTagName.text = addedTags[indexPath.row];
            cell.buttonDelete.tag = indexPath.item
            cell.buttonDelete.addTarget(self, action: #selector(self.actionDeleteTag(_:)), forControlEvents: .TouchUpInside)
            return cell
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TagsCollectionCell
            cell.labelTagName.text = tags[indexPath.row];
            return cell
        }
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        handelingTgsForCollection(collectionView, forIndexPath: indexPath)
           }
    func actionDeleteTag(sender : UIButton) -> () {
       if let indexPath = indexPathForSender(sender)
       {
        handelingTgsForCollection(collectionAddedTags, forIndexPath: indexPath)
        }
    }
    func handelingTgsForCollection(collectionView : UICollectionView , forIndexPath indexPath:NSIndexPath) -> () {
        switch collectionView {
        case collectionAddedTags:
            let tag = addedTags.removeAtIndex(indexPath.row)
            tags += [tag]
            let row = tags.count - 1
            let addedindexPath = NSIndexPath(forItem: row , inSection: 0)
            collectionTags.insertItemsAtIndexPaths([addedindexPath])
            collectionAddedTags.deleteItemsAtIndexPaths([indexPath])
        default:
            let tag = tags.removeAtIndex(indexPath.row)
            addedTags += [tag]
            let row = addedTags.count - 1
            let addedindexPath = NSIndexPath(forItem: row , inSection: 0)
            collectionAddedTags.insertItemsAtIndexPaths([addedindexPath])
            collectionTags.deleteItemsAtIndexPaths([indexPath])
        }
       labelTagsCount.text = "Tags (\(addedTags.count))"
    }
    func indexPathForSender(sender : UIView?) -> NSIndexPath? {
        var currentView = sender
        while currentView != nil {
            if currentView is AddedTagCollectionCell {
                return collectionAddedTags.indexPathForCell(currentView as! AddedTagCollectionCell)
            }
            else
            {
                currentView = currentView?.superview
            }
        }
        return nil
    }
}
class AddedTagCollectionCell: UICollectionViewCell {
    @IBOutlet weak var labelTagName : UILabel!
    @IBOutlet weak var buttonDelete : UIButton!
    override func awakeFromNib() {
        
    }
}
class TagsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var labelTagName : UILabel!
    override func awakeFromNib() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.whiteColor().CGColor
    }
}
extension UICollectionView
{
//    func setEstimatedSizeIFNeeded() -> () {
//        if let flowlayout = self.collectionViewLayout as? UICollectionViewFlowLayout
//        {
//            let estimatedWidth : CGFloat = 50.0
//            if estimatedWidth != flowlayout.estimatedItemSize.width {
//                flowlayout.estimatedItemSize = CGSizeMake(estimatedWidth, 30.0)
//                flowlayout.invalidateLayout()
//            }
//        }
//    }

}
