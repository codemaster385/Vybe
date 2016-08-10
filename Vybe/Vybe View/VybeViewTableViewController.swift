//
//  VybeViewTableViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 6/7/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class VybeViewTableViewController: UITableViewController {

    var arr = [VybePosters]()
    var indexPath : NSIndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VybeViewTableViewController.swipeLeftORRight(_:)), name: "kNotificationForLeftSwipe", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VybeViewTableViewController.addPost(_:)), name: "kNotificationAddClick", object: nil)
        tableView.pagingEnabled = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
    }
    func swipeLeftORRight(noti:NSNotification) -> () {
        let swipe = noti.object as! UISwipeGestureRecognizer
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.Left:
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PostrDetailScreen") as! PostrDetailScreen
            self.navigationController!.pushViewController(vc, animated: true)
            
        case UISwipeGestureRecognizerDirection.Right:
            navigationController?.popViewControllerAnimated(true)
        default:
            break
        }
    }
    func addPost(noti : NSNotification)  {
       
        let vc = storyboard?.instantiateViewControllerWithIdentifier("CameraVIewId")
        
       
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "kNotificationForLeftSwipe", object: nil)
         NSNotificationCenter.defaultCenter().removeObserver(self, name: "kNotificationAddClick", object: nil)
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
extension VybeViewTableViewController
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! VybeViewTableViewCell
        let poster = arr[indexPath.row]
    cell.arrPosts = poster.vybePosts
        cell.mCollectionView.reloadData()
        cell.mCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0,inSection: 0), atScrollPosition: .Right, animated: false)
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.height
    }
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideUnhidebuttonsOfCollectionView(true)
    }
   override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
         hideUnhidebuttonsOfCollectionView(false)
    }
    func hideUnhidebuttonsOfCollectionView(hide : Bool) -> () {
        for cell in tableView.visibleCells {
            let collection = (cell as! VybeViewTableViewCell).mCollectionView
            let collectionCell = collection.visibleCells().first as! VybeShowCollectionViewCell
            collectionCell.buttonNext.hidden = hide
            collectionCell.buttonDetail.hidden = hide
            
        }
    }
}

class VybePosters {
  
    let posterName : String
    let posterImageName : String
    let vybePosts : [VybePosts]
    init(dict : [String: AnyObject])
    {
       self.posterName = dict["posterName"] as! String
        self.posterImageName = dict["posterImage"] as! String
        var temp = [VybePosts]()
        for post in (dict["posts"] as! [[String : AnyObject]]) {
            temp += [VybePosts(dict:post)]
        }
        self.vybePosts = temp
    }
}
class VybePosts {
    
    enum PostType {
        case Image , Video
    }
    let type : PostType
    let mediaFileName : String
    var timer : NSTimer?
    
    init(dict : [String : AnyObject])
    {
        self.type = (dict["type"] as! Bool) ? .Image : .Video
        self.mediaFileName = dict["fileName"] as! String
    }
}
