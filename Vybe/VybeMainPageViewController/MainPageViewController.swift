//
//  MainPageViewController.swift
//  Vybe
//
//  Created by Arun Kumar on 08/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    
    var modelController: ModelPageViewContainer {
      
        if _modelController == nil {
            _modelController = ModelPageViewContainer(storyBoard: self.storyboard!)
        }
        return _modelController!
    }
    
    var _modelController: ModelPageViewContainer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageViewController.delegate = self
        pageViewController.dataSource = self.modelController
        selectIndex(1)
        
        pageViewController.view.frame = self.view.bounds
        
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        
        pageViewController.didMoveToParentViewController(self)
       
        self.view.gestureRecognizers = pageViewController.gestureRecognizers
        // Do any additional setup after loading the view.
    }

    func selectIndex(index : Int)  {
        let startingViewcontroller  = self.modelController.viewControllerAtIndex(index)!
        let viewControllers = [startingViewcontroller]
        pageViewController.setViewControllers(viewControllers, direction: index == 0 ? .Reverse : .Forward, animated: true, completion: nil)
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
extension MainPageViewController : UIPageViewControllerDelegate
{
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        let currentViewController = pageViewController.viewControllers![0]
        
        
        let viewControllers = [currentViewController]
        pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
        
        pageViewController.doubleSided = false
        return .Min
    }
}
