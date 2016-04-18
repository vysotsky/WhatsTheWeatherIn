//
//  AppDelegate.swift
//  WhatsTheWeatherIn
//
//  Created by Marin Bencevic on 03/10/15.
//  Copyright © 2015 marinbenc. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let container = Container()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        container.register(ImageLoaderType.self) { _ in NativeWebImageLoader() }

        return true
    }

    class var sharedInstance: AppDelegate {
        get {
            return UIApplication.sharedApplication().delegate as! AppDelegate
        }
    }
    
}

