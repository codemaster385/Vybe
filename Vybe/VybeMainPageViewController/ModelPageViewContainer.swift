//
//  ModelPageViewContainer.swift
//  Vybe
//
//  Created by Arun Kumar on 08/07/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class ModelPageViewContainer: NSObject , UIPageViewControllerDataSource {

    let pages : [UIViewController]
    let storyboard : UIStoryboard
    init(storyBoard : UIStoryboard) {
        self.storyboard = storyBoard
        let first = storyBoard.instantiateViewControllerWithIdentifier("SettingScreen")
        let second = storyBoard.instantiateViewControllerWithIdentifier("MainCameraViewController")
        let third = storyBoard.instantiateViewControllerWithIdentifier("ListItemScreen")
        self.pages = [first , second , third]
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if (index >= self.pages.count) {
            return nil
        }
        
        return pages[index]
    }
    func indexOfViewController(viewController : UIViewController) -> Int {
        return pages.indexOf(viewController) ?? NSNotFound
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.pages.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
}
