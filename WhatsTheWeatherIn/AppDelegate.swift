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

    var container = Container() { container in
        
        container.register(NetworkManager.self) { _ in NetworkManagerImpl() }

        container.register(ViewModel.self, name: WeatherTableViewModel.name) { r in WeatherTableViewModel(networkManager: r.resolve(NetworkManager.self)!) }

        container.storyboardInitCompleted(WeatherTableViewController.self) { r, c in
            c.viewModel = r.resolve(ViewModel.self, name: WeatherTableViewModel.name) as! WeatherTableViewModel
        }

    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        window?.rootViewController = storyboard.instantiateInitialViewController()

        window?.makeKeyAndVisible()
        return true
    }

    class var sharedInstance: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }

}

