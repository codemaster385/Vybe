//
//  PostrDetailScreen.swift
//  Vybe
//
//  Created by paramvir singh on 17/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostrDetailScreen:UIViewController {
    
    @IBOutlet weak var tableDetail : UITableView!
    var valueY = CGFloat()
    var isOPen = false
    
    let size = UIScreen.mainScreen().bounds.size
    
    @IBOutlet weak var bottomViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintTbleHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
           
            if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil) {
                locationManager.requestWhenInUseAuthorization()
            } else if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil) {
                locationManager.requestAlwaysAuthorization()
            } else {
                fatalError("To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
            }
 
        }
        else{
            let alert = UIAlertAction(title: "OK" , style: .Default , handler: {(a) -> Void in
            self.backBtnClicked("")
            })
            showAlertWithTitle(title: "Alert", message: "Please turn on your location service.", alertType: .Alert, actions: [alert])
            return
        }
        
        
        valueY = 0.0
        animateTableHeight()
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways,.AuthorizedWhenInUse:
            let initialLocation = locationManager.location
            
            let regionRadius: CLLocationDistance = 100
            func centerMapOnLocation(location: CLLocation) {
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                          regionRadius * 2.0, regionRadius * 2.0)
                mapView.setRegion(coordinateRegion, animated: true)
            }
            
            centerMapOnLocation(initialLocation!)
            mapView.showsUserLocation = true
            
            mapView.mapType = .Standard

        default:
            let alert = UIAlertAction(title: "OK" , style: .Default , handler: {(a) -> Void in
                self.backBtnClicked("")
            })
            showAlertWithTitle(title: "Alert", message: "Please go to device privacy setting and allow device location service for this application.", alertType: .Alert, actions: [alert])
            return
        }
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self , action: #selector(self.popView))
        swipeGesture.direction = .Right
        self.view.addGestureRecognizer(swipeGesture)
        
      }
    func popView() -> () {
        self.backToPreviousView(UIButton())
    }
    
       @IBAction func moveView(sender: UIScreenEdgePanGestureRecognizer) {
      
//        if sender.state == UIGestureRecognizerState.Began || sender.state == UIGestureRecognizerState.Changed {
//            let translation = sender.translationInView(self.view)
//            
//            if (valueY + translation.y) > -size.height+64+150 && (valueY + translation.y) < 0  {
//                bottomViewTopConstraint.constant = valueY + translation.y
//            }
//            
//            
//        }
//        if sender.state == UIGestureRecognizerState.Ended {
//            sender.setTranslation(CGPointMake(0, 0), inView: self.view)
//            valueY = bottomViewTopConstraint.constant
//        }
        
        
    }
    @IBAction func animateBottomView(sender : UIButton) -> () {
        
        let distanceFromBottom = abs(valueY)
        var distanceFromUp = -464.0 - valueY
        distanceFromUp = abs(distanceFromUp)
        
        
        if distanceFromUp > distanceFromBottom
        {
            valueY = -464.0
        }
        else
        {
            valueY = 0.0
        }
        
       self.view.layoutIfNeeded()
        bottomViewTopConstraint.constant = valueY
        UIView.animateWithDuration(0.3) { 
           self.view.layoutIfNeeded() 
        }
        
    }
    @IBAction func backBtnClicked(sender: AnyObject) {
        
        self.backToPreviousView(sender)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    func animateTableHeight() -> () {
        self.view.layoutIfNeeded()
        constraintTbleHeight.constant = isOPen ? 330 : 150
        UIView.animateWithDuration(0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
}
extension PostrDetailScreen : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NSBundle.mainBundle().loadNibNamed("VybeDetailHeader", owner: self, options: nil).last as! UIView
        let label = view.viewWithTag(100) as! UILabel
        let button = view.viewWithTag(101) as! UIButton
         button.selected = isOPen
        button.hidden = section != 1
        switch section {
        case 0:
            label.text = "701 Brazo Street"
        case 1:
            label.text = "Today:   11:30 am - 9:30 pm"
        case 2:
            label.text = "(888)888-8888"
        case 3:
            label.attributedText = getAttributedText("http://www.starbucks.com")
        case 4:
            label.text = "Parking: Yes"
        default:
            break
        }
        button.addTarget(self, action: #selector(PostrDetailScreen.showMore(_:)), forControlEvents: .TouchUpInside)
        return view
    }
    func getAttributedText(text : String) -> NSAttributedString {
        
        let underlineAttriString = NSAttributedString(string:text, attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue , NSForegroundColorAttributeName : UIColor(red: 42.0/255.0, green: 183.0/255.0, blue: 216.0/255.0, alpha: 1.0)])
        
        return underlineAttriString
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return isOPen ? 6 : 0
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Tue:   11:30 am - 9:30 pm"
        case 1:
            cell.textLabel?.text = "Wedy:   11:30 am - 9:30 pm"
        case 2:
            cell.textLabel?.text = "Thu:   11:30 am - 9:30 pm"
        case 3:
            cell.textLabel?.text = "Fri:   11:30 am - 9:30 pm"
        case 4:
            cell.textLabel?.text = "Sat:   11:30 am - 9:30 pm"
        case 5:
            cell.textLabel?.text = "Sun:   -"
        default:
            break
        }
        cell.selectionStyle = .None
        return cell
    }
    func showMore(sender : UIButton) -> () {
        isOPen = !isOPen
        sender.selected = isOPen
        tableDetail.reloadSections(NSIndexSet(index:1), withRowAnimation: .None)
        animateTableHeight()
    }
}

extension PostrDetailScreen : MKMapViewDelegate
{
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
        if pin == nil {
            pin = MKAnnotationView(annotation: annotation , reuseIdentifier: "pin")
        }
        else
        {
            pin?.annotation = annotation
        }
        pin?.image = UIImage(named: "pinLocation")
    return pin
    }
    
}
