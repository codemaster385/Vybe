//
//  AppDelegate.swift
//  Vybe
//
//  Created by paramvir singh on 08/04/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit
//import GoogleMaps
let GOOGLEAPIKEY = "AIzaSyCIxXORRqQcNvkCGJFMsxTuG9IUzHKVqXo"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isBusinessCreated = false
    var window: UIWindow?
    var loader : CustomeLoader?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        loader  = NSBundle.mainBundle().loadNibNamed("CustomLoader", owner: nil, options: nil).last as? CustomeLoader
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarHidden = true
        return true
    }

    func showLoaderWithText(title:String , onView:UIView?){
        
        loader?.setWidthLoaderTitleWithText(title)
        loader?.startAnimationOnview(onView)
        
    }
    func hideLoader(){
        loader?.stopAnimating()
    }
    func changeLoaderText(text:String){
        loader?.setWidthLoaderTitleWithText(text)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

   
    
}

 var sharedInstance : AppDelegate {return UIApplication.sharedApplication().delegate as! AppDelegate}