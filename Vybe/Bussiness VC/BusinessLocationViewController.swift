//
//  BusinessLocationViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 19/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class BusinessLocationViewController: UIViewController {
    @IBOutlet var viewtitleView: UIView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    @IBOutlet weak var tablePlaces: UITableView!
    @IBOutlet weak var placeSearchBar: UISearchBar!
    
    @IBOutlet weak var buttonCancel: UIBarButtonItem!
    @IBOutlet weak var buttonNext: UIBarButtonItem!
    
    var timerForSearch : NSTimer?
    var places = [JSON]()
    var nearbyPlaces = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
navigationItem.titleView = viewtitleView
        showLoader = true
        buttonCancel.setFont(openSansefontWithSize(17.0))
        buttonNext.setFont(openSansefontWithSize(17.0))
        shouldInteractiveGestureofNavigationBeActivated = true
        removeSearchBarBackGround()
        
        GooglePlaceService.shareInstance.getCurrentPlaces(false){ (error, response) in
            self.showLoader = false
            if error != nil
            {
                if error!.code == 1000
                {
                    let alert = UIAlertAction(title: "OK" , style: .Default , handler: {(a) -> Void in
                        self.backToPreviousView("")
                    })
                    self.showAlertWithTitle(title: "Alert", message: "Please go to device privacy setting and allow device location service for this application.", alertType: .Alert, actions: [alert])
                }

                
            }
            else
            {
                print(response!.object!)
                let placeResponse = PlaceResponse(response: response!)
                if placeResponse.status == "OK"
                {
                    for place in placeResponse.results {
                        
                        let jsonObject = JSON(place)
                        self.nearbyPlaces += [JSON(PlaceModel(response:jsonObject))]
                    }
            self.tablePlaces.reloadData()
                }

                
            }
        }

            // Do any additional setup after loading the view.
    }

    func removeSearchBarBackGround() -> () {
        for subview in placeSearchBar.subviews.first!.subviews {
            
            
            if subview.isKindOfClass(NSClassFromString("UISearchBarBackground")!)  {
                subview.removeFromSuperview()
                break
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var showLoader : Bool {
        get{return false}
        set(show){
        labelHeader.hidden = show
            indicator.hidden = !show
            show ? indicator.startAnimating() : indicator.stopAnimating()
        }
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
    print("deinit")
    }
}

extension BusinessLocationViewController : UITableViewDataSource , UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeSearchBar.text?.length > 0 ? places.count : nearbyPlaces.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("place", forIndexPath: indexPath)
        if placeSearchBar.text?.length > 0 {
            let model = places[indexPath.row].object as! CityModel
            cell.textLabel?.text = model.city + ", " + model.State
            cell.detailTextLabel?.text = model.country
        }
        else
        {
            let model = nearbyPlaces[indexPath.row].object as! PlaceModel
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.address
  
        }
        
        return cell
    }
}
extension BusinessLocationViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        timerForSearch?.invalidate()
        timerForSearch = nil
        if searchBar.text?.length > 0
        {
            
            timerForSearch = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: #selector(self.findPlace(_:)), userInfo: nil, repeats: false)
        }
        else
        {
           tablePlaces.reloadData()
        }
    }
    
    func findPlace(obj : AnyObject)  {
        timerForSearch?.invalidate()
        self.showLoader = true
    GooglePlaceService.shareInstance.searchPlaces(placeSearchBar.text ?? "") { (error, response) in
        self.showLoader = false

            if error != nil
            {
                if error!.code == 1000
                {
                    let alert = UIAlertAction(title: "OK" , style: .Default , handler: {(a) -> Void in
                        self.backToPreviousView("")
                    })
                    self.showAlertWithTitle(title: "Alert", message: "Please go to device privacy setting and allow device location service for this application.", alertType: .Alert, actions: [alert])
                }

                
            }
            else
            {
                let status = response!["status"].stringValue
                if status == "OK"
                {
                    self.places.removeAll()
                    let arrPlaces = response!["predictions"].arrayValue
                    for predictedPlace in arrPlaces
                    {
                        let object = JSON(predictedPlace)
                        let model = CityModel(dict:object)
                        self.places += [JSON(model)]
                    }
                    self.tablePlaces.reloadData()
                }
                
                
                
            }
        }
    }
}

class CityModel {
    
    let city : String
    let State : String
    let country : String
    init(dict : JSON)
    {
        let description = dict["description"].stringValue.stringByReplacingOccurrencesOfString(", ", withString: ",")
        let arr = description.componentsSeparatedByString(",")
        if arr.count >= 3 {
            self.city = arr[0]
            self.State = arr[1]
            self.country = arr[2]
        }
        else if arr.count == 2
        {
            self.city = arr[0]
            self.State = arr[1]
            self.country = ""
        }
        else
        {
            self.city = arr[0]
            self.State = ""
            self.country = ""
        }
        
    }
}