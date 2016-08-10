//
//  NavigationLoaderClass.swift
//  Woodpecker
//
//  Created by Arun Kumar on 3/16/16.
//  Copyright © 2016 Arun. All rights reserved.
//

import Foundation

extension UINavigationItem
{
    func showLoaderWithText(text:String)
    {
    let loaderView = LoaderView.loaderView
     loaderView.backgroundColor = UIColor.clearColor()
        self.title = ""
         let indicatior = loaderView.viewWithTag(101) as! UIActivityIndicatorView
        indicatior.startAnimating()
        let label = loaderView.viewWithTag(100) as! UILabel
        label.text = text
        self.titleView = loaderView
        
       
    }
    
    func hideLoaderWithTitle(text: String)
    {
        self.titleView = nil
        self.title = text
    }
}

struct LoaderView {
    
    static let loaderView = NSBundle.mainBundle().loadNibNamed("NavigationLoaderView", owner: nil, options: nil).last as! UIView
}
