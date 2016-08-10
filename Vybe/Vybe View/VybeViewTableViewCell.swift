//
//  VybeViewTableViewCell.swift
//  Vybe
//
//  Created by Arun Kumar on 6/7/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit
import AVFoundation

class VybeViewTableViewCell: UITableViewCell {
    @IBOutlet weak var mCollectionView : UICollectionView!
    var player : AVPlayer?
    var arrPosts = [VybePosts]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mCollectionView.scrollEnabled = false
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension VybeViewTableViewCell : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPosts.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! VybeShowCollectionViewCell
        if cell.gestureRecognizers == nil
        {
            
            let swipeLeft = UISwipeGestureRecognizer(target: self , action: #selector(VybeViewTableViewCell.swipeView(_:)))
            swipeLeft.direction = .Left
            cell.addGestureRecognizer(swipeLeft)
            let swipeRight = UISwipeGestureRecognizer(target: self , action: #selector(VybeViewTableViewCell.swipeView(_:)))
            swipeRight.direction = .Right
            cell.addGestureRecognizer(swipeRight)
        }
        
        let post = arrPosts[indexPath.row]
        cell.viewButtons.hidden = true
        cell.imageView.hidden = post.type == .Video
        cell.viewOuterSide.hidden = post.type == .Video
        if post.type == .Image {
            cell.circularProgress.progress = 0.0
            cell.shouldStopProgress = false
            cell.animateProgress(4.0)
            cell.imageView.image = UIImage(named: post.mediaFileName)
            post.timer?.invalidate()
            post.timer = nil
            post.timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(VybeViewTableViewCell.showButtonsView(_:)), userInfo: ["view":cell], repeats: false)
//            cell.configureTimer()
           
        }
        else
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VybeViewTableViewCell.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
            let videoURL = (string:NSBundle.mainBundle().pathForResource(post.mediaFileName, ofType: "mov")!)
            player = AVPlayer(URL: NSURL(fileURLWithPath: videoURL))
            let playerLayer = AVPlayerLayer(player: player)
            
            playerLayer.frame = cell.bounds
            cell.contentView.layer.addSublayer(playerLayer)
            player?.play()
        }
        cell.buttonRepeat.addTarget(self, action: #selector(VybeViewTableViewCell.actionReplay(_:)), forControlEvents: .TouchUpInside)
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        
        let post = arrPosts[indexPath.row]
        
        if post.type == .Image {
 (cell as! VybeShowCollectionViewCell).stopProgress()
        }
        post.type == .Image ?  post.timer?.invalidate() : NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        if let sublayers = cell.contentView.layer.sublayers
        {
            for  view  in sublayers {
                
                view .removeFromSuperlayer()
            }
        }
    }
    func showButtonsView(timer : NSTimer) -> () {
        
        let cell = timer.userInfo?["view"] as! VybeShowCollectionViewCell
        cell.viewButtons.hidden = false
        cell.stopProgress()
        timer.invalidate()
        
    }
    func playerDidFinishPlaying(note: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        let cell = mCollectionView.visibleCells().first as! VybeShowCollectionViewCell
        cell.viewButtons.hidden = false
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let post = arrPosts[indexPath.row]
        post.type == .Image ?  post.timer?.invalidate() : NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
        var nextIndex = indexPath.row + 1
        if nextIndex >= arrPosts.count
        {
            nextIndex = 0
        }
        
        mCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: nextIndex , inSection: 0), atScrollPosition: nextIndex == 0 ? .Right : .Left, animated: true)
    }
    func actionReplay(sender:UIButton) -> () {
        if let cell = getCellForSender(sender) , let indexPath = mCollectionView.indexPathForCell(cell)
        {
            cell.viewButtons.hidden = true
            let post = arrPosts[indexPath.row]
            switch post.type {
            case .Image:
                post.timer?.invalidate()
                post.timer = nil
                post.timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(VybeViewTableViewCell.showButtonsView(_:)), userInfo: ["view":cell.viewButtons], repeats: false)
            case .Video:
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VybeViewTableViewCell.playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
                player?.seekToTime(kCMTimeZero)
                player?.play()
            }
            
        }
    }
    func getCellForSender(sender : UIView) -> VybeShowCollectionViewCell? {
        var view : UIView?  = sender
        while view != nil {
            if view is VybeShowCollectionViewCell {
                return view as? VybeShowCollectionViewCell
            }
            else
            {
                view = view!.superview
            }
        }
        return nil
    }
    func swipeView(gesture : UISwipeGestureRecognizer) -> () {
        NSNotificationCenter.defaultCenter().postNotificationName("kNotificationForLeftSwipe", object: gesture)
    }
}
