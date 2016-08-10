//
//  BussinessLogocameraViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 17/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit
protocol CameraImageDelegate : NSObjectProtocol {
    func clickedImage(image : UIImage) -> ()
}

class BussinessLogocameraViewController: AVCamViewController  {
@IBOutlet weak var viewCamera: AVCamPreviewView!
    weak var delegate : CameraImageDelegate?
    override func viewDidLoad() {
         self.previewView = viewCamera
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",style: .Plain , target: nil , action: nil)
        shouldInteractiveGestureofNavigationBeActivated = true
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @IBAction func actionFlash(sender: UIButton) {
        
        sender.selected = !sender.selected
        self.setFlashCurrentMode()
    }
    @IBAction func actionChangeCameraMode(sender: UIButton) {
        sender.selected = !sender.selected
        self.changeCamera(nil)
    }
    @IBAction func clickPhoto(sender: AnyObject) {
        
        // cameraManagerVar.cameraOutputMode = .StillImage
        self.captureImage { (image, error) in
         
           self.delegate?.clickedImage(image)
        self.backToPreviousView(sender)
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
