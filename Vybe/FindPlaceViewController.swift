//
//  FindPlaceViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 30/06/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit
import CoreLocation
//import GoogleMaps
class FindPlaceViewController: UIViewController {

    @IBOutlet var mSearchBar: UISearchBar!
    @IBOutlet weak var tablePlace: UITableView!
    
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var timerForSearch : NSTimer?
    //let placesClient = GMSPlacesClient.sharedClient()
    var defaultPlaces = [PlaceModel]()
    var searchPlace = [PlaceModel]()
    let pendingDownloads = PendingOperations()
    
    var currentPlace : PlaceModel?
    var currentToken = ""
    var showLoader : Bool {
        get{return false}
        set(show){
            labelHeader.hidden = show
            indicator.hidden = !show
            show ? indicator.startAnimating() : indicator.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader = true
tablePlace.tableHeaderView = mSearchBar
        tablePlace.rowHeight = UITableViewAutomaticDimension
        tablePlace.estimatedRowHeight = 200
        
        getNearbyAllRestaurants()
        // Do any additional setup after loading the view.
    }
    func getNearbyAllRestaurants() -> () {
        GooglePlaceService.shareInstance.getCurrentPlaces(true) { (error, response) in
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
                self.reloadSearchPlacedWithResponse(response!,isSearching: false)
                
            }
        }

    }
    func reloadSearchPlacedWithResponse(response : JSON , isSearching : Bool) -> () {
        let placeResponse = PlaceResponse(response: response)
        if placeResponse.status == "OK"
        {
            var tempArray = [PlaceModel]()
            for place in placeResponse.results {
                
                let jsonObject = JSON(place)
                tempArray += [PlaceModel(response:jsonObject)]
            }
            if isSearching {
                searchPlace = tempArray
            }
            else{
                defaultPlaces += tempArray
            }
            
        }
        else if placeResponse.status == "ZERO_RESULTS"
        {
      //  showAlertWithTitle(title: "Message", message: "No restaurant found. Make sure you have entered correct restaurant name", alertType: .Alert, actions: nil)
        }
        tablePlace.reloadData()
    }
    @IBAction func currentLocation(sender : UIButton)
    {
        mSearchBar.text = ""
        mSearchBar.resignFirstResponder()
        tablePlace.reloadData()

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

}
extension FindPlaceViewController : UISearchBarDelegate
{
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
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        timerForSearch?.invalidate()
        timerForSearch = nil
        if searchBar.text?.characters.count > 0
        {
       
        timerForSearch = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(FindPlaceViewController.findPlace(_:)), userInfo: nil, repeats: false)
        }
        else
        {
            tablePlace.reloadData()
        }
    }
    func findPlace(obj : AnyObject)  {
        timerForSearch?.invalidate()
        showLoader = true
        GooglePlaceService.shareInstance.searchRestaurantsByName(mSearchBar.text ?? "") { (error, response) in
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
                self.reloadSearchPlacedWithResponse(response!,isSearching: true)
                
            }
        }
    }
}
extension FindPlaceViewController : UITableViewDataSource , UITableViewDelegate
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mSearchBar.text!.characters.count > 0 ? searchPlace.count : defaultPlaces.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PlaceCell
        let model = mSearchBar.text?.length > 0 ? searchPlace[indexPath.row] : defaultPlaces[indexPath.row]
        
        cell.labelName.text = model.name
        cell.labelAddress.text = model.address
        
        
        
        cell.imageviewPlace.image = model.iconClass.image
        self.startDownloadingImageFor(indexPath, record: model.iconClass, imageView: cell.imageviewPlace)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentPlace  = mSearchBar.text!.characters.count > 0 ? searchPlace[indexPath.row] : defaultPlaces[indexPath.row]
        performSegueWithIdentifier("unwindSegueForPlace", sender: nil)
    }
    
    func startDownloadingImageFor(indexPath : NSIndexPath , record : ImageClass , imageView : UIImageView?)  {
        if let _ = pendingDownloads.downloadingInProgress[indexPath]
        {
            return
        }
        let downloader = ImageDownloader(record : record)
        downloader.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), { 
                self.pendingDownloads.downloadingInProgress[indexPath] = nil
                imageView?.image = record.image
            })
        }
        pendingDownloads.downloadingInProgress[indexPath] = downloader
        pendingDownloads.downloadQueue.addOperation(downloader)
    }
}

class GooglePlaceService {
    static let shareInstance = GooglePlaceService()
    
    func getCurrentPlaces(onlyRestaurnats : Bool,completion:((error : NSError? , response : JSON?) -> Void)) -> () {

        if CLLocationManager.locationServicesEnabled() {
            
        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse,.AuthorizedAlways:
            let latstring = String(OneShotLocationManager.sharedInstance.locationManager.location!.coordinate.latitude)
            let longString = String(OneShotLocationManager.sharedInstance.locationManager.location!.coordinate.longitude)
            let urlString : String
            if onlyRestaurnats {
                urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+latstring+","+longString+"&rankby=distance&type=restaurant&key="+GOOGLEAPIKEY
            }
            else
            {
                urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+latstring+","+longString+"&radius=5000&key="+GOOGLEAPIKEY
            }
            getDataFromRequest(NSURL(string: urlString)!) { (data, response, error) in
                
                if error != nil{
                    completion(error: error , response: nil)
                }
                else
                {
                    completion(error: nil , response: JSON(data))
                }
            }
        default:
            let error = NSError(domain: "Location Error" , code: 1000 ,userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("NIL" , value : "Something is not right! Please check your Location service." , comment : "")])
            completion(error: error , response: nil)
        }
        }
        else
        {
            let error = NSError(domain: "Location Error" , code: 1000 ,userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("NIL" , value : "Something is not right! Please check your Location service." , comment : "")])
            completion(error: error , response: nil)
        }
       
        
    }
    func searchRestaurantsByName(text : String , completion:((error : NSError? , response : JSON?) -> Void))  {
        if CLLocationManager.locationServicesEnabled() {
            
            
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedWhenInUse,.AuthorizedAlways:
        let latstring = String(OneShotLocationManager.sharedInstance.locationManager.location!.coordinate.latitude)
        let longString = String(OneShotLocationManager.sharedInstance.locationManager.location!.coordinate.longitude)
        
        let searchPlace = text.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        //"30.2558857""-97.7650764"
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+latstring+","+longString+"&rankby=distance&type=restaurant&name="+searchPlace+"&key="+GOOGLEAPIKEY
        getDataFromRequest(NSURL(string: urlString)!) { (data, response, error) in
            
            if error != nil{
                completion(error: error , response: nil)
            }
            else
            {
                completion(error: nil , response: JSON(data))
            }
        }
            default:
                let error = NSError(domain: "Location Error" , code: 1000 ,userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("NIL" , value : "Something is not right! Please check your Location service." , comment : "")])
                completion(error: error , response: nil)
            }
        }
        else
        {
            let error = NSError(domain: "Location Error" , code: 1000 ,userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("NIL" , value : "Something is not right! Please check your Location service." , comment : "")])
            completion(error: error , response: nil)
        }
    }
    func searchPlaces(text : String , completion:((error : NSError? , response : JSON?) -> Void)) -> () {
        
        if CLLocationManager.locationServicesEnabled() {
            
            
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedWhenInUse,.AuthorizedAlways:
        let latstring = String(OneShotLocationManager.sharedInstance.locationManager.location!.coordinate.latitude)
        let longString = String(OneShotLocationManager.sharedInstance.locationManager.location!.coordinate.longitude)
        
        let searchPlace = text.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        let urlString = "https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=\(searchPlace)&types=geocode&location=\(latstring),\(longString)&radius=1000&language=english&key="+GOOGLEAPIKEY
        getDataFromRequest(NSURL(string: urlString)!) { (data, response, error) in
            
            if error != nil{
                completion(error: error , response: nil)
            }
            else
            {
                completion(error: nil , response: JSON(data))
            }
        }
            default :
                let error = NSError(domain: "Location Error" , code: 1000 ,userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("NIL" , value : "Something is not right! Please check your Location service." , comment : "")])
                completion(error: error , response: nil)
                
            }
        }
        else
        {
            let error = NSError(domain: "Location Error" , code: 1000 ,userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("NIL" , value : "Something is not right! Please check your Location service." , comment : "")])
            completion(error: error , response: nil)
        }

    }
    private func getDataFromRequest(url : NSURL , completion: ((data : NSData? , response :NSURLResponse? , error : NSError?) -> Void))
    {
        autoreleasepool {
            
            let session = NSURLSession.sharedSession()
            session.configuration.timeoutIntervalForRequest = 12
            session.configuration.timeoutIntervalForResource = 15;
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            session.dataTaskWithURL(url) {  (data, response, error) in
                dispatch_async(dispatch_get_main_queue(), {  () -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    completion(data: data, response: response, error: error)
                })
                
                }.resume()
            
        }
        
    }

}

class PlaceResponse {
    
    let status : String
    let results : [AnyObject]
    let token : String
    init(response : JSON)
    {
        self.status = response["status"].stringValue
        self.results = response["results"].arrayValue
        self.token = response["next_page_token"].stringValue
    }
}
class PlaceModel {
    let iconClass : ImageClass
    let name : String
    let address : String
    init(response : JSON)
    {
        self.name = response["name"].stringValue
        self.address = response["vicinity"].stringValue
        let photos = response["photos"].arrayValue
        var imageURL = ""
        if photos.count > 0 {
           if let dictPhotos = photos.first as? [String : AnyObject]
           {
            let strPhotoRef = dictPhotos["photo_reference"] as? String ?? ""
            imageURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=59&photoreference="+strPhotoRef+"&key="+GOOGLEAPIKEY
            }
        }
       
        self.iconClass = ImageClass(imagePath: imageURL , defaultImage: "category7")
    }
}
class PlaceCell: UITableViewCell {
    @IBOutlet weak var labelName : UILabel!
    @IBOutlet weak var labelAddress : UILabel!
    @IBOutlet weak var imageviewPlace : UIImageView!
    override func awakeFromNib() {
        imageviewPlace.clipsToBounds = true
        imageviewPlace.layer.cornerRadius = 25.0
    }
}