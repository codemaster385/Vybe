//
//  VybePostLocationViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 27/06/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VybePostLocationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var constraintHeightAddlocationView: NSLayoutConstraint!
    @IBOutlet weak var viewLocationdescription: UIView!
    @IBOutlet weak var locationImageview: UIImageView!
    @IBOutlet weak var labelLocationName: UILabel!
    @IBOutlet weak var labelLocationDescprtion: UILabel!
    @IBOutlet weak var textFieldtitle: UITextField!
    @IBOutlet weak var viewGotoLocation: UIView!
    
    var imagePost : UIImage?
    var VideoPath : NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
shouldPlaceBeShown = false
        imageView.image = self.imagePost
        addleftView()
        if self.imagePost == nil {
            let videoController = AVPlayerViewController()
            self.addChildViewController(videoController)
            self.view.addSubview(videoController.view)
            var rect = self.view.bounds
            rect.origin.y = 64
            rect.size.height -= 354
            videoController.view.frame = rect
            let player = AVPlayer(URL: VideoPath)
            
            videoController.player = player
            
            player.play()
        }
        // Do any additional setup after loading the view.
    }
    
    var shouldPlaceBeShown : Bool
    {
        get{return false}
        set(show){
            viewLocationdescription.hidden = !show
            constraintHeightAddlocationView.constant = show ? 0.0 : 44.0
            viewGotoLocation.hidden = show
        }
    }
    @IBAction func goToLocationview(sender: AnyObject) {
    }

    @IBAction func deleteLocation(sender: AnyObject) {
        shouldPlaceBeShown = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   @IBAction func unwindSegueForPlace(segue : UIStoryboardSegue) {
        let placeVC = segue.sourceViewController as! FindPlaceViewController
    labelLocationName.text = placeVC.currentPlace?.name
    labelLocationDescprtion.text = placeVC.currentPlace?.address
    locationImageview.image = placeVC.currentPlace?.iconClass.image
    shouldPlaceBeShown = true
    }

    @IBAction func actionPublish(sender:UIButton)
    {
        if let index = self.navigationController?.viewControllers.indexOf({ (vc:UIViewController) -> Bool in
            return vc is MainPageViewController
        })
        {
            let vc = self.navigationController?.viewControllers[index] as! MainPageViewController
            vc.selectIndex(2)
            self.navigationController?.popToViewController(vc, animated: false)
        }
        //category7
    }
    func addleftView() -> () {
        textFieldtitle.leftViewMode = .Always
        let rect = CGRectMake(0, 0, 40, 20)
        let imagevw = UIImageView(image: UIImage(named: "editTitle")!)
        imagevw.frame = rect
        imagevw.contentMode = .Center
        textFieldtitle.leftView = imagevw

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
extension VybePostLocationViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
