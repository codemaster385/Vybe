//
//  DHCollectionTableViewController.swift
//  DHCollectionTableView
//
//  Copyright (c) 2016 Param. All rights reserved.
//

/*

let numberOfTableViewRows: NSInteger = 20
let numberOfCollectionViewCells: NSInteger = 30

var source = Array<AnyObject>()
for _ in 0..<numberOfTableViewRows {
var colorArray = Array<UIColor>()
for _ in 0..<numberOfCollectionViewCells {
let color = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
colorArray.append(color)
}
source.append(colorArray)
}

// the source format is Array<Array<AnyObject>>
let viewController = DHCollectionTableViewController(source: source)
//viewController.title = "TableView&CollectionView"
window?.rootViewController = UINavigationController(rootViewController: viewController)
window?.makeKeyAndVisible()

*/

import UIKit
import AVFoundation

let reuseTableViewCellIdentifier = "TableViewCell"
let reuseCollectionViewCellIdentifier = "CollectionViewCell"


class DHCollectionTableViewController: UITableViewController {
  
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
//    }
//    override func viewWillDisappear(animated: Bool) {
//         self.navigationController?.navigationBarHidden = true
//    }
    
    
    var finishedView = UIView?()
    var player = AVPlayer()
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DHCollectionTableViewController.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
      //  self.tableView setContentInset;:UIEdgeInsetsMake(50,0,0,0)];
        
      // self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        //let size=UIScreen.mainScreen().bounds.size
        
        let homeButton : UIBarButtonItem = UIBarButtonItem(title: "Camers", style: UIBarButtonItemStyle.Plain, target: self, action:  #selector(DHCollectionTableViewController.CameraBtnClicked(_:)))
        
        self.navigationItem.rightBarButtonItem = homeButton
        
     //   self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:button)
        
        
    }
  var sourceArray: Array<AnyObject>!
  var contentOffsetDictionary: Dictionary<NSObject,AnyObject>!
  
  convenience init(source: Array<AnyObject>) {
    self.init()
    tableView.registerClass(DHCollectionTableViewCell.self, forCellReuseIdentifier: reuseTableViewCellIdentifier)
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    self.tableView.pagingEnabled=true
    //self.tableView.scrollEnabled=false
    self.navigationController?.navigationBarHidden=true
   
    sourceArray = source
    contentOffsetDictionary = Dictionary<NSObject,AnyObject>()
  }
    
    func CameraBtnClicked(sender:UIButton!)
    {
        print("Button Clicked")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CameraVIewId")
        
        //let nav = UINavigationController()
        self.navigationController!.pushViewController(vc, animated: true)

        
        
    }
    
    func shareBtnClicked(sender:UIButton!)
    {
        print("Share Clicked")
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("CameraVIewId")
//        
//        //let nav = UINavigationController()
//        self.navigationController!.pushViewController(vc, animated: true)
        
        
        
    }

    func replayBtnClicked(sender:UIButton!)
    {
        print("replay Clicked")
        
        finishedView! .removeFromSuperview()
        finishedView = nil
        
         player.seekToTime(kCMTimeZero)
        player.play()
    
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewControllerWithIdentifier("CameraVIewId")
        //
        //        //let nav = UINavigationController()
        //        self.navigationController!.pushViewController(vc, animated: true)
        
        
        
    }

}



// MARK: - Table view data source
extension DHCollectionTableViewController {
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sourceArray.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseTableViewCellIdentifier, forIndexPath: indexPath) as! DHCollectionTableViewCell
    
    if (finishedView != nil) {
        finishedView! .removeFromSuperview()
        finishedView = nil
    }
   
    

    return cell
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    let collectionCell = cell as! DHCollectionTableViewCell
    collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.row)
    
    let index = collectionCell.collectionView.tag
    let value = contentOffsetDictionary[index]
    let horizontalOffset = CGFloat(value != nil ? value!.floatValue : 0)
    collectionCell.collectionView.setContentOffset(CGPointMake(horizontalOffset,20), animated: false)
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return self.view.frame.size.height
  }
}
// MARK: - Collection View Data source and Delegate
extension DHCollectionTableViewController:UICollectionViewDataSource,UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let collectionViewArray = sourceArray[collectionView.tag] as! Array<AnyObject>
    return collectionViewArray.count
  }
  
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSize(width: self.view.frame.size.width,height: self.view.frame.size.height)
    }
    
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseCollectionViewCellIdentifier, forIndexPath: indexPath)
    
    
    if (finishedView != nil) {
        finishedView! .removeFromSuperview()
        finishedView = nil
    }
    
    let collectionViewArray = sourceArray[collectionView.tag] as! Array<AnyObject>
    cell.backgroundColor = collectionViewArray[indexPath.item] as? UIColor
    
    // add movie player
    
    
   // let screenSize=UIScreen.mainScreen().bounds.size
    
    let videoURL = (string:NSBundle.mainBundle().pathForResource("saveVideo", ofType: "mov")!)
    player = AVPlayer(URL: NSURL(fileURLWithPath: videoURL))
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.backgroundColor = UIColor.blueColor().CGColor
    playerLayer.frame = cell.contentView.bounds
    cell.contentView.layer.addSublayer(playerLayer)
    player.play()
    
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(DHCollectionTableViewController.respondToSwipeGesture(_:)))
    swipeLeft.direction = .Left
    cell.addGestureRecognizer(swipeLeft)
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(DHCollectionTableViewController.respondToSwipeGesture(_:)))
    swipeRight.direction = .Right
    cell.addGestureRecognizer(swipeRight)

    return cell
    
  }
  
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        
        for  view  in cell.contentView.layer.sublayers! {
            
            view .removeFromSuperlayer()
        }
        
        
    }
//MARK -: Delegate Method
    func playerDidFinishPlaying(note: NSNotification) {
        // Your code here
        
    print("finished")
        
        let cellArry = self.tableView.visibleCells as NSArray
        
        let cellTableview = cellArry[0] as! DHCollectionTableViewCell
        
        let collectionview = cellTableview.collectionView
        
        let collectionViewCellArry = collectionview.visibleCells()
        
        let visibleCell = collectionViewCellArry[0] as UICollectionViewCell
        
        
        
        
        let size=UIScreen.mainScreen().bounds.size
        
        finishedView = UIView.init(frame: CGRectMake(0, 0,size.width, size.height))
        finishedView!.backgroundColor = UIColor.lightGrayColor()
        finishedView!.alpha = 0.5
     //   finishedView!.hidden = true
        visibleCell.addSubview(finishedView!)
        
        let buttonCamera   = UIButton(type: UIButtonType.System) as UIButton
        buttonCamera.frame = CGRectMake(size.width/2-60,size.height/2-60,120,120)
        buttonCamera.backgroundColor = UIColor.greenColor()
        buttonCamera.setTitle("Add Post", forState: UIControlState.Normal)
        buttonCamera.addTarget(self, action: #selector(DHCollectionTableViewController.CameraBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        finishedView!.addSubview(buttonCamera)
        
        
        let buttonReplay   = UIButton(type: UIButtonType.System) as UIButton
        buttonReplay.frame = CGRectMake(5,size.height/2-60,120,120)
        buttonReplay.backgroundColor = UIColor.greenColor()
        buttonReplay.setTitle("Reply", forState: UIControlState.Normal)
        buttonReplay.addTarget(self, action: #selector(DHCollectionTableViewController.replayBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        finishedView!.addSubview(buttonReplay)
        
        let buttonShare   = UIButton(type: UIButtonType.System) as UIButton
        buttonShare.frame = CGRectMake(size.width-125,size.height/2-60,120,120)
        buttonShare.backgroundColor = UIColor.greenColor()
        buttonShare.setTitle("Share", forState: UIControlState.Normal)
        buttonShare.addTarget(self, action: #selector(DHCollectionTableViewController.shareBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        finishedView!.addSubview(buttonShare)
        
    }

  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    /*
    let itemColor: UIColor = self.sourceArray[collectionView.tag][indexPath.item] as! UIColor

    
    let alert = UIAlertController(title: "\(collectionView.tag)", message: "\(indexPath.item)", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
    let v: UIView = UIView(frame: CGRectMake(10, 20, 50, 50))
    v.backgroundColor = itemColor
    alert.view.addSubview(v)
    presentViewController(alert, animated: true, completion: nil)
    */
  }
  
  override func scrollViewDidScroll(scrollView: UIScrollView) {
    if !(scrollView is UICollectionView) {
      return
    }
    let horizontalOffset = scrollView.contentOffset.x
    let collectionView = scrollView as! UICollectionView
    contentOffsetDictionary[collectionView.tag] = horizontalOffset
  }
    
    func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
       
        
       // self.navigationController!.pushViewController(viewCtrl, animated: true)
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.Left:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("PostrDetailViewID")
            self.navigationController!.pushViewController(vc, animated: true)
            
        default:
        navigationController?.popViewControllerAnimated(true)
            
        }
        
    
    }

}
