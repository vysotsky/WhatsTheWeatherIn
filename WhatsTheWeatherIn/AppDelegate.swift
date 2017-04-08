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

    var container: Container = {
        let container = Container()

        container.register(ViewModelType.self, name: WeatherTableViewModel.name) { _ in WeatherTableViewModel() }

        container.registerForStoryboard(WeatherTableViewController.self) { r, c in
            c.viewModel = r.resolve(ViewModelType.self, name: WeatherTableViewModel.name) as! WeatherTableViewModel
        }

        container.register(ImageLoaderType.self) { _ in AlamofireImageLoader() }
        container.register(NetworkConfigType.self) { _ in OpenWeatherApiConfig() }
        container.register(NetworkManagerType.self) { r in MoyaNetworkManager(config: r.resolve(NetworkConfigType.self)!) }

        return container
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.makeKeyAndVisible()
        self.window = window

        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        window.rootViewController = storyboard.instantiateInitialViewController()

        return true
    }

    class var sharedInstance: AppDelegate {
        get {
            return UIApplication.sharedApplication().delegate as! AppDelegate
        }
    }

    class func resolve<ObjectType>(type: ObjectType.Type) -> ObjectType {
        return sharedInstance.container.resolve(type)!
    }
}

