//
//  AppDelegate.swift
//  Tricktionary
//
//  Created by Marek Šťovíček on 15/11/2018.
//  Copyright © 2018 Marek Šťovíček. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import GoogleSignIn
import LifetimeTracker
import Swinject
import SwiftUI
import Resolver
import Apollo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var resolver: Swinject.Resolver?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UserDefaults.standard.register(defaults: [PxSettings.newScreen : false])

        LifetimeTracker.setup(onUpdate: LifetimeTrackerDashboardIntegration(visibility: .visibleWithIssuesDetected, style: .circular).refreshUI)
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID

        TrickManager.shared.loadRemoteConfig()

        let _ = UserManager()
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = Color.red
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().layer.shadowColor = UIColor.clear.cgColor
        
        UITabBar.appearance().barTintColor = Color.red
        UITabBar.appearance().unselectedItemTintColor = .white
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        registerDependencies()

        let usingSwiftUI = resolver?.resolve(RemoteConfigType.self)?.isSwiftUIEnabled == true
        self.window?.rootViewController = usingSwiftUI ? UIHostingController(rootView: TabBarView()) : TabBarViewController()

        return true
    }
    
    func registerDependencies() {
        Resolver.registerDependencies()
        let container = Container()
        container.register(TricksDataProviderType.self) { _ in
            TrickManager()
        }.inObjectScope(.container)
        container.register(TrickDetailDataProviderType.self) { _ in TrickManager() }.inObjectScope(.container)
        container.register(UserManagerType.self) { _ in UserManager() }.inObjectScope(.container)
        container.register(TricksContentManagerType.self) { resolver in
            TricksContentManager()
        }.inObjectScope(.container)
        container.register(RemoteConfigType.self) { _ in
            TRRemoteConfig()
        }.inObjectScope(.container)
        
        resolver = container.synchronize()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}
