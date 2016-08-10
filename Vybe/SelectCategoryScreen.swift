//
//  SelectCategoryScreen.swift
//  Vybe
//
//  Created by paramvir singh on 13/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit

class SelectCategoryScreen: UIViewController,UISearchControllerDelegate, UISearchResultsUpdating {
    
    let size=UIScreen.mainScreen().bounds.size
    let arryItem = ["Coffee","Health & Fittness","Outdoors","Restaurants & Bars","Arts & Movies","Shopping","Coffee","Lunch","Breakfast","Health & Fittness","Brunch","Live Music","Happy Hour","Outdoors","Nightlife","Beauty & Spa"]
    
    @IBOutlet weak var constraintBottomCollectionView: NSLayoutConstraint!
    @IBOutlet weak var collectionviewSongs: UICollectionView!
    @IBOutlet weak var searchBarContainer: UIView!
    var searchController: UISearchController?
    
    var btnShowSelectedCategory = UIButton()
    
    var data = [String]()
    var filteredData = [String]()
    var isDataFiltered: Bool = false
    
    var selectedCell = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let string = "Underusher blindstory twopenny nonserviceab"
        
        data = string.componentsSeparatedByString(" ")
        
        searchController = ({
            
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.dimsBackgroundDuringPresentation = true
            //setup the search bar
            searchController.searchBar.sizeToFit()
            //searchController.searchBar.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            self.searchBarContainer?.addSubview(searchController.searchBar)
            
            automaticallyAdjustsScrollViewInsets = false
            definesPresentationContext = true
            
            return searchController
        })()
        
        
        
    }
    @IBAction func pressed(sender: UIButton!){
        self.performSegueWithIdentifier("goToListViewController", sender: nil)
    }
    //MARK:UISearchResultsUpdating
    
    //MARK: Private
    
    func searchString(string: String, searchTerm:String) -> Array<AnyObject>
    {
        var matches:Array<AnyObject> = []
        do {
            let regex = try NSRegularExpression(pattern: searchTerm, options: [.CaseInsensitive, .AllowCommentsAndWhitespace])
            let range = NSMakeRange(0, string.characters.count)
            matches = regex.matchesInString(string, options: [], range: range)
        } catch _ {
        }
        return matches
    }
    
    func searchIsEmpty() -> Bool
    {
        if let searchTerm = self.searchController?.searchBar.text {
            return searchTerm.isEmpty
        }
        return true
    }
    
    func filterData()
    {
        if searchIsEmpty() {
            isDataFiltered = false
        } else {
            filteredData = data.filter({ (string) -> Bool in
                if let searchTerm = self.searchController?.searchBar.text {
                    let searchTermMatches = self.searchString(string, searchTerm: searchTerm).count > 0
                    if searchTermMatches {
                        return true
                    }
                }
                return false
            })
            isDataFiltered = true
        }
    }
    
    func textForIndexPath(indexPath: NSIndexPath) -> String
    {
        let text = isDataFiltered ? filteredData[indexPath.row] : data[indexPath.row] as String
        return text
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        //  filterData()
        collectionviewSongs?.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arryItem.count
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width:size.width/2,height:size.width/2)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCellIdentifier", forIndexPath: indexPath) as! SelectCategoryCell
        
        
        cell.titleLabel?.text = arryItem[indexPath.row]
        
        
        if selectedCell.containsObject(indexPath.row){
            let strname = String(format:"category_%d_selected",(indexPath.row % 6)+1)
            let image = UIImage(named:strname)
            cell.imgItem.image = image
            cell.selectionImgView.hidden = true
        }
        else{
            let strname = String(format:"category_%d",(indexPath.row % 6)+1)
            let image = UIImage(named:strname)
            cell.imgItem.image = image
            cell.selectionImgView.hidden = true
        }
        return cell
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        
        _=UIScreen.mainScreen().bounds.size
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectCategoryCell
        
        if selectedCell.containsObject(indexPath.row) {
            let strname = String(format:"category_%d",(indexPath.row % 6)+1)
            let image : UIImage = UIImage(named:strname)!
            cell.imgItem.image = image
            selectedCell.removeObject(indexPath.row)
        }
        else{
            selectedCell.addObject(indexPath.row)
            
            let strname = String(format:"category_%d_selected",(indexPath.row % 6)+1)
            let image : UIImage = UIImage(named:strname)!
            cell.imgItem.image = image
        }
        
    }
    
    //MARK -: Custom methods
    
    @IBAction func btnbackClicked(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnNextClicked(sender: AnyObject) {
        
        
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        //dismiss the keyboard if the search results are scrolled
        searchController?.searchBar.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
