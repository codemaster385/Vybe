//
//  NetReachability.swift
//  Woodpecker
//
//  Created by Arun Kumar on 3/10/16.
//  Copyright © 2016 Arun. All rights reserved.
//

import Foundation
import SystemConfiguration
public let FFReachabilityChangedNotification = "FFNetworkReachabilityChangedNotification"

public enum NetworkStatus
{
    case NotReachable, ReachableViaWiFi, ReachableViaWWAN
    
    public var description : String
        {
            switch self {
            case .ReachableViaWWAN:
                return "2G/3G/4G"
            case .ReachableViaWiFi:
                return "WiFi"
            case .NotReachable:
                return "No Connection"
            }
    }
}

public protocol NetReachabilityProtocol
{
    static func reachabilityWithHostName(hostName : String) -> NetworkStatus
    func startNotifier()
    func stopNotifier()
    var currentReachabilityStatus: NetworkStatus {get}
}

private func & (lhs : SCNetworkReachabilityFlags , rhs : SCNetworkReachabilityFlags) -> UInt32
{
    return lhs.rawValue & rhs.rawValue
}

public class NetReachability : NetReachabilityProtocol
{
    public static func reachabilityWithHostName(hostName: String) -> NetworkStatus {
        let reach = NetReachability(hostname: hostName)
        
        return reach.currentReachabilityStatus
    }
    private var reachability : SCNetworkReachability?
    public init(hostname : String)
    {
        reachability = SCNetworkReachabilityCreateWithName(nil, hostname)!
    }
    
    public func startNotifier() {
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        SCNetworkReachabilitySetCallback(reachability! , {(_,_,_) in
            NSNotificationCenter.defaultCenter().postNotificationName(FFReachabilityChangedNotification, object: nil)
            
            }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability!, CFRunLoopGetMain(), kCFRunLoopCommonModes)
    }
    
    public func stopNotifier() {
        if reachability != nil
        {
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability!, CFRunLoopGetMain(), kCFRunLoopCommonModes)
        }
    }
    
    public var currentReachabilityStatus: NetworkStatus
        {
            if reachability == nil
            {
                return NetworkStatus.NotReachable
            }
            
            var flags = SCNetworkReachabilityFlags(rawValue: 0)
            SCNetworkReachabilityGetFlags(reachability! , &flags)
            return networkStatus(flags)
    }
    
    func networkStatus(flags : SCNetworkReachabilityFlags) -> NetworkStatus
    {
        if (flags & SCNetworkReachabilityFlags.Reachable == 0)
        {
            return .NotReachable
        }
        var returnValue = NetworkStatus.NotReachable
        if flags & SCNetworkReachabilityFlags.ConnectionRequired == 0
        {
            returnValue = .ReachableViaWiFi
        }
        if flags & SCNetworkReachabilityFlags.ConnectionOnDemand != 0 || flags & SCNetworkReachabilityFlags.ConnectionOnTraffic != 0
        {
            if flags & SCNetworkReachabilityFlags.InterventionRequired == 0 {
                returnValue = .ReachableViaWiFi
            }
        }
        if flags & SCNetworkReachabilityFlags.IsWWAN == SCNetworkReachabilityFlags.IsWWAN.rawValue
        {
            returnValue = .ReachableViaWWAN
        }
        return returnValue
    }
}
