//
//  ListItemScreen.swift
//  Vybe
//
//  Created by paramvir singh on 13/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit


class ListItemScreen:UIViewController,UISearchBarDelegate {
    
    var isPreviousViewAvailable = false
     @IBOutlet var mSearchBar: UISearchBar!
    var shouldEditButtonBeShown = false
  
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var constraintHeaderTopSpace: NSLayoutConstraint!
     @IBOutlet weak var mainTblVIew: UITableView!
    
    var arr = [VybePosters]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTblVIew.tableHeaderView = mSearchBar
        editButton.hidden = !shouldEditButtonBeShown
        for i in 0..<10 {
            var temp = [[String : AnyObject]]()
            for j in 0..<5 {
                var dict = [String:AnyObject]()
                dict["type"] = j%2 == 0
                dict["fileName"] = j%2 == 0 ? "postImage" : "saveVideo"
                temp += [dict]
            }
            var dict = [String:AnyObject]()
            dict["posts"] = temp
            dict["posterImage"] = i%2 == 0 ? "photo" : "post1"
            dict["posterName"] = i%2 == 0 ? "BOY'S NIGHT!" : "EXCELLENT MORNING!!!"
            arr += [VybePosters(dict:dict)]
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
//        shouldInteractiveGestureofNavigationBeActivated = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.resetTableViewInititalOffeset()
    }
    @IBAction func swipeBackToView(sender: AnyObject) {
        if isPreviousViewAvailable{
            if let index = navigationController?.viewControllers.indexOf({ (a) -> Bool in
                return a is BussinessTableViewController
            }) {
                navigationController?.popToViewController(navigationController!.viewControllers[index], animated: true)
            }
            
        }
    }
    
    private func resetTableViewInititalOffeset()
    {
        var point = mainTblVIew.contentOffset
        point.y = self.mainTblVIew.contentInset.top + 44.0
        self.mainTblVIew.contentOffset = point
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
       
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
       // self.animateHeader(-64.0)
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
         searchBar.showsCancelButton = false
       // self.animateHeader(0.0)
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func animateHeader(top:CGFloat) -> () {
        self.view.layoutIfNeeded()
        constraintHeaderTopSpace.constant = top
        UIView.animateWithDuration(0.3) { 
          self.view.layoutIfNeeded()
        }
    }
    @IBAction func actionEdit(sender: AnyObject) {
        
        mainTblVIew.setEditing(!mainTblVIew.editing, animated: true)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
   

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListItemCell
        let poster = arr[indexPath.row]
        cell.labelPosterName.text = poster.posterName
        cell.imageViewPoster.image = UIImage(named: poster.posterImageName)
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

      
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("VybeViewTableViewController") as! VybeViewTableViewController
        vc.arr = arr
        vc.indexPath = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
        

        
    }
   func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
   {
    if editingStyle == .Delete {
        
        arr.removeAtIndex(indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    }
    
}