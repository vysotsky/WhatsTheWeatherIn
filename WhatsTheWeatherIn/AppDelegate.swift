//
//  AppDelegate.swift
//  WhatsTheWeatherIn
//
//  Created by Marin Bencevic on 03/10/15.
//  Copyright © 2015 marinbenc. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var container: Container = {
        let container = Container()

        container.register(ViewModelType.self, name: WeatherTableViewModel.name) { _ in WeatherTableViewModel() }

        container.storyboardInitCompleted(WeatherTableViewController.self) { r, c in
            c.viewModel = r.resolve(ViewModelType.self, name: WeatherTableViewModel.name) as! WeatherTableViewModel
        }

        container.register(ImageLoaderType.self) { _ in NativeWebImageLoader() }
        container.register(NetworkManagerType.self) { _ in MoyaNetworkManager() }

        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        window.rootViewController = storyboard.instantiateInitialViewController()

        return true
    }

    class var sharedInstance: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }

    class func resolve<ObjectType>(_ type: ObjectType.Type) -> ObjectType {
        return sharedInstance.container.resolve(type)!
    }
}

