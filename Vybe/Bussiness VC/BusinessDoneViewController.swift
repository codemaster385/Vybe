//
//  BusinessDoneViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 25/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class BusinessDoneViewController: UIViewController {

    var captureImage : UIImage?
    var shouldGoToMyVybe = false
    @IBOutlet weak var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !shouldGoToMyVybe {
            sharedInstance.isBusinessCreated = true
        }
        if let image = captureImage {
            imageView.image = image
            imageView.addBlurrView()
        }
        
        performSelector(#selector(self.goToBusinessDetail), withObject: nil, afterDelay: 1.0)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",style: .Plain , target: nil , action: nil)
        shouldInteractiveGestureofNavigationBeActivated = false
    }
    func goToBusinessDetail() -> () {
        
        if !shouldGoToMyVybe {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("BussinessTableViewController") as! BussinessTableViewController
            pushToVC(vc)
          
        }
        else
        {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("ListItemScreen") as! ListItemScreen
            vc.shouldEditButtonBeShown = true
            vc.isPreviousViewAvailable = true
            pushToVC(vc)
        }
        
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
